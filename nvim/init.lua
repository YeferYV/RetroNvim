-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

-- Clone 'mini.nvim'
local path_package = vim.env.HOME .. "/.vscode/extensions/yeferyv.retronvim-0.0.4/nvim/plugins/site/"
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

vim.opt.rtp:prepend(mini_path)
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local _, vscode = pcall(require, "vscode-neovim")

------------------------------------------------------------------------------------------------------------------------

-- text-objects
add { source = "chrisgrieser/nvim-various-textobjs", checkout = "52343c70e2487095cafd4a5000d0465a2b992b03", }
add { source = "folke/flash.nvim", checkout = "v2.1.0" }
add { source = "lewis6991/gitsigns.nvim", checkout = "v0.9.0", }
add { source = "nvim-treesitter/nvim-treesitter", checkout = "a8535b2329a082c7f4e0b11b91b1792770425eaa", }
add { source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "33a17515b79ddb10d750320fa994098bdc3e93ef" }

-- completion
add { source = "mehalter/codeium.vim", checkout = "8b0a827a6fc6a224c2a3f083def46bd5981309f3", } -- offline: https://github.com/Exafunction/codeium.vim/pull/421, run `:Codeium Auth` then `:Codeium Enable` see: https://github.com/Exafunction/codeium.vim/issues/376
add { source = "L3MON4D3/LuaSnip", checkout = "v2.0.0" }
add { source = "jay-babu/mason-null-ls.nvim", checkout = "de19726de7260c68d94691afb057fa73d3cc53e7" }
add { source = "neovim/nvim-lspconfig", checkout = "6c505d4220b521f3b0e7b645f6ce45fa914d0eed" }
add { source = "nvim-lua/plenary.nvim", checkout = "a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683" }
add { source = "nvimtools/none-ls.nvim", checkout = "cfa65d86e21eeb60544d5e823f6db43941322a53" }
add { source = "rafamadriz/friendly-snippets", checkout = "00ebcaa159e817150bd83bfe2d51fa3b3377d5c4" }
add { source = "williamboman/mason-lspconfig.nvim", checkout = "62360f061d45177dda8afc1b0fd1327328540301" }
add { source = "williamboman/mason.nvim", checkout = "e2f7f9044ec30067bc11800a9e266664b88cda22", }

-- luasnip version "v2.3.0" or latest commit requires modifying `null_ls.builtins.completion.luasnip`. see: https://github.com/nvimtools/none-ls.nvim/discussions/130
later(function() require("luasnip.loaders.from_vscode").lazy_load() end)

later(function() require("flash").setup { modes = { search = { enabled = true } } } end)

later(
  function()
    require("gitsigns").setup {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "│" },
        topdelete    = { text = "" },
        changedelete = { text = "~" },
        untracked    = { text = '┆' },
      }
    }
  end
)

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
vim.opt.iskeyword:append "-"      -- hyphenated words recognized by searches

if not vim.g.vscode then
  vim.opt.cmdheight = 0                               -- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 3                              -- laststatus=3 global status line (line between splits)
  vim.opt.number = true                               -- set numbered lines
  vim.opt.scrolloff = 8                               -- vertical scrolloff
  vim.opt.sidescrolloff = 8                           -- horizontal scrolloff
  vim.opt.virtualedit = "all"                         -- allow cursor bypass end of line
  vim.g.mapleader = " "                               -- <leader> key
  vim.o.foldcolumn = '1'                              -- if '1' will show clickable fold signs
  vim.o.foldlevel = 99                                -- Disable folding at startup
  vim.o.foldmethod = "expr"                           -- expr = specify an expression to define folds
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- folding using treesitter (grammar required)
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  vim.o.statuscolumn =
  '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%s%l '

  vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "" })
  vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "" })
  vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "" })
  vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "" })
  vim.cmd [[ TSEnable highlight ]]
end

-- ╭──────────────╮
-- │ Autocommands │
-- ╰──────────────╯

vim.cmd [[

  augroup _general_settings
    autocmd!
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufEnter     * :set formatoptions-=cro
    autocmd BufReadPost  * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup end

  augroup _hightlight_whitespaces
    autocmd!
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd InsertLeave * redraw!
    match ExtraWhitespace /\s\+$\| \+\ze\t/
    autocmd BufWritePre * :%s/\s\+$//e
  augroup end

]]

