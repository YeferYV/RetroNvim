-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

-- Clone 'mini.nvim'
-- vim.fn.glob("~/.*/extensions/yeferyv.retronvim*/nvim/init.lua", 0, 1)[1] -- ...,0,1 shows in a list && [1] grabs the first match
local retronvim_exist = vim.env.APPDIR2 and
    vim.env.APPDIR2 .. "/usr/home/user/.config/nvim/init.lua" or
    vim.fn.expand("~/.*/extensions/yeferyv.retronvim*/nvim/init.lua", 0, 1)[1]

local retronvim_path = (retronvim_exist ~= nil) and
    vim.fs.dirname(retronvim_exist) or
    vim.env.HOME .. "/.vscode/extensions/yeferyv.retronvim/nvim"

local path_package = retronvim_path .. "/plugins/site/"
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

vim.opt.rtp:prepend(mini_path)
require('mini.deps').setup({ path = { package = path_package }, job = { timeout = 300000 } })
vim.cmd('packadd mini.nvim | helptags ALL')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local _, vscode = pcall(require, "vscode-neovim")
local map = vim.keymap.set
local M = {}

------------------------------------------------------------------------------------------------------------------------

if not vim.g.vscode then
  add { source = "folke/snacks.nvim", checkout = "v2.22.0" }

  now(
    function()
      local ok, snacks = pcall(require, "snacks")
      if not ok then return end
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
          sources = { explorer = { hidden = true, --[[ ignored = true ]] } },
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
      })
    end
  )
end

if not vim.g.vscode then
  -- add { source = "copilotlsp-nvim/copilot-lsp", checkout = "173c015ea61cb493997e3b1fa80bf57f6db58c26" }

  now(
    function()
      vim.opt.rtp:append(path_package .. 'pack/deps/opt/copilot-lsp')
      vim.g.copilot_nes_debounce = 75
      vim.lsp.enable("copilot_ls")
      vim.keymap.set({ "n", "i" }, "<A-;>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
              or (
                require("copilot-lsp.nes").apply_pending_nes()
                and require("copilot-lsp.nes").walk_cursor_end_edit()
              )
        end
      end, { desc = "Accept Copilot NES suggestion" })
    end
  )
end

if not vim.g.vscode then
  -- add { source = "folke/sidekick.nvim", checkout = "v2.1.0" }

  later(
    function()
      map(
        { 'x', 'n', 'i' },
        '<leader>lg',
        function() require("sidekick.cli").toggle({ name = "gemini" }) end,
        { desc = 'gemini cli' }
      )
      map(
        { 'x', 'n', 'i' },
        '<leader>lG',
        function() require("sidekick.cli").prompt() end,
        { desc = 'gemini prompt' }
      )

      vim.opt.rtp:append(path_package .. 'pack/deps/opt/sidekick.nvim')
      local ok, sidekick = pcall(require, "sidekick")
      if not ok then return end
      sidekick.setup({ nes = { enabled = false } })
    end
  )
end

if not vim.g.vscode then
  -- add { source = "supermaven-inc/supermaven-nvim", checkout = "07d20fce48a5629686aefb0a7cd4b25e33947d50" }

  later(
    function()
      vim.opt.rtp:append(path_package .. 'pack/deps/opt/supermaven-nvim')
      local ok, supermaven = pcall(require, "supermaven-nvim")
      if not ok then return end
      supermaven.setup {
        keymaps = {
          accept_suggestion = "<A-l>",
          clear_suggestion = "<A-k>",
          accept_word = "<A-j>",
        }
        -- ignore_filetypes = { "prompt", "snacks_input", "snacks_picker_input" }
      }
    end
  )
end

-- ╭──────╮
-- │ Opts │
-- ╰──────╯

vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.smartcase = true          -- smart case
vim.opt.splitbelow = true         -- force all horizontal splits to go below current window
vim.opt.splitright = true         -- force all vertical splits to go to the right of current window
vim.opt.tabstop = 2               -- insert 2 spaces for a tab
vim.opt.timeoutlen = 500          -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.wrap = false              -- display lines as one long line
vim.opt.shortmess:append "c"      -- don't give |ins-completion-menu| messages
vim.g.mapleader = " "             -- <leader> key

if not vim.g.vscode then
  vim.opt.cmdheight = 0                       -- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 3                      -- laststatus=3 global status line (line between splits)
  vim.opt.number = true                       -- set numbered lines
  vim.opt.scrolloff = 8                       -- vertical scrolloff
  vim.opt.sidescrolloff = 8                   -- horizontal scrolloff
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

local autocmd = vim.api.nvim_create_autocmd

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

------------------------------------------------------------------------------------------------------------------------

autocmd({ "TermEnter", "TermOpen" }, {
  callback = function()
    vim.cmd.startinsert()

    -- hide bufferline if `nvim -cterm`
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 and
      vim.bo.filetype ~= "snacks_win" and
      vim.bo.filetype ~= "snacks_terminal" then
      vim.opt.showtabline = 0
    else
      vim.opt.showtabline = 2
    end
  end,
})

------------------------------------------------------------------------------------------------------------------------

