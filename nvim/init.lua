-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

-- Clone 'mini.nvim'
local path_package = vim.env.HOME .. "/.vscode/extensions/yeferyv.retronvim/nvim/plugins/site/"
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

vim.opt.rtp:prepend(mini_path)
require('mini.deps').setup({ path = { package = path_package } })
vim.cmd('packadd mini.nvim | helptags ALL')
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local _, vscode = pcall(require, "vscode-neovim")

------------------------------------------------------------------------------------------------------------------------

-- text-objects
add { source = "folke/flash.nvim", checkout = "v2.1.0" }

if not vim.g.vscode then
  -- completions / UI
  add { source = "supermaven-inc/supermaven-nvim", checkout = "07d20fce48a5629686aefb0a7cd4b25e33947d50" }
  add { source = "williamboman/mason.nvim", checkout = "v1.10.0", }
  add { source = "folke/snacks.nvim", checkout = "v2.21.0" }
end

later(function() require("flash").setup { modes = { search = { enabled = true } } } end)

if not vim.g.vscode then
  later(
    function()
      require("supermaven-nvim").setup {
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

if not vim.g.vscode then now(function() require("mason").setup({ ui = { border = "rounded" } }) end) end -- now() because of vim.lsp.enable()

if not vim.g.vscode then
  now(
    function()
      require("snacks").setup({
        explorer = { replace_netrw = true },
        image = {},
        indent = {},
        input = {},
        picker = { sources = { explorer = { hidden = true, --[[ ignored = true ]] } } },
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

if not vim.g.vscode then
  vim.opt.cmdheight = 0                       -- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 3                      -- laststatus=3 global status line (line between splits)
  vim.opt.number = true                       -- set numbered lines
  vim.opt.scrolloff = 8                       -- vertical scrolloff
  vim.opt.sidescrolloff = 8                   -- horizontal scrolloff
  vim.opt.virtualedit = "all"                 -- allow cursor bypass end of line
  vim.g.mapleader = " "                       -- <leader> key
  vim.o.foldcolumn = '1'                      -- if '1' will show clickable fold signs
  vim.o.foldlevel = 99                        -- Disable folding at startup
  vim.o.foldmethod = "expr"                   -- expr = specify an expression to define folds
  vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()' -- if folding using treesitter then 'v:lua.vim.treesitter.foldexpr()'
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  vim.o.statuscolumn =
  '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%s%l '

  vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "" })
  vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "" })
  vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "" })
  vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "" })
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

------------------------------------------------------------------------------------------------------------------------

autocmd({ "TermEnter", "TermOpen" }, {
  callback = function()
    vim.cmd.startinsert()

    -- hide bufferline if `nvim -cterm`
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
      vim.opt.showtabline = 0
    else
      vim.opt.showtabline = 2
    end
  end,
})

------------------------------------------------------------------------------------------------------------------------

