## [0.4.6](https://github.com/YeferYV/RetroNvim/compare/v0.4.5...v0.4.6) (2026-06-11)


### Bug Fixes

* **appman.yaml:** linux appimage installer ([e5a1a37](https://github.com/YeferYV/RetroNvim/commit/e5a1a37d515dacb2a34a4be2e0f7823286ef31d3))
* **extension.js:** autoinstall conditionally retronvim.conda and firacode.conda ([aed8b09](https://github.com/YeferYV/RetroNvim/commit/aed8b0935042cfbc2a2912d6dad932fe3d48233f))
* **mingit.yaml:** using mingit since lazygit doesn't support msys2's git which uses unix paths ([98a98e2](https://github.com/YeferYV/RetroNvim/commit/98a98e2657fef42b48718233040ab8fcbddedfb5))
* **nvim:** migrating to lazyvim ([455ade2](https://github.com/YeferYV/RetroNvim/commit/455ade2663651e05846e70ab836f75bfd0adb422))
* **release.yaml:** adding conda releases ([62cc12c](https://github.com/YeferYV/RetroNvim/commit/62cc12caf7b45b69a2409530f2328180b8112913))
* **release.yaml:** missing git-submodules ([ddb7487](https://github.com/YeferYV/RetroNvim/commit/ddb74872e917047c6e5ae12fb201628d564f33b5))
* **retronvim.yaml:** missing terax desktop icon ([c6ee096](https://github.com/YeferYV/RetroNvim/commit/c6ee096f5e74cb3f189a518d19a931b6f40b4409))
* **terax.yaml:** migrating to terax removing wezterm ([abe4c5f](https://github.com/YeferYV/RetroNvim/commit/abe4c5f1a838c975a625f27c5b8d3ba667cc0a26))
* **zsh:** getting multiples ~/.cache/zcompdump.some-id + hide suggestion after pressing tab ([8cad67f](https://github.com/YeferYV/RetroNvim/commit/8cad67f2d5f59a17fa5d87cec381cf2074e89c3a))
* **zsh:** OSC 11 and DECRQM sequences leaks on yazi inside terax workaround ([b87df6d](https://github.com/YeferYV/RetroNvim/commit/b87df6d2f0042d5c7c2c5009e9002803582d8d2a))

## [0.3.1](https://github.com/YeferYV/RetroNvim/compare/v0.4.6...v0.3.1) (2026-06-11)


### Features

* **assets:** adding demo + zsh/bash/git-bash keymaps info ([32aa40b](https://github.com/YeferYV/RetroNvim/commit/32aa40b046744ce68104a3a5f2421997579c1b34))
* **extension.js:** adding "vscode-neovim.neovimExecutablePath" for Windows and MacOS ([7ebc856](https://github.com/YeferYV/RetroNvim/commit/7ebc8567733788abeb90e810eb48643296167b3e))
* **kanata,package.json:** open with vscode, wrap and markdown preview whichkey entry ([9ff1bd5](https://github.com/YeferYV/RetroNvim/commit/9ff1bd50373e8e4f6eb74949657b465cf136a1a0))
* **kanata:** fast hjkl repeat rate ([2247495](https://github.com/YeferYV/RetroNvim/commit/22474953936115645f0c266fbae1842bd7d96670))
* **kanata:** Lalt+space =&gt; Lshift+space and Rshift+space =&gt; Ralt+space ([9994c07](https://github.com/YeferYV/RetroNvim/commit/9994c07a484d00ca6c7c00d9c8db78a56e7232b4))
* **kanata:** new keys `pageup`, `home`, `end`, `pagedown`, `¿`, left-wheel and right-wheel ([b1e98a1](https://github.com/YeferYV/RetroNvim/commit/b1e98a135999d6643219f90508eb6f9225c6002d))
* **kanata:** repeat hjkl every 15 miliseconds ([f6d077e](https://github.com/YeferYV/RetroNvim/commit/f6d077ec9b52320618a22c81079e353bcfe2b16d))
* **nvim,package.json,kanata:** Neovim A-Z text objects + LSP whichkey + touchcursor keyboard layout ([966fd90](https://github.com/YeferYV/RetroNvim/commit/966fd90f7f05ebd422fd23a470dd635b821489dd))
* **nvim:** adding ColumnMove, removing next_indent ([6fad5bb](https://github.com/YeferYV/RetroNvim/commit/6fad5bb412243378aecebb7e189313ee285e88a5))
* **nvim:** adding mini.hipatterns with tailwind support ([18a843c](https://github.com/YeferYV/RetroNvim/commit/18a843c7395e031ae14d4addb076b85a69efe3e4))
* **nvim:** adding plugins as git-submodules ([781b707](https://github.com/YeferYV/RetroNvim/commit/781b707b0c0f6451f2ab7f7a30755540148864b5))
* **nvim:** big_preview layout for snacks.explorer + mini.completion now support vscode snippets ([7d84929](https://github.com/YeferYV/RetroNvim/commit/7d84929641ea73a551b3c8ddaca7e458407d8cd9))
* **nvim:** configuring mason.nvim + nvim-lspconfig to stop depending on mason-lspconfig.nvim ([c418220](https://github.com/YeferYV/RetroNvim/commit/c41822039a2fabbdd93c17e7440271054ea60f60))
* **nvim:** extensions now lives inside ~/.vscode/extensions/yeferyv.retronvim-0.0.4 ([e18c553](https://github.com/YeferYV/RetroNvim/commit/e18c55328e72b7695c0a9e68679ec1d2b663ab15))
* **nvim:** gitsigns.nvim to preview/reset hunk (only inside neovim) ([1045194](https://github.com/YeferYV/RetroNvim/commit/1045194cc7351d8b7e3fdf0e7be3159e043317be))
* **nvim:** intelephense installer for php's lsp ([326e432](https://github.com/YeferYV/RetroNvim/commit/326e432b37b2e637857f8841a1e0bb1282b48732))
* **nvim:** mason/terminal support + _hightlight_whitespaces + mini.cursorword migration ([f4e70bb](https://github.com/YeferYV/RetroNvim/commit/f4e70bbcbcd6168cee7c81b64ffcc12693fd5258))
* **nvim:** migrating to bat's base16 theme from tokyonight ([d3e7641](https://github.com/YeferYV/RetroNvim/commit/d3e7641c43043d22682b27379bb401b222ab1c82))
* **nvim:** migrating to efm-language-server (which support formatters and linters) from none-ls ([e6f6b8b](https://github.com/YeferYV/RetroNvim/commit/e6f6b8b5191d9bb9514ce5d19f8b9af84f1bc18c))
* **nvim:** migrating to mini.deps ([ebf3937](https://github.com/YeferYV/RetroNvim/commit/ebf393701f6584f4a4fc28534ba8fb37772dc037))
* **nvim:** migrating to supermaven since codeium is slow ([7d6a6ce](https://github.com/YeferYV/RetroNvim/commit/7d6a6cea019ff7cfe2c025d410a39c1e63027a57))
* **nvim:** migrating to vim.snippets from luasnip ([50b6715](https://github.com/YeferYV/RetroNvim/commit/50b6715793cdceb77ba7a665a671a52fd5e8c566))
* **nvim:** mini.completion now supports lsp snippets but still not MiniSnippets.mock_lsp_server ([b4d0319](https://github.com/YeferYV/RetroNvim/commit/b4d0319df537b1f66048b9fd404faf63210af99d))
* **nvim:** poimandres colorscheme generated by mini.base16 ([5b28853](https://github.com/YeferYV/RetroNvim/commit/5b288534d1d7d5b9568c561de1c601bf6210ce50))
* **nvim:** snippet support for mini.completion ([78d6a48](https://github.com/YeferYV/RetroNvim/commit/78d6a487860fd3d2ffddbac40296541b36c3efcf))
* **nvim:** ToggleTerminal support ([7b6fe2b](https://github.com/YeferYV/RetroNvim/commit/7b6fe2b154bffa9ac6c3448608b35e5df32870f3))
* **nvim:** vscode_select_git_hunk() workaround but race condition may happen ([e11c41f](https://github.com/YeferYV/RetroNvim/commit/e11c41f785e1e5a6c02ffbbdf5bab03b951fe29b))
* **package.json,extesion.js:** adding $RETRONVIM_PATH/bin to $PATH ([74d2bb2](https://github.com/YeferYV/RetroNvim/commit/74d2bb26a98bc6a4141cf09b523bd2e6aba2d6b7))
* **package.json:** bat's base16 theme ([3746495](https://github.com/YeferYV/RetroNvim/commit/374649535064bc6b72836d8126445e82716ab2a5))
* **package.json:** map jk to vscode-neovim escape + custom tokyonight/poimandres theme ([02146ef](https://github.com/YeferYV/RetroNvim/commit/02146ef5e766412767d795effcf9fde1e277e643))
* **package.json:** migrating to pnpm since npm is slow ([7ed02bb](https://github.com/YeferYV/RetroNvim/commit/7ed02bb11368d830b058bc68be1191bd473e5971))
* **package.json:** migrating to vscodevim since neovim someday will crash as always (vim.lsp.completion.enable() stops being compatible with mini.completion) ([3b127f8](https://github.com/YeferYV/RetroNvim/commit/3b127f8038826dbbf5ffe40c3725996c00d60920))
* **package.json:** remapping hjkl as cursor left/down/up/right on windows ([4e47f7f](https://github.com/YeferYV/RetroNvim/commit/4e47f7f5df1fdda388180f03414d2b624fad10e2))
* **package.json:** whichkey entries to show keybindings of yazi and lazygit ([7bd2d7e](https://github.com/YeferYV/RetroNvim/commit/7bd2d7ec27ceff1add5a301b3cf6dca7ecd8b474))
* **README.md:** adding README of text objects + touchcursor-like keyboard layout ([8531de6](https://github.com/YeferYV/RetroNvim/commit/8531de6749bc317535c41cb0760062aa0e0695bf))
* **release.yaml:** support for open-vsx.org, windsurf and cursor ([53dde0a](https://github.com/YeferYV/RetroNvim/commit/53dde0a96b7b9d5052978506257c276fa9c03500))
* **release.yml:** adding a github action to publish to vscode marketplace ([246c811](https://github.com/YeferYV/RetroNvim/commit/246c811208cfeef9ec6acc6d86028526d179a1d8))
* **whichkey.bindings:** adding Javascript/Python extensions pack installer ([81af956](https://github.com/YeferYV/RetroNvim/commit/81af95692f94b83eeb541c80b61c34c9837f3134))
* **whichkey.bindings:** adding open neovim terminal ([ba098dc](https://github.com/YeferYV/RetroNvim/commit/ba098dcbf3b70b3adcfbdda394bc201f646d55d5))
* **whichkey.bindings:** separating 'start touchcursor keyboard' for windows and unix ([a39a1ca](https://github.com/YeferYV/RetroNvim/commit/a39a1caa1711ff14c1327142cfe2a455d24f0282))
* **whichkey.bindings:** start kanata with US keyboard layout on Windows ([ce21b31](https://github.com/YeferYV/RetroNvim/commit/ce21b311d3c37cca4e2c37232eb374e93af79ff6))
* **whichkey:** adding `Install jupyter and kaggle` entry ([8617a59](https://github.com/YeferYV/RetroNvim/commit/8617a594c8dd600bb95ac4decb19bae06c81254f))
* **whichkey:** FigmaToCode and AutoHTML installer link + open flowbite.com and chatgpt.com ([aad684d](https://github.com/YeferYV/RetroNvim/commit/aad684dd8cf11919cd0295730ef2ccff72cb9208))
* **yazi:** bookmarks.yazi, smart-enter.yazi and new shell commands ([7425b76](https://github.com/YeferYV/RetroNvim/commit/7425b76d6b7d5ee0d954d5c4923a60c5950bda3a))
* **yazi:** Platform-Specific Key Binding ([145a1e6](https://github.com/YeferYV/RetroNvim/commit/145a1e603b10f650cfe5143bde71fa9a38a3de23))
* **zsh:** adding plugins as git-submodules ([688c7b5](https://github.com/YeferYV/RetroNvim/commit/688c7b585835490e0ea133b56fce0f70fb47fb6d))


### Bug Fixes

* **appman.yaml:** linux appimage installer ([e5a1a37](https://github.com/YeferYV/RetroNvim/commit/e5a1a37d515dacb2a34a4be2e0f7823286ef31d3))
* **ci:** PKG_CONFIG_PATH and PKG_CONFIG_LIBDIR for ripdrag build ([f7cb9a4](https://github.com/YeferYV/RetroNvim/commit/f7cb9a4220095bae2d84bae6ee97608d99b44e03))
* compositeEscape entries are no longer necessary ([#1](https://github.com/YeferYV/RetroNvim/issues/1)) ([332e014](https://github.com/YeferYV/RetroNvim/commit/332e0144fe96216f3d44a330b9707319a7cf8c70))
* **extension.js:** autoinstall conditionally retronvim.conda and firacode.conda ([aed8b09](https://github.com/YeferYV/RetroNvim/commit/aed8b0935042cfbc2a2912d6dad932fe3d48233f))
* **extension.js:** create symlink from ~/.vscode/extensions/yeferyv.retronvim-0.1.0-win32-x64 ([d1f8059](https://github.com/YeferYV/RetroNvim/commit/d1f80591f4743ff406af51b7b5ccdac62218ac39))
* **extension.js:** faster way to open yazi ([da27ca6](https://github.com/YeferYV/RetroNvim/commit/da27ca6853ad8c22baee7a212dfb0fb9a0d34523))
* **extension.js:** include java framework configs and extensions ([cb7576f](https://github.com/YeferYV/RetroNvim/commit/cb7576fc43fd247405720ddbbb4c35dcee1d07d3))
* **extension.js:** lazygit requires git ([92d15ae](https://github.com/YeferYV/RetroNvim/commit/92d15ae6549761df3f0911281e0842961edccbff))
* **extension.js:** symlink to `~/.vscode/extensions/yefery.retronvim` no longer required ([94ea1c3](https://github.com/YeferYV/RetroNvim/commit/94ea1c3bc964c4649f7bcdc459c15e9db0df2860))
* **extension.js:** uncompress environment.sh if there is no pixi in PATH ([2b945e8](https://github.com/YeferYV/RetroNvim/commit/2b945e8aab9f2a50cc984e31affc2241b74901dc))
* **extension.js:** vscode's marketplace support for windsurf ([bb79613](https://github.com/YeferYV/RetroNvim/commit/bb79613aa17f9c19d2b8bbcbafa0c0d72f013a99))
* **kanata:** multi f24 not required in v1.11.0 ([5d39e1a](https://github.com/YeferYV/RetroNvim/commit/5d39e1aca1c68be3f5cbac50d61835fe75a22c40))
* **kanata:** short scroll doesn't scroll wezterm ([acf7a09](https://github.com/YeferYV/RetroNvim/commit/acf7a09918badab47b9136712b3876ad7153d5bb))
* **kanata:** wrong `_` position ([f5d2065](https://github.com/YeferYV/RetroNvim/commit/f5d2065b107e765a08e95b57931f3697078d47f7))
* **keybinding.json:** `!inputFocus` doesn't trigger search key `/` ([7edfe73](https://github.com/YeferYV/RetroNvim/commit/7edfe730adf3b88562dddf8c32ea77772643d04c))
* **keybinding.json:** suggest widget blocks inline completion ([ec2424a](https://github.com/YeferYV/RetroNvim/commit/ec2424a3ff0ab86cf75412c3fefcb5486801de8a))
* **keybindings.json:** `alt+l` windsurf supercomplete and `alt+p`/`alt+n` prev/next snippet stop ([6cc3dae](https://github.com/YeferYV/RetroNvim/commit/6cc3dae84660bf1250a40d309e056d3cc998c4a7))
* **keybindings.json:** `ctrl+f` searches file inside explorer since `/` doesn't work on cvim ([2120dff](https://github.com/YeferYV/RetroNvim/commit/2120dffbbdae2cc6e38e07649f011995ade5f15d))
* **keybindings.json:** `suggestWidgetMultipleSuggestions` unneeded for `enter` nor `tab` nor `ctrl+j` nor `ctrl+k` ([ec3e3ba](https://github.com/YeferYV/RetroNvim/commit/ec3e3bad6e3864e0544af2babe358c24c0a51ce4))
* **keybindings.json:** disable &lt;tab&gt; inline completion which blocks &lt;tab&gt; snippet mode ([7593fda](https://github.com/YeferYV/RetroNvim/commit/7593fdaaa81c625fc950d29979ad79f26b20d37b))
* **keybindings.json:** map `tab` to `selectNextSuggestion` and `shift+tab` to `selectPrevSuggestion` ([115e253](https://github.com/YeferYV/RetroNvim/commit/115e253792ca640af6bcab278a41216159ec0b87))
* **mingit.yaml:** using mingit since lazygit doesn't support msys2's git which uses unix paths ([98a98e2](https://github.com/YeferYV/RetroNvim/commit/98a98e2657fef42b48718233040ab8fcbddedfb5))
* **nvim:** `@github/copilot-language-server` location path has changed and also works on windows ([78fdbc3](https://github.com/YeferYV/RetroNvim/commit/78fdbc3a2daf3aa7f192c19588d641e5cebd0872))
* **nvim:** `<cmd>` is `{ silent = true}` (`:` is not) to prevent confirmation on small screen ([e307cee](https://github.com/YeferYV/RetroNvim/commit/e307ceea6227668d18c6cdd73abd352572191d0e))
* **nvim:** `attempt to index field 'snippets' (a nil value)` it was a typo ([4fea54a](https://github.com/YeferYV/RetroNvim/commit/4fea54a8e5b08b7561afa17e19f7a04c2f9be706))
* **nvim:** `jk` on visual mode is slow ([7d3a181](https://github.com/YeferYV/RetroNvim/commit/7d3a18143a82f0ae00816540da175a0bcb9a96dc))
* **nvim:** `mini.snippets` searches for cursor/vscode/windsurf extension snippets alphabetically ([599b362](https://github.com/YeferYV/RetroNvim/commit/599b3620cf8b0a1d173bd2ecd4fde3a52f67e292))
* **nvim:** `preview git hunk` deleted hunk takes out one line + terminal keymaps ([29a8e0a](https://github.com/YeferYV/RetroNvim/commit/29a8e0a70b0ab761a1df8ac52e93f547c26f52af))
* **nvim:** `preview git hunk` search and jump to hunk ([60de283](https://github.com/YeferYV/RetroNvim/commit/60de2836a9f4658038b210c3b1aae53299aaadc5))
* **nvim:** `preview git hunk` with `[directory]` now works ([ec679bb](https://github.com/YeferYV/RetroNvim/commit/ec679bbf08928e490aba0b296f9a37fb7adccefa))
* **nvim:** `v:lua.vim.treesitter.foldexpr()` stops working on new opened buffers ([17b4006](https://github.com/YeferYV/RetroNvim/commit/17b40063823e3265208da221877d7d0c48d0538e))
* **nvim:** `vim.loop.fs_realpath` doesn't work with `~/.pixi/envs/neovim-lsp/bin/<symlink>` on windows ([c4e5030](https://github.com/YeferYV/RetroNvim/commit/c4e5030f22ae4d45e44c458f43aaf98e31fc5e81))
* **nvim:** `windsurf.nvim` alternative to supermaven since the service will be sunset + `Amp` extension keymaps for vscode ([cef8012](https://github.com/YeferYV/RetroNvim/commit/cef8012df095a3064f2bd96eaff14a5155afc63c))
* **nvim:** $APPDIR2 when init.lua is inside two nvim.appimage ([ad33fc4](https://github.com/YeferYV/RetroNvim/commit/ad33fc46617d2b7b142bcd384b0155172990e0b8))
* **nvim:** clangd and rust-analyzer installer + detect docker-compose.yaml filetype ([d6c7db5](https://github.com/YeferYV/RetroNvim/commit/d6c7db52867a4a433832c1fc2ebceff1eb90390f))
* **nvim:** comment out jsx keybinding ([fcf68d4](https://github.com/YeferYV/RetroNvim/commit/fcf68d42c5d3e82b0c5ae158305f6948569ee0a0))
* **nvim:** consolelog.nvim freezes mini.starter ([95092fc](https://github.com/YeferYV/RetroNvim/commit/95092fcace59aade80610183d59c14a20c792dcd))
* **nvim:** copilot NES support added since supermaven doesn't support NES ([d58e9a1](https://github.com/YeferYV/RetroNvim/commit/d58e9a17189a57f00eac8712a3cf7b21a22ba07c))
* **nvim:** copilot-lsp requires init_options + LspCopilotSignIn ([55662c9](https://github.com/YeferYV/RetroNvim/commit/55662c9c2a010c601fb383b9f3815ba4a2f207fd))
* **nvim:** copilot.lua as alternative since supermaven seems to be unmaintained ([ba3bc22](https://github.com/YeferYV/RetroNvim/commit/ba3bc226fb261ef08786e7502d05538c2c1d1b73))
* **nvim:** CREATE_APPIMAGE=1 to use different init.lua ([c2ed169](https://github.com/YeferYV/RetroNvim/commit/c2ed1699b1c7a3784424248a099c70f49e6de6a0))
* **nvim:** fh, fj, fk, fl, sh, sj, sk, sl, rh, rj, rk, rl now has a special f_mode and r_mode ([ab5ff6b](https://github.com/YeferYV/RetroNvim/commit/ab5ff6bceeba74968bd9afe2f7e576f0c0d38fad))
* **nvim:** file change detection used by `next dev --turbopack`, `git`, etc ([97d038f](https://github.com/YeferYV/RetroNvim/commit/97d038fc28d0a428d45dfdbc7a68e409f3701b42))
* **nvim:** going back to `copilotlsp-nvim` since `sidekick.nvim nes` doesn't diff well ([b824f22](https://github.com/YeferYV/RetroNvim/commit/b824f221bd82ae80a172484585b24fadb99f4036))
* **nvim:** indent_at_cursor = false (inside vscode) ([2b906d6](https://github.com/YeferYV/RetroNvim/commit/2b906d6cc3fb1c38d0032eee01cd598cdf85c9e3))
* **nvim:** manually start ConsoleLog since it breaks mini.starter ([f5f4800](https://github.com/YeferYV/RetroNvim/commit/f5f48006561907bb21f69817a5659de1448d615e))
* **nvim:** migrating to lazyvim ([455ade2](https://github.com/YeferYV/RetroNvim/commit/455ade2663651e05846e70ab836f75bfd0adb422))
* **nvim:** migrating to neocodeium which doesn't require plenary (dependencies tends to break) ([20a1209](https://github.com/YeferYV/RetroNvim/commit/20a1209065782e954e60cc70897b7f5d0db64210))
* **nvim:** migrating to nvim-treesitter main branch ([e29494b](https://github.com/YeferYV/RetroNvim/commit/e29494ba100dcc782f248c232b4349a50164a420))
* **nvim:** migrating to snacks.picker (which supports preview) from mini.pick + new plugin nvim-tree ([5eda6e9](https://github.com/YeferYV/RetroNvim/commit/5eda6e904a1a63d1e0e66ce155ead99637bb66b5))
* **nvim:** mini.snippets now can read vscode snippet extensions automatically ([9bfee36](https://github.com/YeferYV/RetroNvim/commit/9bfee36f79a34e58b83d12217c42a64377da2c6f))
* **nvim:** missing loading friendly-snippets, treesitter indent and highlight ([4c5b72f](https://github.com/YeferYV/RetroNvim/commit/4c5b72f40fdd3720c7be81bce4b9ae7c3472462e))
* **nvim:** missing StatusColumn Hide/Show ([7d5a783](https://github.com/YeferYV/RetroNvim/commit/7d5a7836782ee52f4bd8298840a7efb2bfa5a101))
* **nvim:** neocodeium doesn't work on windows and supermaven completion still works ([1c85590](https://github.com/YeferYV/RetroNvim/commit/1c855907a7cbf13221ba3bb59f9eb7c30c1f09d2))
* **nvim:** new minimal Lsp Installer since `:Mason` has no configured lsp ([0703563](https://github.com/YeferYV/RetroNvim/commit/07035637034b6a3dd8a250f4d8fb597236728226))
* **nvim:** nightly neovim CSI-U doesn't detect `shift+number` from kitty keyboard protocol on Windows ([b839964](https://github.com/YeferYV/RetroNvim/commit/b8399643102a7c374620531c5fda44f7745c07b4))
* **nvim:** node based language servers inside lib/node_modules installed using pixi doesn't work on windows with the error  `...\bin\node` command not found ([1ab1c1d](https://github.com/YeferYV/RetroNvim/commit/1ab1c1d4257547e7566733a57d405b2e0e1bda14))
* **nvim:** pnpm packages on Windows 11 requires `.cmd` + zsh.exe doesn't support `:!pixi ...` + jdtls support ([13f0c33](https://github.com/YeferYV/RetroNvim/commit/13f0c335fea07a2cf7784afeaee446072858bec4))
* **nvim:** pyright requires a empty lsp setting ([fcb124d](https://github.com/YeferYV/RetroNvim/commit/fcb124d85815ab85a59bdfbf5fa02d8608a49cc1))
* **nvim:** remap gh to gH, remap gl to g., adding gnH gpH + fixing iy, R and Q key combinations ([b40b93e](https://github.com/YeferYV/RetroNvim/commit/b40b93e53bee3955a7b956b90db01e8672f1cb54))
* **nvim:** removing copilot.lua since it's limited to 2000 free request per month ([1709d1b](https://github.com/YeferYV/RetroNvim/commit/1709d1b8d2ca97fa193c4b2b46c9c845c24a734e))
* **nvim:** rewriting a minimal flash.nvim since plugins tends to change (gets broken) ([9f70a5c](https://github.com/YeferYV/RetroNvim/commit/9f70a5cd7d3dea675d34fd260887c14c687fd5d6))
* **nvim:** treesitter support from helix ([72acbef](https://github.com/YeferYV/RetroNvim/commit/72acbef51b6223fd465f71f420d2f368b9f7bc75))
* **nvim:** using OmniSharp instead of csharp-ls ([5be433c](https://github.com/YeferYV/RetroNvim/commit/5be433c0858244695b7f4145d45fb1cc71d62ba7))
* **nvim:** using schemas instead of lsp for yaml and json files ([907e7da](https://github.com/YeferYV/RetroNvim/commit/907e7dab421a87d136b6b29c14f512f28496e575))
* **nvim:** vim.fn.sign_define() will be deprecated in neovim v0.12 ([05b2c5e](https://github.com/YeferYV/RetroNvim/commit/05b2c5ecc1f4c21bfb917a25f4acb036f1cc868d))
* **nvim:** volar and astro requires typescript ([dfff7bf](https://github.com/YeferYV/RetroNvim/commit/dfff7bf86bdb74250b1882ac8dd148b3a1780bed))
* **nvim:** vscode `undo` snippets conflicts with MiniBracketed.undo() ([c260f34](https://github.com/YeferYV/RetroNvim/commit/c260f340996a931511d316107791a34f867ce0bf))
* **nvim:** Windows needs a autocmd to LspStart ([5904712](https://github.com/YeferYV/RetroNvim/commit/590471210ccd670962db8b0e49e7e10fff3f6f51))
* **nvim:** windsurf.nvim requires msys2 on windows ([7c750de](https://github.com/YeferYV/RetroNvim/commit/7c750deb60010970e04d561427f4d309cf83f985))
* **nvim:** yaml.github filetype (for gh_action_ls to work) and yaml.gitlab filetype (for gitlab_ci_ls) ([9b65e4f](https://github.com/YeferYV/RetroNvim/commit/9b65e4fb77410f016514e07498f63840be46e1b9))
* **nvim:** yazi open file inside neovim ([b49c576](https://github.com/YeferYV/RetroNvim/commit/b49c5761256517e5e513e2aaad4b6905d2574ac3))
* **package.json:** `TRAE coding assistant`, `Gemini code assist` and `sidekick.nvim` have FREE `next-edit-sugggestion` and `agent` ([1153276](https://github.com/YeferYV/RetroNvim/commit/1153276c5f8104b975c346c207c602876ff7f93e))
* **package.json:** adding new file containing shift+u in the file explorer triggers `whichkey.repeatMostRecent` ([2ad5c7b](https://github.com/YeferYV/RetroNvim/commit/2ad5c7ba98a6edef99aebb287a47957cc7077cad))
* **package.json:** affinity for performance and ignore ctrl+space ([c26d74b](https://github.com/YeferYV/RetroNvim/commit/c26d74bab68c73d421c4369cc6d3c8449907bfec))
* **package.json:** RETRONVIM_PATH for kanata on windows doesn't get expanded + keyboard repeat rate on Windows is a powershell script ([df01d44](https://github.com/YeferYV/RetroNvim/commit/df01d4498b432da21d9ad4a1abfbf1e1b80088ad))
* **powershell:** bracket directory support + auto close for yazi ([d626ccb](https://github.com/YeferYV/RetroNvim/commit/d626ccb78cf27484f12cff68cbb6df38212faf59))
* **powershell:** code.exe doesn't support `--locate-shell-integration-path` ([9664008](https://github.com/YeferYV/RetroNvim/commit/96640080bb2714fe373fc18ef0230cf9658086c1))
* **powershell:** if vscode shell integration is sourced two times it crashes ([9128a6a](https://github.com/YeferYV/RetroNvim/commit/9128a6a14fa5393a8c65b5060abd3e25c1204af3))
* **README:** updated broken links ([179e780](https://github.com/YeferYV/RetroNvim/commit/179e780209813ad86d996c22eb585f7bdc2305c7))
* **release.yaml:** adding conda releases ([62cc12c](https://github.com/YeferYV/RetroNvim/commit/62cc12caf7b45b69a2409530f2328180b8112913))
* **release.yaml:** missing git-submodules ([ddb7487](https://github.com/YeferYV/RetroNvim/commit/ddb74872e917047c6e5ae12fb201628d564f33b5))
* **release.yml:** attemp using vsce as devDependency to fix `The user aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa is not authorized` ([ab2979d](https://github.com/YeferYV/RetroNvim/commit/ab2979d7154c8fa2b2e3cc349a6d944a910edc82))
* **release.yml:** lowercase typo + skip `rm nvim.pdb` exit-code ([75662ef](https://github.com/YeferYV/RetroNvim/commit/75662ef9ddb6a05bc15fcc0b6d3103cc6a657ed3))
* **release.yml:** VSCE_TOKEN secret as global env should fix `The user aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa is not authorized` ([1bdd8ae](https://github.com/YeferYV/RetroNvim/commit/1bdd8aebee88dec5a53e2e82d4a1f9578315cd1e))
* **retronvim.yaml:** missing terax desktop icon ([c6ee096](https://github.com/YeferYV/RetroNvim/commit/c6ee096f5e74cb3f189a518d19a931b6f40b4409))
* **settings.json:** `formulahendry.auto-rename-tag` supports vscode-neovim "editor.linkedEditing" doesn't ([e741b34](https://github.com/YeferYV/RetroNvim/commit/e741b34ab0bcdadfbbe7dc54e403fe085a394c54))
* **settings.json:** now tailwind suggestions appears when writing emmet snippets ([4bd51b2](https://github.com/YeferYV/RetroNvim/commit/4bd51b21bc3556e9457715baa56c8aa173991048))
* **settings.json:** vscode's git cannot find retronvim's git ([324ba7f](https://github.com/YeferYV/RetroNvim/commit/324ba7f0d9bc7b9c2bde6e59e7690b6e5250b032))
* **terax.yaml:** migrating to terax removing wezterm ([abe4c5f](https://github.com/YeferYV/RetroNvim/commit/abe4c5f1a838c975a625f27c5b8d3ba667cc0a26))
* **vscodevim:** yank fordward ([617d726](https://github.com/YeferYV/RetroNvim/commit/617d726fb8335f8a89723ff511446dfb35b8d7f1))
* **wezterm:** auto load retronvim's profile.ps1 ([525404e](https://github.com/YeferYV/RetroNvim/commit/525404e8691c353cd66f4bf32ed0a13d6c09c5a2))
* **wezterm:** wezterm.appimage errors if retronvim_path is nil ([86cdb16](https://github.com/YeferYV/RetroNvim/commit/86cdb1622af2f293d5e8082854259eaecdefd236))
* **whichkey.bindings:** adding $RETRONVIM_BIN to start kanata on linux or mac ([ec70525](https://github.com/YeferYV/RetroNvim/commit/ec70525d007fd97c1d7c88326a9fcacfe8a44c45))
* **whichkey:** bat requires less to scroll (when opening inside yazi on Windows) ([8cbf92c](https://github.com/YeferYV/RetroNvim/commit/8cbf92cfcbe478031a5421fa62de736a13025dbe))
* **whichkey:** Install Retronvim's nvim/yazi/zsh on any terminal ([1278a0e](https://github.com/YeferYV/RetroNvim/commit/1278a0e8d1ce8d5e5c40f606e7a8bb2cf528fc5c))
* **whichkey:** missing "workbench.action.terminal.sendsequence" for "install pixi and pnpm" ([1951852](https://github.com/YeferYV/RetroNvim/commit/1951852603a166331c308f0bd9457f3cbe43ba33))
* **yazi:** `yy` needs a `tty` + new command `Ripgrep fzf` ([5efea42](https://github.com/YeferYV/RetroNvim/commit/5efea42724296bd1795a588f6f708ee36ae83a86))
* **yazi:** drag file from vscode and drop it to the browser ([b31b089](https://github.com/YeferYV/RetroNvim/commit/b31b089def851116037b14349d410e8b4461747f))
* **yazi:** fzf match color highlight-reverse ([8748bd1](https://github.com/YeferYV/RetroNvim/commit/8748bd181f0253785304145c8c9363ad2e6ad3d2))
* **yazi:** fzf sorted ([658fa44](https://github.com/YeferYV/RetroNvim/commit/658fa4483d47d6ea480549e70ddfdde9c4b53d98))
* **yazi:** if RETRONVIM_INIT not defined use `~/.config/nvim/init.lua` and `~/appdata/local/nvim/init.lua` as fallback ([1d0699a](https://github.com/YeferYV/RetroNvim/commit/1d0699a37b19b65e33b7acb8c042d6b06922a959))
* **yazi:** now powershell can be open inside bracket directory e.g. [directory] ([066713f](https://github.com/YeferYV/RetroNvim/commit/066713f3d0680c07b68c12dd25503a11c5290d24))
* **yazi:** open msys2's zsh ([a77eebd](https://github.com/YeferYV/RetroNvim/commit/a77eebd65c670c4c2c85094ff09cd9cd53d4ff83))
* **yazi:** powershell splits `%*` by white-spaces not by end-of-line ([6fa640d](https://github.com/YeferYV/RetroNvim/commit/6fa640d7c98189f052bbe946fefbcdf8e054d573))
* **yazi:** removing devour which is not supported on wayland ([d8fd227](https://github.com/YeferYV/RetroNvim/commit/d8fd22767700e4ab0cf7b85cf4cb89673b855587))
* **yazi:** run detached mpv ([c2072ca](https://github.com/YeferYV/RetroNvim/commit/c2072cac6f059db52fcf939eb1b22cb9d31ddffc))
* **yazi:** using chrome to drag and drop instead of ripdrag ([bc30ab5](https://github.com/YeferYV/RetroNvim/commit/bc30ab51b2aa54e70b53055b06c06141a4c265c9))
* **yazi:** using mime-ext.yazi (which works in powershell) plugin falling back to file1 ([a3e9542](https://github.com/YeferYV/RetroNvim/commit/a3e95428a6d93e6f24a730b4026498bb6e9aabd8))
* **zsh:** `$OSTYPE` of msys2 is called now `cygwin` ([01cc617](https://github.com/YeferYV/RetroNvim/commit/01cc617ae493b60c86ac4e8825fb5f4d8e1ad0ee))
* **zsh:** `nvim --clean` doesn't remember last cursor position ([f85087a](https://github.com/YeferYV/RetroNvim/commit/f85087a4075f6a265c0c638deb402dc473225bef))
* **zsh:** `source $ZDOTDIR/plugins/...` ([8c068a3](https://github.com/YeferYV/RetroNvim/commit/8c068a3254b17e45e331a540eb4d93649aaa6ae4))
* **zsh:** getting multiples ~/.cache/zcompdump.some-id + hide suggestion after pressing tab ([8cad67f](https://github.com/YeferYV/RetroNvim/commit/8cad67f2d5f59a17fa5d87cec381cf2074e89c3a))
* **zsh:** OSC 11 and DECRQM sequences leaks on yazi inside terax workaround ([b87df6d](https://github.com/YeferYV/RetroNvim/commit/b87df6d2f0042d5c7c2c5009e9002803582d8d2a))
* **zsh:** ZDOTDIR is overwrited by `code --locate-shell-integration-path` ([20ff9c0](https://github.com/YeferYV/RetroNvim/commit/20ff9c04651f80e9da829bd9416ae2966f122eea))
* **zsh:** zsh.exe slow startup time on windows due to calling msys2.cmd and deleting powershell which is horribly slow ([9853de1](https://github.com/YeferYV/RetroNvim/commit/9853de145ff2d21c3a9a32be8165f28da7134214))


### Miscellaneous Chores

* release 0.3.1 ([2726f61](https://github.com/YeferYV/RetroNvim/commit/2726f61258ca7cb3be84770cd0c03d093ac7c8ed))

## [0.4.5](https://github.com/YeferYV/RetroNvim/compare/v0.4.4...v0.4.5) (2026-05-13)


### Bug Fixes

* **nvim:** nightly neovim CSI-U doesn't detect `shift+number` from kitty keyboard protocol on Windows ([b839964](https://github.com/YeferYV/RetroNvim/commit/b8399643102a7c374620531c5fda44f7745c07b4))
* **nvim:** treesitter support from helix ([72acbef](https://github.com/YeferYV/RetroNvim/commit/72acbef51b6223fd465f71f420d2f368b9f7bc75))
* **powershell:** code.exe doesn't support `--locate-shell-integration-path` ([9664008](https://github.com/YeferYV/RetroNvim/commit/96640080bb2714fe373fc18ef0230cf9658086c1))
* **zsh:** zsh.exe slow startup time on windows due to calling msys2.cmd and deleting powershell which is horribly slow ([9853de1](https://github.com/YeferYV/RetroNvim/commit/9853de145ff2d21c3a9a32be8165f28da7134214))

## [0.4.4](https://github.com/YeferYV/RetroNvim/compare/v0.4.3...v0.4.4) (2026-03-07)


### Bug Fixes

* **release.yml:** lowercase typo + skip `rm nvim.pdb` exit-code ([75662ef](https://github.com/YeferYV/RetroNvim/commit/75662ef9ddb6a05bc15fcc0b6d3103cc6a657ed3))

## [0.4.3](https://github.com/YeferYV/RetroNvim/compare/v0.4.2...v0.4.3) (2026-03-07)


### Bug Fixes

* **extension.js:** faster way to open yazi ([da27ca6](https://github.com/YeferYV/RetroNvim/commit/da27ca6853ad8c22baee7a212dfb0fb9a0d34523))
* **extension.js:** include java framework configs and extensions ([cb7576f](https://github.com/YeferYV/RetroNvim/commit/cb7576fc43fd247405720ddbbb4c35dcee1d07d3))
* **extension.js:** lazygit requires git ([92d15ae](https://github.com/YeferYV/RetroNvim/commit/92d15ae6549761df3f0911281e0842961edccbff))
* **kanata:** multi f24 not required in v1.11.0 ([5d39e1a](https://github.com/YeferYV/RetroNvim/commit/5d39e1aca1c68be3f5cbac50d61835fe75a22c40))
* **keybinding.json:** `!inputFocus` doesn't trigger search key `/` ([7edfe73](https://github.com/YeferYV/RetroNvim/commit/7edfe730adf3b88562dddf8c32ea77772643d04c))
* **keybindings.json:** `ctrl+f` searches file inside explorer since `/` doesn't work on cvim ([2120dff](https://github.com/YeferYV/RetroNvim/commit/2120dffbbdae2cc6e38e07649f011995ade5f15d))
* **nvim:** `@github/copilot-language-server` location path has changed and also works on windows ([78fdbc3](https://github.com/YeferYV/RetroNvim/commit/78fdbc3a2daf3aa7f192c19588d641e5cebd0872))
* **nvim:** `jk` on visual mode is slow ([7d3a181](https://github.com/YeferYV/RetroNvim/commit/7d3a18143a82f0ae00816540da175a0bcb9a96dc))
* **nvim:** `preview git hunk` deleted hunk takes out one line + terminal keymaps ([29a8e0a](https://github.com/YeferYV/RetroNvim/commit/29a8e0a70b0ab761a1df8ac52e93f547c26f52af))
* **nvim:** `preview git hunk` with `[directory]` now works ([ec679bb](https://github.com/YeferYV/RetroNvim/commit/ec679bbf08928e490aba0b296f9a37fb7adccefa))
* **nvim:** consolelog.nvim freezes mini.starter ([95092fc](https://github.com/YeferYV/RetroNvim/commit/95092fcace59aade80610183d59c14a20c792dcd))
* **nvim:** file change detection used by `next dev --turbopack`, `git`, etc ([97d038f](https://github.com/YeferYV/RetroNvim/commit/97d038fc28d0a428d45dfdbc7a68e409f3701b42))
* **nvim:** manually start ConsoleLog since it breaks mini.starter ([f5f4800](https://github.com/YeferYV/RetroNvim/commit/f5f48006561907bb21f69817a5659de1448d615e))
* **nvim:** neocodeium doesn't work on windows and supermaven completion still works ([1c85590](https://github.com/YeferYV/RetroNvim/commit/1c855907a7cbf13221ba3bb59f9eb7c30c1f09d2))
* **nvim:** windsurf.nvim requires msys2 on windows ([7c750de](https://github.com/YeferYV/RetroNvim/commit/7c750deb60010970e04d561427f4d309cf83f985))
* **powershell:** bracket directory support + auto close for yazi ([d626ccb](https://github.com/YeferYV/RetroNvim/commit/d626ccb78cf27484f12cff68cbb6df38212faf59))
* **settings.json:** vscode's git cannot find retronvim's git ([324ba7f](https://github.com/YeferYV/RetroNvim/commit/324ba7f0d9bc7b9c2bde6e59e7690b6e5250b032))
* **yazi:** fzf sorted ([658fa44](https://github.com/YeferYV/RetroNvim/commit/658fa4483d47d6ea480549e70ddfdde9c4b53d98))
* **yazi:** now powershell can be open inside bracket directory e.g. [directory] ([066713f](https://github.com/YeferYV/RetroNvim/commit/066713f3d0680c07b68c12dd25503a11c5290d24))
* **yazi:** powershell splits `%*` by white-spaces not by end-of-line ([6fa640d](https://github.com/YeferYV/RetroNvim/commit/6fa640d7c98189f052bbe946fefbcdf8e054d573))
* **yazi:** removing devour which is not supported on wayland ([d8fd227](https://github.com/YeferYV/RetroNvim/commit/d8fd22767700e4ab0cf7b85cf4cb89673b855587))

## [0.4.2](https://github.com/YeferYV/RetroNvim/compare/v0.4.1...v0.4.2) (2025-11-08)


### Bug Fixes

* **nvim:** `preview git hunk` search and jump to hunk ([60de283](https://github.com/YeferYV/RetroNvim/commit/60de2836a9f4658038b210c3b1aae53299aaadc5))
* **nvim:** `windsurf.nvim` alternative to supermaven since the service will be sunset + `Amp` extension keymaps for vscode ([cef8012](https://github.com/YeferYV/RetroNvim/commit/cef8012df095a3064f2bd96eaff14a5155afc63c))
* **nvim:** migrating to neocodeium which doesn't require plenary (dependencies tends to break) ([20a1209](https://github.com/YeferYV/RetroNvim/commit/20a1209065782e954e60cc70897b7f5d0db64210))
* **nvim:** missing StatusColumn Hide/Show ([7d5a783](https://github.com/YeferYV/RetroNvim/commit/7d5a7836782ee52f4bd8298840a7efb2bfa5a101))
* **nvim:** yazi open file inside neovim ([b49c576](https://github.com/YeferYV/RetroNvim/commit/b49c5761256517e5e513e2aaad4b6905d2574ac3))
* **zsh:** `$OSTYPE` of msys2 is called now `cygwin` ([01cc617](https://github.com/YeferYV/RetroNvim/commit/01cc617ae493b60c86ac4e8825fb5f4d8e1ad0ee))

## [0.4.1](https://github.com/YeferYV/RetroNvim/compare/v0.4.0...v0.4.1) (2025-10-22)


### Bug Fixes

* **keybindings.json:** `alt+l` windsurf supercomplete and `alt+p`/`alt+n` prev/next snippet stop ([6cc3dae](https://github.com/YeferYV/RetroNvim/commit/6cc3dae84660bf1250a40d309e056d3cc998c4a7))
* **nvim:** `mini.snippets` searches for cursor/vscode/windsurf extension snippets alphabetically ([599b362](https://github.com/YeferYV/RetroNvim/commit/599b3620cf8b0a1d173bd2ecd4fde3a52f67e292))
* **nvim:** copilot-lsp requires init_options + LspCopilotSignIn ([55662c9](https://github.com/YeferYV/RetroNvim/commit/55662c9c2a010c601fb383b9f3815ba4a2f207fd))
* **nvim:** going back to `copilotlsp-nvim` since `sidekick.nvim nes` doesn't diff well ([b824f22](https://github.com/YeferYV/RetroNvim/commit/b824f221bd82ae80a172484585b24fadb99f4036))
* **package.json:** `TRAE coding assistant`, `Gemini code assist` and `sidekick.nvim` have FREE `next-edit-sugggestion` and `agent` ([1153276](https://github.com/YeferYV/RetroNvim/commit/1153276c5f8104b975c346c207c602876ff7f93e))

## [0.4.0](https://github.com/YeferYV/RetroNvim/compare/v0.3.8...v0.4.0) (2025-09-09)


### Features

* **release.yaml:** support for open-vsx.org, windsurf and cursor ([53dde0a](https://github.com/YeferYV/RetroNvim/commit/53dde0a96b7b9d5052978506257c276fa9c03500))


### Bug Fixes

* **package.json:** affinity for performance and ignore ctrl+space ([c26d74b](https://github.com/YeferYV/RetroNvim/commit/c26d74bab68c73d421c4369cc6d3c8449907bfec))
* **vscodevim:** yank fordward ([617d726](https://github.com/YeferYV/RetroNvim/commit/617d726fb8335f8a89723ff511446dfb35b8d7f1))

## [0.3.8](https://github.com/YeferYV/RetroNvim/compare/v0.3.7...v0.3.8) (2025-09-02)


### Bug Fixes

* **extension.js:** vscode's marketplace support for windsurf ([bb79613](https://github.com/YeferYV/RetroNvim/commit/bb79613aa17f9c19d2b8bbcbafa0c0d72f013a99))
* **nvim:** $APPDIR2 when init.lua is inside two nvim.appimage ([ad33fc4](https://github.com/YeferYV/RetroNvim/commit/ad33fc46617d2b7b142bcd384b0155172990e0b8))
* **nvim:** comment out jsx keybinding ([fcf68d4](https://github.com/YeferYV/RetroNvim/commit/fcf68d42c5d3e82b0c5ae158305f6948569ee0a0))
* **nvim:** copilot NES support added since supermaven doesn't support NES ([d58e9a1](https://github.com/YeferYV/RetroNvim/commit/d58e9a17189a57f00eac8712a3cf7b21a22ba07c))
* **nvim:** copilot.lua as alternative since supermaven seems to be unmaintained ([ba3bc22](https://github.com/YeferYV/RetroNvim/commit/ba3bc226fb261ef08786e7502d05538c2c1d1b73))
* **nvim:** removing copilot.lua since it's limited to 2000 free request per month ([1709d1b](https://github.com/YeferYV/RetroNvim/commit/1709d1b8d2ca97fa193c4b2b46c9c845c24a734e))
* **package.json:** adding new file containing shift+u in the file explorer triggers `whichkey.repeatMostRecent` ([2ad5c7b](https://github.com/YeferYV/RetroNvim/commit/2ad5c7ba98a6edef99aebb287a47957cc7077cad))
* **powershell:** if vscode shell integration is sourced two times it crashes ([9128a6a](https://github.com/YeferYV/RetroNvim/commit/9128a6a14fa5393a8c65b5060abd3e25c1204af3))
* **wezterm:** wezterm.appimage errors if retronvim_path is nil ([86cdb16](https://github.com/YeferYV/RetroNvim/commit/86cdb1622af2f293d5e8082854259eaecdefd236))
* **yazi:** using chrome to drag and drop instead of ripdrag ([bc30ab5](https://github.com/YeferYV/RetroNvim/commit/bc30ab51b2aa54e70b53055b06c06141a4c265c9))

## [0.3.7](https://github.com/YeferYV/RetroNvim/compare/v0.3.6...v0.3.7) (2025-07-17)


### Bug Fixes

* **nvim:** CREATE_APPIMAGE=1 to use different init.lua ([c2ed169](https://github.com/YeferYV/RetroNvim/commit/c2ed1699b1c7a3784424248a099c70f49e6de6a0))

## [0.3.6](https://github.com/YeferYV/RetroNvim/compare/v0.3.5...v0.3.6) (2025-07-17)


### Bug Fixes

* **zsh:** `source $ZDOTDIR/plugins/...` ([8c068a3](https://github.com/YeferYV/RetroNvim/commit/8c068a3254b17e45e331a540eb4d93649aaa6ae4))

## [0.3.5](https://github.com/YeferYV/RetroNvim/compare/v0.3.4...v0.3.5) (2025-07-16)


### Bug Fixes

* **kanata:** wrong `_` position ([f5d2065](https://github.com/YeferYV/RetroNvim/commit/f5d2065b107e765a08e95b57931f3697078d47f7))

## [0.3.4](https://github.com/YeferYV/RetroNvim/compare/v0.3.3...v0.3.4) (2025-07-11)


### Bug Fixes

* **extension.js:** uncompress environment.sh if there is no pixi in PATH ([2b945e8](https://github.com/YeferYV/RetroNvim/commit/2b945e8aab9f2a50cc984e31affc2241b74901dc))
* **kanata:** short scroll doesn't scroll wezterm ([acf7a09](https://github.com/YeferYV/RetroNvim/commit/acf7a09918badab47b9136712b3876ad7153d5bb))
* **yazi:** run detached mpv ([c2072ca](https://github.com/YeferYV/RetroNvim/commit/c2072cac6f059db52fcf939eb1b22cb9d31ddffc))

## [0.3.3](https://github.com/YeferYV/RetroNvim/compare/v0.3.2...v0.3.3) (2025-07-03)


### Bug Fixes

* **ci:** PKG_CONFIG_PATH and PKG_CONFIG_LIBDIR for ripdrag build ([f7cb9a4](https://github.com/YeferYV/RetroNvim/commit/f7cb9a4220095bae2d84bae6ee97608d99b44e03))
* **wezterm:** auto load retronvim's profile.ps1 ([525404e](https://github.com/YeferYV/RetroNvim/commit/525404e8691c353cd66f4bf32ed0a13d6c09c5a2))

## [0.3.2](https://github.com/YeferYV/RetroNvim/compare/v0.3.1...v0.3.2) (2025-07-02)


### Bug Fixes
* **ci:** release 0.3.1 generated and published package only for macos and fail to generate packages for linux and windows

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

## [0.2.3](https://github.com/YeferYV/RetroNvim/compare/v0.2.2...v0.2.3) (2025-02-15)

### Bug Fixes

- **nvim:** removing nvim-treesitter since LSP supports semantic token colorization and foldexpr ([94915f0](https://github.com/YeferYV/RetroNvim/commit/94915f021eb5522753818438575687f3c829e6f2))
- **nvim:** `v:lua.vim.treesitter.foldexpr()` stops working on new opened buffers ([17b4006](https://github.com/YeferYV/RetroNvim/commit/17b40063823e3265208da221877d7d0c48d0538e))
- **nvim:** `<cmd>` is `{ silent = true}` (`:` is not) to prevent confirmation on small screen ([e307cee](https://github.com/YeferYV/RetroNvim/commit/e307ceea6227668d18c6cdd73abd352572191d0e))
- **nvim:** indent_at_cursor = false (inside vscode) ([2b906d6](https://github.com/YeferYV/RetroNvim/commit/2b906d6cc3fb1c38d0032eee01cd598cdf85c9e3))
- **zsh:** ZDOTDIR is overwrited by `code --locate-shell-integration-path` ([20ff9c0](https://github.com/YeferYV/RetroNvim/commit/20ff9c04651f80e9da829bd9416ae2966f122eea))

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