-- https://github.com/neovim/neovim/issues/14986
autocmd({ "TermLeave", --[[ "TermClose", "BufWipeout" ]] }, {
  callback = function()
    vim.schedule(function()
      -- if vim.bo.buftype == 'terminal'  then vim.cmd [[ bp | bd! # ]] end
      -- if vim.bo.filetype == 'terminal' then vim.cmd [[ bp | bd! # ]] end

      -- required when exiting `nvim -cterm`
      if vim.fn.bufname() == "" then
        vim.cmd [[ quit ]]
      end
    end)
  end,
})

--------------------------------------------------------------------------------------------------------------------

-- https://www.reddit.com/r/neovim/comments/ww2oyu/toggle_terminal
function ToggleTerminal()
  local buf_exists = vim.fn.bufexists(te_buf) == 1
  local win_exists = vim.fn.win_gotoid(te_win_id) == 1

  if not buf_exists then
    -- Terminal buffer doesn't exist, create it
    vim.cmd("vsplit +term")
    te_win_id = vim.fn.win_getid()
    te_buf = vim.fn.bufnr()
  elseif not win_exists then
    -- Terminal buffer exists but not visible, show it
    vim.cmd('vs | buffer' .. te_buf)
    te_win_id = vim.fn.win_getid()
  else
    -- Terminal buffer exists and is visible, hide it
    vim.cmd("hide")
  end
end

--------------------------------------------------------------------------------------------------------------------

-- https://github.com/folke/snacks.nvim/issues/835
-- https://github.com/akinsho/toggleterm.nvim/issues/66
M.ToggleYazi = function()
  if not yazi_win then
    yazi_win = Snacks.win()
    -- vim.cmd.term("yazi --chooser-file ~/.yazi") -- creates a buffer that doesn't autoclose
    vim.fn.jobstart("yazi --chooser-file ~/.yazi", { term = true })
  end

  if not is_yazi_open then
    yazi_win:show()
    is_yazi_open = true
    vim.cmd.startinsert()
  else
    yazi_win:hide()
    is_yazi_open = false
  end

  yazi_win:on("TermClose", function()
    yazi_win:close()
    yazi_win = nil

    local file = io.open(vim.env.HOME .. "/.yazi", "r")
    if file then
      -- vim.cmd("vsplit " .. file:read("*a"))
      vim.cmd("edit " .. file:read("*a"))
      vim.cmd("filetype detect")
      file:close()
    end

    os.remove(vim.env.HOME .. "/.yazi")
  end)
end

------------------------------------------------------------------------------------------------------------------------

local ns = vim.api.nvim_create_namespace("flash")

vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#c0caf5", bg = "#FF007C" })

M.labels = {
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
  "y", "z",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
  "Y", "Z"
}

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
    if vim.fn.search(search, "W") == 0 then
      break
    end

    local start = vim.api.nvim_win_get_cursor(0)
    vim.fn.search(search, "ceW")

    local new_pos = vim.api.nvim_win_get_cursor(0)
    if new_pos[1] == pos[1] and new_pos[2] == pos[2] then
      break
    end
    pos = new_pos

    local line = vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], false)[1] or ""
    table.insert(matches, {
      row = pos[1],
      col = pos[2],
      pos = start,
      next = line:sub(pos[2] + 2, pos[2] + 2),
    })
  end

  vim.fn.winrestview(view)
  return matches
end

-- https://github.com/folke/flash.nvim/blob/22913c65a1c960e3449c813824351abbdb327c7b/lua/flash/init.lua
function M.flash()
  local info = { line = vim.fn.getcmdline() }
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  -- press label and jump
  for char, match in pairs(M.results) do
    if info.line == M.cmdline .. char then
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

  M.cmdline = info.line
  local matches = M.search(info.line)
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

    if not M.labels[l] then
      break
    end

    match.label = M.labels[l]
    M.results[match.label] = match

    vim.api.nvim_buf_set_extmark(0, ns, match.row - 1, 0, {
      virt_text = { { match.label, "FlashLabel" } },
      virt_text_pos = "overlay",
      virt_text_win_col = match.col + 1,
    })
  end
end

autocmd("CmdlineChanged", {
  callback = function()
    if vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?" then -- if stuck press `/` many times
      M.flash()
    end
  end,
})

autocmd("CmdlineLeave", {
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) -- clear extmarks
  end,
})

------------------------------------------------------------------------------------------------------------------------

-- https://github.com/romgrk/columnMove.vim
M.ColumnMove = function(direction)
  local lnum = vim.fn.line('.')
  local colnum = vim.fn.virtcol('.')
  local pattern1, pattern2, remove_extraline
  local match_char = function(lnum, pattern) return vim.fn.getline(lnum):sub(colnum, colnum):match(pattern) end

  if match_char(lnum, '%S') then
    pattern1 = '^$'         -- pattern to stop at empty char
    pattern2 = '%s'         -- pattern to stop at blankspace
    lnum = lnum + direction -- continue (to the blankspace and emptychar conditional) when at end of line
    remove_extraline = true
    -- vim.notify("no_blankspace")
  end

  if match_char(lnum, '%s') then
    pattern1 = '%S'
    pattern2 = nil
    remove_extraline = false
    -- vim.notify("blankspace")
  end

  if match_char(lnum, '^$') then
    pattern1 = '%S'
    pattern2 = nil
    remove_extraline = false
    -- vim.notify("emptychar")
  end

  while lnum >= 0 and lnum <= vim.fn.line('$') do
    if pattern1 and match_char(lnum, pattern1) then break end
    if pattern2 and match_char(lnum, pattern2) then break end

    lnum = lnum + direction
  end

  -- If the match was at the end of the line, return the previous line number
  vim.fn.cursor(remove_extraline and lnum - direction or lnum, colnum)
end

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
      local start_indent = vim.fn.indent(vim.fn.line('.'))
      local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
      local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
      local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end
      local is_out_of_range = function(line) return vim.fn.indent(line) == -1 end

      local prev_line = vim.fn.line('.') - 1
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

require('mini.indentscope').setup({
  options = { indent_at_cursor = false, },
  mappings = {
    object_scope = 'iI',
    object_scope_with_border = 'aI',
  },
  symbol = '',
})

require('mini.align').setup()
require('mini.bracketed').setup({ undo = { suffix = '' } })
require('mini.jump').setup({ repeat_jump = 'f' })
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
      { desc = "same_indent", keys = "ay", mode = "o" },
      { desc = "same_indent", keys = "ay", mode = "x" },
      { desc = "same_indent", keys = "iy", mode = "o" },
      { desc = "same_indent", keys = "iy", mode = "x" },
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
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#787c99" })
  vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { fg = "#5555cc" })
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
  vim.api.nvim_set_hl(0, "diffAdded", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "diffChanged", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#ff0000" })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#990000" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#3C3CFf", fg = "#ffffff" })
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

  M.hl = {}
  M.colors = {
    slate = { [50] = "f8fafc", [100] = "f1f5f9", [200] = "e2e8f0", [300] = "cbd5e1", [400] = "94a3b8", [500] = "64748b", [600] = "475569", [700] = "334155", [800] = "1e293b", [900] = "0f172a", [950] = "020617", },
    gray = { [50] = "f9fafb", [100] = "f3f4f6", [200] = "e5e7eb", [300] = "d1d5db", [400] = "9ca3af", [500] = "6b7280", [600] = "4b5563", [700] = "374151", [800] = "1f2937", [900] = "111827", [950] = "030712", },
    zinc = { [50] = "fafafa", [100] = "f4f4f5", [200] = "e4e4e7", [300] = "d4d4d8", [400] = "a1a1aa", [500] = "71717a", [600] = "52525b", [700] = "3f3f46", [800] = "27272a", [900] = "18181b", [950] = "09090B", },
    neutral = { [50] = "fafafa", [100] = "f5f5f5", [200] = "e5e5e5", [300] = "d4d4d4", [400] = "a3a3a3", [500] = "737373", [600] = "525252", [700] = "404040", [800] = "262626", [900] = "171717", [950] = "0a0a0a", },
    stone = { [50] = "fafaf9", [100] = "f5f5f4", [200] = "e7e5e4", [300] = "d6d3d1", [400] = "a8a29e", [500] = "78716c", [600] = "57534e", [700] = "44403c", [800] = "292524", [900] = "1c1917", [950] = "0a0a0a", },
    red = { [50] = "fef2f2", [100] = "fee2e2", [200] = "fecaca", [300] = "fca5a5", [400] = "f87171", [500] = "ef4444", [600] = "dc2626", [700] = "b91c1c", [800] = "991b1b", [900] = "7f1d1d", [950] = "450a0a", },
    orange = { [50] = "fff7ed", [100] = "ffedd5", [200] = "fed7aa", [300] = "fdba74", [400] = "fb923c", [500] = "f97316", [600] = "ea580c", [700] = "c2410c", [800] = "9a3412", [900] = "7c2d12", [950] = "431407", },
    amber = { [50] = "fffbeb", [100] = "fef3c7", [200] = "fde68a", [300] = "fcd34d", [400] = "fbbf24", [500] = "f59e0b", [600] = "d97706", [700] = "b45309", [800] = "92400e", [900] = "78350f", [950] = "451a03", },
    yellow = { [50] = "fefce8", [100] = "fef9c3", [200] = "fef08a", [300] = "fde047", [400] = "facc15", [500] = "eab308", [600] = "ca8a04", [700] = "a16207", [800] = "854d0e", [900] = "713f12", [950] = "422006", },
    lime = { [50] = "f7fee7", [100] = "ecfccb", [200] = "d9f99d", [300] = "bef264", [400] = "a3e635", [500] = "84cc16", [600] = "65a30d", [700] = "4d7c0f", [800] = "3f6212", [900] = "365314", [950] = "1a2e05", },
    green = { [50] = "f0fdf4", [100] = "dcfce7", [200] = "bbf7d0", [300] = "86efac", [400] = "4ade80", [500] = "22c55e", [600] = "16a34a", [700] = "15803d", [800] = "166534", [900] = "14532d", [950] = "052e16", },
    emerald = { [50] = "ecfdf5", [100] = "d1fae5", [200] = "a7f3d0", [300] = "6ee7b7", [400] = "34d399", [500] = "10b981", [600] = "059669", [700] = "047857", [800] = "065f46", [900] = "064e3b", [950] = "022c22", },
    teal = { [50] = "f0fdfa", [100] = "ccfbf1", [200] = "99f6e4", [300] = "5eead4", [400] = "2dd4bf", [500] = "14b8a6", [600] = "0d9488", [700] = "0f766e", [800] = "115e59", [900] = "134e4a", [950] = "042f2e", },
    cyan = { [50] = "ecfeff", [100] = "cffafe", [200] = "a5f3fc", [300] = "67e8f9", [400] = "22d3ee", [500] = "06b6d4", [600] = "0891b2", [700] = "0e7490", [800] = "155e75", [900] = "164e63", [950] = "083344", },
    sky = { [50] = "f0f9ff", [100] = "e0f2fe", [200] = "bae6fd", [300] = "7dd3fc", [400] = "38bdf8", [500] = "0ea5e9", [600] = "0284c7", [700] = "0369a1", [800] = "075985", [900] = "0c4a6e", [950] = "082f49", },
    blue = { [50] = "eff6ff", [100] = "dbeafe", [200] = "bfdbfe", [300] = "93c5fd", [400] = "60a5fa", [500] = "3b82f6", [600] = "2563eb", [700] = "1d4ed8", [800] = "1e40af", [900] = "1e3a8a", [950] = "172554", },
    indigo = { [50] = "eef2ff", [100] = "e0e7ff", [200] = "c7d2fe", [300] = "a5b4fc", [400] = "818cf8", [500] = "6366f1", [600] = "4f46e5", [700] = "4338ca", [800] = "3730a3", [900] = "312e81", [950] = "1e1b4b", },
    violet = { [50] = "f5f3ff", [100] = "ede9fe", [200] = "ddd6fe", [300] = "c4b5fd", [400] = "a78bfa", [500] = "8b5cf6", [600] = "7c3aed", [700] = "6d28d9", [800] = "5b21b6", [900] = "4c1d95", [950] = "2e1065", },
    purple = { [50] = "faf5ff", [100] = "f3e8ff", [200] = "e9d5ff", [300] = "d8b4fe", [400] = "c084fc", [500] = "a855f7", [600] = "9333ea", [700] = "7e22ce", [800] = "6b21a8", [900] = "581c87", [950] = "3b0764", },
    fuchsia = { [50] = "fdf4ff", [100] = "fae8ff", [200] = "f5d0fe", [300] = "f0abfc", [400] = "e879f9", [500] = "d946ef", [600] = "c026d3", [700] = "a21caf", [800] = "86198f", [900] = "701a75", [950] = "4a044e", },
    pink = { [50] = "fdf2f8", [100] = "fce7f3", [200] = "fbcfe8", [300] = "f9a8d4", [400] = "f472b6", [500] = "ec4899", [600] = "db2777", [700] = "be185d", [800] = "9d174d", [900] = "831843", [950] = "500724", },
    rose = { [50] = "fff1f2", [100] = "ffe4e6", [200] = "fecdd3", [300] = "fda4af", [400] = "fb7185", [500] = "f43f5e", [600] = "e11d48", [700] = "be123c", [800] = "9f1239", [900] = "881337", [950] = "4c0519", },
  }

  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/mini-hipatterns.lua
  require("mini.hipatterns").setup({
    highlighters = {
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color({ priority = 2000 }),
      tailwind = {
        pattern = "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]",
        group = function(_, _, m)
          local match = m.full_match
          local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
          shade = tonumber(shade)
          local bg = vim.tbl_get(M.colors, color, shade)
          if bg then
            local hl = "MiniHipatternsTailwind" .. color .. shade
            if not M.hl[hl] then
              M.hl[hl] = true
              local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
              local fg = vim.tbl_get(M.colors, color, bg_shade)
              vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
            end
            return hl
          end
        end,
      }
    }
  })

  later(
    function()
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
      MiniSnippets.start_lsp_server()
    end
  )

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

  require('mini.completion').setup()
  require('mini.cursorword').setup()
  require('mini.extra').setup()
  require('mini.icons').setup()
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_restore_cursor()
  require('mini.notify').setup( --[[ { lsp_progress = { enable = false } } ]])
  require('mini.pairs').setup()
  require('mini.statusline').setup()
  require('mini.starter').setup()
  require('mini.tabline').setup()
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind( --[[ "replace" ]])
  vim.notify = MiniNotify.make_notify() -- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
  vim.opt.completeopt:append('fuzzy')   -- it should be after require("mini.completion").setup())
