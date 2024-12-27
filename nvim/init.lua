-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

-- Clone 'mini.nvim'
local path_package = vim.env.HOME .. "/.vscode/extensions/yeferyv.retronvim-0.1.20241228/nvim/plugins/site/"
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  -- vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

vim.opt.rtp:prepend(mini_path)
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local _, vscode = pcall(require, "vscode-neovim")

------------------------------------------------------------------------------------------------------------------------

-- text-objects
add { source = "folke/flash.nvim", checkout = "v2.1.0" }
add { source = "lewis6991/gitsigns.nvim", checkout = "v0.9.0", }
add { source = "nvim-treesitter/nvim-treesitter", checkout = "v0.9.3", }
add { source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595" }

if not vim.g.vscode then
  -- completions
  add { source = "supermaven-inc/supermaven-nvim", checkout = "07d20fce48a5629686aefb0a7cd4b25e33947d50" }
  add { source = "williamboman/mason.nvim", checkout = "v1.10.0", }
  add { source = "neovim/nvim-lspconfig", checkout = "v1.0.0" }
end

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

if not vim.g.vscode then
  later(
    function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<A-l>",
          clear_suggestion = "<A-k>",
          accept_word = "<A-j>",
        }
      }
    end
  )
end

later(
  function()
    require("nvim-treesitter.configs").setup {
      indent = { enable = true },    -- https://www.reddit.com/r/neovim/comments/14n6iiy/if_you_have_treesitter_make_sure_to_disable_smartindent
      highlight = { enable = true }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5264
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
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- if folding using lsp then 'v:lua.vim.lsp.foldexpr()'
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

-- https://thevaluable.dev/vim-create-text-objects
-- select indent by the same or mayor level:
M.select_indent = function(skip_blank_line, skip_comment_line, same_indent, visual_mode)
  local start_indent = vim.fn.indent(vim.fn.line('.'))
  local get_comment_regex = "^%s*" .. string.gsub(vim.bo.commentstring, "%%s", ".*") .. "%s*$"
  local is_blank_line = function(line) return string.match(vim.fn.getline(line), '^%s*$') end
  local is_comment_line = function(line) return string.find(vim.fn.getline(line), get_comment_regex) end
  local is_not_out_of_range = function(line) return vim.fn.indent(line) ~= -1 end
  local has_not_same_indent = function(line) return vim.fn.indent(line) ~= start_indent end
  local has_mayor_indent = function(line) return vim.fn.indent(line) >= start_indent end

  vim.cmd [[ execute "normal \<esc>" ]] -- to exit visual mode

  -- go up while having a same or mayor indent
  local prev_line = vim.fn.line('.') - 1
  while has_mayor_indent(prev_line) or (is_blank_line(prev_line) and is_not_out_of_range(prev_line)) do
    if same_indent and has_not_same_indent(prev_line) and (not is_blank_line(prev_line)) then break end
    if skip_blank_line and is_blank_line(prev_line) then break end
    if skip_comment_line and is_comment_line(prev_line) then break end
    vim.cmd('-')
    prev_line = prev_line - 1
  end

  vim.cmd('normal! ' .. visual_mode)

  -- go down while having a same or mayor indent
  local next_line = vim.fn.line('.') + 1
  while has_mayor_indent(next_line) or (is_blank_line(next_line) and is_not_out_of_range(next_line)) do
    if same_indent and has_not_same_indent(next_line) and (not is_blank_line(next_line)) then break end
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
    vim.cmd [[ LspStart ]] -- the `vi` zsh alias doesn't autostart lsp
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
      elseif vim.snippets.active { direction = 1 } then
        vim.snippet.jump(1)
      else
        feedkeys '<Tab>'
      end
    end)
    map({ 'i', 's' }, '<S-Tab>', function()
      if pumvisible() then
        feedkeys '<C-p>'
        -- elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      elseif vim.snippets.active { direction = -1 } then
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

local spec_treesitter = require("mini.ai").gen_spec.treesitter
local gen_ai_spec = require('mini.extra').gen_ai_spec
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
    d = gen_ai_spec.diagnostic(),                                                                                           -- diagnostic textobj
    e = gen_ai_spec.line(),                                                                                                 -- line textobj
    h = { { "<(%w-)%f[^<%w][^<>]->.-</%1>" }, { "%f[%w]%w+=()%b{}()", '%f[%w]%w+=()%b""()', "%f[%w]%w+=()%b''()" } },       -- html attribute textobj
    k = { { "\n.-[=:]", "^.-[=:]" }, "^%s*()().-()%s-()=?[!=<>\\+-\\*]?[=:]" },                                             -- key textobj
    v = { { "[=:]()%s*().-%s*()[;,]()", "[=:]=?()%s*().*()().$" } },                                                        -- value textobj
    N = gen_ai_spec.number(),                                                                                               -- number(inside string) textobj { '[-+]?()%f[%d]%d+()%.?%d*' }
    x = { '#()%x%x%x%x%x%x()' },                                                                                            -- hexadecimal textobj
    o = { "%S()%s+()%S" },                                                                                                  -- whitespace textobj
    S = { { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]', }, '^().*()$' }, -- sub word textobj https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt
    u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },                                                                       -- quote textobj
  },
  n_lines = 500,                                                                                                            -- search range and required by functions less than 500 LOC
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
    use_cterm = true,     -- required if `vi -c 'Pick files'`
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
  vim.api.nvim_set_hl(0, "Comment", { fg = "#5c5c5c", })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#2c2c2c" })
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#3C3CFf" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#990000" })

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

  require('mini.cursorword').setup()
  require('mini.extra').setup()
  require('mini.icons').setup()
  require('mini.indentscope').setup({ options = { indent_at_cursor = false, }, symbol = '│', })
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
  vim.ui.select = MiniPick.ui_select
  vim.opt.completeopt:append('fuzzy')   -- it should be after require("mini.completion").setup())