------------------------------------------------------------------------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "TermEnter", "TermOpen" }, {
  callback = function()
    vim.cmd [[ setlocal nocursorline ]]
    vim.cmd [[ setlocal nonumber ]]
    vim.cmd [[ setlocal signcolumn=no ]]
    vim.cmd.startinsert()
    vim.cmd.highlight("ExtraWhitespace guibg=none")

    -- hide bufferline if `nvim -cterm`
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
      vim.cmd("set showtabline=0")
    else
      vim.cmd("set showtabline=2")
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

-- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
M.EnableAutoNoHighlightSearch = function()
  vim.on_key(function(char)
    if vim.fn.mode() == "n" then
      local new_hlsearch = vim.tbl_contains({ "<Up>", "<Down>", "<CR>", "n", "N", "*", "#", "?", "/" },
        vim.fn.keytrans(char))
      if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
    end
  end, vim.api.nvim_create_namespace "auto_hlsearch")
end

M.DisableAutoNoHighlightSearch = function()
  vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
  vim.cmd [[ set hlsearch ]]
end

vim.api.nvim_create_user_command("EnableAutoNoHighlightSearch", M.EnableAutoNoHighlightSearch, {})
vim.api.nvim_create_user_command("DisableAutoNoHighlightSearch", M.DisableAutoNoHighlightSearch, {})

M.EnableAutoNoHighlightSearch() -- autostart

------------------------------------------------------------------------------------------------------------------------

function GotoTextObj_Callback()
  vim.api.nvim_feedkeys(vim.g.dotargs, "n", true)
end

_G.GotoTextObj = function(motion, selection_char, selection_line, selection_block)
  vim.g.dotargs = motion

  if vim.fn.mode() == "v" then
    vim.g.dotargs = selection_char
  end

  if vim.fn.mode() == "V" then
    vim.g.dotargs = selection_line
  end

  if vim.fn.mode() == "\22" then
    vim.g.dotargs = selection_block
  end

  vim.o.operatorfunc = 'v:lua.GotoTextObj_Callback'
  return "<esc>m'g@"
end

------------------------------------------------------------------------------------------------------------------------

-- https://thevaluable.dev/vim-create-text-objects
-- select indent by the same level:
M.select_same_indent = function(skip_blank_line, skip_comment_line)
  local start_indent = vim.fn.indent(vim.fn.line('.'))
  local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
  local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
  local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end

  -- go up while having the same indent
  local prev_line = vim.fn.line('.') - 1
  while vim.fn.indent(prev_line) == start_indent or (is_blank_line(prev_line) and vim.fn.indent(prev_line) ~= -1) do
    if skip_blank_line and is_blank_line(prev_line) then break end
    if skip_comment_line and is_comment_line(prev_line) then break end
    vim.cmd('-')
    prev_line = prev_line - 1
  end

  vim.cmd('normal! V')

  -- go down while having the same indent
  local next_line = vim.fn.line('.') + 1
  while vim.fn.indent(next_line) == start_indent or (is_blank_line(next_line) and vim.fn.indent(next_line) ~= -1) do
    if skip_blank_line and is_blank_line(next_line) then break end
    if skip_comment_line and is_comment_line(next_line) then break end
    vim.cmd('+')
    next_line = next_line + 1
  end
end

--------------------------------------------------------------------------------------------------------------------

-- https://github.com/romgrk/columnMove.vim
M.ColumnMove = function(direction)
  local lnum = vim.fn.line('.')
  local colnum = vim.fn.virtcol('.')
  local remove_extraline = false
  local pattern1, pattern2
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
    if match_char(lnum, pattern1) then
      break
    end

    if pattern2 then
      if match_char(lnum, pattern2) then
        break
      end
    end

    lnum = lnum + direction
  end

  -- If the match was at the end of the line, return the previous line number and the current column number
  if remove_extraline then
    vim.cmd.normal(lnum - direction .. "gg" .. colnum .. "|")
  else
    vim.cmd.normal(lnum .. "gg" .. colnum .. "|")
  end
end

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

function HideUnhideWindow()
  if not Hidden then
    Bufnr = vim.fn.bufnr()
    vim.cmd('hide')
    Hidden = true
  else
    vim.cmd('vs | buffer' .. Bufnr)
    Hidden = false
  end
end

------------------------------------------------------------------------------------------------------------------------

-- https://www.reddit.com/r/neovim/comments/1d7j0c1/a_small_gist_to_use_the_new_builtin_completion/
-- https://www.reddit.com/r/neovim/comments/rddugs/snipcomplua_luasnip_companion_plugin_for_omni/
local luasnip = require("luasnip")
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

vim.api.nvim_create_autocmd('LspAttach', {

  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })

    -- Use enter to expand snippet or accept completions.
    map('i', '<cr>', function()
      if luasnip.expandable() then
        luasnip.expand()
      elseif pumvisible() then
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
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        feedkeys '<Tab>'
      end
    end)
    map({ 'i', 's' }, '<S-Tab>', function()
      if pumvisible() then
        feedkeys '<C-p>'
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
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

local spec_treesitter = require("mini.ai").gen_spec.treesitter
local mini_clue = require("mini.clue")

require("mini.ai").setup({
  custom_textobjects = {
    K = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
    q = spec_treesitter({ a = "@call.outer", i = "@call.inner" }),
    Q = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
    g = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
    G = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
    F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
    L = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
    P = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
    R = spec_treesitter({ a = "@return.outer", i = "@return.inner" }),
    ["A"] = spec_treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
    ["="] = spec_treesitter({ a = "@assignment.rhs", i = "@assignment.lhs" }),
    ["#"] = spec_treesitter({ a = "@number.outer", i = "@number.inner" }),
    h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } }, -- html attribute textobj
    k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                       -- key textobj
    v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                  -- value textobj
    N = { '[-+]?()%f[%d]%d+()%.?%d*' },                                                                               -- number(inside string) textobj
    x = { '#()%x%x%x%x%x%x()' },                                                                                      -- hexadecimal textobj
    o = { "%S()%s+()%S" },                                                                                            -- whitespace textobj
    u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },                                                                 -- quote textobj
  },
  n_lines = 500,                                                                                                      -- search range and required by functions less than 500 LOC
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
require('mini.bracketed').setup()
require('mini.operators').setup()
require('mini.splitjoin').setup()

if not vim.g.vscode then
  require('mini.clue').setup({
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'o', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'x', keys = 'a' },
      { mode = 'x', keys = 'i' },
      { mode = 'o', keys = 'g' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
      { mode = 'n', keys = ']' },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'x', keys = '[' },
    },
    clues = {
      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.windows(),
      mini_clue.gen_clues.z(),
      { desc = "@block.outer",       keys = "aK", mode = "o" },
      { desc = "@block.outer",       keys = "aK", mode = "x" },
      { desc = "@block.inner",       keys = "iK", mode = "o" },
      { desc = "@block.inner",       keys = "iK", mode = "x" },
      { desc = "@call.outer",        keys = "aC", mode = "o" },
      { desc = "@call.outer",        keys = "aC", mode = "x" },
      { desc = "@call.inner",        keys = "iC", mode = "o" },
      { desc = "@call.inner",        keys = "iC", mode = "x" },
      { desc = "@comment.outer",     keys = "aQ", mode = "o" },
      { desc = "@comment.outer",     keys = "aQ", mode = "x" },
      { desc = "@comment.inner",     keys = "iQ", mode = "o" },
      { desc = "@comment.inner",     keys = "iQ", mode = "x" },
      { desc = "@conditional.outer", keys = "aG", mode = "o" },
      { desc = "@conditional.outer", keys = "aG", mode = "x" },
      { desc = "@conditional.inner", keys = "iG", mode = "o" },
      { desc = "@conditional.inner", keys = "iG", mode = "x" },
      { desc = "@function.outer",    keys = "aF", mode = "o" },
      { desc = "@function.outer",    keys = "aF", mode = "x" },
      { desc = "@function.inner",    keys = "iF", mode = "o" },
      { desc = "@function.inner",    keys = "iF", mode = "x" },
      { desc = "@loop.outer",        keys = "aL", mode = "o" },
      { desc = "@loop.outer",        keys = "aL", mode = "x" },
      { desc = "@loop.inner",        keys = "iL", mode = "o" },
      { desc = "@loop.inner",        keys = "iL", mode = "x" },
      { desc = "@parameter.outer",   keys = "aP", mode = "o" },
      { desc = "@parameter.outer",   keys = "aP", mode = "x" },
      { desc = "@parameter.inner",   keys = "iP", mode = "o" },
      { desc = "@parameter.inner",   keys = "iP", mode = "x" },
      { desc = "@return.outer",      keys = "aR", mode = "o" },
      { desc = "@return.outer",      keys = "aR", mode = "x" },
      { desc = "@return.inner",      keys = "iR", mode = "o" },
      { desc = "@return.inner",      keys = "iR", mode = "x" },
      { desc = "@assignment.outer",  keys = "aA", mode = "o" },
      { desc = "@assignment.outer",  keys = "aA", mode = "x" },
      { desc = "@assignment.inner",  keys = "iA", mode = "o" },
      { desc = "@assignment.inner",  keys = "iA", mode = "x" },
      { desc = "@assignment.rhs",    keys = "a=", mode = "o" },
      { desc = "@assignment.rhs",    keys = "a=", mode = "x" },
      { desc = "@assignment.lhs",    keys = "i=", mode = "o" },
      { desc = "@assignment.lhs",    keys = "i=", mode = "x" },
      { desc = "@number.outer",      keys = "a#", mode = "o" },
      { desc = "@number.outer",      keys = "a#", mode = "x" },
      { desc = "@number.inner",      keys = "i#", mode = "o" },
      { desc = "@number.inner",      keys = "i#", mode = "x" },
    },
  })

  require("mini.files").setup({
    windows = {
      max_number = math.huge,
      preview = true,
      width_focus = 30,
      width_nofocus = 15,
      width_preview = 60,
    },
  })

  require('mini.base16').setup({
    -- `:Inspect` to reverse engineering a colorscheme
    -- `:hi <@treesitter>` to view colors of `:Inspect` output
    -- `:Pick hl_groups` to view generated colorscheme
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
  })

  -- poimandres transparency
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueTitle", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniFilesTitle", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniFilesTitleFocused", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniClueDescSingle", { link = "Pmenu" })
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#1c1c2c" })
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#506477", bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Statusline", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatuslineNC", { bg = "NONE" })

  -- poimandres custom colors
  vim.api.nvim_set_hl(0, "Comment", { fg = "#444444", })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#1ABC9C" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#880000" })

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

  -- poimandres treesitter same as the original
  vim.api.nvim_set_hl(0, "@keyword.operator", { fg = "#5de4c7" })
  vim.api.nvim_set_hl(0, "@keyword.return", { fg = "#5fb3a1" })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = "#e4f0fb", })
  vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#A6ACCD", })
  vim.api.nvim_set_hl(0, "Special", { fg = "#767c9d" })
  vim.api.nvim_set_hl(0, "Type", { fg = "#a6accd" })

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

  require('mini.cursorword').setup()
  require('mini.extra').setup()
  require('mini.icons').setup()
  require('mini.indentscope').setup()
  require('mini.misc').setup_auto_root()
  require('mini.notify').setup()
  require('mini.pairs').setup()
  require('mini.pick').setup()
  require('mini.statusline').setup()
  require('mini.starter').setup()
  require('mini.tabline').setup()
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind( --[[ "replace" ]])
  vim.notify = MiniNotify.make_notify() -- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
  vim.opt.completeopt:append('fuzzy')   -- it should be after require("mini.completion").setup())