-- https://github.com/neovim/neovim/issues/14986
autocmd({ "TermClose", --[[ "BufWipeout" ]] }, {
  callback = function()
    vim.schedule(function()
      -- if vim.bo.buftype == 'terminal' and vim.v.shell_error == 0 then
      if vim.bo.filetype == 'terminal' then
        vim.cmd [[ bp | bd! # ]]
      end

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

------------------------------------------------------------------------------------------------------------------------

-- vscode's keybinding.json with neovim.fullMode context for flash mode and replace mode
-- https://github.com/vscode-neovim/vscode-neovim/issues/1718

-- to view which keypresses is mapped to, run:
-- :lua vim.on_key(function(key) vim.notify(key .. vim.api.nvim_get_mode().mode) end)
-- :lua vim.on_key(function(key) vim.print({ key, vim.api.nvim_get_mode().mode }) end)

if vim.g.vscode then
  vim.on_key(function(key)
    local esc_termcode = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    local key_termcode = vim.api.nvim_replace_termcodes(key, true, false, true)

    if key_termcode:find("X.*g") then
      -- vim.print("f_mode_enter");
      vscode.call("setContext", { args = { "neovim.fullMode", "f" }, })
    end

    if (vim.api.nvim_get_mode().mode == "n" and key_termcode:find("'")) or key_termcode:find(esc_termcode) or key_termcode:find("X.*h") then
      -- vim.print("f_mode_exit");
      vscode.call("setContext", { args = { "neovim.fullMode", "n" }, })
    end

    if vim.api.nvim_get_mode().mode == "n" and key_termcode:find("r") then
      -- vim.print("r_mode_enter");
      vscode.call("setContext", { args = { "neovim.fullMode", "r" }, })
    end

    if vim.api.nvim_get_mode().mode == "R" then
      -- vim.print("r_mode_exit");
      vscode.call("setContext", { args = { "neovim.fullMode", "n" }, })
    end
  end)
end

------------------------------------------------------------------------------------------------------------------------

local M = {}

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

-- https://www.reddit.com/r/neovim/comments/1d7j0c1/a_small_gist_to_use_the_new_builtin_completion/
local map = vim.keymap.set

---For replacing certain <C-x>... keymaps.
---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

autocmd('LspAttach', {

  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })

    -- Use enter to expand snippet or accept completions.
    map('i', '<cr>', function()
      -- if luasnip.expandable() then luasnip.expand()
      if pumvisible() then
        feedkeys '<C-y>'
      else
        feedkeys '<cr>'
      end
    end)

    -- complete placeholder (if selecting snippet expand it with <cr>)
    map('i', '<down>', function()
      if pumvisible() then
        feedkeys '<C-n>'
      else
        feedkeys '<down>'
      end
    end)
    map('i', '<up>', function()
      if pumvisible() then
        feedkeys '<C-p>'
      else
        feedkeys '<up>'
      end
    end)

    -- to navigate between completion list or snippet tabstops,
    map({ 'i', 's' }, '<Tab>', function()
      if pumvisible() then
        feedkeys '<C-n>'
        --  elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      elseif vim.snippet.active { direction = 1 } then
        vim.snippet.jump(1)
      else
        feedkeys '<Tab>'
      end
    end)
    map({ 'i', 's' }, '<S-Tab>', function()
      if pumvisible() then
        feedkeys '<C-p>'
        -- elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      elseif vim.snippet.active { direction = -1 } then
        vim.snippet.jump(-1)
      else
        feedkeys '<S-Tab>'
      end
    end)
  end
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

require('mini.surround').setup({
  mappings = {
    add = 'gza',            -- Add surrounding in Normal and Visual modes
    delete = 'gzd',         -- Delete surrounding
    find = 'gzf',           -- Find surrounding (to the right)
    find_left = 'gzF',      -- Find surrounding (to the left)
    highlight = 'gzh',      -- Highlight surrounding
    replace = 'gzr',        -- Replace surrounding
    update_n_lines = 'gzn', -- Update `n_lines`
  },
})

require('mini.align').setup()
require('mini.bracketed').setup({ undo = { suffix = '' } })
require('mini.operators').setup()
require('mini.splitjoin').setup()
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
      -- nvchad poimandres
      base00 = "#1b1e28", -- default bg, terminal_color_0
      base01 = "#171922", -- line number bg, popup bg
      base02 = "#32384a", -- statusline bg, tabline bg, selection bg
      base03 = "#3b4258", -- line number fg, comments, terminal_color_8
      base04 = "#48506a", -- statusline fg, tabline inactive fg
      base05 = "#A6ACCD", -- default fg, tabline fg, terminal_color_7
      base06 = "#b6d7f4", -- unused
      base07 = "#ffffff", -- terminal_color_15
      base08 = "#A6ACCD", -- return, Diff delete, Diagnostic Error
      base09 = "#D0679D", -- integers, booleans, constants, search
      base0A = "#5DE4C7", -- classes, search, tag signs/attributes
      base0B = "#5DE4C7", -- strings, Diff added
      base0C = "#89DDFF", -- builtins, Diagnostic Info
      base0D = "#ADD7FF", -- functions, Diagnostic Hint
      base0E = "#91B4D5", -- keywords (def, for), Diff changed, Diagnostic Warn
      base0F = "#FFFFFF", -- punctuation, regex, indentscope
    },
    use_cterm = true,     -- required if `vi -c 'Pick files'`
  })

  -- poimandres transparency
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueTitle", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueDescSingle", { link = "Pmenu" })
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })

  -- poimandres custom colors
  vim.api.nvim_set_hl(0, "Comment", { fg = "#5c5c5c", })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#2c2c2c" })
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

  -- poimandres same as the original
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#D0679D" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#91B4D5" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#FFFAC2" })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#D0679D" })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#91B4D5" })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#FFFAC2" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#D0679D" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "#89DDFF" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "#91B4D5" })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "#FFFAC2" })
  vim.api.nvim_set_hl(0, "Number", { fg = "#5de4c7" })
  vim.api.nvim_set_hl(0, "Constant", { fg = "#5de4c7" })
  vim.api.nvim_set_hl(0, "Boolean", { fg = "#5de4c7" })
  vim.api.nvim_set_hl(0, "Search", { fg = "#FFFFFF", bg = "#506477" })
  vim.api.nvim_set_hl(0, "CurSearch", { fg = "#171922", bg = "#ADD7FF" })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#171922", bg = "#ADD7FF" })
  vim.api.nvim_set_hl(0, "Special", { fg = "#767c9d" })
  vim.api.nvim_set_hl(0, "Type", { fg = "#a6accd" })

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

  -- TODO: remove it when mini.snippets available
  local H = {}

  -- extracted from https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/completion.lua
  H.table_get = function(t, id)
    if type(id) ~= 'table' then return H.table_get(t, { id }) end
    local success, res = true, t
    for _, i in ipairs(id) do
      success, res = pcall(function() return res[i] end)
      if not success or res == nil then return end
    end
    return res
  end

  -- Completion word (textEdit.newText > insertText > label)
  H.get_completion_word = function(item)
    return H.table_get(item, { 'textEdit', 'newText' }) or item.insertText or item.label or ''
  end

  -- skip snippets filter
  -- press <c-x><c-o> if snippet not showing (e.g using lua-ls when configured with `require('mini.completion').setup()` )
  require('mini.completion').setup({
    lsp_completion = {
      process_items = function(items, base)
        local res = vim.tbl_filter(function(item)
          -- Keep items which match the base
          local text = item.filterText or H.get_completion_word(item)
          return vim.startswith(text, base)
        end, items)

        table.sort(res, function(a, b) return (a.sortText or a.label) < (b.sortText or b.label) end)
        return res
      end,
    },
  })

  later(
    function()
      local function add_vscode_snippets_to_rtp()
        local extensions_dir = vim.fs.joinpath(vim.env.HOME, '.vscode', 'extensions')

        -- Get all snippet directories using glob
        local snippet_dirs = vim.fn.globpath(
          extensions_dir,
          '*/snippets', -- Matches any extension/snippets directory
          true,         -- recursive
          true          -- return as list
        )

        -- Add to runtimepath (with nil checks)
        for _, dir in ipairs(snippet_dirs) do
          if vim.fn.isdirectory(dir) == 1 then
            -- Normalize the path to handle OS-specific separators
            local normalized_dir = vim.fs.normalize(dir)

            local parent_dir = normalized_dir:gsub("/snippets$", "")
            -- ~/.vscode/extensions/emranweb.daisyui-snippet-1.0.3/snippets/snippetshtml.code-snippets no contains a valid JSON object
            -- ~/.vscode/extensions/imgildev.vscode-nextjs-generator-2.6.0/snippets/trpc.code-snippets no contains a valid JSON object
            vim.opt.rtp:append(parent_dir)
          end
        end
      end

      add_vscode_snippets_to_rtp()
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup({
        snippets = { gen_loader.from_runtime("*") },
        mappings = {
          expand = '<a-.>',
          jump_next = '<a-;>',
          jump_prev = '<a-,>',
        }
      })
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
    mappings = {
      textobject = 'gH',
    },
    options = {
      wrap_goto = true
    }
  })

  require('mini.cursorword').setup()
  require('mini.extra').setup()
  require('mini.icons').setup()
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_restore_cursor()
  require('mini.notify').setup()
  require('mini.pairs').setup()
  require('mini.statusline').setup()
  require('mini.starter').setup()
  require('mini.tabline').setup()
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind( --[[ "replace" ]])
  vim.notify = MiniNotify.make_notify()                                        -- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
  if vim.fn.has('nvim-0.11') == 1 then vim.opt.completeopt:append('fuzzy') end -- it should be after require("mini.completion").setup())
