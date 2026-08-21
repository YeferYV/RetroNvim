--- ╭─────────╮
--- │ Plugins │
--- ╰─────────╯

local vim          = vim --- lsp warnings
local lazy_path    = vim.env.RETRONVIM_PREFIX and (vim.env.RETRONVIM_PREFIX .. '/nvim/plugins/lazy.nvim') or ''
local mini_path    = vim.env.RETRONVIM_PREFIX and (vim.env.RETRONVIM_PREFIX .. '/nvim/plugins/mini.nvim') or ''
local plugins_path = vim.fn.expand(vim.fs.normalize(vim.fn.stdpath("data"))  .. '/site/pack/core/opt/*', 0, 1)

if not vim.loop.fs_stat(mini_path) then
  vim.pack.add({ { src = 'https://github.com/nvim-mini/mini.nvim', version = 'v0.18.0' } })
  vim.pack.add({ { src = 'https://github.com/folke/lazy.nvim', version = 'v11.17.5', } })
end

vim.opt.rtp:append(lazy_path)

require("lazy").setup({
  root = vim.env.RETRONVIM_PREFIX and vim.fs.dirname(lazy_path) or vim.fs.dirname(plugins_path[1]),
  spec = {
    {
      "LazyVim/LazyVim",
      version = "v16.0.0",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "default",
      },
    },
    { "akinsho/bufferline.nvim",                     enabled = false },
    { "catppuccin/nvim",                             enabled = false },
    { "folke/lazydev.nvim",                          enabled = false },
    { "folke/noice.nvim",                            enabled = false },
    { "folke/persistence.nvim",                      enabled = false },
    { "folke/todo-comments.nvim",                    enabled = false },
    { "folke/tokyonight.nvim",                       enabled = false },
    { "folke/trouble.nvim",                          enabled = false },
    { "folke/ts-comments.nvim",                      enabled = false },
    { "lewis6991/gitsigns.nvim",                     enabled = false },
    { "magicduck/grug-far.nvim",                     enabled = false },
    { "mfussenegger/nvim-lint",                      enabled = false },
    { "muniftanjim/nui.nvim",                        enabled = false },
    { "nvim-lua/plenary.nvim",                       enabled = false },
    { "nvim-lualine/lualine.nvim",                   enabled = false },
    { "nvim-mini/mini.icons",                        enabled = false },
    { "nvim-mini/mini.pairs",                        enabled = false },
    { "nvim-treesitter/nvim-treesitter",             enabled = false },
    { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
    { "rafamadriz/friendly-snippets",                enabled = false },
    { "saghen/blink.cmp",                            enabled = false },
    { "windwp/nvim-ts-autotag",                      enabled = false },
    {
      "folke/flash.nvim",
      version = "v2.1.0",
      opts = { modes = { search = { enabled = true } } },
    },
    {
      "folke/snacks.nvim",
      version = "v2.31.0",
      opts = { animate = { enabled = false } },
    },
    {
      "neovim/nvim-lspconfig",
      version = "bff1bd61",
      opts = {
        servers = {
          ['*'] = {
            keys = {
              { "H", "10h" },
              { "J", "10j" },
              { "K", "10k" },
              { "L", "10l" },
            },
          },
          ['lua_ls'] = { mason = false }, --- mason unable to install it on windows
        },
      },
    },
  },
})

--- ╭───────────╮
--- │ Mini.nvim │
--- ╰───────────╯

--- lazy.nvim erases runtimepath
vim.opt.rtp:prepend(mini_path)
vim.opt.rtp:append(plugins_path)

require('mini.base16').setup({
  palette = {
    --- BAT_THEME=base16 --- tokyonight --- description
    base00 = "#000000", -- "#1a1b26", --- default bg
    base01 = "#111111", -- "#16161e", --- line number bg
    base02 = "#2c2c2c", -- "#2f3549", --- statusline bg, selection bg
    base03 = "#444b6a", -- "#444b6a", --- line number fg, comments
    base04 = "#787c99", -- "#787c99", --- statusline fg
    base05 = "#a9b1d6", -- "#a9b1d6", --- default fg, delimiters
    base06 = "#cbccd1", -- "#cbccd1", --- light fg (not often used)
    base07 = "#d5d6db", -- "#d5d6db", --- light bg (not often used)
    base08 = "#5555cc", -- "#7aa2f7", --- variables, tags, Diff delete
    base09 = "#999900", -- "#ff9e64", --- integers, booleans, constants, search fg
    base0A = "#ff0000", -- "#0db9d7", --- classes, search bg
    base0B = "#009900", -- "#73daca", --- strings, Diff insert
    base0C = "#3c3cff", -- "#2ac3de", --- builtins, regex
    base0D = "#5FB3A1", -- "#7aa2f7", --- functions
    base0E = "#8855ff", -- "#bb9af7", --- keywords, Diff changed
    base0F = "#a0a0a0", -- "#7aa2f7", --- punctuation, indentscope
  },
  use_cterm = true,     --- required if `nvim -c 'Pick files'`
})

--- reset neovim terminal colors
for i = 0, 15 do vim.g["terminal_color_" .. i] = nil end

