# psreadline version 2.3 enables:    `Set-PSReadLineOption -PredictionSource History`
# psreadline version 2.3 enabled by: `$env:psmodulepath="$HOME/.vscode/extensions/yeferyv.retronvim/powershell/modules;$env:psmodulepath"; powershell`

function ll() { eza --long --all --icons --group-directories-first $args; }

function vi() { nvim -u $HOME/.vscode/extensions/yeferyv.retronvim/nvim/init.lua $args; }

function y() { yazi $PWD --cwd-file=$HOME/.yazi $args; cd $(cat $HOME/.yazi); write-host -NoNewline "`e[A`e[K"; }

function yy() { start-process -NoNewWindow -Wait yazi -ArgumentList $PWD,"--cwd-file=$HOME/.yazi"; cd $(cat $HOME/.yazi); } # start-process is a equivalent of </dev/tty

function action() { [Microsoft.PowerShell.PSConsoleReadLine]::$args(); }

function action2() { [Microsoft.PowerShell.PSConsoleReadLine]::insert($args) }

function fzf_history() { return (Get-Content $env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt -Raw) -replace "```n", " " | fzf --tac; }

function cursor {
  $esc = [char]27

  if ($args[0] -eq 'command') {
    # write-host -nonewline "`e[2 q";   # not supported on powershell version 5
    [Console]::Write("$esc[2 q")        # block cursor # works on powershell version 5 but it flickers with starship
  } else {
    # write-host -nonewline "$esc[6 q"; # not supported on powershell version 5
    [Console]::Write("$esc[6 q")        # beam cursor # works on powershell version 5 but it flickers with starship
  }
}

cursor # start with beam cursor

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $function:cursor
Set-PSreadLineOption -editmode vi
# Set-PsreadLineOption -Colors @{}
# Set-PSReadLineKeyHandler -key alt+o -ScriptBlock { action RevertLine; y          ; action AcceptLine; write-host -NoNewline "`e[K"; } # can't get a /dev/tty for neovim
# Set-PSReadLineKeyHandler -key alt+o -ScriptBlock { action RevertLine; action2 'y'; action AcceptLine; }                               # clears the current command to make it work
Set-PSReadLineKeyHandler -key alt+o  -ScriptBlock { yy; action InvokePrompt; cursor; }
Set-PSReadLineKeyHandler -key alt+l  -ScriptBlock { action AcceptSuggestion; action ViCommandMode; }
Set-PSReadLineKeyHandler -key alt+k  -ScriptBlock { action HistorySearchBackward; action ViCommandMode; }
Set-PSReadlineKeyHandler -key ctrl+r -ScriptBlock { action RevertLine; action2 "$(fzf_history)"; cursor; }
Set-PSReadlineKeyHandler -key alt+k  -Function HistorySearchBackward -ViMode Command # `-Function PreviousHistory` if you don't want to search current typed command
Set-PSReadlineKeyHandler -key alt+j  -Function HistorySearchForward  -ViMode Command # `-Function NextHistory` if you don't want to search current typed command
Set-PSReadLineKeyHandler -key alt+h  -Function ViCommandMode
Set-PSReadlineKeyHandler -key tab    -Function MenuComplete

$env:BAT_THEME="base16"
$env:EDITOR="nvim"
$env:FZF_DEFAULT_OPTS="--color 'hl:-1:reverse,hl+:-1:reverse' --preview 'bat --color=always {}' --preview-window 'hidden' --bind '?:toggle-preview' --multi --bind 'ctrl-s:select-all+reload:sort --reverse --ignore-case {+f}'"
$env:LESSKEYIN="$HOME/.vscode/extensions/yeferyv.retronvim/yazi/lesskey"
$env:PATH_RIPGREP="$HOME\AppData\Local\Programs\Microsoft VS Code\resources\app\node_modules\@vscode\ripgrep\bin"
$env:PATH="$HOME\.vscode\extensions\yeferyv.retronvim\bin\windows\envs\windows\Library\bin;$HOME\.pixi\bin;$HOME\appdata\local\pnpm;$HOME\local\bin;${env:RIPGREP_PATH};${env:PATH};"
$env:PNPM_HOME="$HOME/appdata/local/pnpm"
$env:PROFILE="$HOME/.vscode/extensions/yeferyv.retronvim/powershell/profile.ps1"
$env:STARSHIP_CONFIG="$HOME/.vscode/extensions/yeferyv.retronvim/powershell/starship.toml"
$env:RETRONVIM_INIT=(Get-ChildItem -Path "$HOME\.vscode\extensions\yeferyv.retronvim*").FullName
$env:VIMINIT="lua vim.cmd.source([[~/.vscode/extensions/yeferyv.retronvim/nvim/init.lua]])"
$env:YAZI_CONFIG_HOME="$HOME/.vscode/extensions/yeferyv.retronvim/yazi"
$env:YAZI_FILE_ONE="$HOME/.vscode/extensions/yeferyv.retronvim/bin/windows/envs/windows/Library/usr/bin/file.exe"

set-alias which get-command

if (get-command starship -ErrorAction SilentlyContinue) { iex (&starship init powershell);                  }
if ($env:TERM_PROGRAM -eq "vscode")                     { . "$(code --locate-shell-integration-path pwsh)"; } # should be after starship otherwise won't work
