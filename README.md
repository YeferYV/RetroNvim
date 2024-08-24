<video controls autoplay loop muted playsinline src="https://github.com/YeferYV/RetroNvim/assets/37911404/4f7002a2-324e-4597-9644-5ab0cd7c5831" title="Demo"></video>

<div align="center"><p>

Neovim text objects from A-Z + LSP whichkey + touchcursor keyboard layout + minimal zsh / Msys2's zsh setup

<!-- <img src="https://github.com/yeferyv/retronvim/blob/main/assets/demo.gif?raw=true"> -->

---

**[<kbd> <br> Install <br> </kbd>][Install]** 
**[<kbd> <br> Keyboard-Layout <br> </kbd>][Keyboard-Layout]** 
**[<kbd> <br> Wiki <br> </kbd>][Wiki]** 
**[<kbd> <br> Dependencies <br> </kbd>][Dependencies]**

[Install]: #dependencies-installation
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
   - [Neovim Space TextObjects/Motions](#neovim-space-textobject-motions)
2. Neovim GoTo
   - [Neovim Mini.brackets](#neovim-minibrackets)
   - [Neovim Go to Previous / Next](#neovim-go-to-previous--next)
   - [Neovim Go to Previous_Start / Next_Start / Previous_End / Next_End of](#neovim-go-to-previous_start--next_start--previous_end--next_end-of)
3. keybindings.json
   - [File Explorer keymaps](#file-explorer-keymaps)
   - [Terminal keymaps](#terminal-keymaps)
   - [Suggestion keymaps](#suggestion-keymaps)
   - [Editor keymaps (keybindings.json)](#editor-keymaps-keybindingsjson)
   - [Native neovim ctrl keys](#native-neovim-ctrl-keys)
4. [zsh keymaps](#zsh-keymaps)
5. [If Touchcursor Keyboard Layout Started](#if-touchcursor-keyboard-layout-started)
6. Installation
   - [terminal Dependencies (optional)](#terminal-dependencies-optional)
   - [Treesitter Installation](#treesitter-installation)
7. [Vim Cheatsheets / Tutorials](#vim-cheatsheets--tutorials)
8. [Related projects](#related-projects)

</details>

---

## Neovim text object that starts with `a`/`i`

<details open><summary></summary>

|         text-object keymap         | repeater key | finds and autojumps? | text-object name       | description                                                                               | inner / outer                                                                 |
| :--------------------------------: | :----------: | :------------------: | :--------------------- | :---------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------- |
|             `ia`, `aa`             |     `.`      |         yes          | \_function_args        | whole argument/parameter of a function                                                    | outer includes braces                                                         |
|             `iA`, `aA`             |     `.`      |         yes          | @Asignment             | inner: left side of asignment without including type                                      | outer includes left and right side                                            |
|             `ib`, `ab`             |     `.`      |         yes          | \_Braces               | find the nearest inside of () [] {}                                                       | outer includes braces                                                         |
|             `iB`, `aB`             |     `.`      |         yes          | greddy_Brace           | use the current inside of {}                                                              | outer includes {}                                                             |
|             `id`, `ad`             |     `.`      |                      | greedyOuterIndentation | outer indentation, expanded to blank lines; useful to get functions with annotations      | outer includes a blank, like `ap`/`ip`                                        |
|             `ie`, `ae`             |     `.`      |                      | nearEoL                | from cursor position to end of line, minus one character                                  | outer includes from start of line (line wise)                                 |
|             `if`, `af`             |     `.`      |         yes          | \_function_call        | like `function args` but only when a function is called                                   | outer includes the function called                                            |
|             `iF`, `aF`             |     `.`      |         yes          | @Function              | inside of a function without leading comments                                             | outer includes function declaration                                           |
|                `ag`                |     `.`      |         yes          | @Comment               | inline comment                                                                            | outer many times same as inner                                                |
|             `iG`, `aG`             |     `.`      |         yes          | @Conditional           | inside conditional without blanklines                                                     | outer includes the start of a condition                                       |
|             `ih`, `ah`             |     `.`      |         yes          | \_htmlAttribute        | attribute in html/xml like `href="foobar.com"`                                            | inner is only the value inside the quotes trailing comma and space            |
|             `ii`, `ai`             |     `.`      |                      | indentation_noblanks   | surrounding lines with same or higher indentation delimited by blanklines                 | outer includes line above                                                     |
|             `iI`, `aI`             |     `.`      |                      | indentation            | surrounding lines with same or higher indentation                                         | outer includes line above and below                                           |
|             `ij`, `aj`             |     `.`      |         yes          | cssSelector            | class in CSS like `.my-class`                                                             | outer includes trailing comma and space                                       |
|             `ik`, `ak`             |     `.`      |         yes          | \_key                  | key of key-value pair, or left side of a assignment                                       | outer includes spaces                                                         |
|             `iK`, `aK`             |     `.`      |                      | @Block                 | code block (inside of a function, loop, ...)                                              | outer includes line above                                                     |
|             `il`, `al`             |     `.`      |         yes          | +Last                  | go to last mini.ai text-object (which start with @ or \_)                                 | requires `i`/`a` example `vilk`                                               |
|             `iL`, `aL`             |     `.`      |         yes          | @Loop                  | inside `while` or `for` clauses                                                           | outer includes blankline + comments + line above                              |
|             `im`, `am`             |     `.`      |         yes          | chainMember            | field with the full call, like `.encode(param)`                                           | outer includes the leading `.` (or `:`)                                       |
|             `iM`, `aM`             |     `.`      |         yes          | mdFencedCodeBlock      | markdown fenced code (enclosed by three backticks)                                        | outer includes the enclosing backticks                                        |
|             `in`, `an`             |     `.`      |         yes          | +Next                  | go to Next mini.ai text-object (which start with @ or \_)                                 | requires `i`/`a` example `viNk`                                               |
|             `iN`, `aN`             |     `.`      |         yes          | \_number               | numbers, similar to `<C-a>`                                                               | inner: only pure digits, outer: number including minus sign and decimal point |
|             `io`, `ao`             |     `.`      |         yes          | \_whitespaces          | whitespace beetween characters                                                            | outer includes surroundings                                                   |
|             `ip`, `ap`             |     `.`      |                      | paragraph              | blanklines can also be treat as paragraphs when focused on a blankline                    | outer includes below lines                                                    |
|             `iP`, `aP`             |     `.`      |         yes          | @Parameter             | parameters of a function (`>,` or `<,` to interchange)                                    | outer includes commas + spaces                                                |
|             `iq`, `aq`             |     `.`      |         yes          | @Call                  | like `function call` but treesitter aware                                                 | outer includes the function called                                            |
|             `iQ`, `aQ`             |     `.`      |         yes          | @Class                 | inside of a class                                                                         | outer includes class declaration                                              |
|             `ir`, `ar`             |     `.`      |                      | restOfIndentation      | lines down with same or higher indentation                                                | outer: restOfParagraph                                                        |
|             `iR`, `aR`             |     `.`      |         yes          | @Return                | inside of a Return clause                                                                 | outer includes the `return                                                    |
|             `is`, `as`             |     `.`      |                      | sentence               | sentence delimited by dots of blanklines                                                  | outer includes spaces                                                         |
|             `iS`, `aS`             |     `.`      |                      | subword                | like `iw`, but treating `-`, `_`, and `.` as word delimiters _and_ only part of camelCase | outer includes trailing `_`,`-`, or space                                     |
|             `it`, `at`             |     `.`      |         yes          | \_tag                  | inside of a html/jsx tag                                                                  | outer includes openning and closing tags                                      |
|             `iu`, `au`             |     `.`      |         yes          | \_quotes               | inside of `` '' ""                                                                        | outer includes openning and closing quotes                                    |
|             `iU`, `aU`             |     `.`      |         yes          | pyTripleQuotes         | python strings surrounded by three quotes (regular or f-string)                           | inner excludes the `"""` or `'''`                                             |
|             `iv`, `av`             |     `.`      |         yes          | \_value                | value of key-value pair, or right side of a assignment                                    | outer includes trailing commas or semicolons or spaces                        |
|             `iw`, `aw`             |     `.`      |                      | word                   | from cursor to end of word (delimited by punctuation or space)                            | outer includes start of word                                                  |
|             `iW`, `aW`             |     `.`      |                      | WORD                   | from cursor to end of WORD (includes punctuation)                                         | outer includes start of word                                                  |
|             `ix`, `ax`             |     `.`      |         yes          | \_Hex                  | hexadecimal number or color                                                               | outer includes hash `#`                                                       |
|             `iy`, `ay`             |     `.`      |                      | same_indent            | surrounding lines with only same indentation (delimited by blankspaces)                   | outer includes blankspaces                                                    |
|             `iz`, `az`             |     `.`      |                      | @fold                  | inside folds without line above neither below (supported only inside neovim)              | outer includes line above andd below                                          |
|             `iZ`, `aZ`             |     `.`      |         yes          | closedFold             | closed fold (supported only inside neovim)                                                | outer includes one line after the last folded line                            |
|             `i=`, `a=`             |     `.`      |         yes          | @Assignment.rhs-lhs    | assignmentt right and left without type keyword neither semicolons                        | inner: left assignment, outer: right assignment                               |
|             `i#`, `a#`             |     `.`      |         yes          | @Number                | like `_number` but treesitter aware                                                       | inner and outer are the same (only pure digits)                               |
|             `i?`, `a?`             |     `.`      |         yes          | \_Prompt               | will ask you for enter the delimiters of a text object (useful for dot repeteability)     | outer includes surroundings                                                   |
|       `i(`, `i)`, `a(`, `a)`       |     `.`      |         yes          | `(` or `)`             | inside `()`                                                                               | outer includes surroundings                                                   |
|       `i[`, `i]`, `a[`, `a]`       |     `.`      |         yes          | `[` or `]`             | inside `[]`                                                                               | outer includes surroundings                                                   |
|       `i{`, `i}`, `a{`, `a}`       |     `.`      |         yes          | `{` or `}`             | inside `{}`                                                                               | outer includes surroundings                                                   |
|       `i<`, `i>`, `a<`, `a>`       |     `.`      |         yes          | `<` or `>`             | inside `<>`                                                                               | outer includes surroundings                                                   |
|         `` i` ``, `` a` ``         |     `.`      |         yes          | apostrophe             | inside `` ` ` ``                                                                          | outer includes surroundings                                                   |
|             `i'`, `a'`             |     `.`      |         yes          | `'`                    | inside `''`                                                                               | outer includes surroundings                                                   |
|             `i"`, `a"`             |     `.`      |         yes          | `"`                    | inside `""`                                                                               | outer includes surroundings                                                   |
|             `i.`, `a.`             |     `.`      |         yes          | `.`                    | inside `..`                                                                               | outer includes surroundings                                                   |
|             `i,`, `a,`             |     `.`      |         yes          | `,`                    | inside `,,`                                                                               | outer includes surroundings                                                   |
|             `i;`, `a;`             |     `.`      |         yes          | `;`                    | inside `;;`                                                                               | outer includes surroundings                                                   |
|             `i-`, `a-`             |     `.`      |         yes          | `-`                    | inside `--`                                                                               | outer includes surroundings                                                   |
|             `i_`, `a_`             |     `.`      |         yes          | `_`                    | inside `__`                                                                               | outer includes surroundings                                                   |
|             `i/`, `a/`             |     `.`      |         yes          | `/`                    | inside `//`                                                                               | outer includes surroundings                                                   |
|            `i\|`, `a\|`            |     `.`      |         yes          | `\|`                   | inside `\|\|`                                                                             | outer includes surroundings                                                   |
|             `i&`, `a&`             |     `.`      |         yes          | `&`                    | inside `&&`                                                                               | outer includes surroundings                                                   |
| `i<punctuation>`, `a<punctuation>` |     `.`      |         yes          | `<punctuation>`        | inside `<punctuation><punctuation>`                                                       | outer includes surroundings                                                   |

</details>

## Neovim text object that starts with `g`

<details open><summary></summary>

| text-object keymap |  mode   | repeater key | text-object description                                       | normal mode                              | operating-pending mode | visual mode                  | examples in normal mode                                                          |
| :----------------: | :-----: | :----------: | :------------------------------------------------------------ | :--------------------------------------- | :--------------------- | :--------------------------- | :------------------------------------------------------------------------------- |
|    `g[` or `g]`    | `o`,`x` |              | +cursor to Left/right Around (only textobj with `@`,`_`)      |                                          | followed by textobject | uses selected region         | `vg]u` will select until quotation                                               |
|        `g<`        | `n`,`x` |     `.`      | +go to start of textobj                                       | followed by textobject                   |                        | selects from cursor position | `vg>iu` will select until end of quotation                                       |
|        `g>`        | `n`,`x` |     `.`      | +go to end of textobj                                         | followed by textobject                   |                        | selects form cursor position | `vg<iu` will select until start of quotation                                     |
|        `g.`        | `o`,`x` |              | Jump toLastChange                                             |                                          | won't jump             | uses selection               | `vg.` will select from cursor position until last change                         |
|        `ga`        | `n`,`x` |              | align                                                         | followed by textobject/motion            |                        | uses selected region         | `vipga=` will align a paragraph by `=`                                           |
|        `gA`        | `n`,`x` |              | preview align (`escape` to cancel, `enter` to accept)         | followed by textobject/motion            |                        | uses selected region         | `vipgA=` will align a paraghaph by `=`                                           |
|        `gb`        | `n`,`x` |     `.`      | Blackhole register                                            | followed by textobject/motion            |                        | deletes selection            | `vipgb` will delete a paragraph without copying                                  |
|        `gB`        | `n`,`x` |     `.`      | Blackhole linewise                                            | textobject not required                  |                        | deletes line                 | `gB.` will delete two lines without saving it in the register                    |
|        `gc`        | `o`,`x` |     `.`      | comment (`vgc` in normal mode will select a block comment)    |                                          | won't jump             | uses selection               | `vipgc` will comment a paragraph                                                 |
|        `gC`        | `o`,`x` |     `.`      | Block comment (supports selection `vgC`)                      |                                          | won't jump             | reselects                    | `vgC` will select current block of comment                                       |
|        `gd`        | `o`,`x` |     `.`      | Diagnostic (requires LSP so only works inside neovim)         |                                          | will find and jump     | will find and jump           | `vgd` will select the error                                                      |
|        `ge`        | `o`,`x` |              | Previous end of word                                          |                                          | uses cursor position   | uses selection               | `vge` will select from cursor position until previous end of word                |
|        `gE`        | `o`,`x` |              | Previous end of WORD ('WORD' omits punctuation )              |                                          | uses cursor position   | uses selection               | `vge` will select from cursor position until previous end of WORD                |
|        `gf`        | `o`,`x` |     `.`      | Next find                                                     |                                          | will find and jump     | uses selection               | `cgf???` will replace last search with `???` forwardly                           |
|        `gF`        | `o`,`x` |     `.`      | Prev find                                                     |                                          | will find and jump     | uses selection               | `cgF???` will replace last search with `???` backwardly                          |
|        `gg`        | `o`,`x` |     `.`      | First line                                                    |                                          | uses cursor position   | uses selection               | `vgg` will select until first line                                               |
|        `gh`        |   `x`   |     `.`      | Git hunk (vscode selects from cursor position to end of diff) |                                          | won't jump             | relesects                    | `vgh` will select modified code                                                  |
|        `gi`        | `n`,`x` |              | Last position of cursor in insert mode                        | will find and jump                       |                        | uses selection               | `vgi` will select until last insertion                                           |
|        `gj`        | `o`,`x` |     `.`      | GoDown when wrapped                                           |                                          | uses cursor position   | uses selection               | `vgj` will select one line down                                                  |
|        `gk`        | `o`,`x` |     `.`      | GoUp when wrapped                                             |                                          | uses cursor position   | uses selection               | `vgj` will select one line up                                                    |
|        `gK`        | `o`,`x` |     `.`      | column down until indent or shorter line                      |                                          | won't jump             | uses selection               | `vgK` will select column from cursor position until indent or shorter line       |
|        `gl`        | `o`,`x` |              | Last modified/yank/pasted (only `vgm` and `dgm` supported)    |                                          | won't jump             | reselects                    | `vgl` will select last change                                                    |
|        `gL`        | `o`,`x` |     `.`      | Url                                                           |                                          | will find and jump     | relesects                    | `vgL` will select url                                                            |
|        `gm`        | `n`,`x` |              | +Multiply (duplicate text) Operator                           |                                          | won't jump             | uses selection               | `vapgm` will duplicate paragraph without replacing clipboard                     |
|        `gn`        | `o`,`x` |     `.`      | +next (only textobj with `@`,`_`)                             |                                          | followed by textobject | uses selection               | `vgniu` will select from cursor position until next quotation                    |
|        `go`        | `o`,`x` |     `.`      | RestOfWindow                                                  |                                          | uses cursor position   | uses selection               | `vgo` will select from the cursorline to the last line in the window             |
|        `gO`        | `o`,`x` |     `.`      | VisibleWindow                                                 |                                          | uses cursor position   | uses selection               | `vgO` will select all lines visible in the current window                        |
|        `gp`        | `o`,`x` |     `.`      | +previous (only textobj with `@`,`_`)                         |                                          | followed by textobject | uses selection               | `vgpiu` will select from cursor position until previous quotation                |
|        `gq`        | `n`,`x` |     `.`      | +Format Selection/comments 80chars 80chars (LSP overrides it) | requires a textobject                    |                        | applies to selection         | `vipgq` will format a paragraph                                                  |
|        `gr`        | `n`,`x` |     `.`      | +Replace (with register) Operator                             | followed by textobject/motion            |                        | applies to selection         | `viwgr` will replace word with register (yanked text)                            |
|        `gs`        | `n`,`x` |     `.`      | +Sort Operator                                                | followed by textobject/motion            |                        | uses selection               | `vipgs` will sort paragraph                                                      |
|        `gS`        | `n`,`x` |     `.`      | Join/Split lines inside braces                                | will toggle inside `{}`,`[]`,`()`        |                        | followed by operator         | `vipgS` will join selected lines in one line                                     |
|        `gt`        | `o`,`x` |              | toNextQuotationMark                                           |                                          | uses cursor position   | uses selection               | `vigt` will select from cursor to next closing `'`, `"`, or `` ` ``              |
|        `gT`        | `o`,`x` |              | toNextClosingBracket                                          |                                          | uses cursor position   | uses selection               | `vigT` will select from cursor to next closing `]`, `)`, or `}`                  |
|        `gu`        | `n`,`x` |     `.`      | +tolowercase                                                  | requires a textobject                    |                        | applies to selection         | `vipgu` will lowercase a paragraph                                               |
|        `gU`        | `n`,`x` |     `.`      | +toUppercase                                                  | requires a textobject                    |                        | applies to selection         | `vipgU` will uppercase a paragraph                                               |
|        `gv`        | `n`,`x` |              | last selected                                                 | will find and jump                       |                        | reselects                    | `vgv` will select last selection                                                 |
|        `gw`        | `n`,`x` |     `.`      | Split/Join comments/lines 80chars (preserves cursor position) | requires a textobject                    |                        | applies to selection         | `vipgw` will split/join a paragraph limited by 80 characters                     |
|        `gx`        | `n`,`x` |     `.`      | +Exchange (text) Operator                                     | followed by textobject/motion            |                        | uses selection               | `viwgx` will exchange word with another `viwgY`                                  |
|        `gz`        | `n`,`x` |     `.`      | +Surround (followed by a=add, d=delete, r=replace)            | followed by textobject/motion (only add) |                        | uses selection (only add)    | `viwgza"` will add `"` to word, `gzd"` will delete `"`, `gzr"'` will replace `"` |
|        `g+`        | `n`,`x` |     `.`      | Increment number                                              | selects number under cursor              |                        | uses selected number         | `3g+` will increment by 3                                                        |
|        `g-`        | `n`,`x` |     `.`      | Decrement number                                              | selects number under cursor              |                        | uses selected number         | `g-..` will decrement by 3                                                       |
|      `g<Up>`       | `n`,`x` |              | Numbers ascending                                             | selects number under cursor              |                        | uses selected number         | `g<Up>` will increase selected numbers ascendingly                               |
|     `g<Down>`      | `n`,`x` |              | Numbers descending                                            | selects number under cursor              |                        | uses selected number         | `g<Down>` will decrease selected numbers descendingly                            |
|        `=`         | `n`,`x` |     `.`      | autoindent                                                    | followed by text-object                  |                        | uses selection               | `==` autoindents line                                                            |
|        `>`         | `n`,`x` |     `.`      | indent right                                                  | followed by text-object                  |                        | uses selection               | `>>` indents to right a line                                                     |
|        `<`         | `n`,`x` |     `.`      | indent left                                                   | followed by text-object                  |                        | uses selection               | `<<` indents to left a line                                                      |
|        `$`         |   `o`   |     `.`      | End of line                                                   |                                          |                        |                              | `d$j.` deletes two end-of-lines                                                  |
|        `%`         |   `o`   |              | Matching character: '()', '{}', '[]'                          | won't jump                               |                        | won't jump                   | `d%` deletes until bracket                                                       |
|        `0`         |   `o`   |     `.`      | Start of line                                                 |                                          |                        |                              | `d0` deletes until column 0                                                      |
|        `^`         |   `o`   |     `.`      | Start of line (non-blank)                                     |                                          |                        |                              | `d^` deletes until start of line (after whitespace)                              |
|        `(`         |   `o`   |     `.`      | Previous sentence                                             |                                          |                        |                              | `d(.` deletes until start of sentence (two times)                                |
|        `)`         |   `o`   |     `.`      | Next sentence                                                 |                                          |                        |                              | `d).` deletes until end of sentence (two times)                                  |
|        `{`         |   `o`   |     `.`      | Previous empty line (before a paragraph)                      |                                          |                        |                              | `d{.` deletes until next empty line (two times)                                  |
|        `}`         |   `o`   |     `.`      | Next empty line (after a paragraph)                           |                                          |                        |                              | `d}.` deletes until previous empty line (two times)                              |
|        `[[`        |   `o`   |     `.`      | Previous section                                              |                                          |                        |                              | `d[[` deletes until start of section                                             |
|        `]]`        |   `o`   |     `.`      | Next section                                                  |                                          |                        |                              | `d]]` deletes until end of section                                               |
|       `<CR>`       |   `o`   |     `.`      | Continue Last Flash search                                    |                                          |                        |                              | `d<CR><CR>` deletes until next searched text                                     |
|        `b`         |   `o`   |     `.`      | Previous word                                                 |                                          |                        |                              | `db` deletes until start of word                                                 |
|        `e`         |   `o`   |     `.`      | Next end of word                                              |                                          |                        |                              | `de` deletes until end of word                                                   |
|        `f`         |   `o`   |     `.`      | Move to next char                                             |                                          |                        |                              | `df,` deletes until a next `,`                                                   |
|        `F`         |   `o`   |     `.`      | Move to previous char                                         |                                          |                        |                              | `dF,` deletes until a previous `,`                                               |
|        `G`         |   `o`   |     `.`      | Last line                                                     |                                          |                        |                              | `dG` deletes until last line                                                     |
|        `R`         |   `o`   |     `.`      | Treesitter Flash Search                                       |                                          |                        |                              | `dR,<CR>` deletes next treesitter region that contains `,`                       |
|        `s`         |   `o`   |     `.`      | Flash (search with labels in current window)                  |                                          |                        |                              | `ds,<CR>` deletes until next `,`                                                 |
|        `S`         |   `o`   |     `.`      | Flash Treesitter                                              |                                          |                        |                              | `dS<CR>` deletes treesitter region under cursor position                         |
|        `t`         |   `o`   |     `.`      | Move before next char                                         |                                          |                        |                              | `dt` deletes before next `,`                                                     |
|        `T`         |   `o`   |     `.`      | Move before previous char                                     |                                          |                        |                              | `dT` deletes before previous `,`                                                 |
|        `w`         |   `o`   |     `.`      | Next word                                                     |                                          |                        |                              | `dw.` deletes 2 words                                                            |
|        `W`         |   `o`   |     `.`      | Next WORD                                                     |                                          |                        |                              | `dW.` deletes 2 WORDS                                                            |

</details>

## Neovim Motions and Operators

<details open><summary></summary>

| Motion/Operator keymap |  Mode   | Description                                              |      repeater key      | requires textobject/motion keymap? (operators requires textobjects/motion) | example when in normal mode                              |
| :--------------------: | :-----: | :------------------------------------------------------- | :--------------------: | :------------------------------------------------------------------------: | :------------------------------------------------------- |
|          `g[`          | `n`,`x` | +Cursor to Left Around (only textobj with `@`,`_`)       |                        |                                    yes                                     | `g]u` go to end to quotation                             |
|          `g]`          | `n`,`x` | +Cursor to Rigth Around (only textobj with `@`,`_`)      |                        |                                    yes                                     | `g[u` go to start of quotation                           |
|          `g<`          | `n`,`x` | +go to start of textobj                                  |          `.`           |                                    yes                                     | `g<iu` go to start of quotation                          |
|          `g>`          | `n`,`x` | +go to end of textobj                                    |          `.`           |                                    yes                                     | `g>iu` go to end of quotation                            |
|          `g.`          | `n`,`x` | go to last change                                        |                        |                                                                            |                                                          |
|          `g,`          |   `n`   | go forward in `:changes`                                 |                        |                                                                            |                                                          |
|          `g;`          |   `n`   | go backward in `:changes`                                |                        |                                                                            |                                                          |
|          `ga`          | `n`,`x` | +align                                                   |          `.`           |                                    yes                                     | `gaip=` will align a paragraph by `=`                    |
|          `gA`          | `n`,`x` | +preview align (escape to cancel, enter to accept)       |          `.`           |                                    yes                                     | `gAip=` will align a paragraph by `=`                    |
|          `gb`          | `n`,`x` | +Blackhole register                                      |          `.`           |                                    yes                                     | `gbip` delete a paragraph without copying                |
|          `gB`          | `n`,`x` | Blackhole linewise                                       |          `.`           |                                    yes                                     | `gB` delete line                                         |
|          `gc`          | `n`,`x` | +comment                                                 |          `.`           |                                    yes                                     | `gcip` comment a paragraph                               |
|          `gd`          |   `n`   | go to definition                                         |                        |                                                                            |                                                          |
|          `ge`          | `n`,`x` | go to previous endOfWord                                 |                        |                                                                            |                                                          |
|          `gE`          | `n`,`x` | go to previous endOfWord                                 |                        |                                                                            |                                                          |
|          `gf`          |   `n`   | go to file under cursor                                  |                        |                                                                            |                                                          |
|          `gg`          | `n`,`x` | go to first line                                         |                        |                                                                            |                                                          |
|          `gi`          | `n`,`x` | Last position of cursor in insert mode                   |                        |                                                                            |                                                          |
|          `gj`          | `n`,`x` | go to Down (when wrapped)                                |                        |                                                                            |                                                          |
|          `gJ`          | `n`,`x` | Join below Line                                          |          `.`           |                                                                            |                                                          |
|          `gk`          | `n`,`x` | go to Up (when wrapped)                                  |                        |                                                                            |                                                          |
|          `gm`          | `n`,`x` | +Multiply (duplicate text) Operator                      |                        |                                                                            | `gmap` duplicate paragraph withoug modifying clipboard   |
|          `gM`          | `n`,`x` | go to mid line                                           |                        |                                                                            |                                                          |
|          `gn`          | `n`,`x` | +next (only textobj with `@`,`_`)                        | `;`forward `,`backward |                                    yes                                     | `gniu` go to next quotation                              |
|          `gp`          | `n`,`x` | +previous (only textobj with `@`,`_`)                    | `;`forward `,`backward |                                    yes                                     | `gpiu` go to previous quotation                          |
|          `gq`          | `n`,`x` | +Format selection/comments                               |          `.`           |                                    yes                                     | `gqip` format a paragraph                                |
|          `gr`          | `n`,`x` | +Replace (with register) Operator                        |          `.`           |                                    yes                                     | `griw` replace word with register (yanked text)          |
|          `gs`          | `n`,`x` | +Sort Operator                                           |          `.`           |                                    yes                                     | `gsip` sort paragraph                                    |
|          `gS`          | `n`,`x` | SplitJoin args                                           |          `.`           |                                                                            |                                                          |
|          `gt`          |   `n`   | go to next tab                                           |                        |                                                                            |                                                          |
|          `gT`          |   `n`   | go to prev tab                                           |                        |                                                                            |                                                          |
|          `gu`          | `n`,`x` | +toLowercase                                             |          `.`           |                                    yes                                     | `guip` lowercase a paragraph                             |
|          `gU`          | `n`,`x` | +toUppercase                                             |          `.`           |                                    yes                                     | `gUip` uppercase a paragraph                             |
|          `gv`          | `n`,`x` | last selected                                            |                        |                                                                            |                                                          |
|          `gw`          | `n`,`x` | +SplitJoin coments/lines 80chars (keeps cursor position) |          `.`           |                                    yes                                     | `gwip` split/join a paragraph by 80 characters           |
|          `gx`          | `n`,`x` | +Exchange (text) Operator                                |          `.`           |                                    yes                                     | `gxiw` exchange word with another `gxiw`                 |
|          `gy`          |   `n`   | Redo register (dot to paste forward)                     |          `.`           |                                                                            |                                                          |
|          `gY`          |   `n`   | Redo register (dot to paste backward)                    |          `.`           |                                                                            |                                                          |
|          `gz`          | `n`,`x` | +Surround (followed by a=add, d=delete, r=replace)       |          `.`           |                                    yes                                     | `gzaiw"` add `"`, `gzd"` delete `"`, `gzr"'` replace `"` |
|          `g+`          | `n`,`x` | Increment number                                         |          `.`           |                                    yes                                     | `10g+` increment by 10                                   |
|          `g-`          | `n`,`x` | Decrement number                                         |          `.`           |                                    yes                                     | `g-` decrement by 1                                      |
|          `=`           | `n`,`x` | +autoindent                                              |          `.`           |                                    yes                                     | `=ip` autoindents paragraph                              |
|          `>`           | `n`,`x` | +indent right                                            |          `.`           |                                    yes                                     | `>ip` indents to right a paragraph                       |
|          `<`           | `n`,`x` | +indent left                                             |          `.`           |                                    yes                                     | `<ip` indents to left a paragraph                        |
|          `$`           | `n`,`x` | End of line                                              |                        |                                                                            |                                                          |
|          `%`           | `n`,`x` | Matching character: '()', '{}', '[]'                     |                        |                                                                            |                                                          |
|          `0`           | `n`,`x` | Start of line                                            |                        |                                                                            |                                                          |
|          `^`           | `n`,`x` | Start of line (non-blank)                                |                        |                                                                            |                                                          |
|          `(`           | `n`,`x` | Previous sentence                                        |                        |                                                                            |                                                          |
|          `)`           | `n`,`x` | Next sentence                                            |                        |                                                                            |                                                          |
|          `{`           | `n`,`x` | Previous empty line (paragraph)                          |                        |                                                                            |                                                          |
|          `}`           | `n`,`x` | Next empty line (paragraph)                              |                        |                                                                            |                                                          |
|          `[[`          | `n`,`x` | Previous section                                         |                        |                                                                            |                                                          |
|          `]]`          | `n`,`x` | Next section                                             |                        |                                                                            |                                                          |
|         `<CR>`         | `n`,`x` | Continue Last Flash search                               |                        |                                                                            |                                                          |
|          `b`           | `n`,`x` | Previous word                                            |                        |                                                                            |                                                          |
|          `e`           | `n`,`x` | Next end of word                                         |                        |                                                                            |                                                          |
|          `f`           | `n`,`x` | Move to next char                                        |          `f`           |                                                                            |                                                          |
|          `F`           | `n`,`x` | Move to previous char                                    |          `F`           |                                                                            |                                                          |
|          `G`           | `n`,`x` | Last line                                                |                        |                                                                            |                                                          |
|          `R`           |   `x`   | Treesitter Flash Search                                  |                        |                                                                            |                                                          |
|          `s`           | `n`,`x` | Flash (search with labels in current window)             |         `<CR>`         |                                                                            |                                                          |
|          `S`           | `n`,`x` | Flash Treesitter                                         |                        |                                                                            |                                                          |
|          `t`           | `n`,`x` | Move before next char                                    |          `t`           |                                                                            |                                                          |
|          `T`           | `n`,`x` | Move before previous char                                |          `T`           |                                                                            |                                                          |
|          `U`           |   `n`   | repeat `:normal <keys>` or `:<commands>`                 |                        |                                                                            |                                                          |
|          `w`           | `n`,`x` | Next word                                                |                        |                                                                            |                                                          |
|          `W`           | `n`,`x` | Next WORD                                                |                        |                                                                            |                                                          |
|          `Y`           | `n`,`x` | Yank until end of line                                   |                        |                                                                            |                                                          |

</details>

## Neovim Space TextObjects/Motions

<details open><summary></summary>

|      Keymap       |    Mode     | Description                                |      repeater key      |
| :---------------: | :---------: | :----------------------------------------- | :--------------------: |
|   `<leader>uU`    |     `n`     | Go to parent fold (only inside VSCode)     |          `.`           |
| `<space><space>p` |   `n`,`x`   | Paste after (secondary clipboard)          |          `.`           |
| `<space><space>P` |   `n`,`x`   | Paste before (secondary clipboard)         |          `.`           |
| `<space><space>y` |   `n`,`x`   | Yank (secondary clipboard)                 |                        |
| `<space><space>Y` |   `n`,`x`   | Yank until EndOfLine (secondary clipboard) |                        |
| `<space><space>j` | `n`,`x`,`o` | prev ColumnMove                            | `;`forward `,`backward |
| `<space><space>k` | `n`,`x`,`o` | next ColumnMove                            | `;`forward `,`backward |

</details>

## Neovim Mini.brackets

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
| `[u`/`]u`/`[U`/`]U` | `n`,`o`,`x` | prev/next/first/last undo                            |
| `[w`/`]w`/`[W`/`]W` | `n`,`o`,`x` | prev/next/first/last window (only inside neovim)     |
| `[y`/`]y`/`[Y`/`]Y` | `n`,`o`,`x` | prev/next/first/last yank                            |

</details>

## Neovim Go to Previous / Next

<details open><summary></summary>

|   Keymap    |    Mode     | Description                                                                                                                                |      repeater key      |
| :---------: | :---------: | :----------------------------------------------------------------------------------------------------------------------------------------- | :--------------------: |
| `gpc`/`gnc` | `n`,`o`,`x` | previous/next comment                                                                                                                      | `;`forward `,`backward |
| `gpd`/`gnd` | `n`,`o`,`x` | previous/next diagnostic                                                                                                                   | `;`forward `,`backward |
| `gpf`/`gnf` | `n`,`x`,`o` | @fold ending/beginning (only inside neovim)                                                                                                | `;`forward `,`backward |
| `gph`/`gnh` | `n`,`o`,`x` | previous/next git hunk ([no supported on Windows10](https://github.com/YeferYV/RetroNvim/wiki/Recipies/#gnh-gph-not-working-on-windows10)) | `;`forward `,`backward |
| `gpH`/`gnH` | `n`,`o`,`x` | previous/next git hunk (supported on Windows10)                                                                                            | `;`forward `,`backward |
| `gpr`/`gnr` | `n`,`o`,`x` | previous/next reference (only inside vscode)                                                                                               | `;`forward `,`backward |

</details>

## Neovim Go to Previous_Start / Next_Start / Previous_End / Next_End of

<details open><summary></summary>

|               Keymap                |    Mode     | Description                                                      |      Repeater Key      |
| :---------------------------------: | :---------: | :--------------------------------------------------------------- | :--------------------: |
| `gpaK` / `gnaK` / `gpeaK` / `gneaK` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @block.outer          | `;`forward `,`backward |
| `gpaq` / `gnaq` / `gpeaq` / `gneaq` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @call.outer           | `;`forward `,`backward |
| `gpaQ` / `gnaQ` / `gpeaQ` / `gneaQ` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @class.outer          | `;`forward `,`backward |
| `gpag` / `gnag` / `gpeag` / `gneag` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @comment.outer        | `;`forward `,`backward |
| `gpaG` / `gnaG` / `gpeaG` / `gneaG` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @conditional.outer    | `;`forward `,`backward |
| `gpaF` / `gnaF` / `gpeaF` / `gneaF` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @function.outer       | `;`forward `,`backward |
| `gpaL` / `gnaL` / `gpeaL` / `gneaL` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @loop.outer           | `;`forward `,`backward |
| `gpaP` / `gnaP` / `gpeaP` / `gneaP` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @parameter.outer      | `;`forward `,`backward |
| `gpaR` / `gnaR` / `gpeaR` / `gneaR` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @return.outer         | `;`forward `,`backward |
| `gpaA` / `gnaA` / `gpeaA` / `gneaA` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @assignment.outer     | `;`forward `,`backward |
| `gpa=` / `gna=` / `gpea=` / `gnea=` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @assignment.lhs       | `;`forward `,`backward |
| `gpa#` / `gna#` / `gpea#` / `gnea#` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @number.outer         | `;`forward `,`backward |
| `gpaf` / `gnaf` / `gpeaf` / `gneaf` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_function      | `;`forward `,`backward |
| `gpah` / `gnah` / `gpeah` / `gneah` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_htmlAttribute | `;`forward `,`backward |
| `gpak` / `gnak` / `gpeak` / `gneak` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_key           | `;`forward `,`backward |
| `gpaN` / `gnaN` / `gpeaN` / `gneaN` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_number        | `;`forward `,`backward |
| `gpau` / `gnau` / `gpeau` / `gneau` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_quote         | `;`forward `,`backward |
| `gpax` / `gnax` / `gpeax` / `gneax` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of outer \_Hex           | `;`forward `,`backward |
| `gpiB` / `gniB` / `gpeiB` / `gneiB` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @block.inner          | `;`forward `,`backward |
| `gpiq` / `gniq` / `gpeiq` / `gneiq` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @call.inner           | `;`forward `,`backward |
| `gpiQ` / `gniQ` / `gpeiQ` / `gneiQ` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @class.inner          | `;`forward `,`backward |
| `gpig` / `gnig` / `gpeig` / `gneig` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @comment.inner        | `;`forward `,`backward |
| `gpiG` / `gniG` / `gpeiG` / `gneiG` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @conditional.inner    | `;`forward `,`backward |
| `gpiF` / `gniF` / `gpeiF` / `gneiF` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @function.inner       | `;`forward `,`backward |
| `gpiL` / `gniL` / `gpeiL` / `gneiL` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @loop.inner           | `;`forward `,`backward |
| `gpiP` / `gniP` / `gpeiP` / `gneiP` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @parameter.inner      | `;`forward `,`backward |
| `gpiR` / `gniR` / `gpeiR` / `gneiR` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @return.inner         | `;`forward `,`backward |
| `gpiA` / `gniA` / `gpeiA` / `gneiA` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @assignment.inner     | `;`forward `,`backward |
| `gpi=` / `gni=` / `gpei=` / `gnei=` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @assignment.rhs       | `;`forward `,`backward |
| `gpi#` / `gni#` / `gpei#` / `gnei#` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of @number.inner         | `;`forward `,`backward |
| `gpif` / `gnif` / `gpeif` / `gneif` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_function      | `;`forward `,`backward |
| `gpih` / `gnih` / `gpeih` / `gneih` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_htmlAttribute | `;`forward `,`backward |
| `gpik` / `gnik` / `gpeik` / `gneik` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_key           | `;`forward `,`backward |
| `gpin` / `gnin` / `gpein` / `gnein` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_number        | `;`forward `,`backward |
| `gpiu` / `gniu` / `gpeiu` / `gneiu` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_quote         | `;`forward `,`backward |
| `gpix` / `gnix` / `gpeix` / `gneix` | `n`,`o`,`x` | prev_start/next_start/prev_end/next_end of inner \_Hex           | `;`forward `,`backward |

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

## Terminal keymaps

<details open><summary></summary>

| Key Combination    | Description                                              |
| :----------------: | :------------------------------------------------------- |
|     `alt+c`        | Copy selection in terminal                               |
|     `alt+v`        | Paste in terminal                                        |
|     `alt+y`        | send sequence to open yazi                               |
|     `alt+r`        | Scroll terminal to next command                          |
|     `alt+w`        | Scroll terminal to previous command                      |
|     `alt+e`        | Scroll terminal up                                       |
|     `alt+d`        | Scroll terminal down                                     |
|     `alt+q`        | Scroll terminal up by page                               |
|     `alt+a`        | Scroll terminal down by page                             |
|     `alt+t`        | Scroll terminal to top                                   |
|     `alt+g`        | Scroll terminal to bottom                                |
|    `alt+left`      | Resize terminal pane left                                |
|   `alt+right`      | Resize terminal pane right                               |
|    `alt+down`      | Resize terminal pane down                                |
|     `alt+up`       | Resize terminal pane up                                  |
|   `alt+ctrl+r`     | select from shell history                                |
|       `Up`         | previous shell history                                   |
|      `Down`        | next shell history                                       |
|     `ctrl+d`       | exit signal                                              |
|     `ctrl+c`       | cancel signal                                            |
|     `ctrl+r`       | search shell history                                     |
|  `ctrl+backspace`  | delete word                                              |
|      `Home`        | jump to start of line (powershelll and bash only)        |
|      `End`         | jump to end of line  (powershelll and bash only)         |
|   `ctrl+left`      | jump backward word (powershelll and bash only)           |
|   `ctrl+right`     | jump forward word (powershelll and bash only)            |
| `ctrl+alt+shift+?` | show shortcuts (powershelll only)                        |
|     `bind -P`      | show shortcuts (bash only, emacs keybindings by default) |

</details>

## Suggestion keymaps

<details open><summary></summary>

|  Key Combination   | mode | Description                                |
| :----------------: | :--: | :----------------------------------------- |
|      `ctrl+i`      | `i`  | Toggle suggestion details                  |
|    `ctrl+space`    | `i`  | Toggle suggestion widget                   |
| `ctrl+shift+space` | `i`  | Toggle parameter hints                     |
|  `ctrl+alt+space`  | `i`  | Toggle suggestion focus                    |
|      `alt+j`       | `i`  | Show next inline suggestion                |
|      `alt+k`       | `i`  | Show previous inline suggestion            |
|      `alt+l`       | `i`  | Commit inline suggestion                   |
|      `ctrl+j`      | `i`  | Select next suggestion                     |
|      `ctrl+k`      | `i`  | Select previous suggestion                 |
|      `ctrl+l`      | `i`  | Accept selected suggestion                 |
|      `ctrl+d`      | `i`  | Select next page in suggestion details     |
|      `ctrl+u`      | `i`  | Select previous page in suggestion details |

</details>

## Editor keymaps (keybindings.json)

<details open><summary></summary>

|     Key Combination      |    mode     | Description                                              |
| :----------------------: | :---------: | :------------------------------------------------------- |
|         `ctrl+\`         |     `n`     | Toggle panel (terminal) visibility                       |
|      `shift+space`       |     `n`     | Show whichkey menu (Windows, Linux, Mac)                 |
|       `alt+space`        |     `n`     | Show whichkey menu (Linux, Mac)                          |
|         `alt+.`          |     `n`     | Repeat most recent Whichkey action                       |
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
|           `h`            |     `n`     | Move cursor left ( Windows10 `<number>h` not supported ) |
|           `j`            |     `n`     | Move cursor down ( Windows10 `<number>j` not supported ) |
|           `k`            |     `n`     | Move cursor up ( Windows10 `<number>k` not supported )   |
|           `l`            |     `n`     | Move cursor right ( Windows10 `<number>l` not supported) |

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
|    `ctrl+u`     | `n`,`v` | scroll up by half page                                                                                                      |
|    `ctrl+v`     | `n`,`v` | visual block mode                                                                                                           |
|    `ctrl+w`     | `n`,`v` | See [vscode-window-commands.vim](https://github.com/vscode-neovim/vscode-neovim/blob/master/vim/vscode-window-commands.vim) |
|    `ctrl+x`     | `n`,`v` | decrease number under cursor                                                                                                |
|    `ctrl+y`     | `n`,`v` | scroll up by line                                                                                                           |
|    `ctrl+/`     | `n`,`v` | comment line                                                                                                                |

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
_    _    @sh  @vim _    _    _    _    @vi  _    _    _    _    _
_    @mw↑ spc  bspc @yaz @laz left down up   rght @mw↓ _    _
_    @za  @zr  caps @cod _    @ñ   _    _    _    _    _
_    _    _              _              _    _    _
```

**layer yazi-find** (press and release space+f to enter the layer)

```
_    _    _    _    _    _    _    _    _    _    _    _    _    _
_    /^q  /^w  /^e  /^r  /^t  /^y  /^u  /^i  /^o  /^p  _    _    _
_    /^a  /^s  /^d  /^f  /^g  /^h  /^j  /^k  /^l  _    _    _
_    /^z  /^x  /^c  /^v  /^b  /^n  /^m  _    _    _    _
_    _    _              _              _    _    _
```

| key  | description                                                                               |          example / keymap          | not supported key on: |
| :--: | :---------------------------------------------------------------------------------------- | :--------------------------------: | :-------------------: |
| @grl | tap: backtick/grave, hold and press `1` = qwerty layer, hold and press `2` = dvorak layer |         `` `+2 = dvorak ``         |                       |
| @cap | tap for escape, hold for LeftCtrl                                                         |          `cap+l = ctrl+l`          |                       |
| @sft | tap for backspace, hold for LeftShift                                                     |         `RAlt+l = shift+l`         |                       |
| @alt | tap for middle click, hold for LeftAlt                                                    |         `LAlt+l = LAlt+l`          |         macos         |
| @spc | tap for space, hold for touchcursor layer, release for qwerty layer                       | `space+jj = DownArrow + DownArrow` |                       |
| @yaz | tap and release then press one key in yazi-find layer (timeout: 500ms)                    |     `space+f l = jump to file`     |                       |
| @sh  | open shell inside yazi                                                                    |             `space+w`              |                       |
| @vim | open with neovim inside yazi                                                              |             `space+e`              |                       |
| @vi  | open with $EDITOR inside yazi                                                             |             `space+i`              |                       |
| @cod | open with vscode inside yazi                                                              |             `space+v`              |                       |
| @laz | open lazygit inside yazi                                                                  |             `space+g`              |                       |
| @za  | zoxide add current working directory inside yazi                                          |             `space+z`              |                       |
| @zr  | zoxide remove current working directory inside yazi                                       |             `space+x`              |                       |
|  @ñ  | unicode ñ                                                                                 |             `space+n`              |         macos         |
| @mw↑ | mouse scrolling up                                                                        |             `space+a`              |         macos         |
| @mw↓ | mouse scrolling down                                                                      |             `space+;`              |         macos         |
| spc  | presses espace                                                                            |             `space+s`              |                       |
| bspc | presses backspace                                                                         |             `space+d`              |                       |
| left | presses left arrow                                                                        |             `space+h`              |                       |
| down | presses down arrow                                                                        |             `space+j`              |                       |
|  up  | presses up arrow                                                                          |             `space+k`              |                       |
| rght | presses right arrow                                                                       |             `space+l`              |                       |
| caps | toggles capslock                                                                          |             `space+c`              |                       |

</details>

---

## Terminal dependencies (optional)

<details open><summary></summary>

RetroNvim extension is shipped with `neovim`, `yazi` and `kanata` binaries and `neovim`'s extensions, `zsh`'s extensions, and `yazi`'s extensions as git-submodules

To install terminal dependencies after installing retronvim extension, open
`whichkey` > `+Install Dependencies` > `install <your package manager>` > `<your package manager> install lazygit startship zsh` > relaunch vscode

</details>

## Treesitter Installation

<details open><summary></summary>

Text objects that has a `@` prefix requires a treesitter parser, neovim version `0.10` or newer comes with treesitter parsers for
`c`, `lua`, `markdown`.
Install treesitter parser for your programming language with `:TSInstall <your programming language>`
( on Windows 10/11 `:TSInstall` requires `scoop install zig` )( on MacOS `https://brew.sh` installs `gcc` which is required by `:TSInstall` ).

Example: in normal mode type `:` to open vim-command-line then type `TSInstall cpp`

Tip: for new retronvim releases you need to install again all your the treesitter parsers

Tip: to make a clean tressitter parser installation remove the folder
`rm -rf ~/.vscode/extensions/yeferyv.retronvim-0.1.0/nvim/plugins/site/pack/deps/opt/nvim-treesitter/parser` (on linux and mac),
`rm -r -force ~/.vscode/extensions/yeferyv.retronvim-0.1.0/nvim/plugins/site/pack/deps/opt/nvim-treesitter/parser` (on Windows 10/11)

</details>

## Vim Cheatsheets / Tutorials

<details open><summary></summary>

- [devhints.io/vim](https://devhints.io/vim)
- [viemu.com](http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)
- [vscode with embedded neovim](https://www.youtube.com/watch?v=g4dXZ0RQWdw) youtube tutorial most of the keybindings are similar to RetroNvim
- [treesitter text-objects demo](https://www.youtube.com/watch?v=FuYQ7M73bC0) youtube tutorial the keybindings are similar to RetroNvim
- [treesitter text-objects extended](https://www.youtube.com/watch?v=CEMPq_r8UYQ) youtube tutorial the keybindings are similar to RetroNvim
- [text-objects from A-Z](https://www.youtube.com/watch?v=JnD9Uro_oqc) youtube tutorial the keybindings are similar to RetroNvim
- [motion-operators from A-Z](https://www.youtube.com/watch?v=HhZJ1kbzkj0) youtube tutorial the keybindings are the same as to RetroNvim

</details>

## Related projects

<details open><summary></summary>

- [yeferyv/archrice](https://github.com/yeferyv/archrice) (RetroNvim linux distro) comes with retronvim's neovim extensions + extra extensions, based on [mini.nvim](https://github.com/echasnovski/mini.nvim)
- [yeferyv/sixelrice](https://github.com/yeferyv/sixelrice) (terminal version of RetroNvim) neovim with text objects from A-Z, based on [lazyvim](https://github.com/LazyVim/LazyVim)
- [lunarkeymap](https://github.com/fathulfahmy/lunarkeymap) vscode vim extension with some text objects + whichkey with [lunarvim](https://github.com/lunarvim/lunarvim)-like keymaps
- [vspacecode](https://github.com/vspacecode/vspacecode) vscode vim extension with some text objects + whichkey with [spacemacs](https://github.com/syl20bnr/spacemacs)-like keymaps

</details>
