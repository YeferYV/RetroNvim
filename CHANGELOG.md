## [0.3.3](https://github.com/YeferYV/RetroNvim/compare/v0.3.2...v0.3.3) (2025-07-03)


### Bug Fixes

* **ci:** PKG_CONFIG_PATH and PKG_CONFIG_LIBDIR for ripdrag build ([f7cb9a4](https://github.com/YeferYV/RetroNvim/commit/f7cb9a4220095bae2d84bae6ee97608d99b44e03))
* **wezterm:** auto load retronvim's profile.ps1 ([525404e](https://github.com/YeferYV/RetroNvim/commit/525404e8691c353cd66f4bf32ed0a13d6c09c5a2))

## [0.3.4](https://github.com/YeferYV/RetroNvim/compare/v0.3.3...v0.3.4) (2025-07-11)


### Bug Fixes

* **extension.js:** uncompress environment.sh if there is no pixi in PATH ([2b945e8](https://github.com/YeferYV/RetroNvim/commit/2b945e8aab9f2a50cc984e31affc2241b74901dc))
* **kanata:** short scroll doesn't scroll wezterm ([acf7a09](https://github.com/YeferYV/RetroNvim/commit/acf7a09918badab47b9136712b3876ad7153d5bb))
* **yazi:** run detached mpv ([c2072ca](https://github.com/YeferYV/RetroNvim/commit/c2072cac6f059db52fcf939eb1b22cb9d31ddffc))

## [0.3.1](https://github.com/YeferYV/RetroNvim/compare/v0.3.0...v0.3.1) (2025-07-01)


### Bug Fixes

* **extension.js:** symlink to `~/.vscode/extensions/yefery.retronvim` no longer required ([94ea1c3](https://github.com/YeferYV/RetroNvim/commit/94ea1c3bc964c4649f7bcdc459c15e9db0df2860))
* **nvim:** `vim.loop.fs_realpath` doesn't work with `~/.pixi/envs/neovim-lsp/bin/<symlink>` on windows ([c4e5030](https://github.com/YeferYV/RetroNvim/commit/c4e5030f22ae4d45e44c458f43aaf98e31fc5e81))
* **nvim:** clangd and rust-analyzer installer + detect docker-compose.yaml filetype ([d6c7db5](https://github.com/YeferYV/RetroNvim/commit/d6c7db52867a4a433832c1fc2ebceff1eb90390f))
* **nvim:** node based language servers inside lib/node_modules installed using pixi doesn't work on windows with the error  `...\bin\node` command not found ([1ab1c1d](https://github.com/YeferYV/RetroNvim/commit/1ab1c1d4257547e7566733a57d405b2e0e1bda14))
* **nvim:** pnpm packages on Windows 11 requires `.cmd` + zsh.exe doesn't support `:!pixi ...` + jdtls support ([13f0c33](https://github.com/YeferYV/RetroNvim/commit/13f0c335fea07a2cf7784afeaee446072858bec4))
* **nvim:** using OmniSharp instead of csharp-ls ([5be433c](https://github.com/YeferYV/RetroNvim/commit/5be433c0858244695b7f4145d45fb1cc71d62ba7))
* **nvim:** using schemas instead of lsp for yaml and json files ([907e7da](https://github.com/YeferYV/RetroNvim/commit/907e7dab421a87d136b6b29c14f512f28496e575))
* **nvim:** volar and astro requires typescript ([dfff7bf](https://github.com/YeferYV/RetroNvim/commit/dfff7bf86bdb74250b1882ac8dd148b3a1780bed))
* **nvim:** yaml.github filetype (for gh_action_ls to work) and yaml.gitlab filetype (for gitlab_ci_ls) ([9b65e4f](https://github.com/YeferYV/RetroNvim/commit/9b65e4fb77410f016514e07498f63840be46e1b9))
* **yazi:** drag file from vscode and drop it to the browser ([b31b089](https://github.com/YeferYV/RetroNvim/commit/b31b089def851116037b14349d410e8b4461747f))

## [0.3.0](https://github.com/YeferYV/RetroNvim/compare/v0.2.4...v0.3.0) (2025-05-08)


### Features

* **nvim:** big_preview layout for snacks.explorer + mini.completion now support vscode snippets ([7d84929](https://github.com/YeferYV/RetroNvim/commit/7d84929641ea73a551b3c8ddaca7e458407d8cd9))
* **nvim:** intelephense installer for php's lsp ([326e432](https://github.com/YeferYV/RetroNvim/commit/326e432b37b2e637857f8841a1e0bb1282b48732))
* **nvim:** migrating to bat's base16 theme from tokyonight ([d3e7641](https://github.com/YeferYV/RetroNvim/commit/d3e7641c43043d22682b27379bb401b222ab1c82))
* **nvim:** mini.completion now supports lsp snippets but still not MiniSnippets.mock_lsp_server ([b4d0319](https://github.com/YeferYV/RetroNvim/commit/b4d0319df537b1f66048b9fd404faf63210af99d))
* **package.json:** bat's base16 theme ([3746495](https://github.com/YeferYV/RetroNvim/commit/374649535064bc6b72836d8126445e82716ab2a5))
* **package.json:** migrating to vscodevim since neovim someday will crash as always (vim.lsp.completion.enable() stops being compatible with mini.completion) ([3b127f8](https://github.com/YeferYV/RetroNvim/commit/3b127f8038826dbbf5ffe40c3725996c00d60920))
* **whichkey:** FigmaToCode and AutoHTML installer link + open flowbite.com and chatgpt.com ([aad684d](https://github.com/YeferYV/RetroNvim/commit/aad684dd8cf11919cd0295730ef2ccff72cb9208))
* **yazi:** Platform-Specific Key Binding ([145a1e6](https://github.com/YeferYV/RetroNvim/commit/145a1e603b10f650cfe5143bde71fa9a38a3de23))


### Bug Fixes

* **nvim:** pyright requires a empty lsp setting ([fcb124d](https://github.com/YeferYV/RetroNvim/commit/fcb124d85815ab85a59bdfbf5fa02d8608a49cc1))

## [0.2.4](https://github.com/YeferYV/RetroNvim/compare/v0.2.3...v0.2.4) (2025-02-19)


### Bug Fixes

* **nvim:** new minimal Lsp Installer since `:Mason` has no configured lsp ([0703563](https://github.com/YeferYV/RetroNvim/commit/07035637034b6a3dd8a250f4d8fb597236728226))
* **nvim:** rewriting a minimal flash.nvim since plugins tends to change (gets broken) ([9f70a5c](https://github.com/YeferYV/RetroNvim/commit/9f70a5cd7d3dea675d34fd260887c14c687fd5d6))
* **nvim:** vim.fn.sign_define() will be deprecated in neovim v0.12 ([05b2c5e](https://github.com/YeferYV/RetroNvim/commit/05b2c5ecc1f4c21bfb917a25f4acb036f1cc868d))

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
