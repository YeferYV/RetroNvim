<video controls autoplay loop muted playsinline src="https://github.com/YeferYV/RetroNvim/assets/37911404/4f7002a2-324e-4597-9644-5ab0cd7c5831" title="Demo"></video>

<div align="center">

vscode extension with minimal whichkey, lazyvim, terax, yazi, zsh and kanata setup

<!-- <img src="https://github.com/yeferyv/retronvim/blob/main/assets/demo.gif?raw=true"> -->

---

**[<kbd> <br> Install <br> </kbd>][Install]** 
**[<kbd> <br> Keyboard-Layout <br> </kbd>][Keyboard-Layout]** 
**[<kbd> <br> Wiki <br> </kbd>][Wiki]** 
**[<kbd> <br> Dependencies <br> </kbd>][Dependencies]**

[Install]: #installation
[Keyboard-Layout]: #if-touchcursor-keyboard-layout-started
[Wiki]: https://github.com/YeferYV/RetroNvim/wiki
[Dependencies]: https://github.com/YeferYV/RetroNvim/wiki/dependencies

</div>

---

<details open><summary>Table of Contents</summary>

1. Neovim keymaps
   - [Neovim text object that starts with a/i](#neovim-text-object-that-starts-with-ai)
   - [Neovim text-object/motions/operators that starts with g](#neovim-text-objectmotionsoperators-that-starts-with-g)
   - [Native neovim ctrl keys](#native-neovim-ctrl-keys)
2. Keybindings.json
   - [File Explorer keymaps](#file-explorer-keymaps)
   - [Editor keymaps (keybindings.json)](#editor-keymaps-keybindingsjson)
   - [Suggestion keymaps](#suggestion-keymaps)
3. Terminal
   - [vscode terminal keymaps](#vscode-terminal-keymaps)
   - [zsh keymaps](#zsh-keymaps)
4. [If Touchcursor Keyboard Layout Started](#if-touchcursor-keyboard-layout-started)
5. Installation
   - [Install](#installation)
   - [Trobleshotting](#troubleshooting)
   - [Package Manager (optional)](#package-manager-optional)
6. [Vim Cheatsheets / Tutorials](#vim-cheatsheets--tutorials)
7. [Related projects](#related-projects)

</details>

---

## Neovim text object that starts with `a`/`i`

<details open><summary></summary>

|         text-object keymap         | requires | repeat action key | finds and autojumps? | text-object name | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :------- | :---------------: | :------------------: | :--------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |          |        `.`        |         yes          | \_argument       | whole argument/parameter of a function                                                    | outer includes comma                                                          |
|             `ib`, `ab`             |          |        `.`        |         yes          | \_braces         | find the nearest inside of `()` `[]` `{}`                                                 | outer includes braces                                                         |
|             `iB`, `aB`             |          |        `.`        |         yes          | \_brackets       | find the nearest inside of `{}` `:help iB`                                                | outer includes brackets                                                       |
|             `id`, `ad`             | neovim   |        `.`        |         yes          | diagnostic       | find errors, warnings, info or hints (only works inside neovim and requires LSP)          | outer same as inner                                                           |
|             `ie`, `ae`             | RetroVim |        `.`        |                      | line             | from start to end of line without beginning whitespaces (line wise)                       | outer includes begining whitespaces                                           |
|             `if`, `af`             | RetroVim |        `.`        |         yes          | \_function_call  | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `ih`, `ah`             | RetroVim |        `.`        |         yes          | \_html_attribute | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |          |        `.`        |                      | indent_noblanks  | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             | RetroVim |        `.`        |                      | indent           | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ik`, `ak`             | RetroVim |        `.`        |         yes          | \_key            | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `il`, `al`             | RetroVim |        `.`        |         yes          | +last            | go to last mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `vilk`                                               |
|             `im`, `am`             | RetroVim |        `.`        |         yes          | \_number         | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `in`, `an`             | RetroVim |        `.`        |         yes          | +next            | go to Next mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `viNk`                                               |
|             `io`, `ao`             | RetroVim |        `.`        |         yes          | \_whitespaces    | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |          |        `.`        |                      | paragraph        | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iq`, `aq`             |          |        `.`        |         yes          | \_quotes         | inside of `` ` ` `` or `' '` or `" "`                                                     | outer includes openning and closing quotes                                    |
|             `is`, `as`             |          |        `.`        |                      | sentence         | sentence delimited by dots of blanklines `:help sentence`                                 | outer includes spaces                                                         |
|             `it`, `at`             |          |        `.`        |         yes          | \_tag            | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             | RetroVim |        `.`        |                      | \_subword        | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `iv`, `av`             | RetroVim |        `.`        |         yes          | \_value          | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |          |        `.`        |                      | word             | from cursor to end of word (delimited by punctuation or space)                            | outer includes whitespace ending                                              |
|             `iW`, `aW`             |          |        `.`        |                      | WORD             | from cursor to end of WORD (includes punctuation)                                         | outer includes whitespace ending                                              |
|             `ix`, `ax`             | RetroVim |        `.`        |         yes          | \_Hex            | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `iy`, `ay`             | RetroVim |        `.`        |                      | same_indent      | surrounding lines with only same indent (delimited by blankspaces or commented lines)     | outer includes blankspaces                                                    |
|             `i?`, `a?`             | RetroVim |        `.`        |         yes          | \_user_prompt    | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |          |        `.`        |         yes          | `(` or `)`       | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |          |        `.`        |         yes          | `[` or `]`       | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |          |        `.`        |         yes          | `{` or `}`       | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |          |        `.`        |         yes          | `<` or `>`       | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |          |        `.`        |         yes          | apostrophe       | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` | RetroVim |        `.`        |         yes          | `<punctuation>`  | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text-object/motions/operators that starts with `g`

<details open><summary></summary>

|      keymap       | requires |    mode     | repeat action key |    repeat jump key     | text-object description                                                   | `n`ormal mode = `n` = operator           | `o`perating-pending mode = `o` = text-object | `v`isual mode = `v` = `x` = motion      | examples in normal mode                                                             |
| :---------------: | :------: | :---------: | :---------------: | :--------------------: | :------------------------------------------------------------------------ | :--------------------------------------- | :------------------------------------------- | :-------------------------------------- | :---------------------------------------------------------------------------------- |
|    `[c` / `]c`    | RetroVim | `n`,`o`,`x` |        `.`        |                        | previous/next comment                                                     | finds and jumps                          | jumps                                        | uses selection                          | `v]c` selects from cursor position until next comment                               |
|    `[d` / `]d`    | RetroVim | `n`,`o`,`x` |        `.`        |                        | previous/next diagnostic                                                  | finds and jumps                          | jumps                                        | uses selection                          | `v]d` selects from cursor position until next diagnostic                            |
|    `[h` / `]h`    | RetroVim | `n`,`o`,`x` |        `.`        |                        | previous/next git hunk                                                    | finds and jumps                          | jumps                                        | uses selection                          | `v]h` selects from cursor position until next git hunk                              |
|    `[i` / `]i`    | RetroVim | `n`,`o`,`x` |        `.`        |                        | previous/next indent                                                      | finds and jumps                          | jumps                                        | uses selection                          | `v]i` selects from cursor position until next indent                                |
|     `g[`/`g]`     | RetroVim | `n`,`o`,`x` |        `.`        |                        | +prev/+next textobj (only textobj with `_` prefix)                        | followed by text-object                  | finds and jumps                              | uses selection                          | `g]q` next end of quotation                                                         |
|   `g\` / `g\|`    | RetroVim | `n`,`o`,`x` |        `.`        |       `\` / `\|`       | +end/+start of textobj (any inner/outer textobj)                          | followed by text-object                  | finds and jumps                              | uses selection (`\` / `\|` to reselect) | `dg\iq` delete until inner end of quotation (`.` to repeat)                         |
|    `qq ... q`     | RetroVim |   `n`,`x`   |        `.`        |   `\` or `@q` + `@@`   | repeats ... macro                                                         | followed by text-object                  |                                              | selects from cursor position            | `qqviqq` selects quotation (`\` to repeat)                                          |
|    `qw ... q`     | RetroVim |   `n`,`x`   |        `.`        |  `\|` or `@w` + `@@`   | repeats ... macro                                                         | followed by text-object                  |                                              | selects from cursor position            | `qwdiqq` delete inner quotation (`\| ` to repeat)                                   |
|     `g;`/`g,`     |          |     `n`     |                   |                        | go backward/forward in `:changes`                                         | jumps                                    |                                              |                                         | `g;` go to last change                                                              |
|       `g.`        | RetroVim | `n`,`o`,`x` |                   |                        | jump to last change                                                       | jumps                                    | won't jump                                   | uses selection                          | `vg.` selects from cursor position until last change                                |
|       `ga`        | RetroVim |   `n`,`x`   |                   |                        | +align                                                                    | followed by textobject/motion            |                                              | uses selected region                    | `gaip=` or `vipga=` aligns a paragraph by `=`                                       |
|       `gb`        | RetroVim |   `n`,`x`   |        `.`        |                        | +blackhole register                                                       | followed by textobject/motion            |                                              | deletes selection                       | `gbip` or `vipgb` deletes a paragraph without copying                               |
|       `gB`        | RetroVim |   `n`,`x`   |        `.`        |                        | blackhole linewise                                                        | text-object not required                 |                                              | deletes line                            | `gB.` deletes two lines without saving it in the register                           |
|       `gc`        |          | `n`,`o`,`x` |        `.`        |                        | +comment (`vgc` in normal mode will select a block comment)               | followed by textobject/motion            | won't jump                                   | uses selection                          | `gcip` or `vipgc` comments a paragraph                                              |
|       `gC`        | RetroVim | `n`,`o`,`x` |        `.`        |                        | block comment (supports selection `vgC` or just `gC`)                     | select text-object under cursor          | won't jump                                   | reselects                               | `vgC` selects current block of comment                                              |
|       `gd`        |          |     `n`     |                   |                        | go to definition                                                          | jumps                                    |                                              |                                         | `gd` go to definition of word under cursor                                          |
|       `gD`        | RetroVim |     `x`     |                   |                        | git diff/hunk (vscode selects from cursor position to end of diff)        |                                          | won't jump                                   | reselects                               | `vgD` selects modified code                                                         |
|     `ge`/`gE`     |          | `n`,`o`,`x` |                   |                        | previous end of word/WORD (`WORD` omits punctuation)                      | jumps                                    | uses cursor position                         | uses selection                          | `vge` selects from cursor position until previous end of word                       |
|       `gf`        |          |   `n`,`x`   |                   |                        | go to file under cursor                                                   | jumps                                    |                                              | uses selection                          | `gf` open in a tab the path under cursor                                            |
|     `gg`/`G`      |          | `n`,`o`,`x` |        `.`        |                        | first/last line                                                           | jumps                                    | uses cursor position                         | uses selection                          | `vgg` selects until first line                                                      |
|       `gi`        |          |   `n`,`x`   |                   |                        | last position of cursor in insert mode                                    | finds and jumps                          |                                              | uses selection                          | `vgi` selects until last insertion                                                  |
|     `gj`/`gk`     |          | `n`,`o`,`x` |        `.`        |                        | go down/up when wrapped                                                   | jumps                                    | uses cursor position                         | uses selection                          | `vgj` selects one line down                                                         |
|       `gJ`        |          |   `n`,`x`   |        `.`        |                        | join below lines                                                          | joins                                    |                                              | uses selection                          | `vgJ` joins selected lines into one line                                            |
|       `gm`        | RetroVim |   `n`,`x`   |                   |                        | +multiply (duplicate text) operator                                       |                                          | won't jump                                   | uses selection                          | `gmap` or `vapgm` duplicates paragraph without replacing clipboard                  |
|       `gM`        |          |   `n`,`x`   |                   |                        | go to middle line                                                         | jumps                                    |                                              | uses selection                          | `vgM` selects until middle of the line                                              |
|     `gp`/`gn`     | RetroVim | `n`,`o`,`x` |        `.`        |                        | prev/next find                                                            | text-object not required                 | finds and jumps                              | uses selection                          | `cgn???` replaces last search with `???` forwardly                                  |
|       `go`        |  neovim  |     `x`     |                   |                        | jsx/tsx comment (only inside neovim)                                      |                                          |                                              | uses selection                          | `vipgt` comments out a paragraph with `{/* */}`                                     |
|       `gq`        |          |   `n`,`x`   |        `.`        |                        | +format selection/comments 80chars (LSP overrides it)                     | requires a textobject                    |                                              | applies to selection                    | `gqip` or `vipgq` formats a paragraph                                               |
|       `gr`        | RetroVim |   `n`,`x`   |        `.`        |                        | +replace (with register) operator                                         | followed by text-object/motion           |                                              | applies to selection                    | `griw` or `viwgr` replaces word with register (yanked text)                         |
|       `gs`        | RetroVim |   `n`,`x`   |        `.`        |                        | +sort Operator                                                            | followed by text-object/motion           |                                              | uses selection                          | `gsip` or `vipgs` sorts a paragraph                                                 |
|       `gS`        | RetroVim |   `n`,`x`   |        `.`        |                        | split/join arguments                                                      | toggles inside `{}`,`[]`,`()`            |                                              | followed by operator                    | `vipgS` joins selected lines in one line                                            |
|     `gu`/`gU`     |          |   `n`,`x`   |        `.`        |                        | +to lowercase/uppercase                                                   | requires a text-object                   |                                              | applies to selection                    | `gUiw` (neovim and cvim only) or `viwgU` uppercase a word                           |
|       `gv`        |          |   `n`,`x`   |                   |                        | last selected                                                             | finds and jumps                          |                                              | reselects                               | `vgv` selects last selection                                                        |
|       `gw`        |          |   `n`,`x`   |        `.`        |                        | split/join comments/lines 80chars (keeps cursor position)                 | requires a text-object                   |                                              | applies to selection                    | `gwip` or `vipgw` split/join a paragraph limited by 80 characters                   |
|       `gx`        | RetroVim |   `n`,`x`   |        `.`        |                        | +exchange (text) Operator                                                 | followed by text-object/motion           |                                              | uses selection                          | `gxiw` or `viwgx` exchanges word with another `gxiw` or `viwgx` or `.`              |
|     `gy`/`gY`     | RetroVim |     `n`     |        `.`        |                        | redo register (dot to paste forward/bacward)                              | paste                                    |                                              |                                         | `gy.....` paste deleted lines by history                                            |
|     `g-`/`g+`     | RetroVim |   `n`,`x`   |        `.`        |                        | decrement/increment number                                                | selects number under cursor              |                                              | uses selected number                    | `g+..` or `3g+` increments by 3                                                     |
| `g<Up>`/`g<Down>` | RetroVim |   `n`,`x`   |                   |                        | numbers ascending/descending                                              | selects number under cursor              |                                              | uses selected number                    | `g<Up>` increases selected numbers ascendingly                                      |
|        `=`        |          |   `n`,`x`   |        `.`        |                        | +autoindent                                                               | followed by text-object                  |                                              | uses selection                          | `==` autoindents line                                                               |
|      `<`/`>`      |          |   `n`,`x`   |        `.`        |                        | +indent left/right                                                        | followed by text-object                  |                                              | uses selection                          | `<<` indents to left a line                                                         |
|      `0`/`$`      |          | `n`,`o`,`x` |        `.`        |                        | start/end of line                                                         | jumps                                    |                                              | uses selection                          | `d$j.` deletes two end-of-lines                                                     |
|        `^`        |          | `n`,`o`,`x` |        `.`        |                        | start of line (non-blankline)                                             | jumps                                    |                                              | uses selection                          | `d^` deletes until start of line (after whitespace)                                 |
|        `%`        |          | `n`,`o`,`x` |                   |                        | matching character: '()', '{}', '[]'                                      | finds and jumps                          |                                              | finds and jumps                         | `d%` deletes until bracket                                                          |
|      `(`/`)`      |          | `n`,`o`,`x` |        `.`        |                        | prev/next sentence                                                        | jumps                                    |                                              | uses selection                          | `d(.` deletes until start of sentence (two times)                                   |
|      `{`/`}`      |          | `n`,`o`,`x` |        `.`        |                        | prev/next empty line (before a paragraph)                                 | jumps                                    |                                              | uses selection                          | `d{.` deletes until next empty line (two times)                                     |
|     `[[`/`]]`     |          | `n`,`o`,`x` |        `.`        |                        | prev/next section                                                         | jumps                                    |                                              | uses selection                          | `d[[` deletes until start of section                                                |
|      `b`/`w`      |          | `n`,`o`,`x` |        `.`        |                        | prev/next word                                                            | jumps                                    |                                              | uses selection                          | `db` deletes until start of word                                                    |
|      `B`/`W`      |          | `n`,`o`,`x` |        `.`        |                        | prev/next WORD                                                            | jumps                                    |                                              | uses selection                          | `dW.` deletes 2 WORDS                                                               |
|      `e`/`E`      |          | `n`,`o`,`x` |        `.`        |                        | end of word/WORD                                                          | jumps                                    |                                              | uses selection                          | `de` deletes until end of word                                                      |
|        `/`        | RetroVim | `n`,`o`,`x` |        `.`        |                        | search with labels like [flash.nvim](https://github.com/folke/flash.nvim) | jumps                                    | finds and jumps                              | uses selection                          | `d/` then `search` then `label` to delete `c/` to change `v/` to select `/` to jump |
|        `f`        |   cvim   | `n`,`o`,`x` |        `.`        |                        | search with labels like [flash.nvim](https://github.com/folke/flash.nvim) | jumps                                    | finds and jumps                              | uses selection                          | `f` then `search` then `label` or `operator` + `f` + `search` + `label`             |
|      `f`/`F`      |          | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move to next/prev char (`f` forward, `F` backward for vscode-neovim)      | jumps                                    |                                              | uses selection                          | `df,` deletes until a next `,`                                                      |
|      `t`/`T`      |          | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move before next/prev char (`t` forward, `T` backward for vscode-neovim)  | jumps                                    |                                              | uses selection                          | `dt,` deletes before next `,`                                                       |
|        `s`        |          |     `o`     |        `.`        |                        | surround (only on vscodevim)                                              |                                          | uses cursor position                         |                                         | `ysiw"` or `viwS"` adds `"` to word, `ds"` deletes `"`, `cs"'` replaces `"`         |
|        `s`        | RetroVim |   `n`,`x`   |        `.`        |                        | +surround (followed by a=add, d=delete, r=replace)                        | followed by textobject/motion (only add) |                                              | uses selection (only add)               | `saiw"` or `viwsa"` adds `"` to word, `sd"` deletes `"`, `sr"'` replaces `"`        |
|        `U`        |  neovim  |   `n`,`x`   |                   |          `U`           | whichkey repeater (inside neovim repeats `:<command>` like macros)        |                                          |                                              |                                         | `<s-space>gjUUU` repeats next-git-change (`:normal A,jkj` end of line comma)        |
|        `Y`        |          |   `n`,`x`   |                   |                        | yank until end of line                                                    |                                          |                                              | uses selection                          | `v^Y` yanks line                                                                    |
| `<space><space>p` | RetroVim |   `n`,`x`   |        `.`        |                        | Paste after (secondary clipboard)                                         |                                          |                                              | uses selection                          | `viw<space><space>p` replaces word with a second clipboard                          |
| `<space><space>P` | RetroVim |   `n`,`x`   |        `.`        |                        | Paste before (secondary clipboard)                                        |                                          |                                              | uses selection                          | `viw<space><space>P` replaces word with a second clipboard                          |
| `<space><space>y` | RetroVim |   `n`,`x`   |                   |                        | yank (secondary clipboard)                                                |                                          |                                              | uses selection                          | `viw<space><space>y` yanks word using the second clipboard                          |
| `<space><space>Y` | RetroVim |   `n`,`x`   |                   |                        | yank until end of line (secondary clipboard)                              |                                          |                                              | uses selection                          | `v<space><space>Y` yanks until end of line using the second clipboard               |

</details>

## Native neovim ctrl keys

<details open><summary></summary>

| Key Combination |  mode   | Description                                                                                                                                        |
| :-------------: | :-----: | :------------------------------------------------------------------------------------------------------------------------------------------------- |
|    `ctrl+a`     | `n`,`v` | increase number under cursor                                                                                                                       |
|    `ctrl+c`     |   `v`   | stops selection                                                                                                                                    |
|    `ctrl+d`     | `n`,`v` | scroll down by half page (vscodevim maps to multi-cursor mode)                                                                                     |
|    `ctrl+e`     | `n`,`v` | scroll down by line                                                                                                                                |
|    `ctrl+i`     |   `n`   | jump to next in `:jumps`                                                                                                                           |
|    `ctrl+o`     |   `n`   | jump to previous in `:jumps`                                                                                                                       |
|    `ctrl+r`     |   `n`   | redo (`u` to undo)                                                                                                                                 |
|    `ctrl+s`     | `n`,`v` | replace text (using `sed` syntax)(only replaces selected region on visual mode)(neovim only)                                                       |
|    `ctrl+u`     | `n`,`v` | scroll up by half page                                                                                                                             |
|    `ctrl+v`     | `n`,`v` | visual block mode                                                                                                                                  |
|    `ctrl+w`     | `n`,`v` | See [vscode-window-commands.vim](https://github.com/vscode-neovim/vscode-neovim/blob/v1.18.17/runtime/vscode/overrides/vscode-window-commands.vim) |
|    `ctrl+x`     | `n`,`v` | decrease number under cursor                                                                                                                       |
|    `ctrl+y`     | `n`,`v` | scroll up by line                                                                                                                                  |
|    `ctrl+/`     | `n`,`v` | comment line (only inside vscode)                                                                                                                  |

</details>

## File Explorer keymaps

<details open><summary></summary>

|   Key Combination   | Description                                                                                      | compatibility |
| :-----------------: | :----------------------------------------------------------------------------------------------- | :-----------: |
|      `ctrl+f`       | search file [`/` doesn't work on cvim](https://github.com/vscode-neovim/vscode-neovim/pull/1015) |    vscode     |
|         `/`         | search file                                                                                      |    neovim     |
|         `a`         | create new file or folder (`path/to/file` creates 2 folders and 1 file)                          | vscode/neovim |
|         `d`         | delete file                                                                                      | vscode/neovim |
|        `gg`         | focus first file                                                                                 | vscode/neovim |
|         `G`         | focus last file                                                                                  | vscode/neovim |
|         `h`         | collapse list                                                                                    | vscode/neovim |
|         `j`         | move down                                                                                        | vscode/neovim |
|         `k`         | move up                                                                                          | vscode/neovim |
|   `l` or `enter`    | open directory/file passing focus                                                                | vscode/neovim |
|         `J`         | move focus down 10 times in list view                                                            |    vscode     |
|         `K`         | move focus up 10 times in list view                                                              |    vscode     |
|         `L`         | open and toggle sidebar visibility                                                               |    vscode     |
|   `o` or `space`    | open without passing focus replacing current tab                                                 |    vscode     |
|         `O`         | open without passing focus in a new tab                                                          |    vscode     |
|         `p`         | paste file                                                                                       | vscode/neovim |
|         `q`         | close sidebar visibility                                                                         | vscode/neovim |
|         `r`         | rename file                                                                                      | vscode/neovim |
|         `v`         | open selected file to the side and toggle sidebar visibility                                     |    vscode     |
|         `V`         | open selected file to the bottom and toggle sidebar visibility                                   |    vscode     |
|      `ctrl+v`       | open selected file to the side and toggle sidebar visibility                                     |    neovim     |
|      `ctrl+s`       | open selected file to the bottom and toggle sidebar visibility                                   |    neovim     |
|         `m`         | cut/move file                                                                                    |    neovim     |
|         `x`         | cut file                                                                                         |    vscode     |
|         `y`         | copy file                                                                                        | vscode/neovim |
|       `Down`        | focus down and preview file                                                                      | vscode/neovim |
|        `Up`         | focus up and preview file                                                                        | vscode/neovim |
| `<unmapped letter>` | find (by first `<unmapped letter>` of file/folder) and jump                                      |    vscode     |
|         `?`         | show all snacks explorer keymaps                                                                 |    neovim     |

</details>

## Editor keymaps (keybindings.json)

<details open><summary></summary>

|         Key Combination          |    mode     | Description                                           | compatibility |
| :------------------------------: | :---------: | :---------------------------------------------------- | :-----------: |
|               `/`                |     `n`     | search (`ctrl+p`/`up`/`ctrl+n`/`down` search history) | vscode/neovim |
|            `<space>o`            |     `n`     | view file explorer                                    | vscode/neovim |
|             `ctrl+\`             |   `n`,`i`   | toggle panel (terminal) visibility                    | vscode/neovim |
|             `escape`             |     `n`     | clear search highlight                                | vscode/neovim |
|          `shift+escape`          |     `n`     | close any popup window like diff/diagnostic etc       | vscode/neovim |
|          `shift+space`           |     `n`     | show whichkey menu (Windows, Linux, Mac)              |    vscode     |
|           `alt+space`            |     `n`     | show whichkey menu (Linux, Mac)                       |    vscode     |
|             `space`              |     `n`     | show whichkey menu                                    |    neovim     |
|             `alt+o`              | `n`,`i`,`x` | yazi file manager (selection is open with vscode)     |    vscode     |
|             `alt+c`              |     `i`     | copy                                                  | vscode/neovim |
|             `alt+v`              |     `i`     | paste                                                 | vscode/neovim |
|               `jk`               |     `i`     | enter vim normal mode                                 | vscode/neovim |
|             `alt+h`              |   `i`,`x`   | enter vim normal mode                                 | vscode/neovim |
|            `shift+h`             |     `n`     | cursorLeft `10` times                                 | vscode/neovim |
|            `shift+j`             |     `n`     | cursorDown `10` times                                 | vscode/neovim |
|            `shift+k`             |     `n`     | cursorUp `10` times                                   | vscode/neovim |
|            `shift+l`             |     `n`     | cursorRigth `10` times                                | vscode/neovim |
|             `alt+s`              |     `n`     | go to previous tab                                    |    vscode     |
|             `alt+f`              |     `n`     | go to next tab                                        |    vscode     |
|              `left`              |     `n`     | go to previous tab                                    | vscode/neovim |
|             `right`              |     `n`     | go to next tab                                        | vscode/neovim |
| `ctrl+shift+h` or `ctrl+shift+j` |     `n`     | decrease view size of current window or terminal      | vscode/neovim |
| `ctrl+shift+l` or `ctrl+shift+k` |     `n`     | increase view size of current window or terminal      | vscode/neovim |
|           `shift+left`           |     `n`     | resize to left window                                 |    neovim     |
|           `shift+down`           |     `n`     | resize to down window                                 |    neovim     |
|            `shift+up`            |     `n`     | resize to up window                                   |    neovim     |
|          `shift+right`           |     `n`     | resize to right window                                |    neovim     |
|             `ctrl+h`             |     `n`     | navigate to left window                               | vscode/neovim |
|             `ctrl+j`             |     `n`     | navigate to down window                               | vscode/neovim |
|             `ctrl+k`             |     `n`     | navigate to up window                                 | vscode/neovim |
|             `ctrl+l`             |     `n`     | navigate to right window                              | vscode/neovim |
|            `shift+q`             |     `n`     | close active tab                                      | vscode/neovim |
|            `shift+r`             |     `n`     | format and save                                       | vscode/neovim |
|         `ctrl+alt+left`          | `n`,`i`,`x` | select left word (on multi cursor)                    |    vscode     |
|         `ctrl+alt+right`         | `n`,`i`,`x` | select right word (on multi cursor)                   |    vscode     |
|        `<ctr+x><ctrl+o>`         |     `i`     | to expand emmet-ls                                    |    neovim     |

</details>

## Suggestion keymaps

<details open><summary></summary>

|  Key Combination   | mode | Description                                                        | compatibility |
| :----------------: | :--: | :----------------------------------------------------------------- | :-----------: |
|    `ctrl+space`    | `i`  | toggle suggestion widget                                           |    vscode     |
| `ctrl+shift+space` | `i`  | toggle suggestion details (when inside widget)                     |    vscode     |
| `ctrl+shift+space` | `i`  | toggle parameter hints (when inside parameters)                    |    vscode     |
|    `ctrl+space`    | `i`  | mini.completion show                                               |    neovim     |
|      `ctrl+y`      | `i`  | mini.completion acccept                                            |    neovim     |
|      `ctrl+e`      | `i`  | mini.completion cancel/hide                                        |    neovim     |
|      `ctrl+n`      | `i`  | mini.completion select next                                        |    neovim     |
|      `ctrl+p`      | `i`  | mini.completion select prev                                        |    neovim     |
|      `ctrl+f`      | `i`  | mini.completion scroll info down                                   |    neovim     |
|      `ctrl+b`      | `i`  | mini.completion scroll info up                                     |    neovim     |
|      `ctrl+d`      | `i`  | scroll down (when inside suggestion details)                       |    vscode     |
|      `ctrl+u`      | `i`  | scroll up (when inside suggestion details)                         |    vscode     |
|      `ctrl+h`      | `i`  | toggle suggestion focus (when inside widget)                       |    vscode     |
|      `ctrl+j`      | `i`  | select next suggestion                                             |    vscode     |
|      `ctrl+k`      | `i`  | select prev suggestion                                             |    vscode     |
|      `ctrl+l`      | `i`  | accept selected suggestion                                         |    vscode     |
|      `ctrl+i`      | `i`  | prompt to AI (gemini/windsurf/copilot)                             |    vscode     |
|      `ctrl+k`      | `i`  | prompt to AI (cursor)                                              |    vscode     |
|      `ctrl+.`      | `i`  | fix error with AI (windsurf/cursor/copilot)                        |    vscode     |
|      `alt+]`       | `i`  | show next AI suggestion                                            | vscode/neovim |
|      `alt+[`       | `i`  | show previous AI suggestion                                        | vscode/neovim |
|      `alt+j`       | `i`  | AI suggestion accept next word                                     | vscode/neovim |
|      `alt+k`       | `i`  | AI suggestion accept next line                                     | vscode/neovim |
|      `alt+l`       | `i`  | accept AI/NES suggestion (TRAE/AMP/gemini/windsurf/cursor/copilot) | vscode/neovim |
|      `alt+;`       | `i`  | trigger Next-Edit-Suggestion from AI (`alt+l` to accept)           |    vscode     |
|      `alt+;`       | `i`  | accept Next-Edit-Suggestion from AI                                |    neovim     |
| `escape` / `alt+'` | `i`  | cancel Next-Edit-Suggestion from AI                                | vscode/neovim |
|       `tab`        | `i`  | go to next snippet stop or next suggestion                         |    vscode     |
|    `shift+tab`     | `i`  | go to prev snippet stop or prev suggestion                         |    vscode     |
|      `alt+n`       | `i`  | go to next snippet stop                                            | vscode/neovim |
|      `alt+p`       | `i`  | go to prev snippet stop                                            | vscode/neovim |
|      `alt+.`       | `i`  | expand snippet                                                     |    neovim     |
|      `ctrl+c`      | `i`  | exit snippet session                                               |    neovim     |

</details>

## vscode terminal keymaps

<details open><summary></summary>

| Key Combination    | Description                                 |
| :----------------- | :------------------------------------------ |
| `ctrl+\`           | toggle panel (terminal) visibility          |
| `alt+y`            | send sequence to open yazi                  |
| `alt+ctrl+r`       | select from shell history                   |
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
| `shift+space`      | tmux-copy-mode-like                         |
| `ctrl+shift+f`     | find text                                   |
| `ctrl+plus`        | zoom in                                     |
| `ctrl+minus`       | zoom out                                    |

</details>

---

## zsh keymaps

<details open><summary></summary>

|       keymap        | description                                                |
| :-----------------: | :--------------------------------------------------------- |
|       `<tab>`       | show (dash/path) options or complete path                  |
|    `<tab><tab>`     | enter completion menu                                      |
|    `<esc><esc>`     | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|   `shift+escape`    | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|    `nvim<enter>`    | open retronvim's neovim IDE (`<space>` to open whichkey)   |
|     `y<enter>`      | open yazi (changes directory on exit)                      |
| `alt+o` or `<esc>o` | open yazi (even while writing commands)                    |
| `alt+h` or `<esc>`  | enter vim-mode                                             |
|       `alt+l`       | complete inline/ghost suggestion and enter vim-mode        |
|       `alt+j`       | prev shell history and enter vim-mode                      |
|       `alt+k`       | next shell history and enter vim-mode                      |
|        `Up`         | prev shell history                                         |
|       `Down`        | next shell history                                         |
|      `ctrl+r`       | search history with fzf                                    |
|      `ctrl+l`       | clear screen                                               |
|    `ctrl+alt+l`     | clear screen (inside neovim terminal or vscode terminal)   |
|      `ctrl+d`       | exit signal                                                |
|      `ctrl+c`       | cancel signal                                              |

</details>

---

## If Touchcursor Keyboard Layout Started

<details open><summary></summary>

**layer qwerty**

```
@grl 1    2    3    4    5    6    7    8    9    0    -    =    @bsp
tab  q    w    @e   r    t    y    u    i    o    p    [    ]    ret
@cap a    @s   @d   f    g    @h   @j   @k   @l   @;   '    \
lsft ret  z    x    c    v    b    n    m    ,    .    /    rsft
lctl lmet @alt           @spc           @sft rmet rctl
```

**layer touchcursor** (press and hold space to enter the layer)

```
_    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  _
_    @M↑  del  @m↑  @clr @m🡠  _    _    _    _    _    _    _    _
_    @M↓  @bsp @m↓  spc  @m🡪  @🡠   @↓   @↑   @🡪   @yaz _    _
_    _    _    _    caps @¿   @ñ   pgup home end  pgdn _    _
_    _    _              _              _    _    _
```

| key  | description                                                                               |          example / keymap          |
| :--: | :---------------------------------------------------------------------------------------- | :--------------------------------: |
| @grl | tap: backtick/grave, hold and press `1` = qwerty layer, hold and press `2` = dvorak layer |         `` `+2 = dvorak ``         |
| @cap | tap for escape, hold for LeftCtrl                                                         |          `cap+l = ctrl+l`          |
| @sft | tap for backspace, hold for LeftShift                                                     |         `RAlt+l = shift+l`         |
| @alt | tap for middle click, hold for LeftAlt                                                    |         `LAlt+l = LAlt+l`          |
| @spc | tap for space, hold for touchcursor layer, release for qwerty layer                       | `space+jj = DownArrow + DownArrow` |
|  @;  | tap for semicolon, hold for ctrl                                                          | `;+click = OpenInNewTab (chrome)`  |
| @clr | clear screen on any shell                                                                 |             `space+r`              |
|  @¿  | unicode ¿                                                                                 |             `space+v`              |
|  @ñ  | unicode ñ                                                                                 |             `space+b`              |
| @m🡠  | mouse scrolling left                                                                      |             `space+t`              |
| @m🡪  | mouse scrolling right                                                                     |             `space+g`              |
| @m↑  | mouse scrolling up                                                                        |             `space+e`              |
| @m↓  | mouse scrolling down                                                                      |             `space+d`              |
| @M↑  | mouse fast scrolling up                                                                   |             `space+q`              |
| @M↓  | mouse fast scrolling down                                                                 |             `space+a`              |
| spc  | space key                                                                                 |             `space+f`              |
| bspc | backspace key                                                                             |             `space+s`              |
| home | home key                                                                                  |             `space+m`              |
| end  | end key                                                                                   |             `space+,`              |
| pgup | pageup key                                                                                |             `space+n`              |
| pgdn | pagedown key                                                                              |             `space+.`              |
|  @🡠  | left arrow key                                                                            |             `space+h`              |
|  @↓  | down arrow key                                                                            |             `space+j`              |
|  @↑  | up arrow key                                                                              |             `space+k`              |
|  @🡪  | right arrow key                                                                           |             `space+l`              |
| caps | toggles capslock                                                                          |             `space+c`              |

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

- `Touchcursor Keyboard Layout` on `MacOs` requires `zb install karabiner` or
  open `whichkey` > `+Install Dependencies` > `install brew karabiner`

- `terax` on `archlinux` requires `pacman -S webkit2gtk-4.1`

- `terax` on `debian` requires `apt install webkit2gtk-4.1-dev`

- `terax` on `linux` requires `chsh --shell /bin/zsh` (sets zsh as default shell)

- `terax` requires the setting `Font family: FiraCode Nerd Font` for icons support

**Manual Install**

- Linux/MacOS:

  ```bash
  curl -L pixi.sh/install.sh | sh
  source ~/.zshrc
  pixi global install nodejs retronvim -c retronvim -c conda-forge

  git clone https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out   retronvim.vsix
  code --install-extension retronvim.vsix
  ```

- Windows 10/11:

  ```powershell
  winget install prefix-dev.pixi microsoft.visualstudiocode ###### then relaunch terminal
  pixi global install nodejs retronvim -c retronvim -c conda-forge

  git clone https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out   retronvim.vsix
  code --install-extension retronvim.vsix
  ```

**Install RetroNvim on any terminal or shell**

- Powershell (windows):

  ```bash
  irm pixi.sh/install.ps1 | iex
  pixi g install retronvim -c retronvim -c conda-forge
  ```

- SSH/Bash/Zsh (linux/macos):

  ```bash
  sh <(curl https://pkgx.sh) pixi g install retronvim -c retronvim -c conda-forge --with pixi
  ```

**Install RetroVim (for vscode-neovim support)**

- ```bash
  pixi g uninstall retronvim
  pixi g   install retrovim  -c retronvim -c conda-forge

  code --uninstall-extension cuixiaorui.cvim
  code   --install-extension asvetliakov.vscode-neovim
  ```

**Install from github releases (offline)(portable)**
open command palette `ctrl+shift+p` then type `Extensions: install from vsix`.

**VSCode Marketplace**

- RetroNvim.conda is shipped with
  - [`appman`](https://github.com/ivan-hc/Am)
  - [`bat`](https://github.com/sharkdp/bat)
  - [`eza`](https://github.com/eza-community/eza)
  - [`firacode_nerd_font`](https://github.com/ryanoasis/nerd-fonts)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`git`](https://github.com/git-for-windows/git)
  - [`kanata`](https://github.com/jtroo/kanata)
  - [`lazygit`](https://github.com/jesseduffield/lazygit)
  - [`lazyvim`](https://github.com/lazyvim/lazyvim)
  - [`neovim`](https://neovim.io)
  - [`pixi`](https://github.com/prefix-dev/pixi)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`starship`](https://github.com/starship/starship)
  - [`terax`](https://github.com/crynta/terax-ai)
  - [`yazi`](https://github.com/sxyazi/yazi)
  - [`zerobrew`](https://github.com/lucasgelfond/zerobrew)
  - [`zsh`](https://github.com/zsh-users/zsh)
  - [`zsh-patina`](https://github.com/michel-kraemer/zsh-patina)
  - [`7zip`](https://github.com/ip7z/7zip)

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

- RetroVim/nvim searches for vscode extensions's snippets in `~/.*/extensions/*/snippets/*code-snippets`
  (alphabetically first `~/.antigravity` otherwise `~/.cursor` otherwise `~/.vscode` otherwise `~/.windsurf`)
  and automatically adds them to `mini.completion`
  - if you see: `No contains a valid JSON object` then to fix it use biome linter usually it is extras commas or comments
  - if you see: `File is absent or not readable` then delete the file to make `mini.snippet` work

- Retronvim comes with [bat's base16](https://github.com/sharkdp/bat/blob/master/assets/themes/base16.tmTheme)
  syntax highlighting generated by `npx yo code --extensionType colortheme` and
  a editor theme generated using https://themes.vscode.one

- https://marketplace.visualstudio.com/items?itemName=YeferYV.retronvim

</details>

## Trobleshotting

<details open><summary></summary>

- remove
  `vscode-neovim.neovimExecutablePaths.linux`
  `vscode-neovim.neovimExecutablePaths.win32`
  `vscode-neovim.neovimExecutablePaths.darwin` from
  `settings.json` and relaunch vscode

- open vscode command palette and type: `Output: Show Output Channels` > `vscode-neovim logs`

</details>

## Package Manager (optional)

<details open><summary></summary>

- `zerobrew` (preinstalled) for macos and linux (linux gui programs not supported)
- `whichkey > +Install Dependencies > install nix-env` for linux (gpu programs requires nixGL)
- `whichkey > +Install Dependencies > install scoop` for windows
- `appman` (preinstalled) for linux
- `pixi` (preinstalled) for macos, linux, windows

</details>

## Vim Cheatsheets / Tutorials

<details open><summary></summary>

- [devhints.io/vim](https://devhints.io/vim)
  most used vim keys

- [viemu.com](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)
  vim keys from A-Z

- [vscode with embedded neovim](https://www.youtube.com/watch?v=g4dXZ0RQWdw)
  youtube tutorial most of the keybindings are similar to RetroNvim

- [treesitter text-objects demo](https://www.youtube.com/watch?v=FuYQ7M73bC0)
  youtube tutorial most of the keybindings are similar to RetroNvim

- [treesitter text-objects extended](https://www.youtube.com/watch?v=CEMPq_r8UYQ)
  youtube tutorial most of the keybindings are similar to RetroNvim

- [text-objects from A-Z](https://www.youtube.com/watch?v=JnD9Uro_oqc)
  youtube tutorial most of the keybindings are similar to RetroNvim

- [motion-operators from A-Z](https://www.youtube.com/watch?v=HhZJ1kbzkj0)
  youtube tutorial most of the keybindings are similar to RetroNvim

</details>

## Related projects

<details open><summary></summary>

- [yeferyv/dotfiles](https://github.com/yeferyv/dotfiles)
  retronvim + [hyprland](https://hypr.land) setup

- [yeferyv/RetroVim](https://github.com/yeferyv/sixelrice)
  neovim IDE using 01 plugins (with copilot, agents, text-objects, whichkey ...)

- [lazyvim](https://github.com/lazyvim/lazyvim)
  neovim IDE using 32 plugins (with copilot, agents, text-objects, whichkey ...)

- [binvim](https://github.com/bgunnarsson/binvim/)
  neovim IDE written in rust (with copilot, agents, text-objects, whichkey ...)

- [lunarkeymap](https://github.com/fathulfahmy/lunarkeymap)
  comes with [vscodevim](https://github.com/vscodevim/vim) extension
  which has some text objects + whichkey with [lunarvim](https://github.com/lunarvim/lunarvim)-like keymaps

- [vspacecode](https://github.com/vspacecode/vspacecode)
  comes with [vscodevim](https://github.com/vscodevim/vim) extension
  which has some text objects + whichkey with [spacemacs](https://github.com/syl20bnr/spacemacs)-like keymaps

- [leaderKey](https://github.com/JimmyZJX/leaderkey)
  (a faster whichkey with ripgrep/fzf integration) whichkey
  with [spacemacs](https://github.com/syl20bnr/spacemacs)-like keymaps

</details>