end

-- ╭────────────╮
-- │ Navigation │
-- ╰────────────╯

map({ "i" }, "jk", "<ESC>")
map({ "i" }, "kj", "<ESC>")
map({ "n" }, "J", "10gj")
map({ "n" }, "K", "10gk")
map({ "n" }, "H", "10h")
map({ "n" }, "L", "10l")
map({ "n" }, "Y", "yg_", { desc = "Yank forward" })  -- "Y" yank forward by default
map({ "v" }, "Y", "g_y", { desc = "Yank forward" })
map({ "v" }, "P", "g_P", { desc = "Paste forward" }) -- "P" doesn't change register
map({ "v" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
map({ "n" }, "U", "@:", { desc = "repeat `:command`" })
map({ "v" }, "<", "<gv", { desc = "continious indent" })
map({ "v" }, ">", ">gv", { desc = "continious indent" })
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
  map({ "n", "v", "t" }, "<C-S-l>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "v", "t" }, "<C-S-h>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "v", "t" }, "<C-S-j>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "v", "t" }, "<C-S-k>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "n", "v", "t" }, "<A-S-Right>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "v", "t" }, "<A-S-Left>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "v", "t" }, "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "v", "t" }, "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "t" }, "<S-esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
  map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
  map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
  map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window" })
  map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
  map({ "t", "n" }, "<S-Left>", "<C-\\><C-n><C-w>h", { desc = "left window" })
  map({ "t", "n" }, "<S-Down>", "<C-\\><C-n><C-w>j", { desc = "down window" })
  map({ "t", "n" }, "<S-Up>", "<C-\\><C-n><C-w>k", { desc = "up window" })
  map({ "t", "n" }, "<S-Right>", "<C-\\><C-n><C-w>l", { desc = "right window" })
  map({ "t", "n" }, "<C-\\>", ToggleTerminal, { desc = "toggle window terminal" })
  map({ "t", "n" }, "<a-o>", function() M.ToggleYazi() end, { desc = "toggle yazi (open file)" })
  map({ "t", "n" }, "<C-;>", "<C-\\><C-n><C-6>", { desc = "go to last buffer" })
  map({ "n" }, "<right>", "<cmd>bnext<CR>", { desc = "next buffer" })
  map({ "n" }, "<left>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
  map({ "n" }, "<leader>x", "<cmd>bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
  map({ "n" }, "<leader>;", "<cmd>buffer #<cr>", { desc = "Recent buffer" })
end

-- Quick quit/write
if not vim.g.vscode then
  map({ "n" }, "Q", "<cmd>lua vim.cmd('quit')<cr>")
  map({ "n" }, "R",
    "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 }) MiniTrailspace.trim() vim.cmd('silent write') <cr>")
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
    virtual_text = true,
    float = { border = "rounded" },
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
    -- https://www.reddit.com/r/neovim/comments/1ao6c5a/how_to_make_the_lsp_aware_of_changes_made_to_background_buffers
    -- `:=vim.lsp.protocol.make_client_capabilities()`
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- on linux `next dev --turbo` requires `pixi global install inotify-tools`
        }
      }
    },
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
  map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
  map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
  map("n", "<leader>ld", function() require("snacks").picker.lsp_definitions() end, { desc = "Pick Definition" })
  map("n", "<leader>lD", function() require("snacks").picker.lsp_declarations() end, { desc = "Pick Declaration" })
  map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format" })
  map("n", "<leader>lh", function() vim.lsp.buf.hover() end, { desc = "Hover" })
  map("n", "<leader>lH", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
  map("n", "<leader>lI", function() require("snacks").picker.lsp_implementations() end, { desc = "Pick Implementation" })
  map("n", "<leader>lM", function() vim.cmd("checkhealth vim.lsp") end, { desc = "LspInfo" })
  map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
  map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
  map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
  map("n", "<leader>lq", function() require("snacks").picker.loclist() end, { desc = "Pick LocList" })
  map("n", "<leader>lr", function() require("snacks").picker.lsp_references() end, { desc = "Pick References" })
  map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
  map("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, { desc = "Pick symbols" })
  map("n", "<leader>lS", function() require("snacks").picker.lsp_workspace_symbols() end,
    { desc = "Pick workspace symbols" })
  map("n", "<leader>lt", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Pick TypeDefinition" })
  map("n", "<leader>lX", "<cmd>DepsClean<cr>", { desc = "disable copilot/supermaven" })
  map(
    "n",
    "<leader>lz",
    function()
      local os = vim.uv.os_uname().sysname:lower()
      if os:find('win') then os = "win32" end
      -- sendSequence('pixi g install pnpm; pnpm install --dir ~/.cache @github/copilot-language-server', 'cp ~/.cache/node_modules/@github/copilot-language-server/native/' .. os .. '-x64/copilot-language-server ~/.local/bin')
      sendSequence(
        'pixi exec curl -C- -o $HOME/.cache/copilot.zip -L https://github.com/github/copilot-language-server-release/releases/download/1.386.0/copilot-language-server-' .. os .. '-x64-1.386.0.zip',
        '7z x $HOME/.cache/copilot.zip -o"$HOME/.local/bin"'
      )
      sendSequence('pixi g install pnpm; pnpm install -g @google/gemini-cli')

      add { source = "folke/sidekick.nvim", checkout = "v2.1.0" }
      add { source = "copilotlsp-nvim/copilot-lsp", checkout = "173c015ea61cb493997e3b1fa80bf57f6db58c26" }
      vim.opt.rtp:append(path_package .. 'pack/deps/opt/sidekick.nvim')
      vim.opt.rtp:append(path_package .. 'pack/deps/opt/copilot-lsp')
      vim.lsp.enable("copilot_ls")
      require("sidekick").setup({ nes = { enabled = false }})
      vim.notify("relaunch nvim after installation to login to copilot or rerun this entry")
    end,
    { desc = "gemini/copilot-NES enable" } -- Gemini and Copilot-NES are free and unlimited
  )
  map(
    "n",
    "<leader>lZ",
    function()
      -- vim.cmd("DepsAdd supermaven-inc/supermaven-nvim")
      add { source = "supermaven-inc/supermaven-nvim", checkout = "07d20fce48a5629686aefb0a7cd4b25e33947d50" }
      vim.opt.rtp:append(path_package .. 'pack/deps/opt/supermaven-nvim')
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<A-l>",
          clear_suggestion = "<A-k>",
          accept_word = "<A-j>",
        }
      }
    end,
    { desc = "Supermaven enable" }
  )
  map("n", "<leader>f", "", { desc = "+Find" })
  map("n", "<leader>fb", function() require("snacks").picker.buffers() end, { desc = "buffers" })
  map("n", "<leader>fB", function() require("snacks").picker.grep_buffers() end, { desc = "ripgrep on buffers" })
  map("n", "<leader>fc", function() require("snacks").picker.colorschemes() end, { desc = "colorscheme" })
  map("n", "<leader>fk", function() require("snacks").picker.keymaps() end, { desc = "keymaps" })
  map("n", "<leader>ff", function() require("snacks").picker.files() end, { desc = "files" })
  map(
    "n",
    "<leader>fg",
    function() require("snacks").picker.grep({ layout = "ivy_split", filter = { cwd = true }, }) end,
    { desc = "ripgrep" }
  )
  map("n", "<leader>fn", function() MiniNotify.show_history() end, { desc = "Notify history" })
  map("n", "<leader>fp", function() require("snacks").picker.projects() end, { desc = "projects" })
  map("n", "<leader>fq", function() require("snacks").picker.qflist() end, { desc = "quickfix list" })
  map("n", "<leader>fr", function() require("snacks").picker.recent() end, { desc = "recent files" })
  map("n", '<leader>f"', function() require("snacks").picker.registers() end, { desc = "register (:help quote)" })
  map("n", "<leader>f/", function() require("snacks").picker.git_files() end, { desc = "find git (sorted) files" })
  map("n", "<leader>f;", function() require("snacks").picker.jumps() end, { desc = "jumps" })
  map("n", "<leader>f'", function() require("snacks").picker.marks() end, { desc = "marks" })
  map("n", "<leader>f.", function() require("snacks").picker.resume() end, { desc = "resume" })
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
      -- local curr_file = vim.fs.basename(vim.api.nvim_buf_get_name(0))
      local curr_file = vim.fn.expand('%')
      require("snacks").picker.git_diff({
        on_show = function(picker)
          for i, item in ipairs(picker:items()) do
            if item.text:match(curr_file) then
              picker.list:view(i)
              break -- break at first match
            end
          end
          vim.cmd('stopinsert') -- starts normal mode
        end,
      })
    end,
    { desc = "Preview GitHunk" }
  )
  map("n", "<leader>gr", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gH')<cr>", { desc = "Reset GitHunk" })
  map("n", "<leader>gs", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gh')<cr>", { desc = "Stage GitHunk" })
  map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", { desc = "Toggle Explorer" })
  map("n", "<leader>u", "", { desc = "+UI toggle" })
  map("n", "<leader>u0", "<cmd>set showtabline=0<cr>", { desc = "Buffer Hide" })
  map("n", "<leader>u2", "<cmd>set showtabline=2<cr>", { desc = "Buffer Show" })
  map(
    "n",
    "<leader>uc",
    function()
      vim.o.foldcolumn = '0'
      vim.o.signcolumn = 'no'
      vim.o.statuscolumn = ''
      vim.opt.foldenable = false
      vim.opt.number = false
    end,
    { desc = "StatusColumn Hide" }
  )
  map(
    "n",
    "<leader>uC",
    function()
      vim.o.foldcolumn = '1'
      vim.o.signcolumn = 'auto'
      vim.o.statuscolumn = '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%s%l '
      vim.opt.foldenable = true
      vim.opt.number = true
    end,
    { desc = "StatusColumn Show" }
  )
  map("n", "<leader>ud", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<cr>",
    { desc = "toggle diagnostic" })
  map("n", "<leader>uf", "<cmd>lua vim.o.foldmethod='indent'<cr>", { desc = "fold by indent (press z)" })
  map("n", "<leader>uF", "<cmd>lua vim.o.foldmethod='expr'<cr>", { desc = "fold by lsp (press z)" })
  map("n", "<leader>ul", "<cmd>set cursorline!<cr>", { desc = "toggle cursorline" })
  map("n", "<leader>up", "<cmd>popup PopUp<cr>", { desc = "Toggle Mouse PopUp" })
  map("n", "<leader>us", "<cmd>set laststatus=0<cr>", { desc = "StatusBar Hide" })
  map("n", "<leader>uS", "<cmd>set laststatus=3<cr>", { desc = "StatusBar Show" })
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
    { desc = "Hide/Unhide window (useful for terminal)" }
  )
  map("n", "<leader>t", "", { desc = "+Terminal" })
  map("n", "<leader>tt", function() Snacks.terminal(vim.o.shell --[[ ,{ win = { position = "float" }} ]]) end, { desc = "toggle float terminal" })
  map("n", "<leader>ty", function() M.ToggleYazi() end, { desc = "toggle yazi (open file)" })
  map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = "vertical terminal" })
  map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = "horizontal terminal" })
  map("n", "<leader>w", "", { desc = "+Window" })
  map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "vertical window" })
  map("n", "<leader>wV", "<cmd>split<cr>", { desc = "horizontal window" })
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
    { desc = "Explorer with preview" }
  )
