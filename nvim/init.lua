-- ╭─────────╮
-- │ Plugins │
-- ╰─────────╯

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

local opts = {
  ui = { border = "rounded" },
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
    },
  },
}

local plugins = {

  -- Motions
  {
    'vscode-neovim/vscode-multi-cursor.nvim',
    commit = "ac2505395071a85fe7e051dfd624f933ea5a62ef",
    event = "VeryLazy",
    cond = not not vim.g.vscode,
    opts = {}
  },
  {
    "folke/flash.nvim",
    commit = "48817af25f51c0590653bbc290866e4890fe1cbe",
    event = "VeryLazy",
    opts = {},
  },
  { "RRethy/vim-illuminate",    commit = "a2907275a6899c570d16e95b9db5fd921c167502" },
  { "machakann/vim-columnmove", commit = "21a43d809a03ff9bf9946d983d17b3a316bf7a64", event = "VeryLazy" },

  -- Text-Objects
  { "echasnovski/mini.nvim",    commit = "e8a413b1a29f05bb556a804ebee990eb54479586" },
  {
    "coderifous/textobj-word-column.vim",  -- delimited by comments or indentation
    commit = "cb40e1459817a7fa23741ff6df05e4481bde5a33",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "c36681bb496ebce2946867459ed08774cb61788c",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", commit = "e69a504baf2951d52e1f1fbb05145d43f236cbf1" },
    }
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    commit = "c0aa3ff33eaf9e7bc827ea918f92ac47d6037118",
    config = { useDefaultKeymaps = false, lookForwardSmall = 30, lookForwardBig = 30 },
  },

  -- UI
  { 'olivercederborg/poimandres.nvim' },
  {
    "lewis6991/gitsigns.nvim",
    commit = "372d5cb485f2062ac74abc5b33054abac21d8b58",
    event = "VeryLazy",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "│" },
        topdelete    = { text = "" },
        changedelete = { text = "~" },
        untracked    = { text = '┆' },
      },
    }
  },
}

lazy.setup(plugins, opts)

-- ╭──────╮
-- │ Opts │
-- ╰──────╯

vim.opt.autoindent = true         -- auto indent new lines
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.copyindent = true         -- Copy the previous indentation on autoindenting
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.laststatus = 3            -- laststatus=3 global status line (line between splits)
vim.opt.number = true             -- set numbered lines
vim.opt.numberwidth = 4           -- set number column width to 2 {default 4}
vim.opt.preserveindent = true     -- Preserve indent structure as much as possible
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.showmode = false          -- we don't need to see things like -- INSERT -- anymore
vim.opt.smartcase = true          -- smart case
vim.opt.smartindent = true        -- make indenting smarter again
vim.opt.splitbelow = true         -- force all horizontal splits to go below current window
vim.opt.splitright = true         -- force all vertical splits to go to the right of current window
vim.opt.tabstop = 2               -- insert 2 spaces for a tab
vim.opt.termguicolors = true      -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 500          -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.wrap = false              -- display lines as one long line
vim.opt.shortmess:append "c"      -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"      -- hyphenated words recognized by searches
vim.g.indent_object_ignore_blank_line = false

-- ╭──────────────╮
-- │ Autocommands │
-- ╰──────────────╯

