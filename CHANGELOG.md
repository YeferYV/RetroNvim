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