end

map("n", "<leader><leader>p", '"*p', { desc = "Paste after (second_clip)" })
map("n", "<leader><leader>P", '"*P', { desc = "Paste before (second_clip)" })
map("x", "<leader><leader>p", '"*p', { desc = "Paste (second_clip)" })           -- "Paste after (second_clip)"
map("x", "<leader><leader>P", 'g_"*P', { desc = "Paste forward (second_clip)" }) -- only works in visual mode
map("n", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
map("n", "<leader><leader>Y", '"*yg_', { desc = "Yank forward (second_clip)" })
map("x", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
map("x", "<leader><leader>Y", 'g_"*y', { desc = "Yank forward (second_clip)" })

-- ╭────────────────────╮
-- │ Operator / Motions │
-- ╰────────────────────╯

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

-- ╭───────────────────────────────────────╮
-- │ Text Objects with "g" (dot to repeat) │
-- ╰───────────────────────────────────────╯

if vim.g.vscode then
  map(
    { "n", "x" },
    "gD",
    function()
      vscode.action("editor.action.dirtydiff.next")
      vscode.action("closeQuickDiff")
    end,
    { desc = "go to hunk ending (vscode only)" }
  )
else
  map({ "n", "o", "x" }, "gD", function() require('mini.diff').textobject() end, { desc = "select diff/hunk" })
end

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
map({ "n", "o", "x" }, "g>", "gn", { desc = "Next find textobj" })
map({ "n", "o", "x" }, "g<", "gN", { desc = "Prev find textobj" })

-- ╭───────────────────────────────────────╮
-- │ Text Objects with a/i (dot to repeat) │
-- ╰───────────────────────────────────────╯

map({ "o", "x" }, "ii", function() require("mini.ai").select_textobject("i", "i") end, { desc = "indent_noblanks" })
map({ "o", "x" }, "ai", "<cmd>normal Viik<cr>", { desc = "indent_noblanks" })
map(
  { "o", "x" },
  "iy",
  function()
    _G.skip_blank_line = true
    require("mini.ai").select_textobject("i", "y")
  end,
  { desc = "same_indent" }
)
map(
  { "o", "x" },
  "ay",
  function()
    _G.skip_blank_line = false
    require("mini.ai").select_textobject("i", "y")
  end,
  { desc = "same_indent" }
)
map({ "x" }, "iz", ":<c-u>normal! [zjV]z<cr>", { silent = true, desc = "inner fold" })
map({ "o" }, "iz", ":normal Viz<CR>", { silent = true, desc = "inner fold" })
map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { silent = true, desc = "outer fold" })
map({ "o" }, "az", ":normal Vaz<cr>", { silent = true, desc = "outer fold" })

-- ╭──────────────────────────────────────────╮
-- │ Repeatable Pair - motions using <leader> │
-- ╰──────────────────────────────────────────╯

M.last_move = {}

-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/lua/nvim-treesitter/textobjects/repeatable_move.lua
M.repeat_last_move = function(opts_extend)
  if M.last_move then
    local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_extend)
    M.last_move.func(opts, unpack(M.last_move.additional_args))
  end
