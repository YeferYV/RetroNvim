# psreadline version 2.3 enables:    `Set-PSReadLineOption -PredictionSource History`
# psreadline version 2.3 enabled by: `$env:psmodulepath="$HOME/.vscode/extensions/yeferyv.retronvim/powershell/modules;$env:psmodulepath"; powershell`

function ll() { eza --long --all --icons --group-directories-first $args; }

function y() { yazi $PWD --cwd-file=$HOME/.yazi $args; cd $(cat $HOME/.yazi); write-host -NoNewline "`e[A`e[K"; }

function yy() { start-process -NoNewWindow -Wait yazi -ArgumentList $PWD,"--cwd-file=$HOME/.yazi"; cd $(cat $HOME/.yazi); } # start-process is a equivalent of </dev/tty

function action() { [Microsoft.PowerShell.PSConsoleReadLine]::$args(); }

function action2() { [Microsoft.PowerShell.PSConsoleReadLine]::insert($args) }

function fzf_history() { return (Get-Content $env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt -Raw) -replace "```n", " " | fzf --tac; }

# https://github.com/PowerShell/PSReadLine/issues/3159
function cursor {
  # $esc = [char]27
  $ESC = "$([char]0x1b)"

  if ($args[0] -eq 'command') {
    # write-host -nonewline "`e[2 q";     # not supported on powershell version 5
    # [Console]::Write("$esc[2 q")        # block cursor # works on powershell version 5 but it flickers with starship
     Write-Host -NoNewLine "${ESC}[2 q"   # block cursor
  } else {
    # write-host -nonewline "$esc[6 q";   # not supported on powershell version 5
    # [Console]::Write("$esc[6 q")        # beam cursor # works on powershell version 5 but it flickers with starship
     Write-Host -NoNewLine "${ESC}[6 q"   # beam cursor
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

$env:RETRONVIM_PATH=(Get-ChildItem -Path "$HOME\.*\extensions\yeferyv.retronvim*" | Select-Object -First 1).FullName
$env:BAT_THEME="base16"
$env:EDITOR="nvim"
$env:FZF_DEFAULT_OPTS="--color 'hl:-1:reverse,hl+:-1:reverse' --preview 'bat --color=always {}' --preview-window 'hidden' --bind '?:toggle-preview' --multi --bind 'ctrl-s:select-all+reload:sort --reverse --ignore-case {+f}'"
$env:FONT_PATH="$HOME\AppData\Local\Microsoft\Windows\Fonts\FiraCodeNerdFont-Bold.ttf"
$env:HOME=$env:USERPROFILE # fot ~/.gitconfig
$env:LESSKEYIN="$env:RETRONVIM_PATH/yazi/lesskey"
$env:PATH="$env:RETRONVIM_PATH\bin\windows\envs\windows\Library\bin;$env:RETRONVIM_PATH\bin\windows\envs\windows\Library\mingw64\bin;$HOME\.pixi\bin;$HOME\appdata\local\pnpm;$HOME\.local\bin;${env:PATH};"
$env:PNPM_HOME="$HOME/appdata/local/pnpm"
$env:RETRONVIM_BIN="$env:RETRONVIM_PATH\bin\windows\envs\windows\Library\bin"
$env:STARSHIP_CONFIG="$env:RETRONVIM_PATH/powershell/starship.toml"
$env:SHELL="powershell"
$env:VIMINIT="lua vim.cmd.source(vim.env.RETRONVIM_PATH .. [[/nvim/init.lua]])"
$env:YAZI_CONFIG_HOME="$env:RETRONVIM_PATH/yazi"
$env:YAZI_FILE_ONE="$env:RETRONVIM_PATH/bin/windows/envs/windows/Library/usr/bin/file.exe"

set-alias which get-command

if ( -not (Test-Path $env:RETRONVIM_BIN) -and $env:OS -eq "Windows_NT" ) { try { cd $env:RETRONVIM_PATH/bin; ./7zr.exe x windows.7z; cd ~; } catch {}; }
if ( -not (Test-Path $env:FONT_PATH)     -and $env:OS -eq "Windows_NT" ) { $ErrorActionPreference = 'SilentlyContinue'; set-executionpolicy bypass currentuser; & "$env:RETRONVIM_PATH\bin\nerd-fonts\install.ps1"; }
if ( get-command starship -ErrorAction SilentlyContinue                ) { iex (&starship init powershell);                  }
if ( $env:TERM_PROGRAM   -eq "vscode" -and -not $env:SHELLINTEGRATION  ) { . "$(code --locate-shell-integration-path pwsh)"; $env:SHELLINTEGRATION=1 } # should be after starship otherwise won't work
if ( $env:CHROME_DESKTOP -eq "windsurf"                                ) { set-alias code "winsurf" } # whichkey uses `code --install-extension ...`
if ( $env:CHROME_DESKTOP -eq "cursor"                                  ) { set-alias code "cursor" } # whichkey uses `code --install-extension ...`
