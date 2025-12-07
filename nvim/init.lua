-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

local nvim_path = vim.env.APPDIR2 and
    vim.env.APPDIR2 .. "/usr/home/user/.config/nvim" or
    vim.env.HOME .. "/.vscode/extensions/yeferyv.retronvim/nvim"

-- vim.fn.expand("~/.*/extensions/yeferyv.retronvim*/nvim", 0, 1)[1] -- ...,0,1 shows in a list and [1] grabs the first match
-- vim.fn.expand outputs the same string if not founded
-- vim.fn.glob outputs nil if not found
local retronvim_path = vim.fn.glob("~/.*/extensions/yeferyv.retronvim*/nvim", 0, 1)[1] or nvim_path

local package_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/'
local mini_path = retronvim_path .. '/plugins/site/pack/deps/opt/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.nvim', version = 'b409fd1d8b9ea7ec7c0923eb2562b52ed5d1ab0a', },
    { src = 'https://github.com/folke/snacks.nvim',   version = 'v2.22.0', },
  })
end

vim.opt.rtp:prepend(mini_path)
vim.opt.rtp:append(retronvim_path .. '/plugins/site/pack/deps/opt/snacks.nvim')

local M = {}
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local _, vscode = pcall(require, "vscode-neovim")
vim.g.mapleader = " " -- <leader> key

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  local ok, snacks = pcall(require, "snacks")
  if ok then
    snacks.setup({
      explorer = { replace_netrw = true },
      image = {},
      indent = {},
      input = {},
      picker = {
        layouts = {
          -- https://www.reddit.com/r/neovim/comments/1jv6u2y/replicating_nvchads_telescope_look_for_snacks/
          big_preview = {
            layout = {
              box = "horizontal",
              width = 0.8,  -- vim.o.columns
              min_width = 120,
              height = 0.8, -- vim.o.lines
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "input", height = 1,     border = "bottom" },
                { win = "list",  border = "none" },
              },
              { win = "preview", title = "{preview}", border = "rounded", width = 2 / 3 },
            },
          },
          sidebar = {
            layout = {
              width = 25
            },
          }
        },
        sort = {
          -- default sort is by score, text length and index
          fields = { "idx", "score:desc", "#text" },
        },
        sources = {
          explorer = { hidden = true, --[[ ignored = true ]] },
          grep = {
            layout = "ivy_split",
            args = { "--sort=path" }
          }
        },
        win = {
          preview = { keys = { ["<space><space><space>"] = { "cycle_win", mode = { "n" } } } },
          input = { keys = { ["<space><space>"] = { "cycle_win", mode = { "i", "n" } } } },
          list = {
            keys = {
              ["K"] = { "preview_scroll_up" },
              ["J"] = { "preview_scroll_down" },
              ["M"] = { "toggle_maximize" },
              ["<space>"] = { "cycle_win" },
              -- ["<S-CR>"] = { "close", mode = { "n", "i" } }, -- <S-CR> already closes the picker if a folder is hovered
            },
          },
        },
      },
      styles = {
        input = {
          title_pos = "left",
          relative = "cursor",
          row = 1,
          col = -1,
          width = 30,
        },
      },
      terminal = {
        win = {
          width = vim.o.columns,
          height = vim.o.lines,
          border = 'rounded',
          position = "float"
        }
      }
    })
  end
end

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  map("n", "<leader>ll", "<cmd>ConsoleLogInspect<cr>", { desc = "ConsoleLog Inspect" })
  map("n", "<leader>lL", "<cmd>ConsoleLogInspectAll<cr>", { desc = "ConsoleLog Inspect All" })
  map("n", "<leader>l1", "<cmd>ConsoleLogReload<cr>", { desc = "ConsoleLog (Re)Start" })

  vim.opt.rtp:append(package_path .. "consolelog.nvim")
  local ok, consolelog = pcall(require, "consolelog")
  if ok and not vim.env.APPDATA then -- consolelog.nvim breaks neovim on windows
    consolelog.setup({ auto_enable = false, keymaps = { enabled = false } })
  end
end

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  map(
    { "n", "i" },
    "<A-;>",
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local state = vim.b[bufnr].nes_state

      if state then
        -- Try to jump to the start of the suggestion edit.
        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
        local _ = require("copilot-lsp.nes").walk_cursor_start_edit() or
            (
              require("copilot-lsp.nes").apply_pending_nes() and
              require("copilot-lsp.nes").walk_cursor_end_edit()
            )
      end
    end,
    { desc = "Accept Copilot NES suggestion" }
  )

  vim.opt.rtp:append(package_path .. "copilot-lsp")
  local ok, copilot_lsp = pcall(require, "copilot-lsp")
  if ok then
    copilot_lsp.setup({
      nes = {
        move_count_threshold = 1, -- Clear after 1 cursor movements
      }
    })
    vim.g.copilot_nes_debounce = 75
    vim.lsp.enable("copilot_ls")
  else
    vim.opt.rtp:remove(package_path .. "copilot-lsp")
  end
end

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  vim.opt.rtp:append(package_path .. "supermaven-nvim")
  local ok, supermaven = pcall(require, "supermaven-nvim")

  if ok then
    supermaven.setup {
      keymaps = {
        accept_suggestion = "<A-l>",
        clear_suggestion = "<A-k>",
        accept_word = "<A-j>",
      }
    }
  end
end

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  map({ 'x', 'n', 'i' }, '<leader>lg', ":Sidekick cli toggle name=gemini<cr>", { desc = 'Gemini cli' })
  map({ 'x', 'n', 'i' }, '<leader>lG', ":Sidekick cli prompt<cr>", { desc = 'Gemini prompt' })

  vim.opt.rtp:append(package_path .. "sidekick.nvim")
  local ok, sidekick = pcall(require, "sidekick")
  if ok then
    sidekick.setup({ nes = { enabled = false } })
  end
end

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  vim.opt.rtp:append(package_path .. "windsurf.nvim")
  vim.opt.rtp:append(package_path .. "plenary.nvim")
  local ok, codeium = pcall(require, "codeium")

  if ok then
    codeium.setup({
      idle_delay = 50,
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = "<A-l>",
          accept_word = "<A-j>",
          accept_line = "<A-k>",
          next = "<A-]>",
          prev = "<A-[>",
        }
      },
      tools = {
        uuidgen = vim.env.APPDATA and vim.env.HOME .. "\\scoop\\apps\\msys2\\current\\usr\\bin\\uuidgen.exe" or 'uuidgen',
        curl = vim.env.APPDATA and vim.env.HOME .. "\\scoop\\apps\\msys2\\current\\usr\\bin\\curl.exe" or 'curl',
        gzip = vim.env.APPDATA and vim.env.HOME .. "\\scoop\\apps\\msys2\\current\\usr\\bin\\gzip.exe" or 'gzip'
      },
    })

    -- https://github.com/Exafunction/windsurf.nvim/issues/168
    require('codeium.util').get_newline = function() return "\n" end
  end
end

-- ╭──────╮
-- │ Opts │
-- ╰──────╯

vim.opt.backupcopy = "yes"        -- fixes `next dev --turbopack` file change detection, see `:h file-watcher` and https://github.com/neovim/neovim/issues/1380
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.shellcmdflag = '-c'       -- https://github.com/folke/snacks.nvim/issues/1750
vim.opt.shellxquote = ''          -- https://github.com/folke/snacks.nvim/issues/1750
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.smartcase = true          -- smart case
vim.opt.splitbelow = true         -- force all horizontal splits to go below current window
vim.opt.splitright = true         -- force all vertical splits to go to the right of current window
vim.opt.tabstop = 2               -- insert 2 spaces for a tab
vim.opt.timeoutlen = 500          -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.winborder = 'rounded'     -- MiniCompletion's info and signature border
vim.opt.wrap = false              -- display lines as one long line
vim.opt.shortmess:append "c"      -- don't give |ins-completion-menu| messages
-- vim.opt.pumheight = 5             -- cmdline completion menu height

if not vim.g.vscode then
  vim.opt.cmdheight = 0                       -- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 3                      -- laststatus=3 global status line (line between splits)
  vim.opt.number = true                       -- set numbered lines
  vim.opt.scrolloff = 3                       -- vertical scrolloff
  vim.opt.sidescrolloff = 3                   -- horizontal scrolloff
  vim.opt.virtualedit = "all"                 -- allow cursor bypass end of line
  vim.o.foldcolumn = '1'                      -- if '1' will show clickable fold signs
  vim.o.foldlevel = 99                        -- Disable folding at startup
  vim.o.foldmethod = "expr"                   -- expr = specify an expression to define folds
  vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()' -- if folding using treesitter then 'v:lua.vim.treesitter.foldexpr()'
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  vim.o.statuscolumn =
  '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%s%l '
