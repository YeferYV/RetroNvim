<video controls autoplay loop muted playsinline src="https://github.com/YeferYV/RetroNvim/assets/37911404/4f7002a2-324e-4597-9644-5ab0cd7c5831" title="Demo"></video>

<div align="center"><p>

Neovim text objects + LSP whichkey + touchcursor keyboard layout + minimal zsh/yazi/nvim/powershell setup

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
   - [Neovim text-object/motions that starts with g](#neovim-text-objectmotions-that-starts-with-g)
   - [Native neovim ctrl keys](#native-neovim-ctrl-keys)
2. Keybindings.json
   - [File Explorer keymaps](#file-explorer-keymaps)
   - [Editor keymaps (keybindings.json)](#editor-keymaps-keybindingsjson)
   - [Suggestion keymaps](#suggestion-keymaps)
3. Terminal
   - [Terminal keymaps](#terminal-keymaps)
   - [zsh/powershell keymaps](#zshpowershell-keymaps)
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

|         text-object keymap         | requires      | repeat action key | finds and autojumps? | text-object name | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :------------ | :---------------: | :------------------: | :--------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |               |        `.`        |         yes          | \_argument       | whole argument/parameter of a function                                                    | outer includes comma                                                          |
|             `ib`, `ab`             |               |        `.`        |         yes          | \_braces         | find the nearest inside of `()` `[]` `{}`                                                 | outer includes braces                                                         |
|             `iB`, `aB`             |               |        `.`        |         yes          | \_brackets       | find the nearest inside of `{}` `:help iB`                                                | outer includes brackets                                                       |
|             `id`, `ad`             | neovim        |        `.`        |         yes          | diagnostic       | find errors, warnings, info or hints (only works inside neovim and requires LSP)          | outer same as inner                                                           |
|             `ie`, `ae`             | vscode-neovim |        `.`        |                      | line             | from start to end of line without beginning whitespaces (line wise)                       | outer includes begining whitespaces                                           |
|             `if`, `af`             | vscode-neovim |        `.`        |         yes          | \_function_call  | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `ih`, `ah`             | vscode-neovim |        `.`        |         yes          | \_html_attribute | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |               |        `.`        |                      | indent_noblanks  | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             | vscode-neovim |        `.`        |                      | indent           | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ik`, `ak`             | vscode-neovim |        `.`        |         yes          | \_key            | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `il`, `al`             | vscode-neovim |        `.`        |         yes          | +last            | go to last mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `vilk`                                               |
|             `im`, `am`             | vscode-neovim |        `.`        |         yes          | \_number         | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `in`, `an`             | vscode-neovim |        `.`        |         yes          | +next            | go to Next mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `viNk`                                               |
|             `io`, `ao`             | vscode-neovim |        `.`        |         yes          | \_whitespaces    | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |               |        `.`        |                      | paragraph        | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iq`, `aq`             |               |        `.`        |         yes          | \_quotes         | inside of `` ` ` `` or `' '` or `" "`                                                     | outer includes openning and closing quotes                                    |
|             `is`, `as`             |               |        `.`        |                      | sentence         | sentence delimited by dots of blanklines `:help sentence`                                 | outer includes spaces                                                         |
|             `it`, `at`             |               |        `.`        |         yes          | \_tag            | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             | vscode-neovim |        `.`        |                      | \_subword        | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `iv`, `av`             | vscode-neovim |        `.`        |         yes          | \_value          | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |               |        `.`        |                      | word             | from cursor to end of word (delimited by punctuation or space)                            | outer includes whitespace ending                                              |
|             `iW`, `aW`             |               |        `.`        |                      | WORD             | from cursor to end of WORD (includes punctuation)                                         | outer includes whitespace ending                                              |
|             `ix`, `ax`             | vscode-neovim |        `.`        |         yes          | \_Hex            | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `iy`, `ay`             | vscode-neovim |        `.`        |                      | same_indent      | surrounding lines with only same indent (delimited by blankspaces or commented lines)     | outer includes blankspaces                                                    |
|             `i?`, `a?`             | vscode-neovim |        `.`        |         yes          | \_user_prompt    | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |               |        `.`        |         yes          | `(` or `)`       | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |               |        `.`        |         yes          | `[` or `]`       | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |               |        `.`        |         yes          | `{` or `}`       | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |               |        `.`        |         yes          | `<` or `>`       | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |               |        `.`        |         yes          | apostrophe       | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` | vscode-neovim |        `.`        |         yes          | `<punctuation>`  | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text-object/motions that starts with `g`

<details open><summary></summary>

| text-object keymap | requires      |    mode     | repeat action key |    repeat jump key     | text-object description                                                   | normal mode                              | operating-pending mode | visual mode                  | examples in normal mode                                                      |
| :----------------: | :------------ | :---------: | :---------------: | :--------------------: | :------------------------------------------------------------------------ | :--------------------------------------- | :--------------------- | :--------------------------- | :--------------------------------------------------------------------------- |
|     `g<`/`g>`      | vscode-neovim | `n`,`o`,`x` |        `.`        |                        | prev/next find                                                            | text-object not required                 | finds and jumps        | uses selection               | `cg>???` replaces last search with `???` forwardly                           |
|     `g;`/`g,`      |               |     `n`     |                   |                        | go backward/forward in `:changes`                                         | jumps                                    |                        |                              | `g;` go to last change                                                       |
|        `g.`        | vscode-neovim | `n`,`o`,`x` |                   |                        | jump to last change                                                       | jumps                                    | won't jump             | uses selection               | `vg.` selects from cursor position until last change                         |
|        `ga`        | vscode-neovim |   `n`,`x`   |                   |                        | +align                                                                    | followed by textobject/motion            |                        | uses selected region         | `gaip=` or `vipga=` aligns a paragraph by `=`                                |
|        `gb`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | +blackhole register                                                       | followed by textobject/motion            |                        | deletes selection            | `gbip` or `vipgb` deletes a paragraph without copying                        |
|        `gB`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | blackhole linewise                                                        | text-object not required                 |                        | deletes line                 | `gB.` deletes two lines without saving it in the register                    |
|        `gc`        |               | `n`,`o`,`x` |        `.`        |                        | +comment (`vgc` in normal mode will select a block comment)               | followed by textobject/motion            | won't jump             | uses selection               | `gcip` or `vipgc` comments a paragraph                                       |
|        `gC`        | vscode-neovim | `n`,`o`,`x` |        `.`        |                        | block comment (supports selection `vgC` or just `gC`)                     | select text-object under cursor          | won't jump             | reselects                    | `vgC` selects current block of comment                                       |
|        `gd`        |               |     `n`     |                   |                        | go to definition                                                          | jumps                                    |                        |                              | `gd` go to definition of word under cursor                                   |
|        `gD`        | vscode-neovim |     `x`     |                   |                        | git diff/hunk (vscode selects from cursor position to end of diff)        |                                          | won't jump             | reselects                    | `vgh` selects modified code                                                  |
|     `ge`/`gE`      |               | `n`,`o`,`x` |                   |                        | previous end of word/WORD (`WORD` omits punctuation)                      | jumps                                    | uses cursor position   | uses selection               | `vge` selects from cursor position until previous end of word                |
|        `gf`        |               |   `n`,`x`   |                   |                        | go to file under cursor                                                   | jumps                                    |                        | uses selection               | `gf` open in a tab the path under cursor                                     |
|      `gg`/`G`      |               | `n`,`o`,`x` |        `.`        |                        | first/last line                                                           | jumps                                    | uses cursor position   | uses selection               | `vgg` selects until first line                                               |
|        `gi`        |               |   `n`,`x`   |                   |                        | last position of cursor in insert mode                                    | finds and jumps                          |                        | uses selection               | `vgi` selects until last insertion                                           |
|     `gj`/`gk`      |               | `n`,`o`,`x` |        `.`        |                        | go down/up when wrapped                                                   | jumps                                    | uses cursor position   | uses selection               | `vgj` selects one line down                                                  |
|        `gJ`        |               |   `n`,`x`   |        `.`        |                        | join below lines                                                          | joins                                    |                        | uses selection               | `vgJ` joins selected lines into one line                                     |
|        `gm`        | vscode-neovim |   `n`,`x`   |                   |                        | +multiply (duplicate text) operator                                       |                                          | won't jump             | uses selection               | `gnap` or `vapgm` duplicates paragraph without replacing clipboard           |
|        `gM`        |               |   `n`,`x`   |                   |                        | go to middle line                                                         | jumps                                    |                        | uses selection               | `vgM` selects until middle of the line                                       |
|     `gp`/`gn`      | vscode-neovim | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | +prev/+next textobj (only textobj with `_` prefix)                        | finds and jumps                          | followed by textobject | uses selection               | `vgniq` selects from cursor position until next quotation                    |
|   `gpc` / `gnc`    | vscode-neovim | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | previous/next comment                                                     | finds and jumps                          | jumps                  | uses selection               | `vgnc` selects from cursor position until next comment                       |
|   `gpd` / `gnd`    | vscode-neovim | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | previous/next diagnostic                                                  | finds and jumps                          | jumps                  | uses selection               | `vgnd` selects from cursor position until next diagnostic                    |
|   `gpf` / `gnf`    | neovim        | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | previous/next fold (only inside neovim)                                   | finds and jumps                          | jumps                  | uses selection               | `vgnf` selects from cursor position until next fold                          |
|   `gpH` / `gnH`    | vscode-neovim | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | previous/next git hunk                                                    | finds and jumps                          | jumps                  | uses selection               | `vgnH` selects from cursor position until next git hunk                      |
|   `gpr` / `gnr`    | vscode-neovim | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | previous/next reference (only inside vscode)                              | finds and jumps                          | jumps                  | uses selection               | `vgnr` selects from cursor position until next reference                     |
|        `go`        | neovim        |     `x`     |                   |                        | jsx/tsx comment (only inside neovim)                                      |                                          |                        | uses selection               | `vipgo` comments out a paragraph with `{/* */}`                              |
|        `gq`        |               |   `n`,`x`   |        `.`        |                        | +format selection/comments 80chars (LSP overrides it)                     | requires a textobject                    |                        | applies to selection         | `gqip` or `vipgq` formats a paragraph                                        |
|        `gr`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | +replace (with register) operator                                         | followed by text-object/motion           |                        | applies to selection         | `griw` or `viwgr` replaces word with register (yanked text)                  |
|        `gs`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | +sort Operator                                                            | followed by text-object/motion           |                        | uses selection               | `gsip` or `vipgs` sorts a paragraph                                          |
|        `gS`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | split/join arguments                                                      | toggles inside `{}`,`[]`,`()`            |                        | followed by operator         | `vipgS` joins selected lines in one line                                     |
|     `gt`/`gT`      | vscode-neovim |   `n`,`x`   |        `.`        | `;`ending `,`beginning | +go to end/start of textobj                                               | followed by text-object                  |                        | selects form cursor position | `vgtiq` selects until end of quotation                                       |
|     `gu`/`gU`      |               |   `n`,`x`   |        `.`        |                        | +to lowercase/uppercase                                                   | requires a text-object                   |                        | applies to selection         | `guip` or `vipgu` lowercases a paragraph                                     |
|        `gv`        |               |   `n`,`x`   |                   |                        | last selected                                                             | finds and jumps                          |                        | reselects                    | `vgv` selects last selection                                                 |
|        `gw`        |               |   `n`,`x`   |        `.`        |                        | split/join comments/lines 80chars (keeps cursor position)                 | requires a text-object                   |                        | applies to selection         | `gwip` or `vipgw` split/join a paragraph limited by 80 characters            |
|        `gx`        | vscode-neovim |   `n`,`x`   |        `.`        |                        | +exchange (text) Operator                                                 | followed by text-object/motion           |                        | uses selection               | `gxiw` or `viwgx` exchanges word with another `gxiw` or `viwgx` or `.`       |
|     `gy`/`gY`      | vscode-neovim |     `n`     |        `.`        |                        | redo register (dot to paste forward/bacward)                              | paste                                    |                        |                              | `gy.....` paste deleted lines by history                                     |
|     `g-`/`g+`      | vscode-neovim |   `n`,`x`   |        `.`        |                        | decrement/increment number                                                | selects number under cursor              |                        | uses selected number         | `g+..` or `3g+` increments by 3                                              |
| `g<Up>`/`g<Down>`  | vscode-neovim |   `n`,`x`   |                   |                        | numbers ascending/descending                                              | selects number under cursor              |                        | uses selected number         | `g<Up>` increases selected numbers ascendingly                               |
|        `=`         |               |   `n`,`x`   |        `.`        |                        | +autoindent                                                               | followed by text-object                  |                        | uses selection               | `==` autoindents line                                                        |
|      `<`/`>`       |               |   `n`,`x`   |        `.`        |                        | +indent left/right                                                        | followed by text-object                  |                        | uses selection               | `<<` indents to left a line                                                  |
|      `0`/`$`       |               | `n`,`o`,`x` |        `.`        |                        | start/end of line                                                         | jumps                                    |                        | uses selection               | `d$j.` deletes two end-of-lines                                              |
|        `^`         |               | `n`,`o`,`x` |        `.`        |                        | start of line (non-blankline)                                             | jumps                                    |                        | uses selection               | `d^` deletes until start of line (after whitespace)                          |
|        `%`         |               | `n`,`o`,`x` |                   |                        | matching character: '()', '{}', '[]'                                      | finds and jumps                          |                        | finds and jumps              | `d%` deletes until bracket                                                   |
|      `(`/`)`       |               | `n`,`o`,`x` |        `.`        |                        | prev/next sentence                                                        | jumps                                    |                        | uses selection               | `d(.` deletes until start of sentence (two times)                            |
|      `{`/`}`       |               | `n`,`o`,`x` |        `.`        |                        | prev/next empty line (before a paragraph)                                 | jumps                                    |                        | uses selection               | `d{.` deletes until next empty line (two times)                              |
|     `[[`/`]]`      |               | `n`,`o`,`x` |        `.`        |                        | prev/next section                                                         | jumps                                    |                        | uses selection               | `d[[` deletes until start of section                                         |
|      `b`/`w`       |               | `n`,`o`,`x` |        `.`        |                        | prev/next word                                                            | jumps                                    |                        | uses selection               | `db` deletes until start of word                                             |
|      `B`/`W`       |               | `n`,`o`,`x` |        `.`        |                        | prev/next WORD                                                            | jumps                                    |                        | uses selection               | `dW.` deletes 2 WORDS                                                        |
|      `e`/`E`       |               | `n`,`o`,`x` |        `.`        |                        | end of word/WORD                                                          | jumps                                    |                        | uses selection               | `de` deletes until end of word                                               |
|        `f`         | cvim          | `n`,`o`,`x` |        `.`        |                        | search with labels like [flash.nvim](https://github.com/folke/flash.nvim) | jumps                                    |                        | uses selection               | `f???` then press the label                                                  |
|      `f`/`F`       |               | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move to next/prev char (`f` to repeat_jump on vscode-neovim)              | jumps                                    |                        | uses selection               | `df,` deletes until a next `,`                                               |
|      `t`/`T`       |               | `n`,`o`,`x` |        `.`        | `;`forward `,`backward | move before next/prev char (`f` to repeat_jump on vscode-neovim)          | jumps                                    |                        | uses selection               | `dt,` deletes before next `,`                                                |
|        `s`         |               |     `o`     |        `.`        |                        | surround (only on vscodevim)                                              |                                          | uses cursor position   |                              | `ysiw"` or `viwS"` adds `"` to word, `ds"` deletes `"`, `cs"'` replaces `"`  |
|        `s`         | vscode-neovim |   `n`,`x`   |        `.`        |                        | +surround (followed by a=add, d=delete, r=replace)                        | followed by textobject/motion (only add) |                        | uses selection (only add)    | `saiw"` or `viwsa"` adds `"` to word, `sd"` deletes `"`, `sr"'` replaces `"` |
|        `U`         | neovim        |   `n`,`x`   |                   |          `U`           | whichkey.repeatMostRecent (inside neovim repeats `:<command>`)            |                                          |                        |                              | `<s-space>gjUUUUU` repeats go to next git-change                             |
|        `Y`         |               |   `n`,`x`   |                   |                        | yank until end of line                                                    |                                          |                        | uses selection               | `v^Y` yanks line                                                             |
| `<space><space>p`  | vscode-neovim |   `n`,`x`   |        `.`        |                        | Paste after (secondary clipboard)                                         |                                          |                        | uses selection               | `viw<space><space>p` replaces word with a second clipboard                   |
| `<space><space>P`  | vscode-neovim |   `n`,`x`   |        `.`        |                        | Paste before (secondary clipboard)                                        |                                          |                        | uses selection               | `viw<space><space>P` replaces word with a second clipboard                   |
| `<space><space>y`  | vscode-neovim |   `n`,`x`   |                   |                        | yank (secondary clipboard)                                                |                                          |                        | uses selection               | `viw<space><space>y` yanks word using the second clipboard                   |
| `<space><space>Y`  | vscode-neovim |   `n`,`x`   |                   |                        | yank until end of line (secondary clipboard)                              |                                          |                        | uses selection               | `v<space><space>Y` yanks until end of line using the second clipboard        |
| `<space><space>j`  | vscode-neovim | `n`,`x`,`o` |                   | `;`forward `,`backward | prev ColumnMove                                                           | jumps                                    |                        | uses selection               | `v<space><space>j` selects until start of column                             |
| `<space><space>k`  | vscode-neovim | `n`,`x`,`o` |                   | `;`forward `,`backward | next ColumnMove                                                           | jumps                                    |                        | uses selection               | `v<space><space>k` selects until end of coumn                                |

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

|   Key Combination   | Description                                                             |
| :-----------------: | :---------------------------------------------------------------------- |
|         `a`         | Create new file or folder (`path/to/file` creates 2 folders and 1 file) |
|         `d`         | delete file                                                             |
|        `gg`         | focus first file                                                        |
|         `G`         | focus last file                                                         |
|         `h`         | Collapse list                                                           |
|         `j`         | Move down                                                               |
|         `k`         | Move up                                                                 |
|   `l` or `enter`    | open directory/file passing focus                                       |
|   `o` or `space`    | open without passing focus replacing current tab                        |
|         `O`         | open without passing focus in a new tab                                 |
|         `p`         | paste file                                                              |
|         `q`         | close sidebar visibility                                                |
|         `r`         | Rename file                                                             |
|         `v`         | Open selected file to the side and toggle sidebar visibility            |
|         `V`         | Open selected file to the bottom and toggle sidebar visibility          |
|         `x`         | cut file                                                                |
|         `y`         | copy file                                                               |
|         `/`         | search                                                                  |
|       `Down`        | Focus down and preview file                                             |
|        `Up`         | Focus up and preview file                                               |
|      `shift+j`      | Move focus down 10 times in list view                                   |
|      `shift+k`      | Move focus up 10 times in list view                                     |
|      `shift+l`      | Open and toggle sidebar visibility                                      |
| `<unmapped letter>` | find (by first `<unmapped letter>` of file/folder) and jump             |

</details>

## Editor keymaps (keybindings.json)

<details open><summary></summary>

|     Key Combination      |    mode     | Description                                      |
| :----------------------: | :---------: | :----------------------------------------------- |
|        `<space>o`        |     `n`     | view file explorer                               |
|         `ctrl+\`         |   `n`,`i`   | Toggle panel (terminal) visibility               |
|         `escape`         |     `n`     | clear search highlight                           |
|      `shift+escape`      |     `n`     | close any popup window like diff/diagnostic etc  |
|      `shift+space`       |     `n`     | Show whichkey menu (Windows, Linux, Mac)         |
|       `alt+space`        |     `n`     | Show whichkey menu (Linux, Mac)                  |
|         `alt+c`          |     `i`     | Copy                                             |
|         `alt+v`          |     `i`     | Paste                                            |
|           `jk`           |     `i`     | enter vim normal mode                            |
|         `alt+h`          |   `i`,`x`   | enter vim normal mode                            |
|   `alt+h` or `shift+h`   |     `n`     | cursorLeft `10` times                            |
|   `alt+j` or `shift+j`   |     `n`     | cursorDown `10` times                            |
|   `alt+k` or `shift+k`   |     `n`     | cursorUp `10` times                              |
|   `alt+l` or `shift+l`   |     `n`     | cursorRigth `10` times                           |
|         `alt+v`          |     `n`     | Type `V`                                         |
|    `alt+s` or `left`     |     `n`     | Go to previous tab                               |
|    `alt+f` or `right`    |     `n`     | Go to next tab                                   |
| `alt+left` or `alt+down` |     `n`     | Decrease view size of current window or terminal |
| `alt+right` or `alt+up`  |     `n`     | Increase view size of current window or terminal |
|         `ctrl+h`         |     `n`     | Navigate to left window                          |
|         `ctrl+j`         |     `n`     | Navigate to down window                          |
|         `ctrl+k`         |     `n`     | Navigate to up window                            |
|         `ctrl+l`         |     `n`     | Navigate to right window                         |
|        `shift+q`         |     `n`     | Close active tab                                 |
|        `shift+r`         |     `n`     | Format and save                                  |
|     `ctrl+alt+left`      | `n`,`i`,`x` | select left word (on multi cursor)               |
|     `ctrl+alt+right`     | `n`,`i`,`x` | select right word (on multi cursor)              |
|    `<ctr+x><ctrl+o>`     |     `i`     | to expand emmet-ls (neovim only)                 |

</details>

## Suggestion keymaps

<details open><summary></summary>

|  Key Combination   | mode | Description                                       |
| :----------------: | :--: | :------------------------------------------------ |
|    `ctrl+space`    | `i`  | Toggle suggestion widget                          |
| `ctrl+shift+space` | `i`  | Toggle suggestion details (when inside widget)    |
| `ctrl+shift+space` | `i`  | Toggle parameter hints (when inside parameters)   |
|      `ctrl+h`      | `i`  | Toggle suggestion focus (when inside widget)      |
|      `ctrl+d`      | `i`  | Select next page (when inside suggestion details) |
|      `ctrl+u`      | `i`  | Select prev page (when inside suggestion details) |
|      `ctrl+j`      | `i`  | Select next suggestion                            |
|      `ctrl+k`      | `i`  | Select prev suggestion                            |
|      `ctrl+l`      | `i`  | Accept selected suggestion                        |
|      `alt+]`       | `i`  | Show next inline suggestion                       |
|      `alt+[`       | `i`  | Show previous inline suggestion                   |
|      `alt+j`       | `i`  | inline suggestion accept next word                |
|      `alt+k`       | `i`  | inline suggestion accept next line                |
|      `alt+l`       | `i`  | Commit inline suggestion                          |
|      `alt+;`       | `i`  | trigger next edit suggestion (`alt+l` to accept)  |
|      `alt+;`       | `i`  | accept next edit suggestion (neovim only)         |
|       `tab`        | `i`  | go to next snippet stop or next suggestion        |
|    `shift+tab`     | `i`  | go to prev snippet stop or prev suggestion        |
|      `alt+n`       | `i`  | go to next snippet stop (neovim only)             |
|      `alt+p`       | `i`  | go to prev snippet stop (neovim only)             |
|      `alt+.`       | `i`  | expand snippet (neovim only)                      |
|      `ctrl+c`      | `i`  | exit snippet session (neovim only)                |

</details>

## Terminal keymaps

<details open><summary></summary>

|  Key Combination   | Description                                              |
| :----------------: | :------------------------------------------------------- |
|      `alt+c`       | Copy selection in terminal                               |
|      `alt+v`       | Paste in terminal                                        |
|      `alt+y`       | send sequence to open yazi                               |
|   `alt+shift+d`    | Scroll terminal to next command                          |
|   `alt+shift+e`    | Scroll terminal to previous command                      |
|      `alt+e`       | Scroll terminal up                                       |
|      `alt+d`       | Scroll terminal down                                     |
|      `alt+q`       | Scroll terminal up by page                               |
|      `alt+a`       | Scroll terminal down by page                             |
|      `alt+t`       | Scroll terminal to top                                   |
|      `alt+g`       | Scroll terminal to bottom                                |
|    `alt+ctrl+r`    | select from shell history                                |
|        `Up`        | prev shell history (shell builtin)                       |
|       `Down`       | next shell history (shell builtin)                       |
|      `ctrl+d`      | exit signal (shell builtin)                              |
|      `ctrl+c`      | cancel signal (shell builtin)                            |
|      `ctrl+r`      | search shell history (shell builtin)                     |
|  `ctrl+backspace`  | delete word (shell builtin)                              |
|       `Home`       | jump to start of line (powershelll and bash only)        |
|       `End`        | jump to end of line (powershelll and bash only)          |
|    `ctrl+left`     | jump backward word (powershelll and bash only)           |
|    `ctrl+right`    | jump forward word (powershelll and bash only)            |
| `ctrl+alt+shift+?` | show shortcuts (powershelll only)                        |
|     `bind -P`      | show shortcuts (bash only, emacs keybindings by default) |

</details>

---

## zsh/powershell keymaps

<details open><summary></summary>

|       keymap       | description                                                |
| :----------------: | :--------------------------------------------------------- |
|      `<tab>`       | show (dash/path) options or complete path                  |
|    `<tab><tab>`    | enter completion menu                                      |
|    `<esc><esc>`    | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
|   `nvim<enter>`    | open retronvim's neovim IDE (`<space>` to open whichkey)   |
|     `y<enter>`     | open yazi (changes directory on exit)                      |
|      `alt+o`       | open yazi (even while writing commands)                    |
| `alt+h` or `<esc>` | enter vim-mode                                             |
|      `alt+j`       | previous history and enter vim-mode                        |
|      `alt+k`       | next history and enter vim-mode                            |
|      `alt+l`       | complete inline/ghost suggestion and enter vim-mode        |
|      `ctrl+r`      | search history with fzf                                    |
|      `ctrl+l`      | clear screen                                               |
|    `ctrl+alt+l`    | clear screen (inside neovim terminal or vscode terminal)   |

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

- RetroNvim installs [`cvim` a vscodevim fork with flash.nvim support](https://github.com/VSCodeVim/Vim/issues/8567) and [`whichkey` a menu for keymaps](https://github.com/vspacecode/vscode-which-key) vscode extensions as optional dependencies

- some text-objects requires install [`vscode-neovim`](https://github.com/vscode-neovim/vscode-neovim)
  (tested on vscode-neovim version v1.18.17, neovim version v0.11.0 and retronvim version v0.3.0, future versions may be incompatible with retronvim's [init.lua](https://github.com/YeferYV/RetroNvim/blob/main/nvim/init.lua) file)
  and uninstall/disable [`cvim`](https://github.com/VSCodeVim/Vim/issues/8567) extension, you may need to relaunch vscode,
  alternatively use `nvim` or `yazi` when opening a terminal with the profile `zsh (retronvim)` or `powershell(retronvim)` which are the default profile when opening a terminal

**Manual Install**

- Linux/MacOS:

  ```bash
  curl -L pixi.sh/install.sh | bash
  source ~/.zshrc
  pixi global install git nodejs nvim yazi
  git clone --recursive https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out   retronvim.vsix
  code --install-extension retronvim.vsix
  ```

- Windows 10/11:

  ```powershell
  winget install gnuwin32.file git.git neovim.neovim openjs.nodejs prefix-dev.pixi sxyazi.yazi microsoft.vcredist.2015+.x64 # microsoft.visualstudiocode # then relaunch terminal
  git clone --recursive https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out   retronvim.vsix
  code --install-extension retronvim.vsix
  ```

**Install Retronvim on any terminal or ssh**

- Linux/Macos/Msys2:

  ```bash
  code  --install-extension  yeferyv.retronvim
  cp    ~/.vscode/extensions/yeferyv.retronvim*/zsh/.zshrc  ~/.zshrc
  ```

- SSH:

  ```bash
  curl  -s https://api.github.com/repos/yeferyv/retronvim/releases/latest | grep --only-matching --extended-regexp "https.*linux.*vsix" | curl -o retronvim.vsix -L @-
  unzip retronvim.vsix -d /tmp
  mkdir -p                             ~/.vscode/extensions/yeferyv.retronvim
  cp    -r  /tmp/extension/*           ~/.vscode/extensions/yeferyv.retronvim
  cp    -r  /tmp/extension/zsh/.zshrc  ~/.zshrc
  ```

- Windows 10/11:
  ```powershell
  set-executionpolicy bypass currentuser ################################################ allow to load profile.ps1
  winget  install vscode ################################################################ then relaunch terminal
  code  --install-extension  yeferyv.retronvim
  cp -r ~/.vscode/extensions/yeferyv.retronvim*/powershell  ~/documents/windowspowershell
  ```

**Install from github releases (offline)(portable)**
open command palette `ctrl+shift+p` then type `Extensions: install from vsix`

**VSCode Marketplace**

- RetroNvim extension is shipped with
  [`neovim`](https://neovim.io),
  [`kanata`](https://github.com/jtroo/kanata) binaries
  [`pixi`](https://github.com/prefix-dev/pixi),
  [`bat`](https://github.com/sharkdp/bat),
  [`eza`](https://github.com/eza-community/eza),
  [`fzf`](https://github.com/junegunn/fzf),
  [`git`](https://github.com/git-for-windows/git),
  [`lazygit`](https://github.com/jesseduffield/lazygit),
  [`ripgrep`](https://github.com/BurntSushi/ripgrep),
  [`starship`](https://github.com/starship/starship),
  [`yazi`](https://github.com/sxyazi/yazi),
  [`7zip`](https://github.com/ip7z/7zip), and
  [using github-actions](https://github.com/YeferYV/retronvim/tree/main/.github/workflows/release.yml);
  [`mini.nvim`](https://github.com/echasnovski/mini.nvim),
  [`snacks.nvim`](https://github.com/folke/snacks.nvim),
  [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) and
  [`zsh-fast-syntax-highlighting`](https://github.com/zdharma-continuum/fast-syntax-highlighting) as git-submodules; and
  [`firacode_nerd_font`](https://github.com/ryanoasis/nerd-fonts) for terminal icons

- Retronvim comes with [bat's base16](https://github.com/sharkdp/bat/blob/master/assets/themes/base16.tmTheme) syntax highlighting generated by `npx yo code --extensionType colortheme` and a editor theme generated using https://themes.vscode.one

- https://marketplace.visualstudio.com/items?itemName=YeferYV.retronvim

</details>

## Trobleshotting

<details open><summary></summary>

- remove the `~/.vscode/extensions/yeferyv.retronvim` symlink and relaunch vscode
- remove `vscode-neovim.neovimExecutablePaths.linux` `vscode-neovim.neovimExecutablePaths.win32` `vscode-neovim.neovimExecutablePaths.darwin` from `settings.json` and relaunch vscode
- remove `terminal.integrated.env.linux` `terminal.integrated.env.osx` `terminal.integrated.env.windows` from `settings.json` and relaunch vscode
- open vscode command palette and type: `Output: Show Output Channels` > `vscode-neovim logs`

</details>

## Package Manager (optional)

<details open><summary></summary>

- open `whichkey > +Install Dependencies > install brew` for macos or
  `whichkey > +Install Dependencies > install nix-env` for linux or
  `whichkey > +Install Dependencies > install scoop` for windows or
  just use `pixi` if you don't need GUI programs

</details>

## Vim Cheatsheets / Tutorials

<details open><summary></summary>

- [devhints.io/vim](https://devhints.io/vim) most used vim keys
- [viemu.com](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html) vim keys from A-Z
- [vscode with embedded neovim](https://www.youtube.com/watch?v=g4dXZ0RQWdw) youtube tutorial most of the keybindings are similar to RetroNvim
- [treesitter text-objects demo](https://www.youtube.com/watch?v=FuYQ7M73bC0) youtube tutorial the keybindings are similar to RetroNvim
- [treesitter text-objects extended](https://www.youtube.com/watch?v=CEMPq_r8UYQ) youtube tutorial the keybindings are similar to RetroNvim
- [text-objects from A-Z](https://www.youtube.com/watch?v=JnD9Uro_oqc) youtube tutorial the keybindings are similar to RetroNvim
- [motion-operators from A-Z](https://www.youtube.com/watch?v=HhZJ1kbzkj0) youtube tutorial the keybindings are the same as to RetroNvim

</details>

## Related projects

<details open><summary></summary>

- [yeferyv/dotfiles](https://github.com/yeferyv/dotfiles) retronvim + [hyprland](https://hypr.land) setup
- [yeferyv/sixelrice](https://github.com/yeferyv/sixelrice) appimages containing retronvim's kanata, nvim, yazi and zsh configs
- [lunarkeymap](https://github.com/fathulfahmy/lunarkeymap) comes with [vscodevim](https://github.com/vscodevim/vim) extension which has some text objects + whichkey with [lunarvim](https://github.com/lunarvim/lunarvim)-like keymaps
- [vspacecode](https://github.com/vspacecode/vspacecode) comes with [vscodevim](https://github.com/vscodevim/vim) extension which has some text objects + whichkey with [spacemacs](https://github.com/syl20bnr/spacemacs)-like keymaps

</details>
