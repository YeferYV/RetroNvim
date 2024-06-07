# Change Log

## v0.0.4 (07-06-2024)

**Added**
- javascript extension pack + node version manager whichkey menu entry installer
- python extension pack + python package manager whichkey menu entry installer
- Msys2's zsh support on Windows 10/11
- $ZDOTDIR to auto load minimal RetroNvim's .zshrc
- $STARSHIP_CONFIG to auto load a custom starship.toml
- tokyo night dark / poimandres custom theme

**Changed**
- dropping bash/git-bash support since ble.sh is slow
- RetroNvim now is shipped with zsh-autosuggestions, zsh-fast-syntax-highlighting and fzf-key-bindings.zsh plugins

**Fixed**
- increase keyboard repeat rate on Windows 10/11 is a powershell script
- map `jk` as escape key on `settings.json` instead of `keybindings.json`
- unmmapping `h`, `j`, `k` and `l` to vscode's arrows keys since conflicts with `flash.nvim` on Windows 10/11


## v0.0.3 (04-04-2024)

**Added**
- whichkey entries to show keybindings for yazi and lazygit
- gitsigns.nvim to preview/reset hunk (only inside neovim)
- keymaps `gpH` and `gnH` which works in windows10
- docs for keymaps of zsh/bash/git-bash setup (also shown in the demo.mp4)

**Changed**
- remap `gh` to `gH`
- remap `gl` to `g.`

**Fixed**
- keymaps using `R` and `Q`
- workaround for `gh` when visual-mode inside vscode (but race condition may happen)

## v0.0.2 (16-02-2024)
**Changed**
- remapping hjkl as cursor left/down/up/down on Windows10 for performance but doesn't restore vertical cursor position
- migrating to git-bash since powershell is too slow

**Added**
- kanata open with vscode or $EDITOR inside yazi

## v0.0.1 (12-02-2024)
**Added**
- Neovim A-Z text objects
- Whichkey with LSP,git,... entries
- Kanata with touchcursor-like keyboard layout