if not vim.g.vscode then
  require("poimandres").setup({ disable_background = true })
  vim.opt.scrolloff = 8       -- vertical scrolloff
  vim.opt.sidescrolloff = 8   -- horizontal scrolloff
  vim.opt.signcolumn = "yes"  -- always show the sign column, otherwise it would shift the text each time
  vim.opt.virtualedit = "all" -- allow cursor bypass end of line
  vim.cmd [[ au VimEnter * :TSEnable highlight" ]]
  vim.cmd [[ color poimandres ]]
  vim.api.nvim_set_hl(0, "Comment", { fg = "#444444", bg = "NONE" })
  vim.api.nvim_set_hl(0, "Visual", { fg = "NONE", bg = "#1c1c1c" })
end

------------------------------------------------------------------------------------------------------------------------

-- Illuminate disable underline
vim.cmd [[
  hi   def IlluminatedWordText               guifg=none     guibg=#080811  gui=none
  hi   def IlluminatedWordRead               guifg=none     guibg=#080811  gui=none
  hi   def IlluminatedWordWrite              guifg=none     guibg=#080811  gui=none
]]

------------------------------------------------------------------------------------------------------------------------

vim.cmd [[

  augroup _general_settings
    autocmd!
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufEnter * :set formatoptions-=cro
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup end

]]

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

_G.FeedKeysCorrectly = function(keys)
  local feedableKeys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(feedableKeys, "n", true)
end

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
_G.select_same_indent = function(skip_blank_line)
  local start_indent = vim.fn.indent(vim.fn.line('.'))

  function is_blank_line(line) return string.match(vim.fn.getline(line), '^%s*$') end

  if skip_blank_line then
    match_blank_line = function(line) return false end
  else
    match_blank_line = function(line) return is_blank_line(line) end
  end

  local prev_line = vim.fn.line('.') - 1
  while vim.fn.indent(prev_line) == start_indent or match_blank_line(prev_line) do
    vim.cmd('-')
    prev_line = vim.fn.line('.') - 1

    -- exit loop if there's no indentation
    if skip_blank_line then
      if vim.fn.indent(prev_line) == 0 and is_blank_line(prev_line) then
        break
      end
    else
      if vim.fn.indent(prev_line) < 0 then
        break
      end
    end
  end

  vim.cmd('normal! 0V')

  local next_line = vim.fn.line('.') + 1
  while vim.fn.indent(next_line) == start_indent or match_blank_line(next_line) do
    vim.cmd('+')
    next_line = vim.fn.line('.') + 1

    -- exit loop if there's no indentation
    if skip_blank_line then
      if vim.fn.indent(next_line) == 0 and is_blank_line(next_line) then
        break
      end
    else
      if vim.fn.indent(prev_line) < 0 then
        break
      end
    end
  end
end

------------------------------------------------------------------------------------------------------------------------

-- goto next/prev same/different level indent:
M.next_indent = function(next, level)
  local start_indent = vim.fn.indent(vim.fn.line('.'))
  local current_line = vim.fn.line('.')
  local next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
  local sign = next and '+' or '-'

  function is_blank_line(line) return string.match(vim.fn.getline(line), '^%s*$') end

  -- scroll no_blanklines (indent = 0) when going down
  if is_blank_line(current_line) == nil then
    if sign == '+' then
      while vim.fn.indent(next_line) == 0 and is_blank_line(next_line) == nil do
        vim.cmd('+')
        next_line = vim.fn.line('.') + 1
      end
    end
  end

  -- scroll same indentation (indent != 0)
  if start_indent ~= 0 then
    while vim.fn.indent(next_line) == start_indent do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  end

  if level == "same_level" then
    -- scroll differrent indentation (supports indent = 0, skip blacklines)
    while vim.fn.indent(next_line) ~= -1 and (vim.fn.indent(next_line) ~= start_indent or is_blank_line(next_line)) do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  else -- level == "different_level"
    -- scroll blanklines (indent = -1 is when line is 0 or line is last+1 )
    while vim.fn.indent(next_line) == 0 and is_blank_line(next_line) do
      vim.cmd(sign)
      next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
    end
  end

  -- scroll to next indentation
  vim.cmd(sign)

  -- scroll to top of indentation no_blanklines
  start_indent = vim.fn.indent(vim.fn.line('.'))
  next_line = next and (vim.fn.line('.') + 1) or (vim.fn.line('.') - 1)
  if sign == '-' then
    -- next_line indent is start_indent, next_line is no_blankline
    while vim.fn.indent(next_line) == start_indent and is_blank_line(next_line) == nil do
      vim.cmd('-')
      next_line = vim.fn.line('.') - 1
    end
  end
end

------------------------------------------------------------------------------------------------------------------------

-- ╭──────╮
-- │ Mini │
-- ╰──────╯

local mini_status_ok, mini_ai = pcall(require, 'mini.ai')
if not mini_status_ok then return end
local spec_treesitter = mini_ai.gen_spec.treesitter
local mini_clue = require("mini.clue")

require("mini.ai").setup({
  custom_textobjects = {
    B = spec_treesitter({ a = "@block.outer", i = "@block.inner" }),
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
    n = { '[-+]?()%f[%d]%d+()%.?%d*' },                                                                               -- number(inside string) textobj
    x = { '#()%x%x%x%x%x%x()' },                                                                                      -- hexadecimal textobj
    o = { "%S()%s+()%S" },                                                                                            -- whitespace textobj
    u = { { "%b''", '%b""', '%b``' }, '^.().*().$' },                                                                 -- quote textobj
  },
  user_textobject_id = true,
  mappings = {
    around = 'a',
    inside = 'i',
    around_next = 'aN',
    inside_next = 'iN',
    around_last = 'al',
    inside_last = 'il',
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 50,
  search_method = 'cover_or_next',
})

require('mini.align').setup()

require('mini.bracketed').setup({
  buffer     = { suffix = 'b', options = {} },
  comment    = { suffix = 'c', options = {} },
  conflict   = { suffix = 'x', options = {} },
  diagnostic = { suffix = 'd', options = {} },
  file       = { suffix = 'f', options = {} },
  indent     = { suffix = 'i', options = {} },
  jump       = { suffix = 'j', options = {} },
  location   = { suffix = 'l', options = {} },
  oldfile    = { suffix = 'o', options = {} },
  quickfix   = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo       = { suffix = 'u', options = {} },
  window     = { suffix = 'w', options = {} },
  yank       = { suffix = 'y', options = {} },
})

require('mini.comment').setup()

require('mini.indentscope').setup()

require('mini.operators').setup({
  evaluate = {
    prefix = '', -- 'g=',
    func = nil,
  },
  exchange = {
    prefix = 'gY',
    reindent_linewise = true,
  },
  multiply = {
    prefix = '', -- 'gm',
    func = nil,
  },
  replace = {
    prefix = 'gy',
    reindent_linewise = true,
  },
  sort = {
    prefix = 'gz',
    func = nil,
  }
})

require('mini.splitjoin').setup()

require('mini.surround').setup({
  custom_surroundings = nil,
  highlight_duration = 500,
  mappings = {
    add = 'gsa',            -- Add surrounding in Normal and Visual modes
    delete = 'gsd',         -- Delete surrounding
    find = 'gsf',           -- Find surrounding (to the right)
    find_left = 'gsF',      -- Find surrounding (to the left)
    highlight = 'gsh',      -- Highlight surrounding
    replace = 'gsr',        -- Replace surrounding
    update_n_lines = 'gsn', -- Update `n_lines`

    suffix_last = 'l',      -- Suffix to search with "prev" method
    suffix_next = 'N',      -- Suffix to search with "next" method
  },
  n_lines = 20,
  respect_selection_type = false,
  search_method = 'cover',
})

require('mini.trailspace').setup()

if not vim.g.vscode then
  require('mini.clue').setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.windows(),
      mini_clue.gen_clues.z(),
    },

    -- Clue window settings
    window = {
      -- Floating window config
      config = {},

      -- Delay before showing clue window
      delay = 1,

      -- Keys to scroll inside the clue window
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    }
  })

  require('mini.completion').setup()

  require('mini.extra').setup()

  require("mini.files").setup({
    content = {
      filter = nil,
      prefix = nil,
      sort = nil,
    },
    mappings = {
      close       = 'q',
      go_in       = 'l',
      go_in_plus  = 'L',
      go_out      = 'h',
      go_out_plus = 'H',
      reset       = '<BS>',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = '=',
      trim_left   = '<',
      trim_right  = '>',
    },
    options = {
      permanent_delete = true,
      use_as_default_explorer = true,
    },
    windows = {
      max_number = math.huge,
      preview = true,
      width_focus = 30,
      width_nofocus = 15,
      width_preview = 60,
    },
  })

  require('mini.pairs').setup()

  require('mini.pick').setup()

  require('mini.statusline').setup({
    content = {
      active = nil,
      inactive = nil,
    },
    use_icons = true,
    set_vim_settings = false,
  })

  require('mini.tabline').setup()
end

-- ╭────────────╮
-- │ Treesitter │
-- ╰────────────╯

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