end

map({ "n", "x", "o" }, ";", function() M.repeat_last_move { forward = true } end, { desc = "Next TS textobj" })
map({ "n", "x", "o" }, ",", function() M.repeat_last_move { forward = false } end, { desc = "Prev TS textobj" })

M.make_repeatable_move_pair = function(forward_move_fn, backward_move_fn)
  local set_last_move = function(move_fn, opts, ...)
    M.last_move = { func = move_fn, opts = vim.deepcopy(opts), additional_args = { ... } }
  end

  local general_repeatable_move_fn = function(opts, ...)
    if opts.forward then
      forward_move_fn(...)
    else
      backward_move_fn(...)
    end
  end

  local repeatable_forward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = true }, ...)
    forward_move_fn(...)
  end

  local repeatable_backward_move_fn = function(...)
    set_last_move(general_repeatable_move_fn, { forward = false }, ...)
    backward_move_fn(...)
  end

  return repeatable_forward_move_fn, repeatable_backward_move_fn
end

local next_columnmove, prev_columnmove = M.make_repeatable_move_pair(
  function() M.ColumnMove(1) end,
  function() M.ColumnMove(-1) end
)
map({ "n", "x", "o" }, "<leader><leader>j", next_columnmove, { desc = "Next ColumnMove" })
map({ "n", "x", "o" }, "<leader><leader>k", prev_columnmove, { desc = "Prev ColumnMove" })