end

-- ╭──────────────╮
-- │ Autocommands │
-- ╰──────────────╯

-- stop comment prefix on new lines
autocmd({ "BufEnter" }, { command = "set formatoptions-=cro" })

-- briefly highlight yanked text
autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end })

-- Disable mini.completion for a certain filetype (extracted from `:help mini.nvim`)
local f = function(args) vim.b[args.buf].minicompletion_disable = true end
autocmd('Filetype', { pattern = 'snacks_picker_input', callback = f })
autocmd('Filetype', { pattern = 'snacks_input', callback = f })

-- https://www.reddit.com/r/neovim/comments/xgziol/setting_html_syntax_highlight_prevent_the_svelte
autocmd({ "BufWinEnter" }, { pattern = "*.svelte", command = "syntax on | set syntax=html" })
autocmd({ "BufWinEnter" }, { pattern = "*.code-snippets", command = "set ft=json" })

-- right click menu
vim.cmd [[ anoremenu PopUp.Explorer <cmd>lua Snacks.explorer.open({ auto_close = true, layout = { preset = 'big_preview', preview = true, layout = { width = vim.o.columns, height = vim.o.lines } }})<cr> ]]
vim.cmd [[ anoremenu PopUp.Quit <cmd>quit!<cr> ]]

autocmd({ "TermEnter", "TermOpen" }, { callback = function() vim.cmd.startinsert() end })

