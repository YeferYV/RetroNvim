autoload -U compinit && compinit -u -d $HOME/.cache/.zcompdump # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt share_history                                           # share history across sessions
setopt append_history                                          # required by fzf and autosuggestions
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }      # tmux/wezterm CWD status/title
fpath=(~/.nix-profile/share/zsh/site-functions/ $fpath)        # activates tab completion for https://github.com/chubin/cheat.sh

# linux keyboard repeat rate
(
  [[ -e $XAUTHORITY                  ]] && xset b off r rate 210 70                2>/dev/null
  [[ -e $SWAYSOCK                    ]] && swaymsg input "*" repeat_delay 210      2>/dev/null
  [[ -e $SWAYSOCK                    ]] && swaymsg input "*" repeat_rate 70        2>/dev/null
  [[ -e $HYPRLAND_INSTANCE_SIGNATURE ]] && hyprctl keyword input:repeat_delay 210  2>/dev/null
  [[ -e $HYPRLAND_INSTANCE_SIGNATURE ]] && hyprctl keyword input:repeat_rate 70    2>/dev/null
)

# Change cursor shape for different vi modes.
zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

# yazi cd on exit (then moves the cursor up and clear until end of line)
y()  { yazi --cwd-file=$HOME/.yazi $@; cd "$(cat $HOME/.yazi)"; printf "\x1b[A\x1b[K"; }

# yazi cd on exit (even while writing commands)
yy() { yazi --cwd-file=$HOME/.yazi $@ < /dev/tty; cd "$(cat $HOME/.yazi)"; zle reset-prompt; echo -ne "\e[6 q"; }
zle -N yy          # creating `yy` keymap
bindkey '\eo' 'yy' # \eo = alt + o

alias  apt="sudo apt -y"
alias  cht="cht.sh"                       # nix-env -iA nixpkgs.cht-sh
alias  grep="grep --color=auto"
alias  ll="ls -l"
alias  svim="NVIM_APPNAME=sixelrice nvim" # git clone https://github.com/yeferyv/sixelrice ~/.config/sixelrice
export RETRONVIM_PATH=$(realpath $HOME/.*/extensions/yeferyv.retronvim* | head -n1)
export BAT_THEME="base16"
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window "hidden" --bind "?:toggle-preview" --multi --bind "ctrl-s:select-all+reload:sort --reverse --ignore-case {+f}"'
export HISTFILE="$HOME/.cache/.zsh_history"
export LESSKEYIN="$RETRONVIM_PATH/yazi/lesskey"
export LESSHISTFILE="-"
export MANROFFOPT="-c"
export PAGER="less -R --use-color --color=d+g --color=u+r --color=Pyk --color=Syk"
export SAVEHIST=10000
export SHELL="zsh" # for nvim terminal if bash is the default shell
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
export VIMINIT="lua vim.cmd.source(vim.env.RETRONVIM_PATH .. [[/nvim/init.lua]])"
export YAZI_CONFIG_HOME="$RETRONVIM_PATH/yazi"

[[ "$OSTYPE" == "linux-gnu"                ]] && export PATH="$RETRONVIM_PATH/bin/env/bin:$HOME/.local/share/pnpm:$HOME/.pixi/bin:$HOME/.console-ninja/.bin:$PATH:$HOME/.local/bin"
[[ "$OSTYPE" == "linux-gnu"                ]] && export PNPM_HOME="$HOME/.local/share/pnpm"
[[ "$OSTYPE" == "linux-gnu"                ]] && test ! -e ~/.local/share/fonts/FiraCode && mkdir -p ~/.local/share/fonts && cp -r $RETRONVIM_PATH/bin/nerd-fonts/patched-fonts/FiraCode ~/.local/share/fonts/FiraCode 2>/dev/null && fc-cache
[[ "$OSTYPE" == "darwin"                   ]] && test ! -e ~/Library/Fonts/FiraCode      && mkdir -p ~/.local/share/fonts && cp -r $RETRONVIM_PATH/bin/nerd-fonts/patched-fonts/FiraCode ~/Library/Fonts/FiraCode      2>/dev/null
[[ "$OSTYPE" == "darwin"                   ]] && export PATH="$RETRONVIM_PATH/bin/env/bin:$HOME/Library/pnpm:$HOME/.pixi/bin:$HOME/.console-ninja/.bin:$PATH:$HOME/.local/bin"
[[ "$OSTYPE" == "darwin"                   ]] && export PNPM_HOME="$HOME/Library/pnpm"
[[ "$OSTYPE" == "msys"                     ]] && test ! -e $HOME/AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont-Bold.ttf && powershell.exe -ExecutionPolicy Bypass -File $RETRONVIM_PATH/bin/nerd-fonts/install.ps1
[[ "$OSTYPE" == "msys"                     ]] && export PATH="$RETRONVIM_PATH/bin/windows/envs/windows/Library/bin:$HOME/appdata/local/pnpm:$HOME/.pixi/bin:$HOME/.console-ninja/.bin:$PATH:$HOME/.local/bin"
[[ "$OSTYPE" == "msys"                     ]] && export PNPM_HOME="$HOME/appdata/local/pnpm"
[[ "$OSTYPE" != "msys"                     ]] && alias  pacman="sudo pacman --noconfirm"
[[ "$TERM_PROGRAM" == "vscode"             ]] && source "$(code --locate-shell-integration-path zsh)"
[[ "$CHROME_DESKTOP" == "cursor.desktop"   ]] && alias code="cursor" # whichkey uses `code --install-extension <publisher.extension>` but cursor can't find some <publisher.extension> due to `extensions.gallery.serviceUrl`
[[ "$CHROME_DESKTOP" == "windsurf.desktop" ]] && alias code="winsurf" # whichkey uses `code --install-extension <publisher.extension>` but windsurf can't find some <publisher.extension> due to `extensions.gallery.serviceUrl`
[[   -z $ZDOTDIR                           ]] && export ZDOTDIR="$RETRONVIM_PATH/zsh" # for `nvim -cterm` on Windows should be after `code --locate-shell-integration-path zsh`
[[ ! -e $RETRONVIM_PATH/bin/env/bin/pixi   ]] && (cd $RETRONVIM_PATH/bin && ./environment.sh) 2>/dev/null

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

eval "$(/usr/local/bin/brew                 shellenv 2>/dev/null)"
eval "$(/opt/homebrew/bin/brew              shellenv 2>/dev/null)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null)"

# >/dev/null 2>&1 ! diff -q $HOME/.zshrc $ZDOTDIR/.zshrc && [[ "$(realpath $HOME/.zshrc)" != "$(realpath $ZDOTDIR/.zshrc)" ]] && source $HOME/.zshrc
>/dev/null 2>&1 which devour	                       && export SWALLOWER="devour"
>/dev/null 2>&1 which fzf	                           && source <(fzf --zsh)
>/dev/null 2>&1 which eza              	             && alias ls="eza --all --icons --group-directories-first"
>/dev/null 2>&1 which starship                       && eval "$(starship init zsh)"