end

-- ╭────────────╮
-- │ Navigation │
-- ╰────────────╯

local flash = require("flash")
local gs = require("gitsigns")
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
  map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
  map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, desc = "prev completion when no lsp" })
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

  -- https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/mason/names.lua
  local masonames = {
    angularls = "angular-language-server",
    astro = "astro-language-server",
    bashls = "bash-language-server",
    cmake = "cmake-language-server",
    csharp_ls = "csharp-language-server",
    css_variables = "css-variables-language-server",
    cssls = "css-lsp",
    cssmodules_ls = "cssmodules-language-server",
    denols = "deno",
    docker_compose_language_service = "docker-compose-language-service",
    dockerls = "dockerfile-language-server",
    emmet_language_server = "emmet-language-server",
    emmet_ls = "emmet-ls",
    eslint = "eslint-lsp",
    graphql = "graphql-language-service-cli",
    gitlab_ci_ls = "gitlab-ci-ls",
    gopls = "gopls",
    html = "html-lsp",
    htmx = "htmx-lsp",
    java_language_server = "java-language-server",
    jdtls = "jdtls",
    jsonls = "json-lsp",
    lua_ls = "lua-language-server",
    neocmake = "neocmakelsp",
    nginx_language_server = "nginx-language-server",
    omnisharp = "omnisharp",
    prismals = "prisma-language-server",
    pylsp = "python-lsp-server",
    pylyzer = "pylyzer",
    quick_lint_js = "quick-lint-js",
    r_language_server = "r-languageserver",
    ruby_lsp = "ruby-lsp",
    ruff_lsp = "ruff-lsp",
    rust_analyzer = "rust-analyzer",
    svelte = "svelte-language-server",
    tailwindcss = "tailwindcss-language-server",
    ts_ls = "typescript-language-server",
    volar = "vue-language-server",
    vuels = "vetur-vls",
    yamlls = "yaml-language-server",
  }

  -- extract installed lsp servers from mason.nvim
  local servers = {}
  local pkgs = require("mason-registry").get_installed_packages()
  for _, pkgvalue in pairs(pkgs) do
    if pkgvalue.spec.categories[1] == "LSP" then
      table.insert(servers, pkgvalue.name)
    end
  end

  -- update incompatible mason's lsp names according to nvim-lspconfig
  -- https://github.com/NvChad/ui/blob/v3.0/lua/nvchad/mason/init.lua
  for masonkey, masonvalue in pairs(masonames) do
    for serverkey, servervalue in pairs(servers) do
      if masonvalue == servervalue then
        servers[serverkey] = masonkey
      end
    end
  end

  -- autoconfigure lsp servers installed by mason
  for _, server in pairs(servers) do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local opts = { capabilities = capabilities }

    require("lspconfig")[server].setup(opts)
  end

  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/formatters
  -- https://github.com/creativenull/efmls-configs-nvim/tree/v1.9.0/lua/efmls-configs/linters
  if vim.tbl_contains(servers, "efm") then
    require("lspconfig").efm.setup {
      init_options = { documentFormatting = true },
      settings = {
        rootMarkers = { ".git/" },
        languages = {
          python = { { formatCommand = "black -", formatStdin = true } },
          javascript = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          javascriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          typescript = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          typescriptreact = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          css = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          html = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          json = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          markdown = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
          yaml = { { formatCommand = "prettier --stdin-filepath '${INPUT}'", formatStdin = true } },
        }
      }
    }
  end

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

  map("n", "<leader>o", ":lua MiniFiles.open()<cr>", { desc = "Open Explorer (CWD)" })
  map("n", "<leader>O", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { desc = "Open Explorer (CurrentFile)" })
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