-- ╭──────────────────────────────────────────────────╮
-- │ Repeatable Pair - textobj navigation using gn/gp │
-- ╰──────────────────────────────────────────────────╯

if vim.g.vscode then
  local next_diagnostic, prev_diagnostic = M.make_repeatable_move_pair(
    function() vscode.call("editor.action.marker.next") end,
    function() vscode.call("editor.action.marker.prev") end
  )
  map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Diagnostic" })
  map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Diagnostic" })

  local next_hunk_repeat, prev_hunk_repeat = M.make_repeatable_move_pair(
    function() vscode.call("workbench.action.editor.nextChange") end,
    function() vscode.call("workbench.action.editor.previousChange") end
  )
  map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { desc = "GitHunk" })
  map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { desc = "GitHunk" })
  map({ "n", "x", "o" }, "gnH", next_hunk_repeat, { desc = "GitHunk" })
  map({ "n", "x", "o" }, "gpH", prev_hunk_repeat, { desc = "GitHunk" })

  local next_reference, prev_reference = M.make_repeatable_move_pair(
    function() vscode.call("editor.action.wordHighlight.next") end,
    function() vscode.call("editor.action.wordHighlight.prev") end
  )
  map({ "n", "x", "o" }, "gnr", next_reference, { desc = "Reference (vscode only)" })
  map({ "n", "x", "o" }, "gpr", prev_reference, { desc = "Reference (vscode only)" })