configs.setup {
  ensure_installed = { "python", "bash", "javascript", "json", "html", "css", "c", "lua" },
  autopairs = {
    enable = false,
  },
  highlight = {     -- enable highlighting for all file types
    enable = false, -- you can also use a table with list of langs here (e.g. { "python", "javascript" })
    use_languagetree = false,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "python", "yaml" } },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_previous_start = {
        ['gpaB'] = '@block.outer',
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

        ['gpiB'] = '@block.inner',
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
        ['gnaB'] = '@block.outer',
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

        ['gniB'] = '@block.inner',
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
        ['gpeaB'] = '@block.outer',
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

        ['gpeiB'] = '@block.inner',
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
        ['gneaB'] = '@block.outer',
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

        ['gneiB'] = '@block.inner',
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
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['>,'] = '@parameter.inner',
      },
      swap_previous = {
        ['<,'] = '@parameter.inner',
      },
    },
  },
}

-- ╭────────────╮
-- │ Automation │
-- ╰────────────╯

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set

-- setting leaderkey
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick Escape
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Quick Jump
-- keymap("n", "j", "gj", opts) -- skips vscode folds but slows j press
-- keymap("n", "k", "gk", opts) -- skips vscode folds but slows k press
keymap("n", "J", "10gj", opts)
keymap("n", "K", "10gk", opts)
keymap("n", "H", "10h", opts)
keymap("n", "L", "10l", opts)
keymap("n", "<M-j>", "10gj", opts)
keymap("n", "<M-k>", "10gk", opts)
keymap("n", "<M-h>", "10h", opts)
keymap("n", "<M-l>", "10l", opts)
keymap("n", "<M-v>", "V", opts)

-- Forward yank/paste
keymap("n", "Y", "yg_", { noremap = true, silent = true, desc = "Yank forward" })  -- "Y" yank forward by default
keymap("v", "Y", "g_y", { noremap = true, silent = true, desc = "Yank forward" })
keymap("v", "P", "g_P", { noremap = true, silent = true, desc = "Paste forward" }) -- "P" doesn't change register

-- Unaltered clipboard
keymap("v", "p", '"_c<c-r>+<esc>', { noremap = true, silent = true, desc = "Paste (dot repeat)(register unchanged)" })

-- Quick quit/write
if not vim.g.vscode then
  keymap("n", "<S-q>", "<cmd>quit<CR>", opts)
  keymap("n", "<S-r>", "<cmd>write<cr>", opts)
else
  map("n", "<S-q>", function() require('vscode-neovim').call('workbench.action.closeActiveEditor') end, opts)
  map("n", "<S-r>", function()
    require('vscode-neovim').call('editor.action.format')
    require('vscode-neovim').call('workbench.action.files.save')
  end, opts)
end

-- Macros and :normal <keys> repeatable
keymap("n", "U", "@:", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigation
if not vim.g.vscode then
  keymap("n", "<M-Left>", ":vertical resize +2<cr>", { noremap = true, silent = true, desc = "Resize Left" })
  keymap("n", "<M-Down>", ":resize +2<cr>", { noremap = true, silent = true, desc = "Resize Down" })
  keymap("n", "<M-Up>", ":resize -2<cr>", { noremap = true, silent = true, desc = "Resize Up" })
  keymap("n", "<M-Right>", ":vertical resize -2<cr>", { noremap = true, silent = true, desc = "Resize Right" })
  keymap("n", "<C-h>", ":wincmd h<cr>", { noremap = true, silent = true, desc = "Window Left" })
  keymap("n", "<C-j>", ":wincmd j<cr>", { noremap = true, silent = true, desc = "Window Down" })
  keymap("n", "<C-k>", ":wincmd k<cr>", { noremap = true, silent = true, desc = "Window Up" })
  keymap("n", "<C-l>", ":wincmd l<cr>", { noremap = true, silent = true, desc = "Window Right" })
  keymap("n", "<Left>", ":bprevious<cr>", { noremap = true, silent = true, desc = "Buffer prev" })
  keymap("n", "<Right>", ":bnext<cr>", { noremap = true, silent = true, desc = "Buffer next" })
  keymap("n", "<leader>x", ":bdelete<cr>", { noremap = true, silent = true, desc = "Buffer delete" })
end

-- ╭────────────────╮
-- │ leader keymaps │
-- ╰────────────────╯

if not vim.g.vscode then
  -- Explorer
  keymap(
    "n",
    "<leader>o",
    ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0),true)<cr>",
    { noremap = true, silent = true, desc = "Open Explorer" }
  )

  -- Pick
  keymap(
    "n",
    "<leader>f/",
    ":Pick files<cr>",
    { noremap = true, silent = true, desc = "Pick Files (tab to preview)" }
  )
  keymap(
    "n",
    "<leader>fF",
    ":Pick grep_live<cr>",
    { noremap = true, silent = true, desc = "Pick Grep (tab to preview)" }
  )
  keymap(
    "n",
    "<leader>f'",
    ":Pick marks<cr>",
    { noremap = true, silent = true, desc = "Pick Marks (tab to preview)" }
  )
  keymap(
    "n",
    "<leader>fR",
    ":Pick registers<cr>",
    { noremap = true, silent = true, desc = "Pick register" }
  )

  -- Toggle
  keymap("n", "<leader>u0", ":set showtabline=0<cr>", { noremap = true, silent = true, desc = "Buffer Hide" })
  keymap("n", "<leader>u2", ":set showtabline=2<cr>", { noremap = true, silent = true, desc = "Buffer Show" })
  keymap("n", "<leader>us", ":set laststatus=0<cr>", { noremap = true, silent = true, desc = "StatusBar Hide" })
  keymap("n", "<leader>uS", ":set laststatus=3<cr>", { noremap = true, silent = true, desc = "StatusBar Show" })
end

-- Highlight Search:
map("n", "<esc>", "<esc><cmd>noh<cr>", { desc = "NoHighlight" })
map("n", "<leader>uh", function() M.EnableAutoNoHighlightSearch() end, { desc = "Enable AutoNoHighlightSearch" })
map("n", "<leader>uH", function() M.DisableAutoNoHighlightSearch() end, { desc = "Disable AutoNoHighlightSearch" })