--- adding tokyonight transparency
vim.api.nvim_set_hl(0, "Normal", { fg = "#787c99", bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { fg = "#444b6a" })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#787c99" })
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#a9b1d6" })
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
vim.api.nvim_set_hl(0, "SidekickDiffContext", { bg = "#00003c", blend = 50 }) --- blend for virtual line not suported, SidekickDiffContext = SidekickDiffAdd + SidekickDiffDelete rest of background
vim.api.nvim_set_hl(0, "SidekickDiffAdd", { bg = "#003c00", blend = 50 })     --- blend for virtual line not suported, uses `Normal` background + foreground if treesitter not available
vim.api.nvim_set_hl(0, "SidekickDiffDelete", { bg = "#3c0000", blend = 50 })  --- blend for virtual line not suported, doesn't diff well without treesitter
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
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" }) --- transparent mini.completion
vim.api.nvim_set_hl(0, "PmenuSel", { fg = "NONE", bg = "#2c2c2c" })
vim.api.nvim_set_hl(0, "PmenuMatch", { bold = true, fg = "#3C3CFf" })
vim.api.nvim_set_hl(0, "Search", { fg = "#c0caf5", bg = "#3d59a1" })
vim.api.nvim_set_hl(0, "WhichKeySeparator", { bg = "NONE" })

local vscode_extensions = vim.fn.glob("~/.*/extensions", 0, 1)[1] or ''
local snippet_path      = vim.fn.expand(vscode_extensions .. "/*/snippets", 0, 1)
local snippet_dirname   = vim.tbl_map(vim.fs.dirname, snippet_path)
vim.opt.rtp:append(snippet_dirname)

require('mini.snippets').setup({
  snippets = { require('mini.snippets').gen_loader.from_runtime("*code-snippets") },
  mappings = {
    expand = '<a-.>',
    jump_next = '<a-n>',
    jump_prev = '<a-p>',
  }
})

require('mini.align').setup()
require('mini.bracketed').setup({ undo = { suffix = '' } })
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.diff').setup({ view = { style = 'sign', signs = { add = '│', change = '│', delete = '│' } }, options = { wrap_goto = true } })
require("mini.hipatterns").setup({ highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() } })
require('mini.icons').mock_nvim_web_devicons()
require('mini.icons').setup()
require('mini.icons').tweak_lsp_kind( --[[ "replace" ]])
require('mini.jump').setup( --[[{ repeat_jump = ';' }]])
require('mini.misc').setup_auto_root()
require('mini.notify').setup({ window = { winblend = 0 } --[[ ,lsp_progress = { enable = false } ]] })
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.snippets').start_lsp_server()
require('mini.splitjoin').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.trailspace').setup()

--- ╭────────────╮
--- │ Navigation │
--- ╰────────────╯

local map           = vim.keymap.set
local autocmd       = vim.api.nvim_create_autocmd
local no_completion = function(args) vim.b[args.buf].minicompletion_disable = true end
local no_trailspace = function(args) vim.b[args.buf].minitrailspace_disable = true end

autocmd({ "BufEnter" }, { command = "set formatoptions-=cro" })
autocmd({ "TermEnter", "TermOpen" }, { command = "startinsert" })
autocmd("FileType", { pattern = "markdown", callback = function() vim.opt.wrap = false end })
autocmd('Filetype', { pattern = 'snacks_picker_input', callback = no_completion })
autocmd('Filetype', { pattern = 'snacks_input', callback = no_completion })
autocmd('User', { pattern = 'SnacksDashboardOpened', callback = no_trailspace })
autocmd('TermLeave', { command = [[lua vim.schedule(function() return vim.fn.bufname() == "" and vim.cmd.quit() end)]] })

autocmd('LspAttach', {
  callback = function(args)
    map("n", "<C-s>", ":%s//g<Left><Left>", { buffer = args.buf, desc = "Replace in Buffer" })
    map("x", "<C-s>", ":s//g<Left><Left>", { buffer = args.buf, desc = "Replace in Visual_selected" })
  end,
})

vim.o.shell = vim.fn.executable('zsh') == 1 and 'zsh' or vim.env.SHELL --> fixes --> vim.o.shell='C:\\Users\\user\\zsh' --> set by --> export SHELL=zsh

