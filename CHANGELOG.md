## [0.2.0](https://github.com/YeferYV/RetroNvim/compare/v0.1.1...v0.2.0) (2025-01-05)


### Features

* **kanata:** repeat hjkl every 15 miliseconds ([f6d077e](https://github.com/YeferYV/RetroNvim/commit/f6d077ec9b52320618a22c81079e353bcfe2b16d))
* **nvim:** adding mini.hipatterns with tailwind support ([18a843c](https://github.com/YeferYV/RetroNvim/commit/18a843c7395e031ae14d4addb076b85a69efe3e4))
* **nvim:** configuring mason.nvim + nvim-lspconfig to stop depending on mason-lspconfig.nvim ([c418220](https://github.com/YeferYV/RetroNvim/commit/c41822039a2fabbdd93c17e7440271054ea60f60))
* **nvim:** migrating to efm-language-server (which support formatters and linters) from none-ls ([e6f6b8b](https://github.com/YeferYV/RetroNvim/commit/e6f6b8b5191d9bb9514ce5d19f8b9af84f1bc18c))
* **nvim:** migrating to supermaven since codeium is slow ([7d6a6ce](https://github.com/YeferYV/RetroNvim/commit/7d6a6cea019ff7cfe2c025d410a39c1e63027a57))
* **nvim:** migrating to vim.snippets from luasnip ([50b6715](https://github.com/YeferYV/RetroNvim/commit/50b6715793cdceb77ba7a665a671a52fd5e8c566))
* **package.json:** migrating to pnpm since npm is slow ([7ed02bb](https://github.com/YeferYV/RetroNvim/commit/7ed02bb11368d830b058bc68be1191bd473e5971))
* **release.yml:** adding a github action to publish to vscode marketplace ([246c811](https://github.com/YeferYV/RetroNvim/commit/246c811208cfeef9ec6acc6d86028526d179a1d8))
* **whichkey:** adding `Install jupyter and kaggle` entry ([8617a59](https://github.com/YeferYV/RetroNvim/commit/8617a594c8dd600bb95ac4decb19bae06c81254f))


### Bug Fixes

* **release.yml:** attemp using vsce as devDependency to fix `The user aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa is not authorized` ([ab2979d](https://github.com/YeferYV/RetroNvim/commit/ab2979d7154c8fa2b2e3cc349a6d944a910edc82))
* **release.yml:** VSCE_TOKEN secret as global env should fix `The user aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa is not authorized` ([1bdd8ae](https://github.com/YeferYV/RetroNvim/commit/1bdd8aebee88dec5a53e2e82d4a1f9578315cd1e))

## [0.2.2](https://github.com/YeferYV/RetroNvim/compare/v0.2.1...v0.2.2) (2025-01-30)


### Bug Fixes

* **nvim:** mini.snippets now can read vscode snippet extensions automatically ([9bfee36](https://github.com/YeferYV/RetroNvim/commit/9bfee36f79a34e58b83d12217c42a64377da2c6f))
* **nvim:** Windows needs a autocmd to LspStart ([5904712](https://github.com/YeferYV/RetroNvim/commit/590471210ccd670962db8b0e49e7e10fff3f6f51))
* **whichkey:** bat requires less to scroll (when opening inside yazi on Windows) ([8cbf92c](https://github.com/YeferYV/RetroNvim/commit/8cbf92cfcbe478031a5421fa62de736a13025dbe))
* **whichkey:** Install Retronvim's nvim/yazi/zsh on any terminal ([1278a0e](https://github.com/YeferYV/RetroNvim/commit/1278a0e8d1ce8d5e5c40f606e7a8bb2cf528fc5c))
* **yazi:** if RETRONVIM_INIT not defined use `~/.config/nvim/init.lua` and `~/appdata/local/nvim/init.lua` as fallback ([1d0699a](https://github.com/YeferYV/RetroNvim/commit/1d0699a37b19b65e33b7acb8c042d6b06922a959))
* **yazi:** open msys2's zsh ([a77eebd](https://github.com/YeferYV/RetroNvim/commit/a77eebd65c670c4c2c85094ff09cd9cd53d4ff83))
* **yazi:** using mime-ext.yazi (which works in powershell) plugin falling back to file1 ([a3e9542](https://github.com/YeferYV/RetroNvim/commit/a3e95428a6d93e6f24a730b4026498bb6e9aabd8))
* **zsh:** `nvim --clean` doesn't remember last cursor position ([f85087a](https://github.com/YeferYV/RetroNvim/commit/f85087a4075f6a265c0c638deb402dc473225bef))

## [0.2.1](https://github.com/YeferYV/RetroNvim/compare/v0.2.0...v0.2.1) (2025-01-21)


### Bug Fixes

* **keybinding.json:** suggest widget blocks inline completion ([ec2424a](https://github.com/YeferYV/RetroNvim/commit/ec2424a3ff0ab86cf75412c3fefcb5486801de8a))
* **keybindings.json:** `suggestWidgetMultipleSuggestions` unneeded for `enter` nor `tab` nor `ctrl+j` nor `ctrl+k` ([ec3e3ba](https://github.com/YeferYV/RetroNvim/commit/ec3e3bad6e3864e0544af2babe358c24c0a51ce4))
* **keybindings.json:** disable &lt;tab&gt; inline completion which blocks <tab> snippet mode ([7593fda](https://github.com/YeferYV/RetroNvim/commit/7593fdaaa81c625fc950d29979ad79f26b20d37b))
* **keybindings.json:** map `tab` to `selectNextSuggestion` and `shift+tab` to `selectPrevSuggestion` ([115e253](https://github.com/YeferYV/RetroNvim/commit/115e253792ca640af6bcab278a41216159ec0b87))
* **nvim:** `attempt to index field 'snippets' (a nil value)` it was a typo ([4fea54a](https://github.com/YeferYV/RetroNvim/commit/4fea54a8e5b08b7561afa17e19f7a04c2f9be706))
* **nvim:** migrating to snacks.picker (which supports preview) from mini.pick + new plugin nvim-tree ([5eda6e9](https://github.com/YeferYV/RetroNvim/commit/5eda6e904a1a63d1e0e66ce155ead99637bb66b5))
* **nvim:** vscode `undo` snippets conflicts with MiniBracketed.undo() ([c260f34](https://github.com/YeferYV/RetroNvim/commit/c260f340996a931511d316107791a34f867ce0bf))
* **settings.json:** `formulahendry.auto-rename-tag` supports vscode-neovim "editor.linkedEditing" doesn't ([e741b34](https://github.com/YeferYV/RetroNvim/commit/e741b34ab0bcdadfbbe7dc54e403fe085a394c54))
* **settings.json:** now tailwind suggestions appears when writing emmet snippets ([4bd51b2](https://github.com/YeferYV/RetroNvim/commit/4bd51b21bc3556e9457715baa56c8aa173991048))
* **whichkey:** missing "workbench.action.terminal.sendsequence" for "install pixi and pnpm" ([1951852](https://github.com/YeferYV/RetroNvim/commit/1951852603a166331c308f0bd9457f3cbe43ba33))
* **yazi:** `yy` needs a `tty` + new command `Ripgrep fzf` ([5efea42](https://github.com/YeferYV/RetroNvim/commit/5efea42724296bd1795a588f6f708ee36ae83a86))
* **yazi:** fzf match color highlight-reverse ([8748bd1](https://github.com/YeferYV/RetroNvim/commit/8748bd181f0253785304145c8c9363ad2e6ad3d2))

## v0.1.1 (06-09-2024)

**Added**

- `bookmars.yazi` and `smart-enter.yazi` plugins
- yazi new shell commands
- `touchcursor` layout new keys: `pageup`, `home`, `end`, `pagedown`, `¿`, `left-wheel` and `right-wheel`

**Changed**

- yazi keymaps: `f` to `F` and `s` to `sD`
- `touchcursor` layout fast `hjkl`/arrow keys
- `start touchcursor` now also start the `en-US` keyboard layout on Windows

**Fixed**

- yazi now has large image preview

## v0.1.0 (28-08-2024)

**Added**

- neovim LSP / Formatter / Linter / Snippet support
- open neovim terminal
- neovim's extension and zsh's extensions as git-submodules

**Changed**

- migration to more `mini.nvim` modules
- removed `vscode-multi-cursor.nvim` and `textobj-word-column.vim`
- replacing `vim-columnmove` extension and `next_indent` with builtin `ColumnMove`
- replacing `install sixelrice` with `install archrice's neovim`
- refactored keymaps

**Fixed**

- `h`, `j`, `k` and `l` mapped to vscode's arrow keys on Windows 10/11 since it's slow in old machines
- Windows requires compiling treesitter parsers with Zig otherwise it crashes when opening neovim in the terminal

## v0.0.4 (07-06-2024)

**Added**

- javascript extension pack + node version manager whichkey menu entry installer
- python extension pack + python package manager whichkey menu entry installer
- `Msys2's zsh` support on Windows 10/11
- `$ZDOTDIR` to auto load minimal RetroNvim's .zshrc
- `$STARSHIP_CONFIG` to auto load a custom starship.toml
- `tokyo night dark` / `poimandres` custom theme

**Changed**

- dropping bash/git-bash support since `ble.sh` is slow
- RetroNvim now is shipped with `zsh-autosuggestions`, `zsh-fast-syntax-highlighting` and `fzf-key-bindings.zsh` plugins

**Fixed**

- increase keyboard repeat rate on Windows 10/11 is a powershell script
- map `jk` as escape key on `settings.json` instead of `keybindings.json`
- unmmapping `h`, `j`, `k` and `l` to vscode's arrows keys since conflicts with `flash.nvim` on Windows 10/11

## v0.0.3 (04-04-2024)

**Added**

- whichkey entries to show keybindings for yazi and lazygit
- `gitsigns.nvim` to preview/reset hunk (only inside neovim)
- keymaps `gpH` and `gnH` which works in windows10
- docs for keymaps of `zsh`/`bash`/`git-bash` setup (also shown in the demo.mp4)

**Changed**

- remap `gh` to `gH`
- remap `gl` to `g.`

**Fixed**

- keymaps using `R` and `Q`
- workaround for `gh` when visual-mode inside vscode (but race condition may happen)

## v0.0.2 (16-02-2024)

**Changed**

- remapping `hjkl` as cursor left/down/up/down on Windows10 for performance but doesn't restore vertical cursor position
- migrating to `git-bash` since `powershell` is too slow

**Added**

- kanata open with vscode or `$EDITOR` inside yazi

## v0.0.1 (12-02-2024)

**Added**

- Neovim A-Z text objects
- Whichkey with LSP,git,... entries
- Kanata with touchcursor-like keyboard layout