-- https://vi.stackexchange.com/questions/22570/is-there-a-way-to-move-to-the-beginning-of-the-next-text-object
map(
  { "n", "x" },
  "gh",
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
  "gl",
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

-- ╭───────────────────────────────────────╮
-- │ Text Objects with a/i (dot to repeat) │
-- ╰───────────────────────────────────────╯

map({ "o", "x" }, "iI", function() require("mini.indentscope").textobject(false) end, { desc = "indent blank" })
map({ "o", "x" }, "aI", function() require("mini.indentscope").textobject(true) end, { desc = "indent blank" })
map({ "x", "o" }, "ii", function() M.select_indent(true, true, false, "V") end, { desc = "indent" })
map({ "x", "o" }, "ai", function() M.select_indent(true, true, false, "kV") end, { desc = "indent" })
map({ "x", "o" }, "iy", function() M.select_indent(true, true, true, "V") end, { desc = "same_indent" })
map({ "x", "o" }, "ay", function() M.select_indent(false, false, true, "V") end, { desc = "same_indent blank" })
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
repeat_mini_ai("i", "K", "@block.inner")
repeat_mini_ai("a", "K", "@block.outer")
repeat_mini_ai("i", "Q", "@call.inner")
repeat_mini_ai("a", "Q", "@call.outer")
repeat_mini_ai("i", "g", "@comment.inner")
repeat_mini_ai("a", "g", "@comment.outer")
repeat_mini_ai("i", "G", "@conditional.inner")
repeat_mini_ai("a", "G", "@conditional.outer")
repeat_mini_ai("i", "F", "@function.inner")
repeat_mini_ai("a", "F", "@function.outer")
repeat_mini_ai("i", "L", "@loop.inner")
repeat_mini_ai("a", "L", "@loop.outer")
repeat_mini_ai("i", "P", "@parameter.inner")
repeat_mini_ai("a", "P", "@parameter.outer")
repeat_mini_ai("i", "R", "@return.inner")
repeat_mini_ai("a", "R", "@return.outer")
repeat_mini_ai("i", "A", "@assignment.inner")
repeat_mini_ai("a", "A", "@assignment.outer")
repeat_mini_ai("i", "=", "@assignment.lhs")
repeat_mini_ai("a", "=", "@assignment.rhs")
repeat_mini_ai("i", "#", "@number.inner")
repeat_mini_ai("a", "#", "@number.outer")