-- https://github.com/neovim/neovim/issues/14986
autocmd({ "TermLeave", --[[ "TermClose", "BufWipeout" ]] }, {
  callback = function()
    vim.schedule(function()
      -- if vim.bo.buftype == 'terminal'  then vim.cmd [[ bp | bd! # ]] end
      -- if vim.bo.filetype == 'terminal' then vim.cmd [[ bp | bd! # ]] end

      -- required when exiting `nvim -cterm`
      if vim.fn.bufname() == "" then
        vim.cmd.quit()
      end
    end)
  end,
})

------------------------------------------------------------------------------------------------------------------------

local ns = vim.api.nvim_create_namespace("flash")

vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#c0caf5", bg = "#FF007C" })

M.labels = vim.split('abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ', '')
M.results = {}
M.cmdline = ""

-- For replacing certain <C-x>... keymaps.
function M.press(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "nt", true)
end

-- get search results in a table
function M.search(search)
  local view = vim.fn.winsaveview()
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  local pos = vim.api.nvim_win_get_cursor(0)

  local matches = {}
  while true do
    if vim.fn.search(search, "W") == 0 then break end

    local start = vim.api.nvim_win_get_cursor(0)

    vim.fn.search(search, "ceW")

    -- skip label for the first char of search
    local new_pos = vim.api.nvim_win_get_cursor(0)
    if new_pos[1] == pos[1] and new_pos[2] == pos[2] then
      break
    end
    pos = new_pos

    table.insert(matches, {
      row = pos[1],
      col = pos[2],
      pos = start,
      next = vim.api.nvim_buf_get_text(0, pos[1] - 1, pos[2] + 1, pos[1] - 1, pos[2] + 2, {})[1]
    })
  end

  vim.fn.winrestview(view)
  return matches
end

-- https://github.com/folke/flash.nvim/blob/22913c65a1c960e3449c813824351abbdb327c7b/lua/flash/init.lua
function M.flash()
  local info = vim.fn.getcmdline()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  -- press label and jump
  for char, match in pairs(M.results) do
    if info == M.cmdline .. char then
      local pos = match.pos

      -- For operator pending mode, set the search pattern to the first character on the match position
      -- \%5l\%11c.  match in line 5 at column 11 `.` matches any character
      if vim.v.operator ~= "" then
        local s = ("\\%%%dl\\%%%dc."):format(pos[1], pos[2] + 1)
        vim.fn.setcmdline(s)
        M.press("<CR>")
      else
        M.press("<esc>")
        vim.schedule(function()
          vim.api.nvim_win_set_cursor(0, pos)
        end)
      end

      return
    end
  end

  M.cmdline = info
  local matches = M.search(info)
  -- vim.notify(vim.inspect(matches))

  ---@type table<string, boolean>
  local next_chars = {}
  for _, match in ipairs(matches) do
    next_chars[match.next] = true
    next_chars[match.next:lower()] = true -- lower() to skip lowercase label of the char if next char is Uppercase
  end

  M.results = {}

  -- create virtual text with labels
  local l = 0
  for _, match in ipairs(matches) do
    l = l + 1

    -- Skip labels that match next characters
    while M.labels[l] and next_chars[M.labels[l]] do
      l = l + 1
    end

    if not M.labels[l] then break end

    M.results[M.labels[l]] = match

    vim.api.nvim_buf_set_extmark(0, ns, match.row - 1, 0, {
      virt_text = { { M.labels[l], "FlashLabel" } },
      virt_text_pos = "overlay",
      virt_text_win_col = match.col + 1,
    })
  end
end

autocmd("CmdlineChanged", {
  callback = function()
    if vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?" then -- if stuck press `/` many times
      M.flash()
      vim.schedule(function()
        vim.cmd("redraw") -- forces to redraw the extmarks for neovim v0.12
      end)
    end
    -- vim.notify("") -- forces to redraw the extmarks for neovim v0.12
  end,
})

autocmd("CmdlineLeave", {
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) -- clear extmarks
  end,
})

------------------------------------------------------------------------------------------------------------------------

-- ╭──────╮
-- │ Mini │
-- ╰──────╯

local gen_ai_spec = require('mini.extra').gen_ai_spec
local mini_clue = require("mini.clue")

require("mini.ai").setup({
  custom_textobjects = {
    d = gen_ai_spec.diagnostic(),                                                                                           -- diagnostic textobj
    e = gen_ai_spec.line(),                                                                                                 -- line textobj
    I = gen_ai_spec.indent(),                                                                                               -- indent textobj including blank-lines
    h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } },       -- html attribute textobj
    k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                             -- key textobj
    v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                        -- value textobj
    m = gen_ai_spec.number(),                                                                                               -- number(inside string) textobj { '[-+]?()%f[%d]%d+()%.?%d*' }
    x = { '#()%x%x%x%x%x%x()' },                                                                                            -- hexadecimal textobj
    o = { "%S()%s+()%S" },                                                                                                  -- whitespace textobj
    u = { { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]', }, '^().*()$' }, -- sub word textobj https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt

    -- https://thevaluable.dev/vim-create-text-objects
    -- select indent by the same or mayor level delimited by blank-lines
    i = function()
      local start_indent = vim.fn.indent(vim.fn.line('.'))

      local prev_line = vim.fn.line('.') - 1
      while vim.fn.indent(prev_line) >= start_indent do
        prev_line = prev_line - 1
      end

      local next_line = vim.fn.line('.') + 1
      while vim.fn.indent(next_line) >= start_indent do
        next_line = next_line + 1
      end

      return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
    end,

    -- select indent by the same level delimited by comment-lines (outer: includes blank-lines)
    y = function()
      local start_indent      = vim.fn.indent(vim.fn.line('.'))
      local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
      local is_out_of_range   = function(line) return vim.fn.indent(line) == -1 end
      local is_comment_line   = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end
      local is_blank_line     = function(line) return string.match(vim.fn.getline(line), '^%s*$') end

      local prev_line         = vim.fn.line('.') - 1
      while vim.fn.indent(prev_line) == start_indent or is_blank_line(prev_line) do
        if is_out_of_range(prev_line) then break end
        if is_comment_line(prev_line) then break end
        if is_blank_line(prev_line) and _G.skip_blank_line then break end
        prev_line = prev_line - 1
      end

      local next_line = vim.fn.line('.') + 1
      while vim.fn.indent(next_line) == start_indent or is_blank_line(next_line) do
        if is_out_of_range(next_line) then break end
        if is_comment_line(next_line) then break end
        if is_blank_line(next_line) and _G.skip_blank_line then break end
        next_line = next_line + 1
      end

      return { from = { line = prev_line + 1, col = 1 }, to = { line = next_line - 1, col = 100 }, vis_mode = 'V' }
    end
  },
  n_lines = 500, -- search range and required by functions less than 500 LOC
})

require('mini.align').setup()
require('mini.bracketed').setup({ undo = { suffix = '' } })
require('mini.jump').setup( --[[{ repeat_jump = ';' }]]) -- ; by default
require('mini.operators').setup()
require('mini.splitjoin').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()

if not vim.g.vscode then
  require('mini.clue').setup({
    triggers = {
      { mode = 'o', keys = 'a' },
      { mode = 'x', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'x', keys = 'i' },
      { mode = 'o', keys = 'g' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
      { mode = 'n', keys = "'" },
      { mode = 'x', keys = "'" },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
    },
    clues = {
      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.windows(),
      mini_clue.gen_clues.z(),
      { desc = "argument",    keys = "aa", mode = "o" },
      { desc = "argument",    keys = "aa", mode = "x" },
      { desc = "argument",    keys = "ia", mode = "o" },
      { desc = "argument",    keys = "ia", mode = "x" },
      { desc = "braces",      keys = "ab", mode = "o" },
      { desc = "braces",      keys = "ab", mode = "x" },
      { desc = "braces",      keys = "ib", mode = "o" },
      { desc = "braces",      keys = "ib", mode = "x" },
      { desc = "diagnostic",  keys = "ad", mode = "o" },
      { desc = "dignostic",   keys = "ad", mode = "x" },
      { desc = "dignostic",   keys = "id", mode = "o" },
      { desc = "dignostic",   keys = "id", mode = "x" },
      { desc = "line",        keys = "ae", mode = "o" },
      { desc = "line",        keys = "ae", mode = "x" },
      { desc = "line",        keys = "ie", mode = "o" },
      { desc = "line",        keys = "ie", mode = "x" },
      { desc = "func_call",   keys = "af", mode = "o" },
      { desc = "func_call",   keys = "af", mode = "x" },
      { desc = "func_call",   keys = "if", mode = "o" },
      { desc = "func_call",   keys = "if", mode = "x" },
      { desc = "html_atrib",  keys = "ah", mode = "o" },
      { desc = "html_atrib",  keys = "ah", mode = "x" },
      { desc = "html_atrib",  keys = "ih", mode = "o" },
      { desc = "html_atrib",  keys = "ih", mode = "x" },
      { desc = "indent",      keys = "aI", mode = "o" },
      { desc = "indent",      keys = "aI", mode = "x" },
      { desc = "indent",      keys = "iI", mode = "o" },
      { desc = "indent",      keys = "iI", mode = "x" },
      { desc = "key",         keys = "ak", mode = "o" },
      { desc = "key",         keys = "ak", mode = "x" },
      { desc = "key",         keys = "ik", mode = "o" },
      { desc = "key",         keys = "ik", mode = "x" },
      { desc = "number",      keys = "am", mode = "o" },
      { desc = "number",      keys = "am", mode = "x" },
      { desc = "number",      keys = "im", mode = "o" },
      { desc = "number",      keys = "im", mode = "x" },
      { desc = "whitespace",  keys = "ao", mode = "o" },
      { desc = "whitespace",  keys = "ao", mode = "x" },
      { desc = "whitespace",  keys = "io", mode = "o" },
      { desc = "whitespace",  keys = "io", mode = "x" },
      { desc = "paragraph",   keys = "ao", mode = "o" },
      { desc = "paragraph",   keys = "ap", mode = "x" },
      { desc = "paragraph",   keys = "ip", mode = "o" },
      { desc = "paragraph",   keys = "ip", mode = "x" },
      { desc = "quote",       keys = "aq", mode = "o" },
      { desc = "quote",       keys = "aq", mode = "x" },
      { desc = "quote",       keys = "iq", mode = "o" },
      { desc = "quote",       keys = "iq", mode = "x" },
      { desc = "sentence",    keys = "as", mode = "o" },
      { desc = "sentence",    keys = "as", mode = "x" },
      { desc = "sentence",    keys = "is", mode = "o" },
      { desc = "sentence",    keys = "is", mode = "x" },
      { desc = "tag",         keys = "at", mode = "o" },
      { desc = "tag",         keys = "at", mode = "x" },
      { desc = "tag",         keys = "it", mode = "o" },
      { desc = "tag",         keys = "it", mode = "x" },
      { desc = "subword",     keys = "au", mode = "o" },
      { desc = "subword",     keys = "au", mode = "x" },
      { desc = "subword",     keys = "iu", mode = "o" },
      { desc = "subword",     keys = "iu", mode = "x" },
      { desc = "value",       keys = "av", mode = "o" },
      { desc = "value",       keys = "av", mode = "x" },
      { desc = "value",       keys = "iv", mode = "o" },
      { desc = "value",       keys = "iv", mode = "x" },
      { desc = "word",        keys = "aw", mode = "o" },
      { desc = "word",        keys = "aw", mode = "x" },
      { desc = "word",        keys = "iw", mode = "o" },
      { desc = "word",        keys = "iw", mode = "x" },
      { desc = "WORD",        keys = "aW", mode = "o" },
      { desc = "WORD",        keys = "aW", mode = "x" },
      { desc = "WORD",        keys = "iW", mode = "o" },
      { desc = "WORD",        keys = "iW", mode = "x" },
      { desc = "hexadecimal", keys = "ax", mode = "o" },
      { desc = "hexadecimal", keys = "ax", mode = "x" },
      { desc = "hexadecimal", keys = "ix", mode = "o" },
      { desc = "hexadecimal", keys = "ix", mode = "x" },
      { desc = "user_prompt", keys = "a?", mode = "o" },
      { desc = "user_prompt", keys = "a?", mode = "x" },
      { desc = "user_prompt", keys = "i?", mode = "o" },
      { desc = "user_prompt", keys = "i?", mode = "x" },
    },
  })

  require('mini.base16').setup({
    -- `:Inspect` to reverse engineering a colorscheme
    -- `:hi <@treesitter>` to view colors of `:Inspect` output
    -- `:lua require("snacks").picker.highlights()` to view generated colorscheme
    -- https://github.com/NvChad/base46/tree/v2.5/lua/base46/themes for popular colorscheme palettes
    -- https://github.com/echasnovski/mini.nvim/discussions/36 community palettes
    palette = {
      -- BAT_THEME=base16 -- tokyonight -- description
      base00 = "#000000", -- "#1a1b26", -- default bg
      base01 = "#111111", -- "#16161e", -- line number bg
      base02 = "#2c2c2c", -- "#2f3549", -- statusline bg, selection bg
      base03 = "#444b6a", -- "#444b6a", -- line number fg, comments
      base04 = "#787c99", -- "#787c99", -- statusline fg
      base05 = "#a9b1d6", -- "#a9b1d6", -- default fg, delimiters
      base06 = "#cbccd1", -- "#cbccd1", -- light fg (not often used)
      base07 = "#d5d6db", -- "#d5d6db", -- light bg (not often used)
      base08 = "#5555cc", -- "#7aa2f7", -- variables, tags, Diff delete
      base09 = "#999900", -- "#ff9e64", -- integers, booleans, constants, search fg
      base0A = "#ff0000", -- "#0db9d7", -- classes, search bg
      base0B = "#009900", -- "#73daca", -- strings, Diff insert
      base0C = "#3c3cff", -- "#2ac3de", -- builtins, regex
      base0D = "#5FB3A1", -- "#7aa2f7", -- functions
      base0E = "#8855ff", -- "#bb9af7", -- keywords, Diff changed
      base0F = "#a0a0a0", -- "#7aa2f7", -- punctuation, indentscope
    },
    use_cterm = true,     -- required if `vi -c 'Pick files'`
  })

  -- neovim terminal colors
  vim.g.terminal_color_0 = "#3c3c3c"
  vim.g.terminal_color_1 = "#990000"
  vim.g.terminal_color_2 = "#009900"
  vim.g.terminal_color_3 = "#999900"
  vim.g.terminal_color_4 = "#5555cc"
  vim.g.terminal_color_5 = "#8855ff"
  vim.g.terminal_color_6 = "#5FB3A1"
  vim.g.terminal_color_7 = "#a0a0a0"
  vim.g.terminal_color_8 = "#6c6c6c"
  vim.g.terminal_color_9 = "#ff0000"
  vim.g.terminal_color_10 = "#00ff00"
  vim.g.terminal_color_11 = "#ffff00"
  vim.g.terminal_color_12 = "#1c1cff"
  vim.g.terminal_color_13 = "#8844bb"
  vim.g.terminal_color_14 = "#5DE4C7"
  vim.g.terminal_color_15 = "#ffffff"

  -- adding tokyonight transparency
  vim.api.nvim_set_hl(0, "Normal", { fg = "#787c99", bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#444b6a" })
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#787c99" })
  vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#a9b1d6" })
  vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { fg = "#5555cc" })
  -- vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#d5d6db" })
  vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#5555cc" })
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#990000" })
  vim.api.nvim_set_hl(0, "MiniClueDescGroup", { fg = "#8855ff" })
  vim.api.nvim_set_hl(0, "MiniClueNextKey", { fg = "#5fb3a1" })
  vim.api.nvim_set_hl(0, "MiniClueTitle", { fg = "#5fb3a1" })
  vim.api.nvim_set_hl(0, "MiniClueSeparator", { fg = "#3c3cff" })
  vim.api.nvim_set_hl(0, "diffAdded", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "diffChanged", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#ff0000" })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#990000" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#3C3CFf", fg = "#ffffff" })
  vim.api.nvim_set_hl(0, "CopilotLspNesApply", { bg = "#00003c", blend = 50 })  -- blend for virtual line not suported
  vim.api.nvim_set_hl(0, "CopilotLspNesAdd", { bg = "#003c00", blend = 50 })    -- blend for virtual line not suported
  vim.api.nvim_set_hl(0, "CopilotLspNesDelete", { bg = "#3c0000", blend = 50 }) -- blend for virtual line not suported
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e0af68" })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#e0af68" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#db4b4b" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#1abc9c" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#0db9d7" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#e0af68" })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = "#2c2c2c" })
  vim.api.nvim_set_hl(0, "PmenuMatch", { bold = true, fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "Search", { fg = "#c0caf5", bg = "#3d59a1" })

  local function add_vscode_snippets_to_rtp()
    -- local snippet_dirs = vim.fn.glob("~/.vscode/extensions/*/snippets", 0, 1)
    -- local snippet_dirs = vim.fn.expand("~/.vscode/extensions/*/snippets", 0, 1)
    local vscode_extensions = vim.fs.dirname(vim.fs.dirname(retronvim_path))
    local snippet_dirs = vim.fn.expand(vscode_extensions .. "/*/snippets", 0, 1)

    for _, dir in ipairs(snippet_dirs) do
      -- ~/.vscode/extensions/emranweb.daisyui-snippet-1.0.3/snippets/snippetshtml.code-snippets  No contains a valid JSON object so delete the file to make mini.snippet work or to fix it (usually extras commas) install biome and change snippetshtml.code-snippets filetype to json `:set ft=json`
      -- ~/.vscode/extensions/imgildev.vscode-nextjs-generator-2.6.0/snippets/trpc.code-snippets  No contains a valid JSON object so delete the file to make mini.snippet work or to fix it (usually extras commas) install biome and change trpc.code-snippets         filetype to json `:set ft=json`
      vim.opt.rtp:append(vim.fs.dirname(dir))
    end
  end

  add_vscode_snippets_to_rtp()

  require('mini.snippets').setup({
    snippets = { require('mini.snippets').gen_loader.from_runtime("*code-snippets") },
    mappings = {
      expand = '<a-.>',
      jump_next = '<a-n>',
      jump_prev = '<a-p>',
    }
  })

  -- vscode snippets inside mini.completion (uninstall the vscode snippet extensions that you don't want to be sourced into mini.completion)
  -- race condition with lsp completion when pressing `.` causing showing only mini.snippets entries, example in python: `import os; os.`
  require('mini.snippets').start_lsp_server()

  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = {
        add = '│',
        change = '│',
        delete = '│'
      }
    },
    options = {
      wrap_goto = true
    }
  })

  -- install tailwindcss-language-server to highlight tailwind classes
  require("mini.hipatterns").setup({
    highlighters = {
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color()
    }
  })

  -- require('mini.cmdline').setup() -- FIXME: not closing popup when using with M.flash
  require('mini.completion').setup()
  require('mini.cursorword').setup()
  require('mini.icons').setup()
  require('mini.icons').mock_nvim_web_devicons()
  require('mini.icons').tweak_lsp_kind( --[[ "replace" ]])
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_restore_cursor()
  require('mini.notify').setup({ window = { winblend = 0 } --[[ ,lsp_progress = { enable = false } ]] })
  require('mini.pairs').setup()
  require('mini.statusline').setup()
  require('mini.starter').setup()
  require('mini.tabline').setup()
  vim.notify = require('mini.notify').make_notify() -- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
  vim.opt.completeopt:append('fuzzy')               -- it should be after require("mini.completion").setup())

  if vim.fn.has('nvim-0.12') == 1 then
    vim.opt.pumborder = 'rounded' -- MiniCompletion's suggestion border
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
  end
end

-- ╭────────────╮
-- │ Navigation │
-- ╰────────────╯

map({ "i" }, "jk", "<ESC>") -- disabled on visual mode since is slow
map({ "i" }, "kj", "<ESC>") -- disabled on visual mode since is slow
map({ "n" }, "J", "10gj")
map({ "n" }, "K", "10gk")
map({ "n" }, "H", "10h")
map({ "n" }, "L", "10l")
map({ "n" }, "Y", "yg_", { desc = "Yank forward" })          -- "Y" yank forward by default
map({ "x" }, "Y", "g_y", { desc = "Yank forward" })
map({ "x" }, "P", "g_P", { desc = "Paste forward" })         -- "P" doesn't change register
map({ "x" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
map({ "n", "x" }, "U", "@:", { desc = "repeat `:command`" }) --> :normal A,jkj --> :normal A,j --->  escape char by pression ctrl+v then escape
map({ "n", "x" }, "\\", "@q", { desc = "repeat q register/macro" })
map({ "n", "x" }, "|", "@w", { desc = "repeat w register/macro" })
map({ "x" }, "<", "<gv", { desc = "continious indent" })
map({ "x" }, ">", ">gv", { desc = "continious indent" })
map(
  "n",
  "<esc>",
  function()
    local ok, copilot_lsp = pcall(require, "copilot-lsp.nes")
    if ok then copilot_lsp.clear() end
    vim.cmd.nohlsearch()
    M.press("<esc>")
  end,
  { desc = "Clear Copilot-suggestion / search-highlight" }
)

if not vim.g.vscode then
  map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
  map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, desc = "prev completion when no lsp" })
  map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "t" }, "<S-esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
  map({ "n" }, "<C-;>", "<C-6>", { desc = "go to last buffer" })
  map({ "n", "t" }, "<C-\\>", function() Snacks.terminal() end, { desc = "toggle float terminal" }) -- vim.o.shell doesn't work on zsh.exe
  map({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window or [w" })
  map({ "n", "t" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window or ]w" })
  map({ "n", "t" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window or [w" })
  map({ "n", "t" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window or ]w" })
  map({ "n", "x", "t" }, "<C-S-l>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "x", "t" }, "<C-S-h>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "x", "t" }, "<C-S-j>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "x", "t" }, "<C-S-k>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "n", "x", "t" }, "<S-right>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "x", "t" }, "<S-left>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "x", "t" }, "<S-down>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "x", "t" }, "<S-up>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "n" }, "<right>", "<cmd>bnext<CR>", { desc = "next buffer" })
  map({ "n" }, "<left>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
  map({ "n" }, "<leader>x", "<cmd>bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
end

-- Quick quit/write
if not vim.g.vscode then
  map({ "n" }, "Q", "<cmd>lua vim.cmd.quit()<cr>")
  map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format{ timeout_ms = 5000 } MiniTrailspace.trim() vim.cmd.write()<cr>")
else
  map({ "n" }, "Q", function() vscode.call('workbench.action.closeActiveEditor') end)
  map({ "n" }, "R", function()
    vscode.call('editor.action.format')
    vscode.call('workbench.action.files.save')
  end)
end

-- ╭────────────────╮
-- │ leader keymaps │
-- ╰────────────────╯

if not vim.g.vscode then
  ---------------------------------------------------------------------------------------------------------------------
  vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })

  -- https://neovim.io/doc/user/lsp.html#_quickstart
  vim.lsp.config('*', {
    ---- https://www.reddit.com/r/neovim/comments/1ao6c5a/how_to_make_the_lsp_aware_of_changes_made_to_background_buffers
    ---- `:=vim.lsp.protocol.make_client_capabilities()`
    -- capabilities = {
    --   workspace = {
    --     didChangeWatchedFiles = {
    --       dynamicRegistration = true, -- on linux if `next dev --turbopack` not working install `pixi global install fswatch` or `pixi global install inotify-tools`, see: https://github.com/neovim/neovim/issues/1380
    --     }
    --   }
    -- },
    root_markers = { '.git' },
  })

  -- pnpm packages on Windows 11 requires `.cmd`
  local dotcmd                            = vim.env.APPDATA and '.cmd' or ''

  vim.lsp.config['astro']                 = {
    cmd = { 'astro-ls' .. dotcmd, '--stdio' },
    init_options = {
      typescript = {
        tsdk = vim.env.HOME .. '/.pixi/envs/neovim-lsp/lib/node_modules/typescript/lib'
      },
    },
    filetypes = { 'astro' }
  }

  -- https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/lsp/settings/jsonls.lua
  -- to have intellisense for your-file.json add `"$schema": "https://json.schemastore.org/<your-file>.json"`
  -- tutorial: https://www.youtube.com/watch?v=m30JiCuW42U
  vim.lsp.config['jsonls']                = {
    cmd = { 'vscode-json-language-server' .. dotcmd, '--stdio' },
    filetypes = { 'json', 'jsonc' },
    settings = {
      json = {
        schemas = {
          {
            description = "NPM configuration file",
            fileMatch = {
              "package.json",
            },
            url = "https://json.schemastore.org/package.json",
          },
        },
        validate = {
          enable = true, -- to show errors since we are rewritting json settings
        },
        format = {
          enable = true
        }
      },
    }
  }

  vim.lsp.config['luals']                 = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            "vim"
          }
        }
      }
    }
  }

  -- https://github.com/zed-industries/zed/issues/30767
  vim.lsp.config['prismals']              = {
    cmd = { 'prisma-language-server' .. dotcmd, '--stdio' },
    filetypes = { 'prisma' },
    settings = {
      prisma = {
        diagnostics = true, -- fixes `settings.enableDiagnostics === false` in prisma version 6.8.2
      },
    },
  }

  -- https://www.reddit.com/r/neovim/comments/1jn3rjw/help_me_understand/
  vim.lsp.config['pyright']               = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    settings = { python = {} } -- provides default settings
  }

  vim.lsp.config['volar']                 = {
    cmd = { 'vue-language-server' .. dotcmd, '--stdio' },
    filetypes = { 'vue' },
    init_options = {
      typescript = {
        tsdk = vim.env.HOME .. '/.pixi/envs/neovim-lsp/lib/node_modules/typescript/lib'
      },
      vue = {
        hybridMode = false, -- allows typescript inside .vue files
      },
    },
  }

  -- to have intellisense for your-file.yaml add `# yaml-language-server: $schema=https://json.schemastore.org/<your-file>.json`
  -- example: https://gist.github.com/doitian/4c849956f5c97bd1115351142d446853
  -- yaml-language-server downloads https://schemastore.org's schemas and detects files like .gitlab-ci.yaml, .github/worksflows/*, docker-compose.yaml ... by default
  -- `:lua vim.lsp.buf.hover()` to see which schema is using
  vim.lsp.config['yamlls']                = {
    cmd = { 'yaml-language-server' .. dotcmd, '--stdio' },
    filetypes = { 'yaml' },
    settings = {
      yaml = {
        schemas = {
          -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci*",
          -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.yaml",
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] =
          "/*.k8s.yaml",
        },
        format = {
          enable = true
        }
      }
    }
  }

  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/formatters
  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/linters
  vim.lsp.config['efm']                   = {
    cmd = { 'efm-langserver' },
    filetypes = { 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'html', 'json', 'jsonc', 'markdown', 'yaml' },
    init_options = { documentFormatting = true },
    settings = {
      rootMarkers = { ".git/" },
      languages = {
        python          = { { formatCommand = "black -", formatStdin = true } },
        javascript      = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        javascriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        typescript      = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        typescriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        css             = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        html            = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        json            = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        jsonc           = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        markdown        = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        yaml            = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
      }
    }
  }

  -- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
  vim.lsp.config['bashls']                = { cmd = { 'bash-language-server' .. dotcmd, 'start' }, filetypes = { 'bash', 'sh' } }
  vim.lsp.config['biome']                 = { cmd = { 'biome', 'lsp-proxy' }, filetypes = { 'astro', 'css', 'graphql', 'javascript', 'javascriptreact', 'json', 'jsonc', 'svelte', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' } }
  vim.lsp.config['clangd']                = { cmd = { 'clangd' }, filetypes = { 'c', 'cpp' } }
  vim.lsp.config['cssls']                 = { cmd = { 'vscode-css-language-server' .. dotcmd, '--stdio' }, filetypes = { 'css', 'scss', 'less' } }
  vim.lsp.config['dockerls']              = { cmd = { 'docker-langserver' .. dotcmd, '--stdio' }, filetypes = { 'dockerfile' } }
  vim.lsp.config['emmet_language_server'] = { cmd = { 'emmet-language-server' .. dotcmd, '--stdio' }, filetypes = { 'astro', 'css', 'html', 'htmldjango', 'javascriptreact', 'svelte', 'typescriptreact', 'vue', 'htmlangular' } }
  vim.lsp.config['gopls']                 = { cmd = { 'gopls' }, filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' } }
  vim.lsp.config['html']                  = { cmd = { 'node', 'vscode-html-language-server' .. dotcmd, '--stdio' }, filetypes = { 'html', 'templ' } }
  vim.lsp.config['intelephense']          = { cmd = { 'intelephense' .. dotcmd, '--stdio' }, filetypes = { 'php' } }
  vim.lsp.config['jdtls']                 = { cmd = { 'jdtls', }, filetypes = { 'java' }, }
  vim.lsp.config['marksman']              = { cmd = { 'marksman' }, filetypes = { 'markdown', 'markdown.mdx' } }
  vim.lsp.config['neocmake']              = { cmd = { 'neocmakelsp', '--stdio' }, filetypes = { 'cmake' } }
  vim.lsp.config['omnisharp']             = { cmd = { "OmniSharp", "-lsp" }, filetypes = { 'cs' } }
  vim.lsp.config['pylsp']                 = { cmd = { 'pylsp' }, filetypes = { 'python' } }
  vim.lsp.config['ruff']                  = { cmd = { 'ruff', 'server' }, filetypes = { 'python' } }
  vim.lsp.config['rust_analyzer']         = { cmd = { 'rust-analyzer' }, filetypes = { 'rust' } }
  vim.lsp.config['sqlls']                 = { cmd = { 'sql-language-server' .. dotcmd, 'up', '--method', 'stdio' }, filetypes = { 'sql', 'mysql' } }
  vim.lsp.config['sqls']                  = { cmd = { 'sqls' }, filetypes = { 'sql', 'mysql' } }
  vim.lsp.config['svelte']                = { cmd = { 'svelteserver' .. dotcmd, '--stdio' }, filetypes = { 'svelte' } }
  vim.lsp.config['tailwindcss']           = { cmd = { 'tailwindcss-language-server' .. dotcmd, '--stdio' }, filetypes = { 'astro', 'astro-markdown', 'django-html', 'htmldjango', 'gohtml', 'gohtmltmpl', 'html', 'htmlangular', 'markdown', 'mdx', 'php', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'templ' } }
  vim.lsp.config['taplo']                 = { cmd = { 'taplo', 'lsp', 'stdio' }, filetypes = { 'toml' } }
  vim.lsp.config['terraformls']           = { cmd = { 'terraform-ls', 'serve' }, filetypes = { 'terraform', 'terraform-vars' } }
  vim.lsp.config['ts_ls']                 = { cmd = { 'typescript-language-server' .. dotcmd, '--stdio' }, filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' } }

  vim.lsp.enable({
    'astro',
    'bashls', 'biome',
    'clangd', 'cssls', 'copilot',
    'dockerls',
    'efm', 'emmet_language_server',
    'gopls',
    'html',
    'intelephense',
    'jdtls', 'jsonls',
    'luals',
    'marksman',
    'neocmake',
    'omnisharp',
    'prismals', 'pylsp', 'pyright',
    'ruff', 'rust_analyzer',
    'sqlls', 'sqls', 'svelte',
    'tailwindcss', 'taplo', 'terraformls', 'ts_ls',
    'volar',
    'yamlls'
  })

  -- https://www.youtube.com/watch?v=ooTcnx066Do
  local sendSequence = function(sequence1, sequence2)
    sequence2 = sequence2 or ""
    vim.cmd.term()
    vim.fn.chansend(vim.bo.channel, { sequence1 .. '\r' })
    vim.fn.chansend(vim.bo.channel, { sequence2 .. '\r' })
  end

  -- zsh.exe and bash.exe doesn't support `:!pixi global install lua-language-server` on Windows use powershell.exe or cmd.exe though `:lua os.execute('pixi global install lua-language-server')` works
  -- `pixi global remove nodejs --environment neovim-lsp` to remove only nodejs (e.g. if you want `pixi global install nodejs=20`)
  ---@format disable
  --vipga, --> to format manually
  map("n", "<leader>L", "", { desc = "+LSP installer" }) -- relaunch nvim to autostart the new installed lsp
  map("n", "<leader>La",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g @astrojs/language-server typescript') end,             { desc = "astro" })                       -- (no formatter use biome instead)
  map("n", "<leader>Lb",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g bash-language-server') end,                            { desc = "bashls" })                      -- (no formatter press `=` to format selection)
  map("n", "<leader>LB",  function() sendSequence('pixi g install biome --environment neovim-lsp') end,                                               { desc = "biome (formatter+eslint)" })    -- https://biomejs.dev/internals/language-support/
  map("n", "<leader>Lc",  function() sendSequence('pixi g install clang-tools --expose clangd') end,                                                  { desc = "clangd" })                      -- (+formatter)
  map("n", "<leader>Ld",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g dockerfile-language-server-nodejs') end,               { desc = "dockerls" })                    -- (+formatter)
  map("n", "<leader>Le",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g @olrtg/emmet-language-server') end,                    { desc = "emmet (autoclose tag)" })       -- suggests <autoclose-this-tag> but not </close-some-open-tag> like vscode-html-language-server
  map("n", "<leader>Lg",  function() sendSequence('pixi g install gopls --environment neovim-lsp') end,                                               { desc = "gopls (golang)" })              -- (+formatter)
  map("n", "<leader>Li",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g intelephense') end,                                    { desc = "intelephense (php)" })          -- (+formatter)
  map("n", "<leader>Lj",  function() sendSequence('pixi g install jdtls --environment neovim-lsp') end,                                               { desc = "jdtls (java)" })                -- (+formatter)
  map("n", "<leader>LJ",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g vscode-langservers-extracted') end,                    { desc = "cssls/html/jsonls" })           -- (+formatter)
  map("n", "<leader>Lk",  function() sendSequence('pixi g install black efm-langserver --environment neovim-lsp') end,                                { desc = "black (python formatter)" })
  map("n", "<leader>Ll",  function() sendSequence('pixi g install lua-language-server --environment neovim-lsp') end,                                 { desc = "luals (for unix)" })            -- (+formatter)
  map("n", "<leader>LL",  function() sendSequence('winget install luals.lua-language-server; # scoop install lua-language-server') end,               { desc = "luals (for windows)" })         -- (+formatter)
  map("n", "<leader>Lm",  function() sendSequence('pixi g install marksman --environment neovim-lsp') end,                                            { desc = "marksman (markdown)" })         -- (no formatter use prettier)
  map("n", "<leader>Ln",  function() sendSequence('pixi g install neocmakelsp --environment neovim-lsp') end,                                         { desc = "neocmake" })                    -- (+formatter +linter) https://github.com/regen100/cmake-language-server doesn't have formatter nor linter
  map("n", "<leader>Lo",  function() sendSequence('pixi g install omnisharp-roslyn --environment neovim-lsp') end,                                    { desc = "omnisharp (c#)" })              -- (+formatter)
  map("n", "<leader>Lpr", function() sendSequence('pixi g install prettier efm-langserver --environment neovim-lsp') end,                             { desc = "prettier (formatter)" })
  map("n", "<leader>LpR", function() sendSequence('pixi g install pnpm nodejs; pnpm install -g @prisma/language-server') end,                         { desc = "prismals" })                    -- (+formatter)
  map("n", "<leader>Lpy", function() sendSequence('pixi g install pyright --environment neovim-lsp') end,                                             { desc = "pyright (python)" })            -- (-formatter) means no formatter
  map("n", "<leader>LpY", function() sendSequence('pixi g install python-lsp-server -e neovim-lsp; pixi global expose add pylsp -e neovim-lsp' ) end, { desc = "pylsp (+formatter)" })          -- TODO: replace with https://github.com/astral-sh/ty since doens't show completions on external libraries like pynput
  map("n", "<leader>Lr",  function() sendSequence('pixi g install ruff --environment neovim-lsp') end,                                                { desc = "ruff (python formatter)" })
  map("n", "<leader>LR",  function() sendSequence('pixi g install rust --with rust-src') end,                                                         { desc = "rust_analyzer" })               -- (+formatter)
  map("n", "<leader>Lsq", function() sendSequence('pixi g install pnpm nodejs; pnpm install -g sql-language-server vscode-jsonrpc') end,              { desc = "sqlls(-formatter +linter)" })   -- (no formatter use sqls)
  map("n", "<leader>LsQ", function() sendSequence('pixi g install sqls --environment neovim-lsp') end,                                                { desc = "sqls (+formatter -linter)" })
  map("n", "<leader>Lsv", function() sendSequence('pixi g install pnpm nodejs; pnpm install -g svelte-language-server') end,                          { desc = "svelte" })                      -- (no formatter use biome)
  map("n", "<leader>Lta", function() sendSequence('pixi g install pnpm nodejs; pnpm install -g @tailwindcss/language-server') end,                    { desc = "tailwindcss" })
  map("n", "<leader>LtA", function() sendSequence('pixi g install taplo --environment neovim-lsp') end,                                               { desc = "taplo (toml)" })                -- (+formatter)
  map("n", "<leader>Lte", function() sendSequence('pixi g install terraform-ls --environment neovim-lsp') end,                                        { desc = "terraformls" })                 -- (no formatter press `=` to format selection)
  map("n", "<leader>Lty", function() sendSequence('pixi g install pnpm nodejs; pnpm install -g typescript typescript-language-server') end,           { desc = "typescript/angular/react/js" }) -- (+formatter)
  map("n", "<leader>Lv",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g @vue/language-server typescript') end,                 { desc = "volar (vue)" })                 -- (no formatter use biome)
  map("n", "<leader>Ly",  function() sendSequence('pixi g install pnpm nodejs; pnpm install -g yaml-language-server') end,                            { desc = "yamlls" })                      -- (+formatter)
  ---@format enable

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>l", "", { desc = "+LSP" })
  map("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  map("n", "<leader>lb", function() require("snacks").picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  map("n", "<leader>lc", function() require("snacks").picker.lsp_incoming_calls() end, { desc = "Incoming Calls" })
  map("n", "<leader>lC", function() require("snacks").picker.lsp_outgoing_calls() end, { desc = "Outcoming Calls" })
  map("n", "<leader>ld", function() require("snacks").picker.lsp_definitions() end, { desc = "Pick Definition" })
  map("n", "<leader>lD", function() require("snacks").picker.lsp_declarations() end, { desc = "Pick Declaration" })
  map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format" })
  map("n", "<leader>lh", function() vim.lsp.buf.hover() end, { desc = "Hover" })
  map("n", "<leader>lH", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
  map("n", "<leader>lI", function() require("snacks").picker.lsp_implementations() end, { desc = "Pick Implementation" })
  map("n", "<leader>lM", function() vim.cmd("checkhealth vim.lsp") end, { desc = "LspInfo" })
  map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
  map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
  map("n", "<leader>lO", function() require("snacks").picker.diagnostics() end, { desc = "Pick Diagnostics" })
  map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
  map("n", "<leader>lq", function() require("snacks").picker.loclist() end, { desc = "Pick Location List" })
  map("n", "<leader>lr", function() require("snacks").picker.lsp_references() end, { desc = "Pick References" })
  map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
  map("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, { desc = "Pick symbols" })
  map("n", "<leader>lS", function() require("snacks").picker.lsp_workspace_symbols() end,
    { desc = "Pick workspace symbols" })
  map("n", "<leader>lt", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Pick TypeDefinition" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>E", "", { desc = "+Extension" })
  map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", { desc = "Toggle Explorer" })
  map(
    "n",
    "<leader>Ec",
    function()
      if vim.env.APPDATA then vim.notify("windows not supported") return end

      vim.pack.add({{ src = 'https://github.com/chriswritescode-dev/consolelog.nvim', version = 'a7fe38cbef59d78f669744765f6d8b7b14b27d9a' }})

      vim.notify("only available for js, jsx, ts, tsx files")
      vim.notify("consolelog.nvim requires (debian) ------> apt install net-tools")
      vim.notify("consolelog.nvim requires (archlinux) ---> pacman -S net-tools")
      vim.notify("relaunch neovim")
    end,
    { desc = "consolelog.nvim install" }
  )
  map(
    "n",
    "<leader>El",
    function()
      local os_uname = vim.uv.os_uname().sysname:lower()
      local os = os_uname:find("win") and "win32" or os_uname
      local download_path = '~/.cache/node_modules/@github/copilot-language-server/native/' .. os .. '-x64/copilot-language-server'
      -- local download_url = 'https://github.com/github/copilot-language-server-release/releases/download/1.397.0/copilot-language-server-' .. os .. '-x64-1.397.0.zip'

      if vim.fn.executable('copilot-language-server') == 0 then
        sendSequence('pixi g install pnpm; pnpm install --dir ~/.cache @github/copilot-language-server', 'mkdir -p ~/.local/bin; cp '.. download_path ..  '~/.local/bin')
        -- sendSequence ( 'pixi exec curl -C- -o $HOME/.cache/copilot.zip -L' .. download_url, '7z x $HOME/.cache/copilot.zip -o"$HOME/.local/bin"')
      end

      vim.pack.add({{ src = 'https://github.com/copilotlsp-nvim/copilot-lsp', version = '884034b23c3716d55b417984ad092dc2b011115b' }})

      vim.notify("relaunch neovim after installation to login to copilot")
    end,
    { desc = "copilot-lsp install" } -- Copilot-NES is free and unlimited
  )
  map(
    "n",
    "<leader>Em",
    function()

      local sm_agent_path = vim.env.HOME .. "\\.supermaven\\binary\\v20\\windows-x86_64\\sm-agent.exe"
      local download_url = "https://supermaven-public.s3.amazonaws.com/sm-agent/v2/8/windows-msvc/x86_64/sm-agent.exe"

      -- download supermaven executable manually since powershell v5 can't download it
      if (vim.fn.has('win32') == 1 and vim.fn.executable(sm_agent_path) == 0) then
        sendSequence('pixi exec curl --create-dirs --output "' .. sm_agent_path .. '" "' .. download_url .. '" ')
      end

      vim.pack.add({{ src = "https://github.com/supermaven-inc/supermaven-nvim", checkout = "07d20fce48a5629686aefb0a7cd4b25e33947d50" }})

      vim.notify("requires a ramdom ID ---> :SupermavenUseFree")
      vim.notify("relaunch neovim")
    end,
    { desc = "supermaven-nvim install" }
  )
  map(
    "n",
    "<leader>Es",
    function()
      if vim.fn.executable('gemini') == 0 then
        sendSequence('pixi g install pnpm; pnpm install -g @google/gemini-cli')
      end

      vim.pack.add({{ src = 'https://github.com/folke/sidekick.nvim', version = 'v2.1.0' }})

      vim.notify("relaunch neovim")
    end,
    { desc = "sidekick.nvim install" }  -- Gemini is free and unlimited
  )
  map(
    "n",
    "<leader>Ew",
    function()
      if vim.env.APPDATA and vim.fn.executable('msys2') == 0 then
        sendSequence("scoop install msys2; msys2")
      end

      vim.pack.add({{ src = 'https://github.com/Exafunction/windsurf.nvim', checkout = "821b570b526dbb05b57aa4ded578b709a704a38a" }})
      vim.pack.add({{ src = 'https://github.com/nvim-lua/plenary.nvim', checkout = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" }})

      vim.notify("relaunch neovim")
      vim.notify("to login to windsurf run ---> :Codeium auth")
    end,
    { desc = "windsurf.nvim install" }
  )
  map("n", "<leader>EC", function() vim.pack.del({"consolelog.nvim"}) vim.notify("relaunch nvim") end, { desc = "consolelog.nvim uninstall" })
  map("n", "<leader>EL", function() vim.pack.del({"copilot-lsp"}) vim.notify("relaunch nvim") end, { desc = "copilot-lsp uninstall" })
  map("n", "<leader>EM", function() vim.pack.del({"supermaven-nvim"}) vim.notify("relaunch nvim") end, { desc = "supermaven-nvim uninstall" })
  map("n", "<leader>ES", function() vim.pack.del({"sidekick.nvim"}) vim.notify("relaunch nvim") end, { desc = "sidekick.nvim uninstall" })
  map("n", "<leader>EW", function() vim.pack.del({"windsurf.nvim", "plenary.nvim"}) vim.notify("relaunch nvim") end, { desc = "windsurf.nvim uninstall" })
  map("n", "<leader>EI", function() vim.print(vim.inspect(vim.pack.get())) end, { desc = "installed extensions" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>f", "", { desc = "+Find" })
  map("n", "<leader>fb", function() require("snacks").picker.buffers() end, { desc = "buffers" })
  map("n", "<leader>fB", function() require("snacks").picker.grep_buffers() end, { desc = "ripgrep on buffers" })
  map("n", "<leader>fc", function() require("snacks").picker.colorschemes() end, { desc = "colorscheme" })
  map("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "keymaps" })
  map("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "files" })
  map("n", "<leader>fg", function() require("snacks").picker.grep() end, { desc = "ripgrep" })
  map("n", "<leader>fn", function() require("mini.notify").show_history() end, { desc = "Notify history" })
  map("n", "<leader>fp", function() require("snacks").picker.projects() end, { desc = "projects" })
  map("n", "<leader>fq", function() require("snacks").picker.qflist() end, { desc = "quick list" })
  map("n", "<leader>fr", function() require("snacks").picker.recent() end, { desc = "recent files" })
  map("n", '<leader>f"', function() require("snacks").picker.registers() end, { desc = "register (:help quote)" })
  map(
    "n",
    "<leader>f;",
    function()
      Snacks.picker.files({
        focus = "list",
        layout = {
          preset = 'big_preview',
          layout = { width = vim.o.columns, height = vim.o.lines }
        }
      })
    end,
    { desc = "files (normal mode)" }
  )
  map("n", "<leader>f.", function() require("snacks").picker.jumps() end, { desc = "jumps" })
  map("n", "<leader>f'", function() require("snacks").picker.marks() end, { desc = "marks" })
  map("n", "<leader>f,", "<cmd>buffer #<cr>", { desc = "Recent buffer" })
  map("n", "<leader>;", function() require("snacks").picker.resume() end, { desc = "resume search" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>g", "", { desc = "+Git" })
  map("n", "<leader>gg", function() Snacks.terminal("lazygit")  end, { desc = "lazygit" }) -- `:term lazygit` doesn't work on zsh.exe
  map(
    "n",
    "<leader>gd",
    "<cmd>diffthis | vertical new | diffthis | read !git show HEAD^:#<cr>",
    { desc = "git difftool -t nvimdiff" }
  )
  map(
    "n",
    "<leader>gp",
    function()

      local curr_file = vim.fn.expand('%')
      local curr_line = vim.fn.line('.') - 2 -- Snacks.picker.git_diff() adds 3 lines and deleted hunks takes out 1 line

      require("snacks").picker.git_diff({
        focus = "list",
        layout = { preset = 'big_preview' },
        on_show = function(picker)

          local pos_index = {} -- { { 6, 3 }, { 19, 4 }, { 45, 5 }, { 55, 6 }, { 63, 7 } }
          local jump = 1

          -- fill pos_index
          for index, item in ipairs(picker:items()) do
            if (item.text == curr_file .. ":" .. item.pos[1]) then -- /[directory]/ also works
              table.insert(pos_index, {item.pos[1], index})
            end
          end

          if not pos_index[1] then return end

          -- find index to jump
          for index, item in ipairs(pos_index) do
            if (curr_line >= item[1]) then
              jump = index
            end
          end

          picker.list:view(pos_index[jump][2])
          -- vim.notify(vim.inspect(pos_index))
        end,
      })
    end,
    { desc = "Preview GitHunk" }
  )
  map("n", "<leader>gr", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gH')<cr>", { desc = "Reset GitHunk" })
  map("n", "<leader>gs", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gh')<cr>", { desc = "Stage GitHunk" })

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>u", "", { desc = "+UI toggle" })
  map("n", "<leader>u0", "<cmd>set showtabline=0<cr>", { desc = "buffer hide" })
  map("n", "<leader>u2", "<cmd>set showtabline=2<cr>", { desc = "buffer show" })
  map(
    "n",
    "<leader>uc",
    function()
      vim.o.number       = not vim.o.number
      vim.o.foldcolumn   = vim.o.number and '1' or '0'
      vim.o.signcolumn   = vim.o.number and 'auto' or 'no'
      vim.o.statuscolumn = vim.o.number and '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%s%l ' or ''
      vim.o.foldenable   = not vim.o.foldenable
    end,
    { desc = "statuscolumn toggle" }
  )
  map("n", "<leader>ud", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<cr>",
    { desc = "diagnostic toggle" })
  map("n", "<leader>uf", "<cmd>lua vim.o.foldmethod='indent'<cr>", { desc = "fold by indent (press z)" })
  map("n", "<leader>uF", "<cmd>lua vim.o.foldmethod='expr'<cr>", { desc = "fold by lsp (press z)" })
  map("n", "<leader>ul", "<cmd>set cursorline!<cr>", { desc = "cursorline toggle" })
  map("n", "<leader>up", "<cmd>popup PopUp<cr>", { desc = "mouse-popup toggle" })
  map("n", "<leader>us", "<cmd>set laststatus=0<cr>", { desc = "statusbar hide" })
  map("n", "<leader>uS", "<cmd>set laststatus=3<cr>", { desc = "statusbar show" })
  map(
    "n",
    "<leader>uu",
    function()
      if not Hidden then
        Bufnr = vim.fn.bufnr()
        vim.cmd.hide()
        Hidden = true
      else
        vim.cmd('split | buffer' .. Bufnr)
        Hidden = false
      end
    end,
    { desc = "hide/unhide window/terminal" }
  )

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>w", "", { desc = "+Window" })
  map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "vertical window" })
  map("n", "<leader>wV", "<cmd>split<cr>", { desc = "horizontal window" })
  map("n", "<leader>t", function() Snacks.terminal() end, { desc = "toggle float terminal" }) -- vim.o.shell doesn't work on zsh.exe
  map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = "vertical terminal" })
  map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = "horizontal terminal" })
end

if vim.g.vscode then
  map(
    "n",
    "<leader>o",
    function()
      vscode.action("workbench.files.action.focusFilesExplorer")
    end,
    { desc = "focus explorer" }
  )
else
  map(
    "n",
    "<leader>o",
    function()
      Snacks.explorer.open({ auto_close = true, layout = { preset = 'big_preview', preview = true } })
    end,
    { desc = "Explorer/previewer" }
  )
end

------------------------------------------------------------------------------------------------------------------------

map({ "n", "x" }, "<leader><leader>", "", { desc = "+Second Clipboard" })
map("n", "<leader><leader>p", '"*p', { desc = "Paste after" })
map("n", "<leader><leader>P", '"*P', { desc = "Paste before" })
map("x", "<leader><leader>p", '"*p', { desc = "Paste" })           -- "Paste after (second_clip)"
map("x", "<leader><leader>P", 'g_"*P', { desc = "Paste forward" }) -- only works in visual mode
map("n", "<leader><leader>y", '"*y', { desc = "Yank" })
map("n", "<leader><leader>Y", '"*yg_', { desc = "Yank forward" })
map("x", "<leader><leader>y", '"*y', { desc = "Yank" })
map("x", "<leader><leader>Y", 'g_"*y', { desc = "Yank forward" })

-- ╭────────────────────╮
-- │ Operator / Motions │
-- ╰────────────────────╯

-- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
map(
  { "n", "x" },
  "gT",
  function()
    local _, inner_outer_key = pcall(vim.fn.getcharstr)
    local _, motion_key = pcall(vim.fn.getcharstr)
    local cmd

    if vim.fn.mode() == "n" then
      -- empty spaces or repeat sequence `<`< escapes special char since `< waits for a especial char
      cmd = "v" .. inner_outer_key .. motion_key .. "`<    "
    else
      -- mT = Temp mark
      -- mS = Start mark
      cmd = "mT`>mS`Tv" .. inner_outer_key .. motion_key .. "`<v`So"
    end

    vim.cmd.exec([["normal ]] .. cmd .. [["]])
    vim.fn.setreg('w', cmd)
  end,
  { desc = "Start of TextObj (| to repeat)" }
)
map(
  { "n", "x" },
  "gt",
  function()
    local _, inner_outer_key = pcall(vim.fn.getcharstr)
    local _, motion_key = pcall(vim.fn.getcharstr)
    local cmd

    if vim.fn.mode() == "n" then
      cmd = "v" .. inner_outer_key .. motion_key .. "`>"
    else
      -- mT = Temp mark
      -- mS = Start mark
      cmd = "mT`<mS`Tv" .. inner_outer_key .. motion_key .. "`>v`So"
    end

    vim.cmd.exec([["normal ]] .. cmd .. [["]])
    vim.fn.setreg('q', cmd)
  end,
  { desc = "End of TextObj (\\ to repeat)" }
)

map({ "n", "x" }, "gb", '"_d', { desc = "Blackhole Motion/Selected (dot to repeat)" })
map({ "n", "x" }, "gB", '"_D', { desc = "Blackhole Linewise (dot to repeat)" })
map({ "n", "o", "x" }, "g.", "`.", { desc = "go to last change" })
map({ "n" }, "g,", "g,", { desc = "go forward in :changes" })  -- Formatting will lose track of changes
map({ "n" }, "g;", "g;", { desc = "go backward in :changes" }) -- Formatting will lose track of changes
map({ "n" }, "gy", '"1p', { desc = "Redo register (dot to Paste forward the rest of register)" })
map({ "n" }, "gY", '"1P', { desc = "Redo register (dot to Paste backward the rest of register)" })
map({ "n" }, "g<Up>", "<c-a>", { desc = "numbers ascending" })
map({ "n" }, "g<Down>", "<c-x>", { desc = "numbers descending" })
map({ "x" }, "g<Up>", "g<c-a>", { desc = "numbers ascending" })
map({ "x" }, "g<Down>", "g<c-x>", { desc = "numbers descending" })
map({ "n", "x" }, "g+", "<C-a>", { desc = "Increment number (dot to repeat)" })
map({ "n", "x" }, "g-", "<C-x>", { desc = "Decrement number (dot to repeat)" })

-- ╭─────────────────────────────────────────────────╮
-- │ Text Objects with "g", "a", "i" (dot to repeat) │
-- ╰─────────────────────────────────────────────────╯

map(
  { "x" },
  "go",
  function()
    local commentstring = vim.bo.commentstring
    vim.bo.commentstring = [[{/* %s */}]]
    vim.cmd [[ normal gc ]]
    vim.bo.commentstring = commentstring
  end,
  { desc = "jsx comment" }
)

map({ "n" }, "vgh", "<cmd>lua require('mini.diff').textobject()<cr>", { desc = "select diff/hunk" })
map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
map({ "n", "o", "x" }, "gC", function() require('mini.comment').textobject() end, { desc = "select BlockComment" })
map({ "n", "o", "x" }, "gD", function() require('mini.diff').textobject() end, { desc = "select diff/hunk" })
map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i", "i") end, { desc = "indent_noblanks" })
map({ "o", "x" }, "ai", "<cmd>normal Viiok<cr>", { desc = "indent_noblanks" })
map({ "o", "x" }, "iy", ":lua _G.skip_blank_line=true  MiniAi.select_textobject('i','y')<cr>", { desc = "same_indent" })
map({ "o", "x" }, "ay", ":lua _G.skip_blank_line=false MiniAi.select_textobject('i','y')<cr>", { desc = "same_indent" })
map({ "x" }, "iz", ":<c-u>normal! [zjV]z<cr>", { silent = true, desc = "inner fold" })
map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { silent = true, desc = "outer fold" })
map({ "o" }, "iz", ":normal Viz<cr>", { silent = true, desc = "inner fold" })
map({ "o" }, "az", ":normal Vaz<cr>", { silent = true, desc = "outer fold" })