end

-- ╭────────────╮
-- │ Treesitter │
-- ╰────────────╯

require("nvim-treesitter.configs").setup {
  indent = { enable = true },    -- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable_smartindent
  highlight = { enable = true }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5264
  textobjects = {
    move = {
      goto_previous_start = {
        ['gpaK'] = '@block.outer',
        ['gpaq'] = '@call.outer',
        ['gpaQ'] = '@class.outer',
        ['gpag'] = '@comment.outer',
        ['gpaG'] = '@conditional.outer',
        ['gpaF'] = '@function.outer',
        ['gpaL'] = '@loop.outer',
        ['gpaP'] = '@parameter.outer',
        ['gpaR'] = '@return.outer',
        ['gpaA'] = '@assignment.outer',
        ['gpa='] = '@assignment.lhs',
        ['gpa#'] = '@number.outer',
        ["gpz"] = { query = "@fold", query_group = "folds", desc = "Previous Start Fold" },
        ["gpZ"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
        ['gpiK'] = '@block.inner',
        ['gpiq'] = '@call.inner',
        ['gpiQ'] = '@class.inner',
        ['gpig'] = '@comment.inner',
        ['gpiG'] = '@conditional.inner',
        ['gpiF'] = '@function.inner',
        ['gpiL'] = '@loop.inner',
        ['gpiP'] = '@parameter.inner',
        ['gpiR'] = '@return.inner',
        ['gpiA'] = '@assignment.inner',
        ['gpi='] = '@assignment.rhs',
        ['gpi#'] = '@number.inner',
      },
      goto_next_start = {
        ['gnaK'] = '@block.outer',
        ['gnaq'] = '@call.outer',
        ['gnaQ'] = '@class.outer',
        ['gnag'] = '@comment.outer',
        ['gnaG'] = '@conditional.outer',
        ['gnaF'] = '@function.outer',
        ['gnaL'] = '@loop.outer',
        ['gnaP'] = '@parameter.outer',
        ['gnaR'] = '@return.outer',
        ['gnaA'] = '@assignment.outer',
        ['gna='] = '@assignment.lhs',
        ['gna#'] = '@number.outer',
        ["gnz"] = { query = "@fold", query_group = "folds", desc = "Next Start Fold" },
        ["gnZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ['gniK'] = '@block.inner',
        ['gniq'] = '@call.inner',
        ['gniQ'] = '@class.inner',
        ['gnig'] = '@comment.inner',
        ['gniG'] = '@conditional.inner',
        ['gniF'] = '@function.inner',
        ['gniL'] = '@loop.inner',
        ['gniP'] = '@parameter.inner',
        ['gniR'] = '@return.inner',
        ['gniA'] = '@assignment.inner',
        ['gni='] = '@assignment.rhs',
        ['gni#'] = '@number.inner',
      },
      goto_previous_end = {
        ['gpeaK'] = '@block.outer',
        ['gpeaq'] = '@call.outer',
        ['gpeaQ'] = '@class.outer',
        ['gpeag'] = '@comment.outer',
        ['gpeaG'] = '@conditional.outer',
        ['gpeaF'] = '@function.outer',
        ['gpeaL'] = '@loop.outer',
        ['gpeaP'] = '@parameter.outer',
        ['gpeaR'] = '@return.outer',
        ['gpeaA'] = '@assignment.lhs',
        ['gpea='] = '@assignment.outer',
        ['gpea#'] = '@number.outer',
        ["gpez"] = { query = "@fold", query_group = "folds", desc = "Previous End Fold" },
        ["gpeZ"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ['gpeiK'] = '@block.inner',
        ['gpeiq'] = '@call.inner',
        ['gpeiQ'] = '@class.inner',
        ['gpeig'] = '@comment.inner',
        ['gpeiG'] = '@conditional.inner',
        ['gpeiF'] = '@function.inner',
        ['gpeiL'] = '@loop.inner',
        ['gpeiP'] = '@parameter.inner',
        ['gpeiR'] = '@return.inner',
        ['gpeiA'] = '@assignment.inner',
        ['gpei='] = '@assignment.rhs',
        ['gpei#'] = '@number.inner',
      },
      goto_next_end = {
        ['gneaK'] = '@block.outer',
        ['gneaq'] = '@call.outer',
        ['gneaQ'] = '@class.outer',
        ['gneag'] = '@comment.outer',
        ['gneaG'] = '@conditional.outer',
        ['gneaF'] = '@function.outer',
        ['gneaL'] = '@loop.outer',
        ['gneaP'] = '@parameter.outer',
        ['gneaR'] = '@return.outer',
        ['gneaA'] = '@assignment.outer',
        ['gnea='] = '@assignment.lhs',
        ['gnea#'] = '@number.outer',
        ["gnez"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["gneZ"] = { query = "@fold", query_group = "folds", desc = "Next End Fold" },
        ['gneiK'] = '@block.inner',
        ['gneiq'] = '@call.inner',
        ['gneiQ'] = '@class.inner',
        ['gneig'] = '@comment.inner',
        ['gneiG'] = '@conditional.inner',
        ['gneiF'] = '@function.inner',
        ['gneiL'] = '@loop.inner',
        ['gneiP'] = '@parameter.inner',
        ['gneiR'] = '@return.inner',
        ['gneiA'] = '@assignment.inner',
        ['gnei='] = '@assignment.rhs',
        ['gnei#'] = '@number.inner',
      }
    }
  }
}

-- ╭────────────╮
-- │ Navigation │
-- ╰────────────╯

local flash = require("flash")
local gs = require("gitsigns")
local textobjs = require("various-textobjs")
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

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
  map({ "n", "v", "t" }, "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "vertical shrink" })
  map({ "n", "v", "t" }, "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "vertical expand" })
  map({ "n", "v", "t" }, "<M-Up>", "<cmd>resize -2<cr>", { desc = "horizontal shrink" })
  map({ "n", "v", "t" }, "<M-Down>", "<cmd>resize +2<cr>", { desc = "horizontal shrink" })
  map({ "t" }, "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
  map({ "n" }, "<C-s>", ":%s//g<Left><Left>", { desc = "Replace in Buffer" })
  map({ "x" }, "<C-s>", ":s//g<Left><Left>", { desc = "Replace in Visual_selected" })
  map({ "t", "n" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window" })
  map({ "t", "n" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window" })
  map({ "t", "n" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window" })
  map({ "t", "n" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window" })
  map({ "t", "n" }, "<C-\\>", ToggleTerminal, { desc = "toggle window terminal" })
  map({ "t", "n" }, "<C-;>", "<C-\\><C-n><C-6>", { desc = "go to last buffer" })
  map({ "n" }, "<right>", ":bnext<CR>", { desc = "next buffer" })
  map({ "n" }, "<left>", ":bprevious<CR>", { desc = "prev buffer" })
  map({ "n" }, "<leader>x", ":bp | bd! #<CR>", { desc = "Close Buffer" }) -- `bd!` forces closing terminal buffer
  map({ "n" }, "<leader>X", ":tabclose<CR>", { desc = "Close Tab" })
  map("i", "<A-j>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, desc = "next suggest" })
  map("i", "<A-k>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, desc = "prev suggest" })
  map("i", "<A-l>", function() return vim.fn["codeium#Accept"]() end, { expr = true, desc = "accept suggest" })
end

-- Quick quit/write
if not vim.g.vscode then
  map({ "n" }, "Q", "<cmd>lua vim.cmd('quit')<cr>")
  map({ "n" }, "R", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 }) vim.cmd('silent write') <cr>")
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
  -- LSP
  require("mason").setup()
  require('null-ls').setup({
    sources = {
      -- to make luasnip behave as a lsp
      require('null-ls').builtins.completion.luasnip
    },
  })
  require("mason-null-ls").setup({ handlers = {}, })

  -- `:help mason-lspconfig.setup_handlers()`
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      -- add snippets capability to lsp to show it inside mini.completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      local opts = { capabilities = capabilities }

      -- require("lspconfig")[server_name].setup {}
      require('lspconfig')[server_name].setup(opts)
    end,
  }

  map("n", "<leader>l", "", { desc = "+LSP" })
  map("n", "<leader>lA", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
  map("n", "<leader>lc", function() vim.lsp.buf.incoming_calls() end, { desc = "Incoming Calls" })
  map("n", "<leader>lC", function() vim.lsp.buf.outcoming_calls() end, { desc = "Outcoming Calls" })
  map("n", "<leader>ld", ":Pick lsp scope='definition'<cr>", { desc = "Goto Definition" })
  map("n", "<leader>lD", ":Pick lsp scope='declaration'<cr>", { desc = "Goto Declaration" })
  map("n", "<leader>lF", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end, { desc = "Format (none-ls > lsp)" })
  map("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })
  map("n", "<leader>lH", function() vim.lsp.buf.hover() end, { desc = "Hover" })
  map("n", "<leader>lI", ":Pick lsp scope='implementation'<cr>", { desc = "Goto Implementation" })
  map("n", "<leader>lm", ":Mason<cr>", { desc = "Mason" })
  map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
  map("n", "<leader>lo", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostic" })
  map("n", "<leader>lp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
  map("n", "<leader>lq", ":Pick diagnostic<cr>", { desc = "Diagnostic List" })
  map("n", "<leader>lr", ":Pick lsp scope='references'<cr>", { desc = "References" })
  map("n", "<leader>lR", function() vim.lsp.buf.rename() end, { desc = "Rename" })
  map("n", "<leader>ls", ":Pick lsp scope='document_symbol'<cr>", { desc = "Document symbols" })
  map("n", "<leader>ls", ":Pick lsp scope='workspace_symbol'<cr>", { desc = "Workspace symbol" })
  map("n", "<leader>lt", ":Pick lsp scope='type_definition'<cr>", { desc = "Goto TypeDefinition" })
  map("n", "<leader>l0", ":LspStop<cr>", { desc = "lsp stop" })

  map(
    "n",
    "<leader>l1",
    function()
      vim.defer_fn(function() vim.cmd("LspStop") end, 1)
      vim.defer_fn(function() vim.cmd("LspRestart") end, 300)
      vim.defer_fn(function() vim.cmd("LspStart") end, 600)
    end,
    { desc = "lsp start (none-ls < lsp)" }
  )

  map("n", "<leader>o", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0),true)<cr>", { desc = "Open Explorer" })
  map("n", "<leader>f", "", { desc = "+Find" })
  map("n", "<leader>f/", ":Pick files<cr>", { desc = "Pick Files (tab to preview)" })
  map("n", "<leader>fF", ":Pick grep_live<cr>", { desc = "Pick Grep (tab to preview)" })
  map("n", "<leader>f'", ":Pick marks<cr>", { desc = "Pick Marks (tab to preview)" })
  map("n", "<leader>fR", ":Pick registers<cr>", { desc = "Pick register" })
  map("n", "<leader>fn", ":lua MiniNotify.show_history()<cr>", { desc = "Notify history" })
  map("n", "<leader>g", "", { desc = "+Git" })
  map("n", "<leader>gg", ":lua vim.cmd[[terminal lazygit]] vim.cmd[[set filetype=terminal]]<cr>", { desc = "lazygit" })
  map("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { silent = true, desc = "Preview GitHunk" })
  map("n", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Reset GitHunk" })
  map("n", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage GitHunk" })
  map("n", "<leader>gS", ":Gitsigns undo_stage_hunk<cr>", { silent = true, desc = "Undo stage GitHunk" })
  map("n", "<leader>u", "", { desc = "+UI toggle" })
  map("n", "<leader>u0", ":set showtabline=0<cr>", { desc = "Buffer Hide" })
  map("n", "<leader>u2", ":set showtabline=2<cr>", { desc = "Buffer Show" })
  map("n", "<leader>us", ":set laststatus=0<cr>", { desc = "StatusBar Hide" })
  map("n", "<leader>uS", ":set laststatus=3<cr>", { desc = "StatusBar Show" })
  map("n", "<leader>uh", function() M.EnableAutoNoHighlightSearch() end, { desc = "Enable AutoNoHighlightSearch" })
  map("n", "<leader>uH", function() M.DisableAutoNoHighlightSearch() end, { desc = "Disable AutoNoHighlightSearch" })
  map("n", "<leader>uu", HideUnhideWindow, { desc = "Hide/Unhide window (useful for terminal)" })
  map("n", "<leader>t", "", { desc = "+Terminal" })
  map("n", "<leader>tt", ":lua vim.cmd [[          terminal ]] <cr>", { desc = "buffer terminal" })
  map("n", "<leader>ty", ":lua vim.cmd[[terminal yazi]] vim.cmd[[set filetype=terminal]]<cr>", { desc = "yazi" })
  map("n", "<leader>v", ":lua vim.cmd [[ split  | terminal ]] <cr>", { desc = "vertical terminal" })
  map("n", "<leader>V", ":lua vim.cmd [[ vsplit | terminal ]] <cr>", { desc = "horizontal terminal" })
end

map(
  "n",
  "<leader>uU",
  function()
    vscode.action("editor.gotoParentFold")
    vscode.action("cursorHome")
  end,
  { desc = "goto parent fold (vscode only)" }
)

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

map(
  { "n", "x" },
  "g<",
  function() return GotoTextObj("`<", "`<v`'", "`<V`'", "`<\22`'") end,
  { expr = true, desc = "StartOf TextObj (dot to repeat)" }
)
map(
  { "n", "x" },
  "g>",
  function() return GotoTextObj("`>", "`'v`>", "`'V`>", "`'\22`>") end,
  { expr = true, desc = "EndOf TextObj (dot to repeat)" }
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
    "gh",
    function()
      vscode.action("editor.action.dirtydiff.next")
      vscode.action("closeDirtyDiff")
    end,
    { desc = "EndOf Git hunk (vscode only)" }
  )
else
  map(
    { "o", "x" },
    "gh",
    ":<c-u>Gitsigns select_hunk<cr>",
    { desc = "Git hunk textobj" }
  )
end

-- ╭───────────────────────────────────────╮
-- │ Text Objects with "g" (dot to repeat) │
-- ╰───────────────────────────────────────╯

map({ "n" }, "vgc", "<cmd>lua require('mini.comment').textobject()<cr>", { desc = "select BlockComment" })
map({ "o", "x" }, "gC", ":<c-u>lua require('mini.comment').textobject()<cr>", { desc = "BlockComment textobj" })
map({ "o", "x" }, "gf", "gn", { desc = "Next find textobj" })
map({ "o", "x" }, "gF", "gN", { desc = "Prev find textobj" })
map({ "o", "x" }, "gd", function() textobjs.diagnostic() end, { desc = "Diagnostic textobj" })
map({ "o", "x" }, "gK", function() textobjs.column() end, { desc = "ColumnDown textobj" })
map({ "o", "x" }, "gl", function() textobjs.lastChange() end, { desc = "last modified/yank/paste (noRepeaterKey)" }) -- `vgm` and `dgm` works. `cgm` and `ygm` doesn't work but it notifies
map({ "o", "x" }, "gL", function() textobjs.url() end, { desc = "Url textobj" })
map({ "o", "x" }, "go", function() textobjs.restOfWindow() end, { desc = "RestOfWindow textobj" })
map({ "o", "x" }, "gO", function() textobjs.visibleInWindow() end, { desc = "VisibleWindow textobj" })
map({ "o", "x" }, "gt", function() textobjs.toNextQuotationMark() end, { desc = "toNextQuotationMark textobj" })
map({ "o", "x" }, "gT", function() textobjs.toNextClosingBracket() end, { desc = "toNextClosingBracket textobj" })

-- ╭───────────────────────────────────────╮
-- │ Text Objects with a/i (dot to repeat) │
-- ╰───────────────────────────────────────╯

map({ "o", "x" }, "ad", function() textobjs.greedyOuterIndentation('outer') end, { desc = "greddyOuterIndent" })
map({ "o", "x" }, "id", function() textobjs.greedyOuterIndentation('inner') end, { desc = "greddyOuterIndent" })
map({ "o", "x" }, "ie", function() textobjs.nearEoL() end, { desc = "nearEndOfLine textobj" })
map({ "o", "x" }, "ae", function() textobjs.lineCharacterwise('inner') end, { desc = "lineCharacterwise" })
map({ "o", "x" }, "ii", function() textobjs.indentation("inner", "inner", "noBlanks") end, { desc = "indent" })
map({ "o", "x" }, "ai", function() textobjs.indentation("outer", "outer", "noBlanks") end, { desc = "indent" })
map({ "o", "x" }, "iI", function() textobjs.indentation("inner", "inner") end, { desc = "Indent blanklines" })
map({ "o", "x" }, "aI", function() textobjs.indentation("outer", "outer") end, { desc = "Indent blanklines" })
map({ "o", "x" }, "aj", function() textobjs.cssSelector('outer') end, { desc = "cssSelector" })
map({ "o", "x" }, "ij", function() textobjs.cssSelector('inner') end, { desc = "cssSelector" })
map({ "o", "x" }, "am", function() textobjs.chainMember('outer') end, { desc = "chainMember" })
map({ "o", "x" }, "im", function() textobjs.chainMember('inner') end, { desc = "chainMember" })
map({ "o", "x" }, "aM", function() textobjs.mdFencedCodeBlock('outer') end, { desc = "mdFencedCodeBlock" })
map({ "o", "x" }, "iM", function() textobjs.mdFencedCodeBlock('inner') end, { desc = "mdFencedCodeBlock" })
map({ "o", "x" }, "ir", function() textobjs.restOfParagraph() end, { desc = "RestOfParagraph" })
map({ "o", "x" }, "ar", function() textobjs.restOfIndentation() end, { desc = "restOfIndentation" })
map({ "o", "x" }, "aS", function() textobjs.subword('outer') end, { desc = "Subword" })
map({ "o", "x" }, "iS", function() textobjs.subword('inner') end, { desc = "Subword" })
map({ "o", "x" }, "aU", function() textobjs.pyTripleQuotes('outer') end, { desc = "pyTrippleQuotes" })
map({ "o", "x" }, "iU", function() textobjs.pyTripleQuotes('inner') end, { desc = "pyTrippleQuotes" })
map({ "x", "o" }, "iy", function() M.select_same_indent(true, true) end, { desc = "same_indent" })
map({ "x", "o" }, "ay", function() M.select_same_indent(false, false) end, { desc = "same_indent blank" })
map({ "o", "x" }, "aZ", function() textobjs.closedFold('outer') end, { desc = "ClosedFold" })
map({ "o", "x" }, "iZ", function() textobjs.closedFold('inner') end, { desc = "ClosedFold" })
map({ "x" }, "iz", ":<c-u>normal! [zjV]zk<cr>", { desc = "inner fold" })
map({ "o" }, "iz", ":normal Viz<CR>", { desc = "inner fold" })
map({ "x" }, "az", ":<c-u>normal! [zV]z<cr>", { desc = "outer fold" })
map({ "o" }, "az", ":normal Vaz<cr>", { desc = "outer fold" })

-- ╭──────────────────────────────────────────╮
-- │ Repeatable Pair - motions using <leader> │
-- ╰──────────────────────────────────────────╯

-- _nvim-treesitter-textobjs_repeatable
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { silent = true, desc = "Next TS textobj" })
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { silent = true, desc = "Prev TS textobj" })

local next_columnmove, prev_columnmove = ts_repeat_move.make_repeatable_move_pair(
  function() M.ColumnMove(1) end,
  function() M.ColumnMove(-1) end
)
map({ "n", "x", "o" }, "<leader><leader>j", next_columnmove, { desc = "Next ColumnMove" })
map({ "n", "x", "o" }, "<leader><leader>k", prev_columnmove, { desc = "Prev ColumnMove" })

-- ╭──────────────────────────────────────────────────╮
-- │ Repeatable Pair - textobj navigation using gn/gp │
-- ╰──────────────────────────────────────────────────╯

if vim.g.vscode then
  local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
    function() vscode.call("editor.action.marker.next") end,
    function() vscode.call("editor.action.marker.prev") end
  )
  map({ "n", "x", "o" }, "gnd", next_diagnostic, { silent = true, desc = "Next Diagnostic" })
  map({ "n", "x", "o" }, "gpd", prev_diagnostic, { silent = true, desc = "Prev Diagnostic" })

  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(
    function() vscode.call("workbench.action.editor.nextChange") end,
    function() vscode.call("workbench.action.editor.previousChange") end
  )
  map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { desc = "Next GitHunk" })
  map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { desc = "Prev GitHunk" })
  map({ "n", "x", "o" }, "gnH", next_hunk_repeat, { desc = "Next GitHunk" })
  map({ "n", "x", "o" }, "gpH", prev_hunk_repeat, { desc = "Prev GitHunk" })

  local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
    function() vscode.call("editor.action.wordHighlight.next") end,
    function() vscode.call("editor.action.wordHighlight.prev") end
  )
  map({ "n", "x", "o" }, "gnr", next_reference, { silent = true, desc = "Next Reference (vscode only)" })
  map({ "n", "x", "o" }, "gpr", prev_reference, { silent = true, desc = "Prev Reference (vscode only)" })
else
  local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
    function() vim.diagnostic.jump({ count = 1, float = true }) end,
    function() vim.diagnostic.jump({ count = -1, float = true }) end
  )
  map({ "n", "x", "o" }, "gnd", next_diagnostic, { desc = "Next Diagnostic" })
  map({ "n", "x", "o" }, "gpd", prev_diagnostic, { desc = "Prev Diagnostic" })

  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
  map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })
end

local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.bracketed").comment("forward") end,
  function() require("mini.bracketed").comment("backward") end
)
map({ "n", "x", "o" }, "gnc", next_comment, { desc = "Next Comment" })
map({ "n", "x", "o" }, "gpc", prev_comment, { desc = "Prev Comment" })

local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal ]z ]]) end,
  function() vim.cmd([[ normal [z ]]) end
)
map({ "n", "x", "o" }, "gnf", next_fold, { desc = "Fold ending" })
map({ "n", "x", "o" }, "gpf", prev_fold, { desc = "Fold beginning" })

local repeat_mini_ai = function(inner_or_around, key, desc)
  local next, prev = ts_repeat_move.make_repeatable_move_pair(
    function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "next" }) end,
    function() require("mini.ai").move_cursor("left", inner_or_around, key, { search_method = "prev" }) end
  )
  map({ "n", "x", "o" }, "gn" .. inner_or_around .. key, next, { desc = desc })
  map({ "n", "x", "o" }, "gp" .. inner_or_around .. key, prev, { desc = desc })
end

repeat_mini_ai("i", "f", "function call")
repeat_mini_ai("a", "f", "function call")
repeat_mini_ai("i", "h", "html atrib")
repeat_mini_ai("a", "h", "html atrib")
repeat_mini_ai("i", "k", "key")
repeat_mini_ai("a", "k", "key")
repeat_mini_ai("i", "n", "number")
repeat_mini_ai("a", "n", "number")
repeat_mini_ai("i", "u", "quote")
repeat_mini_ai("a", "u", "quote")
repeat_mini_ai("i", "v", "value")
repeat_mini_ai("a", "v", "value")
repeat_mini_ai("i", "x", "hexadecimal")
repeat_mini_ai("a", "x", "hexadecimal")