-- Parent Indent:
map(
  "n",
  "<leader>uu",
  function()
    require("vscode-neovim").action("editor.gotoParentFold")
    require("vscode-neovim").action("cursorHome")
  end,
  { desc = "goto parent fold (vscode only)" }
)

-- Paste After/Before from secondary clipboard
keymap("n", "<leader><leader>p", '"*p', { desc = "Paste after (second_clip)" })
keymap("n", "<leader><leader>P", '"*P', { desc = "Paste before (second_clip)" })

-- Visual Paste/ForwardPaste from secondary clipboard
keymap("x", "<leader><leader>p", '"*p', { noremap = true, silent = true, desc = "Paste (second_clip)" })           -- "Paste after (second_clip)"
keymap("x", "<leader><leader>P", 'g_"*P', { noremap = true, silent = true, desc = "Paste forward (second_clip)" }) -- only works in visual mode

-- Yank/ForwardYank to secondary clipboard
keymap("n", "<leader><leader>y", '"*y', { desc = "Yank (second_clip)" })
keymap("n", "<leader><leader>Y", '"*yg_', { desc = "Yank forward (second_clip)" })

-- Visual Yank/Append to secondary clipboard
keymap("x", "<leader><leader>y", '"*y', { noremap = true, silent = true, desc = "Yank (second_clip)" })
keymap("x", "<leader><leader>Y", 'g_"*y', { noremap = true, silent = true, desc = "Yank forward (second_clip)" })

-- ╭─────────╮
-- │ Motions │
-- ╰─────────╯

-- Navigate code with search labels:
map(
  { "n", "x", "o" },
  "s",
  function() require("flash").jump() end,
  { silent = true, desc = "Flash" }
)
map(
  { "n", "x", "o" },
  "S",
  function() require("flash").treesitter() end,
  { silent = true, desc = "Flash Treesitter" }
)
map(
  { "n", "x", "o" },
  "<cr>",
  function() require("flash").jump({ continue = true }) end,
  { silent = true, desc = "Continue Last Flash search" }
)
map(
  { "x", "o" },
  "R",
  function() require("flash").treesitter_search() end,
  { silent = true, desc = "Treesitter Flash Search" }
)
map(
  { "c" },
  "<c-s>",
  function() require("flash").toggle() end,
  { desc = "Toggle Flash Search" }
)

map(
  { "n", "x" },
  "g<",
  function() return GotoTextObj("`<", "`<v`'", "`<V`'", "`<\22`'") end,
  { expr = true, silent = true, desc = "StartOf TextObj" }
)

map(
  { "n", "x" },
  "g>",
  function() return GotoTextObj("`>", "`'v`>", "`'V`>", "`'\22`>") end,
  { expr = true, silent = true, desc = "EndOf TextObj" }
)

-- goto changes:
map({ "n", "o", "x" }, "g.", "`.", { silent = true, desc = "go to last change" })
keymap("n", "g,", "g,", { noremap = true, silent = true, desc = "go forward in :changes" })  -- Formatting will lose track of changes
keymap("n", "g;", "g;", { noremap = true, silent = true, desc = "go backward in :changes" }) -- Formatting will lose track of changes

