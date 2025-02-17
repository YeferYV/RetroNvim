<video controls autoplay loop muted playsinline src="https://github.com/YeferYV/RetroNvim/assets/37911404/4f7002a2-324e-4597-9644-5ab0cd7c5831" title="Demo"></video>

<div align="center"><p>

Neovim text objects + LSP whichkey + touchcursor keyboard layout + minimal zsh/yazi setup (zsh.exe supported)

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

1. Neovim TextObjects/Motions
   - [Neovim text object that starts with a/i](#neovim-text-object-that-starts-with-ai)
   - [Neovim text object that starts with g](#neovim-text-object-that-starts-with-g)
   - [Neovim Motions and Operators](#neovim-motions-and-operators)
2. Neovim GoTo
   - [Neovim Space TextObjects/Motions](#neovim-space-textobject-motions)
   - [Neovim Go to Previous / Next](#neovim-go-to-previous--next)
   - [Neovim Mini.bracketed](#neovim-minibracketed)
   - [Native neovim ctrl keys](#native-neovim-ctrl-keys)
3. keybindings.json
   - [File Explorer keymaps](#file-explorer-keymaps)
   - [Editor keymaps (keybindings.json)](#editor-keymaps-keybindingsjson)
   - [Suggestion keymaps](#suggestion-keymaps)
4. Terminal
   - [Terminal keymaps](#terminal-keymaps)
   - [zsh keymaps](#zsh-keymaps)
5. [If Touchcursor Keyboard Layout Started](#if-touchcursor-keyboard-layout-started)
6. Installation
   - [Install](#installation)
   - [Trobleshotting](#troubleshooting)
   - [Terminal Dependencies (optional)](#terminal-dependencies-optional)
   - [Treesitter Installation (optional)](#treesitter-installation-optional)
7. [Vim Cheatsheets / Tutorials](#vim-cheatsheets--tutorials)
8. [Related projects](#related-projects)

</details>

---

## Neovim text object that starts with `a`/`i`

<details open><summary></summary>

|         text-object keymap         | repeater key | finds and autojumps? | text-object name | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :----------: | :------------------: | :--------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |     `.`      |         yes          | \_argument       | whole argument/parameter of a function                                                    | outer includes comma                                                          |
|             `ib`, `ab`             |     `.`      |         yes          | \_braces         | find the nearest inside of `()` `[]` `{}`                                                 | outer includes braces                                                         |
|             `iB`, `aB`             |     `.`      |         yes          | \_brackets       | find the nearest inside of `{}` `:help iB`                                                | outer includes brackets                                                       |
|             `ie`, `ae`             |     `.`      |                      | line             | from start to end of line without beginning whitespaces (line wise)                       | outer includes begining whitespaces                                           |
|             `if`, `af`             |     `.`      |         yes          | \_function_call  | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `ih`, `ah`             |     `.`      |         yes          | \_html_attribute | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |     `.`      |                      | indent_noblanks  | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             |     `.`      |                      | indent           | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ik`, `ak`             |     `.`      |         yes          | \_key            | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `il`, `al`             |     `.`      |         yes          | +last            | go to last mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `vilk`                                               |
|             `in`, `an`             |     `.`      |         yes          | +next            | go to Next mini.ai text-object (which start with `_`)                                     | requires `i`/`a` example `viNk`                                               |
|             `im`, `am`             |     `.`      |         yes          | \_number         | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `io`, `ao`             |     `.`      |         yes          | \_whitespaces    | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |     `.`      |                      | paragraph        | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iq`, `aq`             |     `.`      |         yes          | \_quotes         | inside of `` ` ` `` or `' '` or `" "`                                                     | outer includes openning and closing quotes                                    |
|             `is`, `as`             |     `.`      |                      | sentence         | sentence delimited by dots of blanklines `:help sentence`                                 | outer includes spaces                                                         |
|             `it`, `at`             |     `.`      |         yes          | \_tag            | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             |     `.`      |                      | \_subword        | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `iv`, `av`             |     `.`      |         yes          | \_value          | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |     `.`      |                      | word             | from cursor to end of word (delimited by punctuation or space)                            | outer includes whitespace ending                                              |
|             `iW`, `aW`             |     `.`      |                      | WORD             | from cursor to end of WORD (includes punctuation)                                         | outer includes whitespace ending                                              |
|             `ix`, `ax`             |     `.`      |         yes          | \_Hex            | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `iy`, `ay`             |     `.`      |                      | same_indent      | surrounding lines with only same indent (delimited by blankspaces or commented lines)     | outer includes blankspaces                                                    |
|             `i?`, `a?`             |     `.`      |         yes          | \_user_prompt    | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |     `.`      |         yes          | `(` or `)`       | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |     `.`      |         yes          | `[` or `]`       | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |     `.`      |         yes          | `{` or `}`       | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |     `.`      |         yes          | `<` or `>`       | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |     `.`      |         yes          | apostrophe       | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` |     `.`      |         yes          | `<punctuation>`  | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text object that starts with `g`

<details open><summary></summary>

| text-object keymap |  mode   | repeater key | text-object description                                       | normal mode                              | operating-pending mode | visual mode                  | examples in normal mode                                                       |
| :----------------: | :-----: | :----------: | :------------------------------------------------------------ | :--------------------------------------- | :--------------------- | :--------------------------- | :---------------------------------------------------------------------------- |
|     `g[`/`g]`      | `o`,`x` |              | +cursor to left/right around (only textobj with `_` prefix)   |                                          | followed by textobject | uses selected region         | `vg]u` will select until quotation                                            |
|     `g<`/`g>`      | `o`,`x` |     `.`      | prev/next find                                                |                                          | will find and jump     | uses selection               | `cg>???` will replace last search with `???` forwardly                        |
|        `g.`        | `o`,`x` |              | jump to last change                                           |                                          | won't jump             | uses selection               | `vg.` will select from cursor position until last change                      |
|        `ga`        | `n`,`x` |              | align                                                         | followed by textobject/motion            |                        | uses selected region         | `vipga=` will align a paragraph by `=`                                        |
|        `gA`        | `n`,`x` |              | preview align (`escape` to cancel, `enter` to accept)         | followed by textobject/motion            |                        | uses selected region         | `vipgA=` will align a paraghaph by `=`                                        |
|        `gb`        | `n`,`x` |     `.`      | blackhole register                                            | followed by textobject/motion            |                        | deletes selection            | `vipgb` will delete a paragraph without copying                               |
|        `gB`        | `n`,`x` |     `.`      | blackhole linewise                                            | textobject not required                  |                        | deletes line                 | `gB.` will delete two lines without saving it in the register                 |
|        `gc`        | `o`,`x` |     `.`      | comment (`vgc` in normal mode will select a block comment)    |                                          | won't jump             | uses selection               | `vipgc` will comment a paragraph                                              |
|        `gC`        | `o`,`x` |     `.`      | block comment (supports selection `vgC`)                      |                                          | won't jump             | reselects                    | `vgC` will select current block of comment                                    |
|     `ge`/`gE`      | `o`,`x` |              | previous end of word/WORD (`WORD` omits punctuation)          |                                          | uses cursor position   | uses selection               | `vge` will select from cursor position until previous end of word             |
|      `gg`/`G`      | `o`,`x` |     `.`      | first/last line                                               |                                          | uses cursor position   | uses selection               | `vgg` will select until first line                                            |
|        `gH`        |   `x`   |     `.`      | git hunk (vscode selects from cursor position to end of diff) |                                          | won't jump             | relesects                    | `vgh` will select modified code                                               |
|        `gi`        | `n`,`x` |              | last position of cursor in insert mode                        | will find and jump                       |                        | uses selection               | `vgi` will select until last insertion                                        |
|     `gj`/`gk`      | `o`,`x` |     `.`      | go down/up when wrapped                                       |                                          | uses cursor position   | uses selection               | `vgj` will select one line down                                               |
|        `gm`        | `n`,`x` |              | +multiply (duplicate text) operator                           |                                          | won't jump             | uses selection               | `vapgm` will duplicate paragraph without replacing clipboard                  |
|     `gp`/`gn`      | `o`,`x` |     `.`      | +prev/+next textobj (only textobj with `_` prefix)            |                                          | followed by textobject | uses selection               | `vgniq` will select from cursor position until next quotation                 |
|        `gq`        | `n`,`x` |     `.`      | +format selection/comments 80chars (LSP overrides it)         | requires a textobject                    |                        | applies to selection         | `vipgq` will format a paragraph                                               |
|        `gr`        | `n`,`x` |     `.`      | +replace (with register) operator                             | followed by textobject/motion            |                        | applies to selection         | `viwgr` will replace word with register (yanked text)                         |
|        `gs`        | `n`,`x` |     `.`      | +sort Operator                                                | followed by textobject/motion            |                        | uses selection               | `vipgs` will sort paragraph                                                   |
|        `gS`        | `n`,`x` |     `.`      | join/split lines inside braces                                | will toggle inside `{}`,`[]`,`()`        |                        | followed by operator         | `vipgS` will join selected lines in one line                                  |
|     `gt`/`gT`      | `n`,`x` |     `.`      | +go to end/start of textobj                                   | followed by textobject                   |                        | selects form cursor position | `vgtiq` will select until start of quotation                                  |
|     `gu`/`gU`      | `n`,`x` |     `.`      | +to lowercase/uppercase                                       | requires a textobject                    |                        | applies to selection         | `vipgu` will lowercase a paragraph                                            |
|        `gv`        | `n`,`x` |              | last selected                                                 | will find and jump                       |                        | reselects                    | `vgv` will select last selection                                              |
|        `gw`        | `n`,`x` |     `.`      | split/join comments/lines 80chars (preserves cursor position) | requires a textobject                    |                        | applies to selection         | `vipgw` will split/join a paragraph limited by 80 characters                  |
|        `gx`        | `n`,`x` |     `.`      | +exchange (text) Operator                                     | followed by textobject/motion            |                        | uses selection               | `viwgx` will exchange word with another `viwgY`                               |
|     `g-`/`g+`      | `n`,`x` |     `.`      | decrement/increment number                                    | selects number under cursor              |                        | uses selected number         | `3g+` will increment by 3                                                     |
| `g<Up>`/`g<Down>`  | `n`,`x` |              | numbers ascending/descending                                  | selects number under cursor              |                        | uses selected number         | `g<Up>` will increase selected numbers ascendingly                            |
|        `=`         | `n`,`x` |     `.`      | autoindent                                                    | followed by text-object                  |                        | uses selection               | `==` autoindents line                                                         |
|      `<`/`>`       | `n`,`x` |     `.`      | indent left/right                                             | followed by text-object                  |                        | uses selection               | `<<` indents to left a line                                                   |
|      `0`/`$`       | `o`,`x` |     `.`      | start/end of line                                             |                                          |                        |                              | `d$j.` deletes two end-of-lines                                               |
|        `^`         | `o`,`x` |     `.`      | start of line (non-blankline)                                 |                                          |                        |                              | `d^` deletes until start of line (after whitespace)                           |
|        `%`         | `o`,`x` |              | matching character: '()', '{}', '[]'                          | won't jump                               |                        | won't jump                   | `d%` deletes until bracket                                                    |
|      `(`/`)`       | `o`,`x` |     `.`      | prev/next sentence                                            |                                          |                        |                              | `d(.` deletes until start of sentence (two times)                             |
|      `{`/`}`       | `o`,`x` |     `.`      | prev/next empty line (before a paragraph)                     |                                          |                        |                              | `d{.` deletes until next empty line (two times)                               |
|     `[[`/`]]`      | `o`,`x` |     `.`      | prev/next section                                             |                                          |                        |                              | `d[[` deletes until start of section                                          |
|      `b`/`w`       | `o`,`x` |     `.`      | prev/next word                                                |                                          |                        |                              | `db` deletes until start of word                                              |
|      `B`/`W`       | `o`,`x` |     `.`      | prev/next WORD                                                |                                          |                        |                              | `dW.` deletes 2 WORDS                                                         |
|      `e`/`E`       | `o`,`x` |     `.`      | end of word/WORD                                              |                                          |                        |                              | `de` deletes until end of word                                                |
|      `f`/`F`       | `o`,`x` |     `.`      | move to next/prev char (`f` to repeat_jump)                   |                                          |                        |                              | `df,` deletes until a next `,`                                                |
|      `t`/`T`       | `o`,`x` |     `.`      | move before next/prev char (`f` to repeat_jump)               |                                          |                        |                              | `dt` deletes before next `,`                                                  |
|        `s`         | `n`,`x` |     `.`      | +surround (followed by a=add, d=delete, r=replace)            | followed by textobject/motion (only add) |                        | uses selection (only add)    | `viwsa"` will add `"` to word, `sd"` will delete `"`, `sr"'` will replace `"` |

</details>

## Neovim Motions and Operators

<details open><summary></summary>

| Motion/Operator keymap |  Mode   |      repeater key      | Description                                                 | requires textobject/motion keymap? (operators requires textobjects/motion) | example when in normal mode                            |
| :--------------------: | :-----: | :--------------------: | :---------------------------------------------------------- | :------------------------------------------------------------------------: | :----------------------------------------------------- |
|       `g[`/`g]`        | `n`,`x` |                        | +cursor to left/right around (only textobj with `_` prefix) |                                    yes                                     | `g]q` go to end to quotation                           |
|       `g<`/`g>`        | `n`,`x` |          `.`           | prev/next find                                              |                                                                            | `g>` will find, jump and select the last search        |
|       `g;`/`g,`        |   `n`   |                        | go backward/forward in `:changes`                           |                                                                            |                                                        |
|          `g.`          | `n`,`x` |                        | go to last change                                           |                                                                            |                                                        |
|          `ga`          | `n`,`x` |          `.`           | +align                                                      |                                    yes                                     | `gaip=` will align a paragraph by `=`                  |
|          `gA`          | `n`,`x` |          `.`           | +preview align (escape to cancel, enter to accept)          |                                    yes                                     | `gAip=` will align a paragraph by `=`                  |
|          `gb`          | `n`,`x` |          `.`           | +blackhole register                                         |                                    yes                                     | `gbip` delete a paragraph without copying              |
|          `gB`          | `n`,`x` |          `.`           | blackhole linewise                                          |                                    yes                                     | `gB` delete line                                       |
|          `gc`          | `n`,`x` |          `.`           | +comment                                                    |                                    yes                                     | `gcip` comment a paragraph                             |
|          `gd`          |   `n`   |                        | go to definition                                            |                                                                            |                                                        |
|       `ge`/`gE`        | `n`,`x` |                        | go to previous end of word/WORD                             |                                                                            |                                                        |
|          `gf`          |   `n`   |                        | go to file under cursor                                     |                                                                            |                                                        |
|        `gg`/`G`        | `n`,`x` |                        | go to first/last line                                       |                                                                            |                                                        |
|       `gt`/`gT`        | `n`,`x` |          `.`           | +go to end/start of textobj                                 |                                    yes                                     | `gtiq` go to end of quotation                          |
|          `gi`          | `n`,`x` |                        | last position of cursor in insert mode                      |                                                                            |                                                        |
|       `gj`/`gk`        | `n`,`x` |                        | go down/up (when wrapped)                                   |                                                                            |                                                        |
|          `gJ`          | `n`,`x` |          `.`           | join below line                                             |                                                                            |                                                        |
|          `gm`          | `n`,`x` |                        | +multiply (duplicate text) operator                         |                                                                            | `gmap` duplicate paragraph withoug modifying clipboard |
|          `gM`          | `n`,`x` |                        | go to mid line                                              |                                                                            |                                                        |
|       `gp`/`gn`        | `n`,`x` | `;`forward `,`backward | +next (only textobj with `_` prefix)                        |                                    yes                                     | `gniq` go to next quotation                            |
|          `gq`          | `n`,`x` |          `.`           | +format selection/comments                                  |                                    yes                                     | `gqip` format a paragraph                              |
|          `gr`          | `n`,`x` |          `.`           | +replace (with register) Operator                           |                                    yes                                     | `griw` replace word with register (yanked text)        |
|          `gs`          | `n`,`x` |          `.`           | +sort operator                                              |                                    yes                                     | `gsip` sort paragraph                                  |
|          `gS`          | `n`,`x` |          `.`           | split/join arguments                                        |                                                                            |                                                        |
|       `gu`/`gU`        | `n`,`x` |          `.`           | +to lowercase/uppercase                                     |                                    yes                                     | `guip` lowercase a paragraph                           |
|          `gv`          | `n`,`x` |                        | last selected                                               |                                                                            |                                                        |
|          `gw`          | `n`,`x` |          `.`           | +split/join coments/lines 80chars (keeps cursor position)   |                                    yes                                     | `gwip` split/join a paragraph by 80 characters         |
|          `gx`          | `n`,`x` |          `.`           | +exchange (text) operator                                   |                                    yes                                     | `gxiw` exchange word with another `gxiw`               |
|       `gy`/`gY`        |   `n`   |          `.`           | redo register (dot to paste forward/bacward)                |                                                                            |                                                        |
|       `g-`/`g+`        | `n`,`x` |          `.`           | decrement/increment number                                  |                                    yes                                     | `10g+` increment by 10                                 |
|          `=`           | `n`,`x` |          `.`           | +autoindent                                                 |                                    yes                                     | `=ip` autoindents paragraph                            |
|        `<`/`>`         | `n`,`x` |          `.`           | +indent left/right                                          |                                    yes                                     | `>ip` indents to right a paragraph                     |
|        `0`/`$`         | `n`,`x` |                        | start/end of line                                           |                                                                            |                                                        |
|          `^`           | `n`,`x` |                        | start of line (non-blankline)                               |                                                                            |                                                        |
|          `%`           | `n`,`x` |                        | matching character: `()`, `{}`, `[]`                        |                                                                            |                                                        |
|        `(`/`)`         | `n`,`x` |                        | prev/next sentence                                          |                                                                            |                                                        |
|        `{`/`}`         | `n`,`x` |                        | prev/next empty line (paragraph)                            |                                                                            |                                                        |
|       `[[`/`]]`        | `n`,`x` |                        | prev/next section                                           |                                                                            |                                                        |
|        `b`/`w`         | `n`,`x` |                        | prev/end word                                               |                                                                            |                                                        |
|        `B`/`W`         | `n`,`x` |                        | prev/next WORD (`WORD` omits punctuation)                   |                                                                            |                                                        |
|        `e`/`E`         | `n`,`x` |          `.`           | end of word/WORD                                            |                                                                            |                                                        |
|        `f`/`F`         | `n`,`x` |          `f`           | move to next/prev char                                      |                                                                            |                                                        |
|        `t`/`T`         | `n`,`x` |          `f`           | move before next/prev char                                  |                                                                            |                                                        |
|          `U`           |   `n`   |                        | repeat `:normal <keys>` or `:<commands>`                    |                                                                            |                                                        |
|          `Y`           | `n`,`x` |                        | yank until end of line                                      |                                                                            |                                                        |
|          `s`           | `n`,`x` |          `.`           | +surround (followed by a=add, d=delete, r=replace)          |                                    yes                                     | `saiw"` add `"`, `sd"` delete `"`, `sr"'` replace `"`  |

</details>

## Neovim Space TextObjects/Motions

<details open><summary></summary>

|      Keymap       |    Mode     |      repeater key      | Description                                  |
| :---------------: | :---------: | :--------------------: | :------------------------------------------- |
| `<space><space>p` |   `n`,`x`   |          `.`           | Paste after (secondary clipboard)            |
| `<space><space>P` |   `n`,`x`   |          `.`           | Paste before (secondary clipboard)           |
| `<space><space>y` |   `n`,`x`   |                        | yank (secondary clipboard)                   |
| `<space><space>Y` |   `n`,`x`   |                        | yank until end of line (secondary clipboard) |
| `<space><space>j` | `n`,`x`,`o` | `;`forward `,`backward | prev ColumnMove                              |
| `<space><space>k` | `n`,`x`,`o` | `;`forward `,`backward | next ColumnMove                              |

</details>

## Neovim Go to Previous / Next

<details open><summary></summary>

|     Keymap      |    Mode     |      repeater key      | Description                                                                                                                                |
| :-------------: | :---------: | :--------------------: | :----------------------------------------------------------------------------------------------------------------------------------------- |
|  `gpc` / `gnc`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next comment                                                                                                                      |
|  `gpd` / `gnd`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next diagnostic                                                                                                                   |
|  `gpf` / `gnf`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next fold (only inside neovim)                                                                                                    |
|  `gph` / `gnh`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next git hunk ([no supported on Windows10](https://github.com/YeferYV/RetroNvim/wiki/Recipies/#gnh-gph-not-working-on-windows10)) |
|  `gpH` / `gnH`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next git hunk (supported on Windows10)                                                                                            |
|  `gpr` / `gnr`  | `n`,`o`,`x` | `;`forward `,`backward | previous/next reference (only inside vscode)                                                                                               |
| `gpaa` / `gnaa` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_argument                                                                                                          |
| `gpab` / `gnab` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_brace                                                                                                             |
| `gpaf` / `gnaf` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_function_call                                                                                                     |
| `gpah` / `gnah` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_html_attribute                                                                                                    |
| `gpak` / `gnak` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_key                                                                                                               |
| `gpam` / `gnam` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_number                                                                                                            |
| `gpao` / `gnao` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_whitespace                                                                                                        |
| `gpaq` / `gnaq` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_quote                                                                                                             |
| `gpat` / `gnat` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_tag                                                                                                               |
| `gpau` / `gnau` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_subword                                                                                                           |
| `gpav` / `gnav` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_value                                                                                                             |
| `gpax` / `gnax` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_hexadecimal                                                                                                       |
| `gpa?` / `gna?` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of outer \_user_prompt                                                                                                       |
| `gpia` / `gnia` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_argument                                                                                                          |
| `gpif` / `gnif` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_function_call                                                                                                     |
| `gpih` / `gnih` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_html_attribute                                                                                                    |
| `gpik` / `gnik` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_key                                                                                                               |
| `gpim` / `gnim` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_number                                                                                                            |
| `gpio` / `gnio` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_whitespace                                                                                                        |
| `gpiq` / `gniq` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_quote                                                                                                             |
| `gpit` / `gnit` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_tag                                                                                                               |
| `gpiu` / `gniu` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_subword                                                                                                           |
| `gpiv` / `gniv` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_value                                                                                                             |
| `gpix` / `gnix` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_hexadecimal                                                                                                       |
| `gpi?` / `gni?` | `n`,`o`,`x` | `;`forward `,`backward | previous/next of inner \_user_prompt                                                                                                       |

</details>

## Neovim Mini.bracketed

<details open><summary></summary>

|       keymap        |    mode     | description                                          |
| :-----------------: | :---------: | :--------------------------------------------------- |
| `[b`/`]b`/`[B`/`]B` | `n`,`o`,`x` | prev/next/first/last buffer                          |
| `[c`/`]c`/`[C`/`]C` | `n`,`o`,`x` | prev/next/first/last comment                         |
| `[x`/`]x`/`[X`/`]X` | `n`,`o`,`x` | prev/next/first/last conflict (only inside neovim)   |
| `[d`/`]d`/`[D`/`]D` | `n`,`o`,`x` | prev/next/first/last diagnostic (only inside neovim) |
| `[f`/`]f`/`[F`/`]F` | `n`,`o`,`x` | prev/next/first/last file                            |
| `[i`/`]i`/`[I`/`]I` | `n`,`o`,`x` | prev/next/first/last indent                          |
| `[j`/`]j`/`[J`/`]J` | `n`,`o`,`x` | prev/next/first/last jump                            |
| `[l`/`]l`/`[L`/`]L` | `n`,`o`,`x` | prev/next/first/last location (only inside neovim)   |
| `[o`/`]o`/`[O`/`]O` | `n`,`o`,`x` | prev/next/first/last oldfile                         |
| `[q`/`]q`/`[Q`/`]Q` | `n`,`o`,`x` | prev/next/first/last quickfix (only inside neovim)   |
| `[t`/`]t`/`[T`/`]T` | `n`,`o`,`x` | prev/next/first/last treesitter                      |
| `[w`/`]w`/`[W`/`]W` | `n`,`o`,`x` | prev/next/first/last window (only inside neovim)     |
| `[y`/`]y`/`[Y`/`]Y` | `n`,`o`,`x` | prev/next/first/last yank                            |

</details>

## Native neovim ctrl keys

<details open><summary></summary>

| Key Combination |  mode   | Description                                                                                                                 |
| :-------------: | :-----: | :-------------------------------------------------------------------------------------------------------------------------- |
|    `ctrl+a`     | `n`,`v` | increase number under cursor                                                                                                |
|    `ctrl+b`     | `n`,`v` | scroll down by page                                                                                                         |
|    `ctrl+e`     | `n`,`v` | scroll down by line                                                                                                         |
|    `ctrl+d`     | `n`,`v` | scroll down by half page                                                                                                    |
|    `ctrl+f`     | `n`,`v` | scroll up by page                                                                                                           |
|    `ctrl+i`     |   `n`   | jump to next in `:jumps`                                                                                                    |
|    `ctrl+o`     |   `n`   | jump to previous in `:jumps`                                                                                                |
|    `ctrl+r`     |   `n`   | redo (`u` to undo)                                                                                                          |
|    `ctrl+s`     | `n`,`v` | replace text (using `sed` syntax)(only replaces selected region on visual mode)(neovim only)                                |
|    `ctrl+u`     | `n`,`v` | scroll up by half page                                                                                                      |
|    `ctrl+v`     | `n`,`v` | visual block mode                                                                                                           |
|    `ctrl+w`     | `n`,`v` | See [vscode-window-commands.vim](https://github.com/vscode-neovim/vscode-neovim/blob/master/vim/vscode-window-commands.vim) |
|    `ctrl+x`     | `n`,`v` | decrease number under cursor                                                                                                |
|    `ctrl+y`     | `n`,`v` | scroll up by line                                                                                                           |
|    `ctrl+/`     | `n`,`v` | comment line                                                                                                                |

</details>

## File Explorer keymaps

<details open><summary></summary>

|   Key Combination    | Description                                                   |
| :------------------: | :------------------------------------------------------------ |
|         `a`          | Create new file (`path/to/file` creates 2 folders and 1 file) |
|         `A`          | Create new folder (`path/to/somewhere` creates 3 folders)     |
|         `d`          | delete file                                                   |
|         `gg`         | focus first file                                              |
|         `G`          | focus last file                                               |
|         `h`          | Collapse list                                                 |
|         `j`          | Move down                                                     |
|         `k`          | Move up                                                       |
|    `l` or `enter`    | open directory/file passing focus                             |
|    `o` or `space`    | open without passing focus replacing current tab              |
|         `O`          | open without passing focus in a new tab                       |
|         `p`          | paste file                                                    |
|         `q`          | close sidebar visibility                                      |
|         `r`          | Rename file                                                   |
|         `R`          | refresh file explorer                                         |
|         `v`          | Open selected file to the side and toggle sidebar visibility  |
|         `x`          | cut file                                                      |
|         `y`          | copy file                                                     |
|         `za`         | toggle expand                                                 |
|         `/`          | search                                                        |
|        `Down`        | Focus down and preview file                                   |
|         `Up`         | Focus up and preview file                                     |
| `alt+j` or `shift+j` | Move focus down 10 times in list view                         |
| `alt+k` or `shift+k` | Move focus up 10 times in list view                           |
| `alt+l` or `shift+l` | Open and toggle sidebar visibility                            |
| `<unmapped letter>`  | find (by first `<unmapped letter>` of file/folder) and jump   |

</details>

## Editor keymaps (keybindings.json)

<details open><summary></summary>

|     Key Combination      |    mode     | Description                                              |
| :----------------------: | :---------: | :------------------------------------------------------- |
|         `ctrl+\`         |     `n`     | Toggle panel (terminal) visibility                       |
|         `escape`         |     `n`     | clear search highlight                                   |
|      `shift+space`       |     `n`     | Show whichkey menu (Windows, Linux, Mac)                 |
|       `alt+space`        |     `n`     | Show whichkey menu (Linux, Mac)                          |
|         `alt+c`          |     `i`     | Copy                                                     |
|         `alt+v`          |     `i`     | Paste                                                    |
|           `jk`           |     `i`     | send Escape                                              |
|         `alt+h`          |   `i`,`x`   | Send Escape                                              |
|         `alt+j`          |     `n`     | Quick-open-menu select next                              |
|         `alt+k`          |     `n`     | Quick-open-menu select previous                          |
|         `alt+h`          |     `n`     | Type `10h`                                               |
|         `alt+j`          |     `n`     | Type `10gj`                                              |
|         `alt+k`          |     `n`     | Type `10gk`                                              |
|         `alt+l`          |     `n`     | Type `10l`                                               |
|         `alt+v`          |     `n`     | Type `V`                                                 |
|    `alt+s` or `left`     |     `n`     | Go to previous editor                                    |
|    `alt+f` or `right`    |     `n`     | Go to next editor                                        |
| `alt+left` or `alt+down` |     `n`     | Decrease view size                                       |
| `alt+right` or `alt+up`  |     `n`     | Increase view size                                       |
|         `ctrl+h`         |     `n`     | Navigate to left window                                  |
|         `ctrl+j`         |     `n`     | Navigate to down window                                  |
|         `ctrl+k`         |     `n`     | Navigate to up window                                    |
|         `ctrl+l`         |     `n`     | Navigate to right window                                 |
|   `alt+q` or `shift+q`   |     `n`     | Close active editor                                      |
|   `alt+r` or `shift+r`   |     `n`     | Format and save                                          |
|     `ctrl+alt+left`      | `n`,`i`,`x` | select left word (on multi cursor)                       |
|     `ctrl+alt+right`     | `n`,`i`,`x` | select right word (on multi cursor)                      |
|    `<ctr+x><ctrl+o>`     |     `i`     | to expand emmet-ls (neovim only)                         |
|           `h`            |     `n`     | Move cursor left ( Windows10 `<number>h` not supported ) |
|           `j`            |     `n`     | Move cursor down ( Windows10 `<number>j` not supported ) |
|           `k`            |     `n`     | Move cursor up ( Windows10 `<number>k` not supported )   |
|           `l`            |     `n`     | Move cursor right ( Windows10 `<number>l` not supported) |

</details>

## Suggestion keymaps

<details open><summary></summary>

|  Key Combination   | mode | Description                                |
| :----------------: | :--: | :----------------------------------------- |
|      `ctrl+i`      | `i`  | Toggle suggestion details                  |
|    `ctrl+space`    | `i`  | Toggle suggestion widget                   |
| `ctrl+shift+space` | `i`  | Toggle parameter hints                     |
|  `ctrl+alt+space`  | `i`  | Toggle suggestion focus                    |
|      `alt+]`       | `i`  | Show next inline suggestion                |
|      `alt+[`       | `i`  | Show previous inline suggestion            |
|      `alt+j`       | `i`  | inline suggestion accept next word         |
|      `alt+k`       | `i`  | inline suggestion accept next line         |
|      `alt+l`       | `i`  | Commit inline suggestion                   |
|      `ctrl+j`      | `i`  | Select next suggestion                     |
|      `ctrl+k`      | `i`  | Select previous suggestion                 |
|       `tab`        | `i`  | go to next snippet stop or next suggestion |
|    `shift+tab`     | `i`  | go to prev snippet stop or prev suggestion |
|      `ctrl+l`      | `i`  | Accept selected suggestion                 |
|      `ctrl+d`      | `i`  | Select next page in suggestion details     |
|      `ctrl+u`      | `i`  | Select previous page in suggestion details |
|      `alt+.`       | `i`  | expand snippet (neovim only)               |
|      `alt+;`       | `i`  | next snippet stop (neovim only)            |
|      `alt+,`       | `i`  | previous snippet stop (neovim only)        |
|      `ctrl+c`      | `i`  | exit snippet session (neovim only)         |

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
|     `alt+left`     | Resize terminal pane left                                |
|    `alt+right`     | Resize terminal pane right                               |
|     `alt+down`     | Resize terminal pane down                                |
|      `alt+up`      | Resize terminal pane up                                  |
|    `alt+ctrl+r`    | select from shell history                                |
|        `Up`        | previous shell history                                   |
|       `Down`       | next shell history                                       |
|      `ctrl+d`      | exit signal                                              |
|      `ctrl+c`      | cancel signal                                            |
|      `ctrl+r`      | search shell history                                     |
|  `ctrl+backspace`  | delete word                                              |
|       `Home`       | jump to start of line (powershelll and bash only)        |
|       `End`        | jump to end of line (powershelll and bash only)          |
|    `ctrl+left`     | jump backward word (powershelll and bash only)           |
|    `ctrl+right`    | jump forward word (powershelll and bash only)            |
| `ctrl+alt+shift+?` | show shortcuts (powershelll only)                        |
|     `bind -P`      | show shortcuts (bash only, emacs keybindings by default) |

</details>

---

## zsh keymaps

<details open><summary></summary>

|    keymap    | description                                                |
| :----------: | :--------------------------------------------------------- |
|   `<tab>`    | show (dash/path) options or complete path                  |
| `<tab><tab>` | enter completion menu                                      |
| `<esc><esc>` | tmux-copy-mode-like / normal-mode (inside neovim terminal) |
| `vi<enter>`  | open retronvim's neovim                                    |
|  `y<enter>`  | open yazi (changes directory on exit)                      |
|   `alt+o`    | open yazi (even while writing commands)                    |
|   `alt+h`    | enter vim mode                                             |
|   `alt+j`    | previous history and enter vim-mode                        |
|   `alt+k`    | next history and enter vim-mode                            |
|   `alt+l`    | complete suggestion and enter vim-mode                     |
|   `ctrl+r`   | search history with fzf                                    |
|   `ctrl+l`   | clear screen                                               |
| `ctrl+alt+l` | clear screen (inside neovim terminal)                      |

</details>

---

## If Touchcursor Keyboard Layout Started

<details open><summary></summary>

**layer qwerty**

```
@grl 1    2    3    4    5    6    7    8    9    0    -    =    bspc
tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
@cap a    s    d    f    g    h    j    k    l    ;    '    ret
lsft z    x    c    v    b    n    m    ,    .    /    rsft
lctl lmet @alt           @spc           @sft rmet rctl
```

**layer touchcursor** (press and hold space to enter the layer)

```
_    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  _
_    @¿   _    _    _    @m🡠  @M↓  @m↓  @m↑  @M↑  @m🡪  _    _    _
_    del  spc  bspc @clr _    @🡠   @↓   @↑   @🡪   @yaz _    _
_    @ñ   _    caps _    _    pgup home end  pgdn _    _
_    _    _              _              _    _    _
```

| key  | description                                                                               |          example / keymap          |
| :--: | :---------------------------------------------------------------------------------------- | :--------------------------------: |
| @grl | tap: backtick/grave, hold and press `1` = qwerty layer, hold and press `2` = dvorak layer |         `` `+2 = dvorak ``         |
| @cap | tap for escape, hold for LeftCtrl                                                         |          `cap+l = ctrl+l`          |
| @sft | tap for backspace, hold for LeftShift                                                     |         `RAlt+l = shift+l`         |
| @alt | tap for middle click, hold for LeftAlt                                                    |         `LAlt+l = LAlt+l`          |
| @spc | tap for space, hold for touchcursor layer, release for qwerty layer                       | `space+jj = DownArrow + DownArrow` |
| @yaz | open yazi_cd on any shell                                                                 |             `space+;`              |
| @clr | clear screen on any shell                                                                 |             `space+f`              |
|  @¿  | unicode ¿                                                                                 |             `space+q`              |
|  @ñ  | unicode ñ                                                                                 |             `space+z`              |
| @m🡠  | mouse scrolling left                                                                      |             `space+t`              |
| @m🡪  | mouse scrolling right                                                                     |             `space+p`              |
| @m↑  | mouse scrolling up                                                                        |             `space+i`              |
| @m↓  | mouse scrolling down                                                                      |             `space+u`              |
| @M↑  | mouse fast scrolling up                                                                   |             `space+y`              |
| @M↓  | mouse fast scrolling down                                                                 |             `space+p`              |
| spc  | space key                                                                                 |             `space+s`              |
| bspc | backspace key                                                                             |             `space+d`              |
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

- On Windows 10/11 before installing `retronvim` extension you need to enable `Developer Mode` to be able to create the `~/.vscode/extensions/yeferyv.retronvim` symlink.
  Go to `Settings` > `System` > `For Developers` > `Developer Mode` > `On` and relaunch vscode

  <img src="https://github.com/user-attachments/assets/eeccfa84-32c1-4b81-bf89-804e08e97afa" alt="https://neacsu.net/posts/win_symlinks" width="700">

**Manual Install**

- Linux/MacOS:

  ```bash
  curl -L pixi.sh/install.sh | bash
  source ~/.zshrc
  pixi global install git nodejs nvim yazi
  git clone --recursive https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out retronvim.vsix
  code --install-extension retronvim.vsix
  ```

  Windows 10/11:

  ```powershell
  winget install git.git openjs.nodejs neovim.neovim sxyazi.yazi microsoft.vcredist.2015+.x64 # microsoft.visualstudiocode # then relaunch terminal
  git clone --recursive https://github.com/yeferyv/retronvim
  cd retronvim
  npx vsce package --out retronvim.vsix
  code --install-extension retronvim.vsix
  ```

**VSCode Marketplace**

- RetroNvim extension is shipped with `neovim`, `yazi` and `kanata` binaries and `neovim`'s extensions as git-submodules

- https://marketplace.visualstudio.com/items?itemName=YeferYV.retronvim

</details>

## Trobleshotting

<details open><summary></summary>

- remove the `~/.vscode/extensions/yeferyv.retronvim` symlink and relaunch vscode
- remove `vscode-neovim.neovimExecutablePaths.linux` `vscode-neovim.neovimExecutablePaths.win32` `vscode-neovim.neovimExecutablePaths.darwin` from `settings.json` and relaunch vscode
- open vscode command palette and type: `Output: Show Output Channels` > `vscode-neovim logs`

</details>

## Terminal dependencies (optional)

<details open><summary></summary>

- To install terminal dependencies after installing retronvim extension, open
  `whichkey` > `+Install Dependencies` > `install <your package manager>` > `<your package manager> install lazygit startship zsh` > relaunch vscode

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

- [yeferyv/archrice](https://github.com/yeferyv/archrice) (RetroNvim's linux distro) comes with extended keybindings for [bspwm](https://github.com/baskerville/bspwm)
- [yeferyv/sixelrice](https://github.com/yeferyv/sixelrice) (terminal version of RetroNvim) neovim with text objects, based on [lazyvim](https://github.com/LazyVim/LazyVim)
- [lunarkeymap](https://github.com/fathulfahmy/lunarkeymap) vscode vim extension with some text objects + whichkey with [lunarvim](https://github.com/lunarvim/lunarvim)-like keymaps
- [vspacecode](https://github.com/vspacecode/vspacecode) vscode vim extension with some text objects + whichkey with [spacemacs](https://github.com/syl20bnr/spacemacs)-like keymaps

</details>