else
  local next_diagnostic, prev_diagnostic = M.make_repeatable_move_pair(
    function() vim.diagnostic.jump({ count = 1, float = true }) end,
    function() vim.diagnostic.jump({ count = -1, float = true }) end
  )
  map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Diagnostic" })
  map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Diagnostic" })

  local next_hunk_repeat, prev_hunk_repeat = M.make_repeatable_move_pair(
    function() require("mini.diff").goto_hunk('next') end,
    function() require("mini.diff").goto_hunk('prev') end
  )
  map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { desc = "GitHunk" })
  map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { desc = "GitHunk" })
end

local next_comment, prev_comment = M.make_repeatable_move_pair(
  function() require("mini.bracketed").comment("forward") end,
  function() require("mini.bracketed").comment("backward") end
)
map({ "n", "x", "o" }, "gnc", next_comment, { desc = "Comment" })
map({ "n", "x", "o" }, "gpc", prev_comment, { desc = "Comment" })

local next_fold, prev_fold = M.make_repeatable_move_pair(
  function() vim.cmd([[ normal ]z ]]) end,
  function() vim.cmd([[ normal [z ]]) end
)
map({ "n", "x", "o" }, "gnf", next_fold, { desc = "Fold ending" })
map({ "n", "x", "o" }, "gpf", prev_fold, { desc = "Fold beginning" })