-- Multi Cursors:
map('n', 'gb', 'mciw*<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor (select and find)" })
map('n', 'gB', 'mcgfn<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor (find selected)" })
map('n', 'go', 'mciwj<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor down" })
map('n', 'gO', 'mciwk<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor up" })
map('x', 'gb', 'mc*<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor (select and find)" })
map('x', 'gB', 'mc*<cmd>nohl<cr>', { remap = true, desc = "add virtual cursor (find selected)" })
map('x', 'go', 'omcj<cmd>nohl<cr>', { remap = true, desc = "visual selected to virtual cursor (ctrl+left=prevword)" })
map('x', 'gO', 'omck<cmd>nohl<cr>', { remap = true, desc = "visual selected to virtual cursor (ctrl+right=nextword)" })

-- paste LastSearch Register:
keymap("n", "gH", '"/p', { silent = true, desc = "paste lastSearch register" })

-- Redo Register:
keymap("n", "gr", '"1p', { silent = true, desc = "Redo register (dot to Paste forward the rest of register)" })
keymap("n", "gR", '"1P', { silent = true, desc = "Redo register (dot to Paste backward the rest of register)" })

-- Word-Column textobj
map(
  { "n", "x" },
  "gW",
  function()
    vim.cmd([[ execute "normal \<c-v>\<Plug>(columnmove-E)" ]])
    local mode = vim.api.nvim_get_mode().mode
    require('vscode-multi-cursor').start_left { no_selection = mode == '\x16' }
    require('vscode-neovim').action("cursorWordEndRightSelect")
  end,
  { silent = true, desc = "word-column multicursor" }
)

-- Blackhole register:
map({ "n", "x" }, "gx", '"_d', { silent = true, desc = "Blackhole Motion/Selected" })
map({ "n", "x" }, "gX", '"_D', { silent = true, desc = "Blackhole Linewise" })

-- Visual increment/decrement numbers:
map("n", "g<Up>", "<c-a>", { noremap = true, silent = true, desc = "numbers ascending" })
map("n", "g<Down>", "<c-x>", { noremap = true, silent = true, desc = "numbers descending" })
map("x", "g<Up>", "g<c-a>", { noremap = true, silent = true, desc = "numbers ascending" })
map("x", "g<Down>", "g<c-x>", { noremap = true, silent = true, desc = "numbers descending" })
map({ "n", "x" }, "g+", "<C-a>", { noremap = true, silent = true, desc = "Increment number (dot to repeat)" })
map({ "n", "x" }, "g-", "<C-x>", { noremap = true, silent = true, desc = "Decrement number (dot to repeat)" })

-- ╭───────────────────────────────────────╮
-- │ Text Objects with "g" (dot to repeat) │
-- ╰───────────────────────────────────────╯

-- braces linewise textobj:
map("x", "g{", "aB$o0", { silent = true, desc = "braces linewise textobj" })
map("o", "g{", "<cmd>normal! vaB$o0<cr>", { silent = true, desc = "braces linewise textobj" })
map("x", "g}", "aB$o0", { silent = true, desc = "braces linewise textobj" })
map("o", "g}", "<cmd>normal! vaB$o0<cr>", { silent = true, desc = "braces linewise textobj" })

-- _mini_comment_(not_showing_desc)_(next/prev_autojump_unsupported)
map(
  { "o" },
  "gc",
  "<cmd>lua require('various-textobjs').multiCommentedLines()<cr>",
  { silent = true, desc = "BlockComment textobj" }
)
map(
  { "n" },
  "vgc",
  "<cmd>lua require('various-textobjs').multiCommentedLines()<cr>",
  { silent = true, desc = "BlockComment textobj" }
)
map(
  { "x" },
  "gC",
  '<cmd>lua require("mini.comment").textobject()<cr>',
  { silent = true, desc = "RestOfComment textobj" }
)
map(
  { "o" },
  "gC",
  ":<c-u>normal vgC<cr>",
  { silent = true, desc = "RestOfComment textobj" }
)

-- _find_textobj_(dot-repeat_supported)
map({ "o", "x" }, "gf", "gn", { noremap = true, silent = true, desc = "Next find textobj" })
map({ "o", "x" }, "gF", "gN", { noremap = true, silent = true, desc = "Prev find textobj" })

-- reference textobj:
map(
  { "n", "x", "o" },
  "gI",
  '<cmd>lua require"illuminate".textobj_select()<cr>',
  { silent = true, desc = "select reference" }
)

-- _git_hunk_(next/prev_autojump_unsupported)
map({ "o", "x" }, "gh", ":<C-U>Gitsigns select_hunk<CR>", { silent = true, desc = "Git hunk textobj" })

-- https://www.reddit.com/r/vim/comments/xnuaxs/last_change_text_object
map("o", "gm", "<cmd>normal! `[v`]<cr>", { silent = true, desc = "Last change textobj" })
map("x", "gm", "`[o`]", { silent = true, desc = "Last change textobj" })

-- _nvim_various_textobjs
map(
  { "o", "x" },
  "gd",
  "<cmd>lua require('various-textobjs').diagnostic()<cr>",
  { silent = true, desc = "Diagnostic textobj" }
)
map(
  { "o", "x" },
  "gK",
  "<cmd>lua require('various-textobjs').column()<cr>",
  { silent = true, desc = "ColumnDown textobj" }
)
map(
  { "o", "x" },
  "gL",
  "<cmd>lua require('various-textobjs').url()<cr>",
  { silent = true, desc = "Url textobj" }
)
map(
  { "o", "x" },
  "gr",
  "<cmd>lua require('various-textobjs').restOfWindow()<CR>",
  { silent = true, desc = "RestOfWindow textobj" }
)
map(
  { "o", "x" },
  "gR",
  "<cmd>lua require('various-textobjs').visibleInWindow()<CR>",
  { silent = true, desc = "VisibleWindow textobj" }
)
map(
  { "o", "x" },
  "gt",
  "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>",
  { silent = true, desc = "toNextQuotationMark textobj" }
)
map(
  { "o", "x" },
  "gT",
  "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>",
  { silent = true, desc = "toNextClosingBracket textobj" }
)

-- ╭───────────────────────────────────────╮
-- │ Text Objects with a/i (dot to repeat) │
-- ╰───────────────────────────────────────╯

-- _nvim_various_textobjs: inner-outer
map(
  { "o", "x" },
  "ad",
  "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>",
  { silent = true, desc = "outer greddyOuterIndent textobj" }
)
map(
  { "o", "x" },
  "id",
  "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>",
  { silent = true, desc = "inner greddyOuterIndent textobj" }
)
map(
  { "o", "x" },
  "ie",
  "<cmd>lua require('various-textobjs').nearEoL()<cr>",
  { silent = true, desc = "nearEndOfLine textobj" }
)
map(
  { "o", "x" },
  "ae",
  "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",
  { silent = true, desc = "lineCharacterwise textobj" }
)
map(
  { "o", "x" },
  "aj",
  "<cmd>lua require('various-textobjs').cssSelector('outer')<CR>",
  { silent = true, desc = "outer cssSelector textobj" }
)
map(
  { "o", "x" },
  "ij",
  "<cmd>lua require('various-textobjs').cssSelector('inner')<CR>",
  { silent = true, desc = "inner cssSelector textobj" }
)
map(
  { "o", "x" },
  "am",
  "<cmd>lua require('various-textobjs').chainMember('outer')<CR>",
  { silent = true, desc = "outer chainMember textobj" }
)
map(
  { "o", "x" },
  "im",
  "<cmd>lua require('various-textobjs').chainMember('inner')<CR>",
  { silent = true, desc = "inner chainMember textobj" }
)
map(
  { "o", "x" },
  "aM",
  "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<cr>",
  { silent = true, desc = "outer mdFencedCodeBlock textobj" }
)
map(
  { "o", "x" },
  "iM",
  "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<cr>",
  { silent = true, desc = "inner mdFencedCodeBlock textobj" }
)
map(
  { "o", "x" },
  "ir",
  "<cmd>lua require('various-textobjs').restOfParagraph()<cr>",
  { silent = true, desc = "RestOfParagraph textobj" }
)
map(
  { "o", "x" },
  "ar",
  "<cmd>lua require('various-textobjs').restOfIndentation()<cr>",
  { silent = true, desc = "restOfIndentation textobj" }
)
map(
  { "o", "x" },
  "aS",
  "<cmd>lua require('various-textobjs').subword('outer')<cr>",
  { silent = true, desc = "outer Subword textobj" }
)
map(
  { "o", "x" },
  "iS",
  "<cmd>lua require('various-textobjs').subword('inner')<cr>",
  { silent = true, desc = "inner Subword textobj" }
)
map(
  { "o", "x" },
  "aU",
  "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<cr>",
  { silent = true, desc = "inner pyTrippleQuotes textobj" }
)
map(
  { "o", "x" },
  "iU",
  "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<cr>",
  { silent = true, desc = "inner pyTrippleQuotes textobj" }
)
map(
  { "o", "x" },
  "aZ",
  "<cmd>lua require('various-textobjs').closedFold('outer')<CR>",
  { silent = true, desc = "outer ClosedFold textobj" }
)
map(
  { "o", "x" },
  "iZ",
  "<cmd>lua require('various-textobjs').closedFold('inner')<CR>",
  { silent = true, desc = "inner ClosedFold textobj" }
)

-- _fold_textobj
-- https://superuser.com/questions/578432/can-vim-treat-a-folded-section-as-a-motion
map("x", "iz", ":<C-U>silent!normal![zjV]zk<CR>", { silent = true, desc = "inner fold textobj" })
map("o", "iz", ":normal Viz<CR>", { silent = true, desc = "inner fold textobj" })
map("x", "az", ":<C-U>silent!normal![zV]z<CR>", { silent = true, desc = "outer fold textobj" })
map("o", "az", ":normal Vaz<CR>", { silent = true, desc = "outer fold textobj" })

-- _vim_indent_object_(incrementalrepressing_+_visualrepeatable_+_vimrepeat_+_respectingblanklines_+_norespectslastblanklines(selectblanklines is vip))
map(
  { "o", "x" },
  "ii",
  '<cmd>lua require("various-textobjs").indentation("inner", "inner", "noBlanks")<cr>',
  { desc = "inner noblanks indentation textobj" }
)
map(
  { "o", "x" },
  "ai",
  '<cmd>lua require("various-textobjs").indentation("outer", "outer", "noBlanks")<cr>',
  { desc = "outer noblanks indentation textobj" }
)
map(
  { "o", "x" },
  "iI",
  '<cmd>lua require("various-textobjs").indentation("inner", "inner")<cr>',
  { desc = "inner indentation textobj" }
)
map(
  { "o", "x" },
  "aI",
  '<cmd>lua require("various-textobjs").indentation("outer", "outer")<cr>',
  { desc = "outer indentation textobj" }
)

-- indent same level textobj:
map(
  { "x", "o" },
  "iy",
  ":<c-u> lua select_same_indent(true)<cr>",
  { silent = true, desc = "same_indent skip_blankline textobj" }
)
map(
  { "x", "o" },
  "ay",
  ":<c-u> lua select_same_indent(false)<cr>",
  { silent = true, desc = "same_indent with_blankline textobj" }
)

-- ╭──────────────────────────────────────────╮
-- │ Repeatable Pair - motions using <leader> │
-- ╰──────────────────────────────────────────╯

-- _nvim-treesitter-textobjs_repeatable
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { silent = true, desc = "Next TS textobj" })
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { silent = true, desc = "Prev TS textobj" })

-- _columnmove_repeatable
vim.g.columnmove_strict_wbege = 0 -- skips inner-paragraph whitespaces for wbege
vim.g.columnmove_no_default_key_mappings = true
map({ "n", "x", "o" }, "<leader><leader>f", "<Plug>(columnmove-f)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>t", "<Plug>(columnmove-t)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>F", "<Plug>(columnmove-F)", { silent = true })
map({ "n", "x", "o" }, "<leader><leader>T", "<Plug>(columnmove-T)", { silent = true })

local next_columnmove, prev_columnmove = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-;)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-,)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>;", next_columnmove, { silent = true, desc = "Next ColumnMove_;" })
map({ "n", "x", "o" }, "<leader><leader>,", prev_columnmove, { silent = true, desc = "Prev ColumnMove_," })

-- _jump_indent_repeatable_with_blankline
local next_indent_wb, prev_indent_wb = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viiV$" ]]) end,
  function() vim.cmd([[ execute "normal viio\<esc>_" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>a", next_indent_wb, { silent = true, desc = "End Indent with_blankline" })
map({ "n", "x", "o" }, "<leader><leader>i", prev_indent_wb, { silent = true, desc = "Start Indent with_blankline" })

-- _jump_indent_repeatable_skip_blankline
local next_indent_sb, prev_indent_sb = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viIV$" ]]) end,
  function() vim.cmd([[ execute "normal viIo\<esc>_" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>A", next_indent_sb, { silent = true, desc = "End Indent skip_blankline" })
map({ "n", "x", "o" }, "<leader><leader>I", prev_indent_sb, { silent = true, desc = "Start Indent skip_blankline" })

local next_columnmove_w, prev_columnmove_b = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-w)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-b)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>w", next_columnmove_w, { silent = true, desc = "Next ColumnMove_w" })
map({ "n", "x", "o" }, "<leader><leader>b", prev_columnmove_b, { silent = true, desc = "Prev ColumnMove_b" })

local next_columnmove_e, prev_columnmove_ge = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-e)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-ge)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>e", next_columnmove_e, { silent = true, desc = "Next ColumnMove_e" })
map({ "n", "x", "o" }, "<leader><leader>ge", prev_columnmove_ge, { silent = true, desc = "Prev ColumnMove_ge" })

local next_columnmove_W, prev_columnmove_B = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-W)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-B)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>W", next_columnmove_W, { silent = true, desc = "Next ColumnMove_W" })
map({ "n", "x", "o" }, "<leader><leader>B", prev_columnmove_B, { silent = true, desc = "Prev ColumnMove_B" })

local next_columnmove_E, prev_columnmove_gE = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-E)" ]]) end,
  function() vim.cmd([[ execute "normal \<Plug>(columnmove-gE)" ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>E", next_columnmove_E, { silent = true, desc = "Next ColumnMove_E" })
map({ "n", "x", "o" }, "<leader><leader>gE", prev_columnmove_gE, { silent = true, desc = "Prev ColumnMove_gE" })

-- _jump_blankline_repeatable
local next_blankline, prev_blankline = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal } ]]) end,
  function() vim.cmd([[ normal { ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>}", next_blankline, { silent = true, desc = "Next Blankline" })
map({ "n", "x", "o" }, "<leader><leader>{", prev_blankline, { silent = true, desc = "Prev Blankline" })

-- _jump_paragraph_repeatable
local next_paragraph, prev_paragraph = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal )) ]]) end,
  function() vim.cmd([[ normal (( ]]) end)
map({ "n", "x", "o" }, "<leader><leader>)", next_paragraph, { silent = true, desc = "Next Paragraph" })
map({ "n", "x", "o" }, "<leader><leader>(", prev_paragraph, { silent = true, desc = "Prev Paragraph" })

-- _jump_edgefold_repeatable
local next_fold, prev_fold = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal ]z ]]) end,
  function() vim.cmd([[ normal [z ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>]", next_fold, { silent = true, desc = "End Fold" })
map({ "n", "x", "o" }, "<leader><leader>[", prev_fold, { silent = true, desc = "Start Fold" })

-- _jump_startofline_repeatable
local next_startline, prev_startline = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ normal + ]]) end,
  function() vim.cmd([[ normal - ]]) end
)
map({ "n", "x", "o" }, "<leader><leader>+", next_startline, { silent = true, desc = "next startline" })
map({ "n", "x", "o" }, "<leader><leader>-", prev_startline, { silent = true, desc = "Prev StartLine" })

