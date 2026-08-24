<video controls autoplay loop muted playsinline src="https://github.com/YeferYV/RetroNvim/assets/37911404/4f7002a2-324e-4597-9644-5ab0cd7c5831" title="Demo"></video>

<div align="center">

yazi-like file manager + whichkey + terminal keymaps

<!-- <img src="https://github.com/yeferyv/retronvim/blob/main/assets/demo.gif?raw=true"> -->

---

**[<kbd> <br> Install <br> </kbd>][Install]** 
**[<kbd> <br> Wiki <br> </kbd>][Wiki]** 
**[<kbd> <br> Dependencies <br> </kbd>][Dependencies]**

[Install]: #installation
[Wiki]: https://github.com/YeferYV/RetroNvim/wiki
[Dependencies]: https://github.com/YeferYV/RetroNvim/wiki/dependencies

</div>

---

<details open><summary>Table of Contents</summary>

1. Keybindings.json
   - [vscode file explorer keymaps](#file-explorer-keymaps)
   - [vscode editor keymaps](#editor-keymaps)
   - [vscode terminal keymaps](#vscode-terminal-keymaps)
2. Installation
   - [Install](#installation)
3. [Related projects](#related-projects)

</details>

---

## vscode file explorer keymaps

<details open><summary></summary>

| Key Combination | Description                                                                                      |
| :-------------: | :----------------------------------------------------------------------------------------------- |
|    `ctrl+f`     | search file [`/` doesn't work on cvim](https://github.com/vscode-neovim/vscode-neovim/pull/1015) |
|       `a`       | create new file or folder (`path/to/file` creates 2 folders and 1 file)                          |
|       `d`       | delete file                                                                                      |
|      `gg`       | focus first file                                                                                 |
|       `G`       | focus last file                                                                                  |
|       `h`       | collapse list                                                                                    |
|       `j`       | move down                                                                                        |
|       `k`       | move up                                                                                          |
| `l` or `enter`  | open directory/file passing focus                                                                |
|       `J`       | move focus down 10 times in list view                                                            |
|       `K`       | move focus up 10 times in list view                                                              |
|       `L`       | open and toggle sidebar visibility                                                               |
| `o` or `space`  | open without passing focus replacing current tab                                                 |
|       `O`       | open without passing focus in a new tab                                                          |
|       `p`       | paste file                                                                                       |
|       `q`       | close sidebar visibility                                                                         |
|       `r`       | rename file                                                                                      |
|       `v`       | open selected file to the side and toggle sidebar visibility                                     |
|       `V`       | open selected file to the bottom and toggle sidebar visibility                                   |
|       `x`       | cut file                                                                                         |
|       `y`       | copy file                                                                                        |
|     `Down`      | focus down and preview file                                                                      |
|      `Up`       | focus up and preview file                                                                        |

</details>

## vscode editor keymaps

<details open><summary></summary>

| Key Combination                  |    mode     | Description                                                        |
| :------------------------------- | :---------: | :----------------------------------------------------------------- |
| `shift+space`                    |     `n`     | show whichkey menu (Windows, Linux, Mac)                           |
| `alt+space`                      |     `n`     | show whichkey menu (Linux, Mac)                                    |
| `<space>o`                       |     `n`     | view file explorer                                                 |
| `/`                              |     `n`     | search (`ctrl+p`/`up`/`ctrl+n`/`down` search history)              |
| `ctrl+\`                         |   `n`,`i`   | toggle panel (terminal) visibility                                 |
| `escape`                         |     `n`     | clear search highlight                                             |
| `shift+escape`                   |     `n`     | close any popup window like diff/diagnostic etc                    |
| `jk`                             |     `i`     | enter vim normal mode                                              |
| `left`                           |     `n`     | go to previous tab                                                 |
| `right`                          |     `n`     | go to next tab                                                     |
| `alt+;`                          |     `i`     | trigger Next-Edit-Suggestion from AI (`alt+l` to accept)           |
| `alt+[`                          |     `i`     | show previous AI suggestion                                        |
| `alt+]`                          |     `i`     | show next AI suggestion                                            |
| `alt+c`                          |     `i`     | copy                                                               |
| `alt+f`                          | `n`,`i`,`x` | go to next tab                                                     |
| `alt+h`                          |   `i`,`x`   | enter vim normal mode                                              |
| `alt+j`                          |     `i`     | AI suggestion accept next word                                     |
| `alt+k`                          |     `i`     | AI suggestion accept next line                                     |
| `alt+l`                          |     `i`     | accept AI/NES suggestion (TRAE/AMP/gemini/windsurf/cursor/copilot) |
| `alt+n`                          |     `i`     | go to next snippet stop                                            |
| `alt+o`                          | `n`,`i`,`x` | yazi-like file manager                                             |
| `alt+p`                          |     `i`     | go to prev snippet stop                                            |
| `alt+s`                          | `n`,`i`,`x` | go to previous tab                                                 |
| `alt+v`                          |     `i`     | paste                                                              |
| `tab`                            |     `i`     | go to next snippet stop or next suggestion                         |
| `shift+tab`                      |     `i`     | go to prev snippet stop or prev suggestion                         |
| `shift+h`                        |     `n`     | cursorLeft `10` times                                              |
| `shift+j`                        |     `n`     | cursorDown `10` times                                              |
| `shift+k`                        |     `n`     | cursorUp `10` times                                                |
| `shift+l`                        |     `n`     | cursorRigth `10` times                                             |
| `shift+r`                        |     `n`     | format and save                                                    |
| `shift+q`                        |     `n`     | close active tab                                                   |
| `ctrl+shift+h` or `ctrl+shift+j` |     `n`     | decrease view size of current window or terminal                   |
| `ctrl+shift+l` or `ctrl+shift+k` |     `n`     | increase view size of current window or terminal                   |
| `ctrl+h`                         |     `n`     | navigate to left window                                            |
| `ctrl+j`                         |     `n`     | navigate to down window                                            |
| `ctrl+k`                         |     `n`     | navigate to up window                                              |
| `ctrl+l`                         |     `n`     | navigate to right window                                           |

</details>

## vscode terminal keymaps

<details open><summary></summary>

| Key Combination    | Description                                 |
| :----------------- | :------------------------------------------ |
| `alt+'`            | send sequence to open yazi                  |
| `alt+0`            | switch to last tab                          |
| `alt+1...9`        | switch to tab 1...9                         |
| `alt+a`            | Scroll terminal down by page                |
| `alt+q`            | Scroll terminal up by page                  |
| `alt+d`            | Scroll terminal down                        |
| `alt+e`            | Scroll terminal up                          |
| `alt+shift+d`      | Scroll terminal to next command             |
| `alt+shift+e`      | Scroll terminal to previous command         |
| `alt+t`            | Scroll terminal to top                      |
| `alt+g`            | Scroll terminal to bottom                   |
| `alt+s`            | Switch to previous tab                      |
| `alt+f`            | Switch to next tab                          |
| `alt+shift+s`      | move tab backward (vscode move to last tab) |
| `alt+shift+f`      | move tab forward (vscode move to last tab)  |
| `alt+c`            | copy                                        |
| `alt+v`            | paste                                       |
| `ctrl+\`           | toggle panel (terminal) visibility          |
| `ctrl+alt+h`       | split horizontal                            |
| `ctrl+alt+v`       | split vertical                              |
| `ctrl+shift+left`  | resize window left                          |
| `ctrl+shift+right` | resize window right                         |
| `ctrl+shift+up`    | resize window up                            |
| `ctrl+shift+down`  | resize window down                          |
| `ctrl+left`        | focus left                                  |
| `ctrl+right`       | focus rigth                                 |
| `ctrl+up`          | focus up                                    |
| `ctrl+down`        | focus down                                  |
| `ctrl+t`           | new tab                                     |
| `ctrl+w`           | close tab                                   |
| `ctrl+shift+t`     | move panel to new tab                       |
| `ctrl+shift+w`     | move panel to new window                    |
| `ctrl+shift+n`     | new window                                  |
| `ctrl+shift+f`     | find text                                   |
| `ctrl+plus`        | zoom in                                     |
| `ctrl+minus`       | zoom out                                    |

</details>

---

## Installation

<details open><summary></summary>

- RECOMENDED: On Windows 10/11 to allow creations of symlinks (npm creates them) you need to enable `Developer Mode`
  Go to `Settings` > `System` > `For Developers` > `Developer Mode` > `On`

  <img src="https://github.com/user-attachments/assets/eeccfa84-32c1-4b81-bf89-804e08e97afa" alt="https://neacsu.net/posts/win_symlinks" width="700">

- RetroNvim installs [`cvim` a vscodevim fork with flash.nvim support](https://github.com/VSCodeVim/Vim/issues/8567)
  and [`whichkey` a menu for keymaps](https://github.com/vspacecode/vscode-which-key) vscode extensions as optional
  dependencies

**VSCode Marketplace**

- Retronvim comes with an installer for frameworks (LSP + formatters + snippets + binaries + cheatsheets) for:
  - `angular`
  - `ansible`
  - `AWS`
  - `c/c++`
  - `c#`
  - `docker`
  - `django`
  - `expo`
  - `fastapi`
  - `flask`
  - `go`
  - `graphql`
  - `kotlin`
  - `kubernetes`
  - `laravel`
  - `nextjs`
  - `prisma`
  - `scikit-learn`
  - `springboot`
  - `supabase`
  - `rust`
  - `terraform`
  - `vue`

- Retronvim comes with [bat's base16](https://github.com/sharkdp/bat/blob/master/assets/themes/base16.tmTheme)
  syntax highlighting generated by `npx yo code --extensionType colortheme` and
  a editor theme generated using https://themes.vscode.one

- https://marketplace.visualstudio.com/items?itemName=YeferYV.retronvim

</details>

## File Manager Roadmap

- [ ] file navigation with vim keys
- [ ] file operations with yazi defaults keys
- [ ] previewer with syntax highlighting and image support
- [ ] open current file in a file-manager tab then replace file-manager tab with chosen file like retrovim or dir.lua
- [ ] bookmarks with whichkey
- [ ] jump by search in current directory
- [ ] jump by search of first character
- [ ] scroll preview by J/K keys
- [ ] open vscode-terminal in current directory

## Related projects

<details open><summary></summary>

- [yeferyv/RetroVim](https://github.com/yeferyv/sixelrice)
  neovim IDE using 01 plugins (with copilot, agents, text-objects, whichkey ...) +
  yazi builtin plugins + zsh builtin plugins + kanata keyboard layout

- [vscode file manager](https://github.com/ArtTemiy/VsCodeFileManager)
  midnight-commander for vscode

- [terax](https://github.com/crynta/terax-ai)
  agentic terminal + neovim-like IDE

- [lunarkeymap](https://github.com/fathulfahmy/lunarkeymap)
  comes with [vscodevim](https://github.com/vscodevim/vim) extension
  which has some text objects + whichkey with [lunarvim](https://github.com/lunarvim/lunarvim)-like keymaps

</details>