vim.notify = require('mini.notify').make_notify() --- `vim.print = MiniNotify.make_notify()` conflicts with `:=vim.opt.number`
vim.treesitter.start = function() end             --- nvim.conda on windows doesn't ship parser/lua.dll etc, lsp has their own syntax highlightting
vim.g.autoformat = false                          --- press R to format
vim.opt.completeopt:append('fuzzy')               --- it should be after require("mini.completion").setup() otherwise auto trigger first suggestion
vim.opt.backupcopy = "yes"                        --- fixes `next dev --turbopack` file change detection
vim.opt.cmdheight = 0                             --- more space in the neovim command line for displaying messages
vim.opt.conceallevel = 0                          --- annoying hide/show text
vim.opt.cursorline = false                        --- enabled by default on lazyvim
vim.opt.laststatus = 3                            --- laststatus=3 global status line (line between splits)
vim.opt.list = false                              --- Disable the visibility of listchars (like trailspace chars)
vim.opt.pumborder = 'rounded'                     --- enable mini.completion border
vim.opt.relativenumber = false                    --- enabled by default on lazyvim
vim.opt.undofile = false                          --- enabled by default on lazyvim
vim.opt.virtualedit = "all"                       --- allow cursor bypass end of line
vim.opt.wrap = false                              --- display lines as one long line
vim.opt.winborder = 'rounded'                     --- MiniCompletion's info and signature border
vim.opt.statuscolumn = ''                         --- disable lazyvim statuscolumn to allow fold signs
vim.opt.foldcolumn = '1'                          --- if '1' will show clickable fold signs
vim.opt.foldlevel = 99                            --- Disable folding at startup
vim.opt.foldmethod = "expr"                       --- expr = specify an expression to define folds
vim.opt.foldexpr = 'v:lua.vim.lsp.foldexpr()'     --- if folding using treesitter then 'v:lua.vim.treesitter.foldexpr()'
vim.opt.fillchars = [[eob: ,fold: ,foldinner: ,foldopen:,foldsep: ,foldclose:]]

map("n", "J", "10gj")
map("n", "K", "10gk")
map("n", "H", "10h")
map("n", "L", "10l")
map("i", "jk", "<ESC>") --- disabled on visual mode since is slow
map("i", "kj", "<ESC>") --- disabled on visual mode since is slow
map("n", "Q", "<cmd>lua vim.cmd.quit()<cr>")
map("n", "R", "<cmd>lua LazyVim.format({force = true}) MiniTrailspace.trim() vim.cmd.write()<cr>")
map("x", "p", '"_c<c-r>+<esc>', { desc = "Paste (dot repeat)(register unchanged)" })
map({ "n", "x" }, "U", "@:", { desc = "repeat `:command`" }) --> :normal A,jkj --> :normal A,j --->  escape char by pression ctrl+v then escape
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, desc = "next completion when no lsp" })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, desc = "prev completion when no lsp" })
map("n", "<right>", "<cmd>bnext<CR>", { desc = "next buffer" })
map("n", "<left>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
map("n", "<leader>x", "<cmd>bp | bd! #<CR>", { desc = " buffer close" }) --- works before triggering whichkey
map("n", "<leader>gr", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gH')<cr>", { desc = " git-hunk reset" })
map("n", "<leader>gs", "<cmd>lua MiniDiff.textobject() vim.cmd.normal('gh')<cr>", { desc = " git-hunk stage" })
map("n", "<leader>n", function() require("mini.notify").show_history() end, { desc = "󰍩 notify history" })
map("n", "<leader>v", "<cmd>vsplit | terminal<cr>", { desc = " term horizontal" })
map("n", "<leader>V", "<cmd>split  | terminal<cr>", { desc = " term vertical" })
map("n", "<leader>t", "<cmd>term<cr>", { desc = " term tab" })
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "normal mode inside terminal" })
map({ "n", "t" }, "<C-\\>", function() Snacks.terminal() end, { desc = "󰨙  " }) --- vim.o.shell doesn't work on zsh.exe
map({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "left window or [W" })
map({ "n", "t" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "down window or ]W" })
map({ "n", "t" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "up window or [W" })
map({ "n", "t" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "right window or ]W" })
map({ 'i' }, '<a-l>', function() vim.lsp.inline_completion.get() end, { desc = ' accept suggestion' })
map({ 'i' }, '<a-[>', function() vim.lsp.inline_completion.select({ count = -1 }) end, { desc = ' prev suggestion' })
map({ 'i' }, '<a-]>', function() vim.lsp.inline_completion.select({ count = 1 }) end, { desc = ' next suggestion' })
map({ 'i', 'n', 'x' }, '<a-;>', function() require("sidekick").nes_jump_or_apply() end, { desc = ' nes apply' }) --- <m-;> doesn't work with pum
map({ 'i', 'n', 'x' }, '<a-,>', function() require("sidekick.nes").update() end, { desc = ' nes update' })
map({ 'i', 'n', 'x' }, "<a-'>", function() require("sidekick.nes").clear() end, { desc = ' nes clear' })
map({ 'i', 'n', 'x' }, '<leader>lg', "<cmd>Sidekick cli toggle name=opencode<cr>", { desc = '󰵰 opencode cli' })
map({ 'i', 'n', 'x' }, '<leader>lG', "<cmd>Sidekick cli prompt<cr>", { desc = '󰵰 opencode prompt' })
map("n", "<leader>e", function() Snacks.explorer({ layout = { layout = { width = 25 } } }) end, { desc = "Explorer" })
map(
  "n",
  "<leader>o",
  function() Snacks.explorer.open({ auto_close = true, layout = { preset = 'default', preview = true, } }) end,
  { desc = "󰙅 explorer/previewer" }
)
map(
  "x",
  "go",
  [[<cmd>let _=&commentstring | set commentstring={/*\ %s\ */} | normal gc<cr><cmd>let &commentstring=_<cr>]],
  { desc = "jsx comment" }
)