-- ╭──────────────────────────────────────────────────╮
-- │ Repeatable Pair - textobj navigation using gn/gp │
-- ╰──────────────────────────────────────────────────╯

-- _comment_(goto_repeatable)
local next_comment, prev_comment = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.bracketed").comment("forward") end,
  function() require("mini.bracketed").comment("backward") end
)
map({ "n", "x", "o" }, "gnc", next_comment, { silent = true, desc = "Next Comment" })
map({ "n", "x", "o" }, "gpc", prev_comment, { silent = true, desc = "Prev Comment" })

-- _goto_diagnostic_repeatable
local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(
  function() require("vscode-neovim").call("editor.action.marker.next") end,
  function() require("vscode-neovim").call("editor.action.marker.prev") end
)
map({ "n", "x", "o" }, "gnd", next_diagnostic, { silent = true, desc = "Next Diagnostic (vscode only)" })
map({ "n", "x", "o" }, "gpd", prev_diagnostic, { silent = true, desc = "Prev Diagnostic (vscode only)" })

-- _gitsigns_chunck_repeatable
local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(
  function() require("vscode-neovim").call("workbench.action.editor.nextChange") end,
  function() require("vscode-neovim").call("workbench.action.editor.previousChange") end
)
map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { desc = "Next GitHunk (vscode only)" })
map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { desc = "Prev GitHunk (vscode only)" })
map({ "n", "x", "o" }, "gnH", next_hunk_repeat, { desc = "Next GitHunk (vscode only)" })
map({ "n", "x", "o" }, "gpH", prev_hunk_repeat, { desc = "Prev GitHunk (vscode only)" })