---------------------------------------------------------------------------------------------------------------------------------------

-- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
local end_of_textobj, start_of_textobj = M.make_repeatable_move_pair(

  function(inner_outer_key, motion_key)
    vim.cmd.exec([["normal \<esc>v]] .. inner_outer_key .. motion_key .. [[\<esc>"]])
    vim.cmd("normal! `>") -- end of latest visual selection
    vim.cmd(_G.reselect_textobj)
  end,

  function(inner_outer_key, motion_key)
    vim.cmd.exec([["normal \<esc>v]] .. inner_outer_key .. motion_key .. [[\<esc>"]])
    vim.cmd("normal! `<") -- start of latest visual selection
    vim.cmd(_G.reselect_textobj)
  end
)

map(
  { "n", "x" },
  "gT",
  function()
    local _, inner_outer_key = pcall(vim.fn.getcharstr)
    local _, motion_key = pcall(vim.fn.getcharstr)
    _G.reselect_textobj = ""

    if vim.fn.mode() ~= "n" then
      vim.cmd.exec([["normal \<esc>"]])
      vim.cmd.normal([[mT`>mS`T]]) -- create [S]tart mark
      _G.reselect_textobj = "normal! v`So"
    end

    start_of_textobj(inner_outer_key, motion_key)
  end,
  { desc = "Start of TextObj" }
)

map(
  { "n", "x" },
  "gt",
  function()
    local _, inner_outer_key = pcall(vim.fn.getcharstr)
    local _, motion_key = pcall(vim.fn.getcharstr)
    _G.reselect_textobj = ""

    if vim.fn.mode() ~= "n" then
      vim.cmd.exec([["normal \<esc>"]])
      vim.cmd.normal([[mT`<mS`T]]) -- create [S]tart mark
      _G.reselect_textobj = "normal! v`So"
    end

    end_of_textobj(inner_outer_key, motion_key)
  end,
  { desc = "End of TextObj" }
)

---------------------------------------------------------------------------------------------------------------------------------------

-- TODO: remove it when https://github.com/echasnovski/mini.nvim/issues/1077 available
local repeat_mini_ai = function(inner_or_around, key, desc)
  local next, prev = M.make_repeatable_move_pair(
    function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "next" }) end,
    function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "prev" }) end
  )
  map({ "n", "x", "o" }, "gn" .. inner_or_around .. key, next, { desc = desc })
  map({ "n", "x", "o" }, "gp" .. inner_or_around .. key, prev, { desc = desc })
end

repeat_mini_ai("i", "a", "argument")
repeat_mini_ai("a", "a", "argument")
repeat_mini_ai("i", "b", "brace")
repeat_mini_ai("a", "b", "brace")
repeat_mini_ai("i", "f", "func_call")
repeat_mini_ai("a", "f", "func_call")
repeat_mini_ai("i", "h", "html_atrib")
repeat_mini_ai("a", "h", "html_atrib")
repeat_mini_ai("i", "k", "key")
repeat_mini_ai("a", "k", "key")
repeat_mini_ai("i", "m", "number")
repeat_mini_ai("a", "m", "number")
repeat_mini_ai("i", "o", "whitespace")
repeat_mini_ai("a", "o", "whitespace")
repeat_mini_ai("i", "q", "quote")
repeat_mini_ai("a", "q", "quote")
repeat_mini_ai("i", "t", "tag")
repeat_mini_ai("a", "t", "tag")
repeat_mini_ai("i", "u", "subword")
repeat_mini_ai("a", "u", "subword")
repeat_mini_ai("i", "v", "value")
repeat_mini_ai("a", "v", "value")
repeat_mini_ai("i", "x", "hexadecimal")
repeat_mini_ai("a", "x", "hexadecimal")
repeat_mini_ai("i", "?", "user_prompt")
repeat_mini_ai("a", "?", "user_prompt")