end

-- ╭────────────╮
-- │ Navigation │
-- ╰────────────╯

local flash = require("flash")

map({ "i" }, "jk", "<ESC>")
map({ "i" }, "kj", "<ESC>")
map({ "n" }, "J", "10gj")
map({ "n" }, "K", "10gk")
map({ "n" }, "H", "10h")
map({ "n" }, "L", "10l")
map({ "n" }, "<M-j>", "10gj")
map({ "n" }, "<M-k>", "10gk")
map({ "n" }, "<M-h>", "10h")
map({ "n" }, "<M-l>", "10l")
map({ "n" }, "<M-v>", "V")
map({ "n" }, "Y", "yg_", { desc = "Yank forward" })  -- "Y" yank forward by default
map({ "v" }, "Y", "g_y", { desc = "Yank forward" })
map({ "v" }, "P", "g_P", { desc = "Paste forward" }) -- "P" doesn't change register
map({ "v" }, "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
map({ "n" }, "U", "@:", { desc = "repeat `:command`" })
map({ "v" }, "<", "<gv", { desc = "continious indent" })
map({ "v" }, ">", ">gv", { desc = "continious indent" })

if not vim.g.vscode then
  map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
  map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, desc = "prev completion when no lsp" })
  map({ "n", "v", "t" }, "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "v", "t" }, "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "v", "t" }, "<M-Up>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "v", "t" }, "<M-Down>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "n" }, "<esc>", "<esc><cmd>lua vim.cmd.nohlsearch()<cr>", { desc = "escape and clear search highlight" })
  map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
  map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
  map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
  map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window" })
  map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
  map({ "t", "n" }, "<C-\\>", ToggleTerminal, { desc = "toggle window terminal" })
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
  vim.diagnostic.config({ virtual_text = true, float = { border = "rounded", }, })

  -- https://neovim.io/doc/user/lsp.html#_quickstart
  vim.lsp.config('*', {
    -- https://www.reddit.com/r/neovim/comments/1ao6c5a/how_to_make_the_lsp_aware_of_changes_made_to/
    -- `:=vim.lsp.protocol.make_client_capabilities()`
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- TODO: still not working/implemented (required by `next dev --turbo`)
        }
      }
    },
    root_markers = { '.git' },
  })

  vim.lsp.config['luals']                   = {
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

  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/formatters
  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/linters
  vim.lsp.config['efm']                     = {
    cmd = { 'efm-langserver' },
    filetypes = { 'python', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'html', 'json', 'markdown', 'yaml' },
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
        markdown        = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        yaml            = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
      }
    }
  }

  -- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
  vim.lsp.config['angularls']               = { cmd = { "ngserver", "--stdio" }, filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' } }
  vim.lsp.config['ansiblels']               = { cmd = { 'ansible-language-server', '--stdio' }, filetypes = { 'yaml.ansible' } }
  vim.lsp.config['arduino_language_server'] = { cmd = { 'arduino-language-server' }, filetypes = { 'arduino' } }
  vim.lsp.config['astro']                   = { cmd = { 'astro-ls', '--stdio' }, filetypes = { 'astro' } }
  vim.lsp.config['autotools_ls']            = { cmd = { 'autotools-language-server' }, filetypes = { 'config', 'automake', 'make' } }
  vim.lsp.config['azure_pipelines_ls']      = { cmd = { 'azure-pipelines-language-server', '--stdio' }, filetypes = { 'yaml' } }
  vim.lsp.config['basedpyright']            = { cmd = { 'basedpyright-langserver', '--stdio' }, filetypes = { 'python' } }
  vim.lsp.config['bashls']                  = { cmd = { 'bash-language-server', 'start' }, filetypes = { 'bash', 'sh' } }
  vim.lsp.config['biome']                   = { cmd = { 'biome', 'lsp-proxy' }, filetypes = { 'astro', 'css', 'graphql', 'javascript', 'javascriptreact', 'json', 'jsonc', 'svelte', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue' } }
  vim.lsp.config['ccls']                    = { cmd = { 'ccls' }, filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' } }
  vim.lsp.config['cmake']                   = { cmd = { 'cmake-language-server' }, filetypes = { 'cmake' } }
  vim.lsp.config['csharp_ls']               = { cmd = { 'csharp-ls' }, filetypes = { 'cs' } }
  vim.lsp.config['css_variables']           = { cmd = { 'css-variables-language-server', '--stdio' }, filetypes = { 'css', 'scss', 'less' } }
  vim.lsp.config['cssls']                   = { cmd = { 'vscode-css-language-server', '--stdio' }, filetypes = { 'css', 'scss', 'less' } }
  vim.lsp.config['cssmodules_ls']           = { cmd = { 'cssmodules-language-server' }, filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } }
  vim.lsp.config['denols']                  = { cmd = { 'deno.cache' }, filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' } }
  vim.lsp.config['docker_compose']          = { cmd = { 'docker-compose-langserver', '--stdio' }, filetypes = { 'yaml.docker-compose' } }
  vim.lsp.config['dockerls']                = { cmd = { 'docker-langserver', '--stdio' }, filetypes = { 'dockerfile' } }
  vim.lsp.config['dprint']                  = { cmd = { 'dprint', 'lsp' }, filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc', 'markdown', 'python', 'toml', 'rust', 'graphql' } }
  vim.lsp.config['emmet_language_server']   = { cmd = { 'emmet-language-server', '--stdio' }, filetypes = { 'astro', 'css', 'html', 'htmldjango', 'javascriptreact', 'svelte', 'typescriptreact', 'vue', 'htmlangular' } }
  vim.lsp.config['emmet_ls']                = { cmd = { 'emmet-ls', '--stdio' }, filetypes = { 'astro', 'css', 'html', 'htmldjango', 'javascriptreact', 'svelte', 'typescriptreact', 'vue', 'htmlangular' } }
  vim.lsp.config['eslint']                  = { cmd = { 'vscode-eslint-language-server', '--stdio' }, filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue', 'svelte', 'astro' } }
  vim.lsp.config['gh_actions_ls']           = { cmd = { 'gh-actions-language-server', '--stdio' }, filetypes = { 'yaml' }, }
  vim.lsp.config['gitlab_ci_ls']            = { cmd = { 'gitlab-ci-ls' }, filetypes = { 'yaml.gitlab' } }
  vim.lsp.config['golangci_lint_ls']        = { cmd = { 'golangci-lint-langserver' }, filetypes = { 'go', 'gomod' } }
  vim.lsp.config['gopls']                   = { cmd = { 'gopls' }, filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' } }
  vim.lsp.config['graphql']                 = { cmd = { 'graphql-lsp', 'server', '-m', 'stream' }, filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' } }
  vim.lsp.config['html']                    = { cmd = { 'vscode-html-language-server', '--stdio' }, filetypes = { 'html', 'templ' } }
  vim.lsp.config['htmx']                    = { cmd = { 'htmx-lsp' }, filetypes = { 'astro', 'astro-markdown', 'django-html', 'htmldjango', 'gohtml', 'gohtmltmpl', 'html', 'htmlangular', 'markdown', 'mdx', 'php', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'templ' } }
  vim.lsp.config['jsonls']                  = { cmd = { 'vscode-json-language-server', '--stdio' }, filetypes = { 'json', 'jsonc' } }
  vim.lsp.config['lsp_ai']                  = { cmd = { 'lsp-ai' } }
  vim.lsp.config['marksman']                = { cmd = { 'marksman' }, filetypes = { 'markdown', 'markdown.mdx' } }
  vim.lsp.config['matlab_ls']               = { cmd = { 'matlab-language-server', '--stdio' }, filetypes = { 'matlab' } }
  vim.lsp.config['neocmake']                = { cmd = { 'neocmakelsp', '--stdio' }, filetypes = { 'cmake' } }
  vim.lsp.config['nginx_language_server']   = { cmd = { 'nginx-language-server' }, filetypes = { 'nginx' } }
  vim.lsp.config['phpactor']                = { cmd = { 'phpactor', 'language-server' }, filetypes = { 'php' } }
  vim.lsp.config['postgres_lsp']            = { cmd = { 'postgres_lsp' }, filetypes = { 'sql' }, }
  vim.lsp.config['prismals']                = { cmd = { 'prisma-language-server', '--stdio' }, filetypes = { 'prisma' } }
  vim.lsp.config['psalm']                   = { cmd = { 'psalm', '--language-server' }, filetypes = { 'php' } }
  vim.lsp.config['pylsp']                   = { cmd = { 'pylsp' }, filetypes = { 'python' } }
  vim.lsp.config['pylyzer']                 = { cmd = { 'pylyzer', '--server' }, filetypes = { 'python' } }
  vim.lsp.config['pyre']                    = { cmd = { 'pyre', 'persistent' }, filetypes = { 'python' } }
  vim.lsp.config['pyright']                 = { cmd = { 'pyright-langserver', '--stdio' }, filetypes = { 'python' } }
  vim.lsp.config['quick_lint_js']           = { cmd = { 'quick-lint-js', '--lsp-server' }, filetypes = { 'javascript', 'typescript' } }
  vim.lsp.config['r_language_server']       = { cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' }, filetypes = { 'r', 'rmd' } }
  vim.lsp.config['rls']                     = { cmd = { 'rls' }, filetypes = { 'rust' } }
  vim.lsp.config['ruff']                    = { cmd = { 'ruff' }, filetypes = { 'python' } }
  vim.lsp.config['ruff_lsp']                = { cmd = { 'ruff-lsp' }, filetypes = { 'python' } }
  vim.lsp.config['rust_analyzer']           = { cmd = { 'rust-analyzer' }, filetypes = { 'rust' } }
  vim.lsp.config['slint_lsp']               = { cmd = { 'slint-lsp' }, filetypes = { 'slint' } }
  vim.lsp.config['sqlls']                   = { cmd = { 'sql-language-server', 'up', '--method', 'stdio' }, filetypes = { 'sql', 'mysql' } }
  vim.lsp.config['sqls']                    = { cmd = { 'sqls' }, filetypes = { 'sql', 'mysql' } }
  vim.lsp.config['svelte']                  = { cmd = { 'svelteserver', '--stdio' }, filetypes = { 'svelte' } }
  vim.lsp.config['tailwindcss']             = { cmd = { 'tailwindcss-language-server', '--stdio' }, filetypes = { 'astro', 'astro-markdown', 'django-html', 'htmldjango', 'gohtml', 'gohtmltmpl', 'html', 'htmlangular', 'markdown', 'mdx', 'php', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'templ' } }
  vim.lsp.config['templ']                   = { cmd = { 'templ', 'lsp' }, filetypes = { 'templ' } }
  vim.lsp.config['terraform_lsp']           = { cmd = { 'terraform-lsp' }, filetypes = { 'terraform', 'hcl' } }
  vim.lsp.config['terraformls']             = { cmd = { 'terraform-ls', 'serve' }, filetypes = { 'terraform', 'terraform-vars' } }
  vim.lsp.config['tflint']                  = { cmd = { 'tflint', '--stdio' }, filetypes = { 'terraform' } }
  vim.lsp.config['ts_ls']                   = { cmd = { 'typescript-language-server', '--stdio' }, filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' } }
  vim.lsp.config['volar']                   = { cmd = { 'vue-language-server', '--stdio' }, filetypes = { 'vue' } }
  vim.lsp.config['vtsls']                   = { cmd = { 'vtsls', '--stdio' }, filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', } }
  vim.lsp.config['vuels']                   = { cmd = { 'vls' }, filetypes = { 'vue' } }
  vim.lsp.config['yamlls']                  = { cmd = { 'yaml-language-server', '--stdio' }, filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' } }

  vim.lsp.enable('luals')
  vim.lsp.enable('efm')
  vim.lsp.enable('angularls')
  vim.lsp.enable('ansiblels')
  vim.lsp.enable('arduino_language_server')
  vim.lsp.enable('astro')
  vim.lsp.enable('autotools_ls')
  vim.lsp.enable('azure_pipelines_ls')
  vim.lsp.enable('basedpyright')
  vim.lsp.enable('bashls')
  vim.lsp.enable('biome')
  vim.lsp.enable('ccls')
  vim.lsp.enable('cmake')
  vim.lsp.enable('csharp_ls')
  vim.lsp.enable('css_variables')
  vim.lsp.enable('cssls')
  vim.lsp.enable('cssmodules_ls')
  vim.lsp.enable('denols')
  vim.lsp.enable('docker_compose')
  vim.lsp.enable('dockerls')
  vim.lsp.enable('dprint')
  vim.lsp.enable('emmet_language_server')
  vim.lsp.enable('emmet_ls')
  vim.lsp.enable('eslint')
  vim.lsp.enable('gh_actions_ls')
  vim.lsp.enable('gitlab_ci_ls')
  vim.lsp.enable('golangci_lint_ls')
  vim.lsp.enable('gopls')
  vim.lsp.enable('graphql')
  vim.lsp.enable('html')
  vim.lsp.enable('htmx')
  vim.lsp.enable('jsonls')
  vim.lsp.enable('lsp_ai')
  vim.lsp.enable('marksman')
  vim.lsp.enable('matlab_ls')
  vim.lsp.enable('neocmake')
  vim.lsp.enable('nginx_language_server')
  vim.lsp.enable('phpactor')
  vim.lsp.enable('postgres_lsp')
  vim.lsp.enable('prismals')
  vim.lsp.enable('psalm')
  vim.lsp.enable('pylsp')
  vim.lsp.enable('pylyzer')
  vim.lsp.enable('pyre')
  vim.lsp.enable('pyright')
  vim.lsp.enable('quick_lint_js')
  vim.lsp.enable('r_language_server')
  vim.lsp.enable('rls')
  vim.lsp.enable('ruff')
  vim.lsp.enable('ruff_lsp')
  vim.lsp.enable('rust_analyzer')
  vim.lsp.enable('slint_lsp')
  vim.lsp.enable('sqlls')
  vim.lsp.enable('sqls')
  vim.lsp.enable('svelte')
  vim.lsp.enable('tailwindcss')
  vim.lsp.enable('templ')
  vim.lsp.enable('terraform_lsp')
  vim.lsp.enable('terraformls')
  vim.lsp.enable('tflint')
  vim.lsp.enable('ts_ls')
  vim.lsp.enable('volar')
  vim.lsp.enable('vtsls')
  vim.lsp.enable('vuels')
  vim.lsp.enable('yamlls')

  ------------------------------------------------------------------------------------------------------------------------

  map("n", "<leader>l", "", { desc = "+LSP" })
  map("n", "<leader>lA", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
  map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
  map("n", "<leader>ld", function() require("snacks").picker.lsp_definitions() end, { desc = "Pick Definition" })
  map("n", "<leader>lD", function() require("snacks").picker.lsp_declarations() end, { desc = "Pick Declaration" })
  map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format" })
  map("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
  map("n", "<leader>lH", function() vim.lsp.buf.hover() end, { desc = "Hover" })
  map("n", "<leader>lI", function() require("snacks").picker.lsp_implementations() end, { desc = "Pick Implementation" })
  map("n", "<leader>lm", function() vim.cmd("Mason") end, { desc = "Mason" })
  map("n", "<leader>lM", function() vim.cmd("checkhealth vim.lsp") end, { desc = "LspInfo" })
  map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
  map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
  map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
  map("n", "<leader>lq", function() require("snacks").picker.loclist() end, { desc = "Pick LocList" })
  map("n", "<leader>lr", function() require("snacks").picker.lsp_references() end, { desc = "Pick References" })
  map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
  map("n", "<leader>ls", function() require("snacks").picker.lsp_symbols() end, { desc = "Pick symbols" })
  map("n", "<leader>lt", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Pick TypeDefinition" })
  map("n", "<leader>f", "", { desc = "+Find" })
  map("n", "<leader>fb", function() require("snacks").picker.grep() end, { desc = "buffers" })
  map("n", "<leader>fB", function() require("snacks").picker.grep() end, { desc = "ripgrep on buffers" })
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
  map("n", "<leader>gg", "<cmd>term lazygit<cr><cmd>set ft=terminal<cr>", { desc = "lazygit" })
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
  map(
    "n",
    "<leader>o",
    function()
      Snacks.explorer.open({ auto_close = true, layout = { preset = 'default', preview = true } })
    end,
    { desc = "Explorer with preview" }
  )
  map("n", "<leader>u", "", { desc = "+UI toggle" })
  map("n", "<leader>u0", "<cmd>set showtabline=0<cr>", { desc = "Buffer Hide" })
  map("n", "<leader>u2", "<cmd>set showtabline=2<cr>", { desc = "Buffer Show" })
  map("n", "<leader>uf", "<cmd>lua vim.o.foldmethod='indent'<cr>", { desc = "fold by indent" })
  map("n", "<leader>uF", "<cmd>lua vim.o.foldmethod='expr'<cr>", { desc = "fold by lsp" })
  map("n", "<leader>ul", "<cmd>set cursorline!<cr>", { desc = "toggle cursorline" })
  map("n", "<leader>um", "<cmd>SupermavenStop<cr>", { desc = "Supermaven stop" })
  map("n", "<leader>uM", "<cmd>SupermavenStart<cr>", { desc = "Supermaven start" })
  map("n", "<leader>us", "<cmd>set laststatus=0<cr>", { desc = "StatusBar Hide" })
  map("n", "<leader>uS", "<cmd>set laststatus=3<cr>", { desc = "StatusBar Show" })
  map("n", "<leader>t", "", { desc = "+Terminal" })
  map("n", "<leader>tt", "<cmd>terminal <cr>", { desc = "buffer terminal" })
  map("n", "<leader>ty", "<cmd>terminal yazi<cr><cmd>set ft=terminal<cr>", { desc = "yazi" })
  map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = "vertical terminal" })
  map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = "horizontal terminal" })
  map("n", "<leader>w", "", { desc = "+Window" })
  map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "vertical window" })
  map("n", "<leader>wV", "<cmd>split<cr>", { desc = "horizontal window" })
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

-- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
map(
  { "n", "x" },
  "gT",
  function()
    local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
    local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
    if not ok1 then return end
    if not ok2 then return end
    local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<"
    if vim.fn.mode() ~= "n" then
      cmd = "<esc>:normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`<v`'"
    end
    return cmd
  end,
  { expr = true, desc = "Start of TextObj" }
)
map(
  { "n", "x" },
  "gt",
  function()
    local ok1, tobj_id1 = pcall(vim.fn.getcharstr)
    local ok2, tobj_id2 = pcall(vim.fn.getcharstr)
    if not ok1 then return end
    if not ok2 then return end
    local cmd = ":normal v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`>"
    if vim.fn.mode() ~= "n" then
      cmd = ":<c-u>normal m'v" .. tobj_id1 .. tobj_id2 .. "o<cr><esc>`'v`>"
    end
    return cmd
  end,
  { expr = true, desc = "End of TextObj" }
)

map({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
map({ "n", "x", "o" }, "<cr>", function() flash.jump({ continue = true }) end, { desc = "Continue Flash search" })
map({ "x", "o" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Flash Search" })
map({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
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

if vim.g.vscode then
  map(
    { "n", "x" },
    "gH",
    function()
      vscode.action("editor.action.dirtydiff.next")
      vscode.action("closeDirtyDiff")
    end,
    { desc = "EndOf Git hunk (vscode only)" }
  )
end

-- ╭───────────────────────────────────────╮
-- │ Text Objects with "g" (dot to repeat) │
-- ╰───────────────────────────────────────╯

map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
map({ "o", "x" }, "gC", function() require('mini.comment').textobject() end, { desc = "BlockComment textobj" })
map({ "o", "x" }, "g>", "gn", { desc = "Next find textobj" })
map({ "o", "x" }, "g<", "gN", { desc = "Prev find textobj" })

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