if not vim.g.vscode then
  local gs = require("gitsigns")
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  map({ "n", "x", "o" }, "gnh", next_hunk_repeat, { silent = true, desc = "Next GitHunk" })
  map({ "n", "x", "o" }, "gph", prev_hunk_repeat, { silent = true, desc = "Prev GitHunk" })
  map({ "n", "x", "o" }, "<leader>gp", function() gs.preview_hunk() end, { silent = true, desc = "Preview GitHunk" })
  map({ "n", "x", "o" }, "<leader>gr", function() gs.reset_hunk() end, { silent = true, desc = "Reset GitHunk" })
end

-- _references_repeatable
local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
  function() require("illuminate").goto_next_reference(wrap) end,
  function() require("illuminate").goto_prev_reference(wrap) end
)
map({ "n", "x", "o" }, "gnr", next_reference, { silent = true, desc = "Next Reference" })
map({ "n", "x", "o" }, "gpr", prev_reference, { silent = true, desc = "Prev Reference" })

-- _goto_function_definition_repeatable
local next_inner_funccall, prev_inner_funccall = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal viNf" ]]) end,
  function() vim.cmd([[ execute "normal vilf" ]]) end)
map({ "n", "x", "o" }, "gnif", next_inner_funccall, { silent = true, desc = "Next inner function call" })
map({ "n", "x", "o" }, "gpif", prev_inner_funccall, { silent = true, desc = "Prev inner function call" })

-- _goto_function_definition_repeatable
local next_funcdefinition, prev_funcdefinition = ts_repeat_move.make_repeatable_move_pair(
  function() vim.cmd([[ execute "normal vaNf" ]]) end,
  function() vim.cmd([[ execute "normal valf" ]]) end)
map({ "n", "x", "o" }, "gnaf", next_funcdefinition, { silent = true, desc = "Next around function call" })
map({ "n", "x", "o" }, "gpaf", prev_funcdefinition, { silent = true, desc = "Prev around function call" })

-- _html_atribute_textobj_(goto_repeatable)
local next_inner_htmlatrib, prev_inner_htmlatrib = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnih", next_inner_htmlatrib, { silent = true, desc = "Next Inner Html Atrib" })
map({ "n", "x", "o" }, "gpih", prev_inner_htmlatrib, { silent = true, desc = "Prev Inner Html Atrib" })

local next_around_htmlatrib, prev_around_htmlatrib = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "h", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnah", next_around_htmlatrib, { silent = true, desc = "Next Around Html Atrib" })
map({ "n", "x", "o" }, "gpah", prev_around_htmlatrib, { silent = true, desc = "Prev Around Html Atrib" })

-- _goto_indent_different_level_skip_blankline_repeatable
local next_different_indent, prev_different_indent = ts_repeat_move.make_repeatable_move_pair(
  function() M.next_indent(true, "different_level") end,
  function() M.next_indent(false, "different_level") end
)
map({ "n", "x", "o" }, "gnii", next_different_indent, { silent = true, desc = "next different_indent" })
map({ "n", "x", "o" }, "gpii", prev_different_indent, { silent = true, desc = "prev different_indent" })

-- _key_textobj_(goto_repeatable)
local next_inner_key, prev_inner_key = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "k", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "k", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnik", next_inner_key, { silent = true, desc = "Next Inner Key" })
map({ "n", "x", "o" }, "gpik", prev_inner_key, { silent = true, desc = "Prev Inner Key" })

local next_around_key, prev_around_key = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "k", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "k", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnak", next_around_key, { silent = true, desc = "Next Around Key" })
map({ "n", "x", "o" }, "gpak", prev_around_key, { silent = true, desc = "Prev Around Key" })

-- hexadecimalcolor_textobj_(goto_repeatable)
local next_inner_numeral, prev_inner_numeral = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "n", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "n", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnin", next_inner_numeral, { silent = true, desc = "Next Inner Number" })
map({ "n", "x", "o" }, "gpin", prev_inner_numeral, { silent = true, desc = "Prev Inner Number" })

local next_around_numeral, prev_around_numeral = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "n", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "n", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnan", next_around_numeral, { silent = true, desc = "Next Around Number" })
map({ "n", "x", "o" }, "gpan", prev_around_numeral, { silent = true, desc = "Prev Around Number" })

-- _goto_quotes_repeatable
local next_inner_quote, prev_inner_quote = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gniu", next_inner_quote, { silent = true, desc = "Next Inner Quote" })
map({ "n", "x", "o" }, "gpiu", prev_inner_quote, { silent = true, desc = "Prev Inner Quote" })

local next_around_quote, prev_around_quote = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "u", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnau", next_around_quote, { silent = true, desc = "Next Around Quote" })
map({ "n", "x", "o" }, "gpau", prev_around_quote, { silent = true, desc = "Prev Around Quote" })

-- _value_textobj_(goto_repeatable)
local next_inner_value, prev_inner_value = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "v", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "v", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gniv", next_inner_value, { silent = true, desc = "Next Inner Value" })
map({ "n", "x", "o" }, "gpiv", prev_inner_value, { silent = true, desc = "Prev Inner Value" })

local next_around_value, prev_around_value = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "v", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "v", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnav", next_around_value, { silent = true, desc = "Next Around Value" })
map({ "n", "x", "o" }, "gnav", prev_around_value, { silent = true, desc = "Prev Around Value" })

-- _number_textobj_(goto_repeatable)
local next_inner_hex, prev_inner_hex = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "i", "x", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "i", "x", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnix", next_inner_hex, { silent = true, desc = "Next Inner Hex" })
map({ "n", "x", "o" }, "gpix", prev_inner_hex, { silent = true, desc = "Prev Inner Hex" })

local next_around_hex, prev_around_hex = ts_repeat_move.make_repeatable_move_pair(
  function() require("mini.ai").move_cursor("left", "a", "x", { search_method = "next" }) end,
  function() require("mini.ai").move_cursor("left", "a", "x", { search_method = "prev" }) end
)
map({ "n", "x", "o" }, "gnax", next_around_hex, { silent = true, desc = "Next Around Hex" })
map({ "n", "x", "o" }, "gpax", prev_around_hex, { silent = true, desc = "Prev Around Hex" })

-- _goto_indent_same_level_skip_blankline_repeatable
local next_same_indent, prev_same_indent = ts_repeat_move.make_repeatable_move_pair(
  function() M.next_indent(true, "same_level") end,
  function() M.next_indent(false, "same_level") end
)
map({ "n", "x", "o" }, "gniy", next_same_indent, { silent = true, desc = "next same_indent" })
map({ "n", "x", "o" }, "gpiy", prev_same_indent, { silent = true, desc = "prev same_indent" })

-- ╭─────────────╮
-- │ Lsp keymaps │
-- ╰─────────────╯

-- map("n", "ga", function() require('vscode-neovim').call("editor.action.autoFix") end, opts)
-- map("n", "gA", function() require('vscode-neovim').call("editor.action.refactor") end, opts)
-- map("n", "gc", function() require('vscode-neovim').call("references-view.showCallHierarchy") end, opts)
-- map("n", "gd", function() require('vscode-neovim').call("editor.action.revealDefinition") end, opts)
-- map("n", "gD", function() require('vscode-neovim').call("editor.action.revealDeclaration") end, opts)
-- map("n", "gF", function() require('vscode-neovim').call("editor.action.format") end, opts)
-- map("n", "gh", function() require('vscode-neovim').call("editor.action.showHover")             vim.call("repeat#set", "gh") end, opts)
-- map("n", "gH", function() require('vscode-neovim').call("editor.action.triggerParameterHints") vim.call("repeat#set", "gH") end, opts)
-- map("n", "gI", function() require('vscode-neovim').call("editor.action.goToImplementation") end, opts)
-- map("n", "gl", function() require('vscode-neovim').call("workbench.action.navigateToLastEditLocation") end,opts)
-- map("n", "gnd", function() require('vscode-neovim').call("editor.action.marker.next")          vim.call("repeat#set", "gnd") end, opts)
-- map("n", "gnD", function() require('vscode-neovim').call("editor.action.marker.nextInFiles")   vim.call("repeat#set", "gnD") end, opts)
-- map("n", "go", function() require('vscode-neovim').call("editor.action.marker.next")           vim.call("repeat#set", "go")  end, opts)
-- map("n", "gpd", function() require('vscode-neovim').call("editor.action.marker.prev")          vim.call("repeat#set", "gpd") end, opts)
-- map("n", "gpD", function() require('vscode-neovim').call("editor.action.marker.prevInFiles")   vim.call("repeat#set", "gpD") end, opts)
-- map("n", "gq", function() require('vscode-neovim').call("workbench.actions.view.problems") end, opts)
-- map("n", "gQ", function() require('vscode-neovim').call("editor.action.quickFix") end, opts)
-- map("n", "gr", function() require('vscode-neovim').call("editor.action.goToReferences") end, opts)
-- map("n", "gR", function() require('vscode-neovim').call("editor.action.rename") end, opts)
-- map("n", "gs", function() require('vscode-neovim').call("workbench.action.gotoSymbol") end, opts)
-- map("n", "gS", function() require('vscode-neovim').call("workbench.action.showAllSymbols") end, opts)
-- map("n", "gt", function() require('vscode-neovim').call("editor.action.goToTypeDefinition") end, opts)
-- map("n", "gv", function() require('vscode-neovim').call("workbench.actions.view.problems") end, opts)
-- map("n", "gV", function() require('vscode-neovim').call("references-view.find") end, opts)
-- map("n", "gw", function() require('vscode-neovim').call("references-view.findImplementations") end, opts)
-- map("n", "gW", function() require('vscode-neovim').call("editor.action.revealDefinitionAside") end, opts)
-- map("n", "gz", function() require('vscode-neovim').call("outline.focus")                       vim.call("repeat#set", "gz") end, opts)
-- map("n", "g\\", function() require('vscode-neovim').call("editor.action.formatDocument") end, opts)
-- map("n", "g<", function() require('vscode-neovim').call("editor.action.wordHighlight.prev") end, opts)
-- map("n", "g>", function() require('vscode-neovim').call("editor.action.wordHighlight.next") end, opts)
