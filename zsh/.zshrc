# time zsh -i -c exit                                          # to calculate startup time
autoload -U compinit                                           # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt share_history                                           # share history across sessions
setopt append_history                                          # required by fzf and autosuggestions
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }      # tmux/wezterm CWD status/title
fpath=(~/.nix-profile/share/zsh/site-functions/ $fpath)        # activates tab completion for https://github.com/chubin/cheat.sh

# VIMINIT should be before `cygpath --unix $CONDA_PREFIX`
export VIMINIT="luafile $CONDA_PREFIX/opt/retronvim/nvim/init.lua" # luafile seems faster then `source` and `dofile`

[[ "$OSTYPE" == "cygwin"                           ]] && export HOME="/c/Users/$USERNAME"
[[ "$OSTYPE" == "cygwin" && -e $CONDA_PREFIX       ]] && export CONDA_PREFIX=$(/bin/cygpath --unix $CONDA_PREFIX) # fixes `command not found` on d: drive

# linux keyboard repeat rate
[[ -e $XAUTHORITY                                 ]] && xset b off r rate 300 50                2>/dev/null
[[ -e $SWAYSOCK                                   ]] && swaymsg input "*" repeat_delay 300      2>/dev/null
[[ -e $SWAYSOCK                                   ]] && swaymsg input "*" repeat_rate 50        2>/dev/null
[[ -e $HYPRLAND_INSTANCE_SIGNATURE                ]] && hyprctl keyword input:repeat_delay 300  2>/dev/null
[[ -e $HYPRLAND_INSTANCE_SIGNATURE                ]] && hyprctl keyword input:repeat_rate 50    2>/dev/null

alias  apt="sudo apt -y"
alias  cht="cht.sh"                       # nix-env -iA nixpkgs.cht-sh
alias  grep="grep --color=auto"
alias  ll="ls -l"
alias  pacman='$(test $APPDATA && echo "pacman --noconfirm" || echo "sudo pacman --noconfirm")'

export BAT_THEME="base16"
export CONDA_PREFIX=${CONDA_PREFIX:-$HOME/.pixi/envs/retronvim}
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FONT_LINUX="$HOME/.local/share/fonts/NerdFonts/FiraCodeNerdFont-Bold.ttf"
export FONT_MACOS="$HOME/Library/Fonts/NerdFonts/FiraCodeNerdFont-Bold.ttf"
export FONT_WINDOWS="$HOME/AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont-Bold.ttf"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window=hidden --bind "?:toggle-preview" --multi'
export HISTFILE="$HOME/.cache/.zsh_history"
export HISTSIZE=10000 # fzf-history-widget by default searches latest 16 entries
export LESS="--ignore-case"                                 # bat search case insensitive
export LESSKEYIN="$CONDA_PREFIX/opt/retronvim/yazi/lesskey" # bat keymaps
export LESSHISTFILE="-"                                     # bat no history
export MANPATH="/opt/homebrew/share/man:$MANPATH";
export MANROFFOPT="-c"                                                   # man pages colored
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/npm"
export PAGER="less -R --use-color --color=d+g --color=u+r --color=Pyk --color=Syk"
export PNPM_HOME="$HOME/.local/share/pnpm"
export SAVEHIST=10000
export SHELL="$CONDA_PREFIX/bin/zsh" # for nvim terminal if bash is the default shell
export STARSHIP_CONFIG="$CONDA_PREFIX/opt/retronvim/zsh/starship.toml"
export YAZI_CONFIG_HOME="$CONDA_PREFIX/opt/retronvim/yazi"
export ZSH_PATINA_CONFIG_PATH="$CONDA_PREFIX/opt/retronvim/zsh/zsh-patina.toml"
export ZEROBREW_ROOT=$HOME/.local/share/zerobrew
export ZEROBREW_PREFIX=$HOME/.local/share/zerobrew/prefix
export PKG_CONFIG_PATH="$ZEROBREW_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

export PATH="/bin:/usr/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"
export PATH="$HOME/.console-ninja/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/pnpm:$PATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"
export PATH="$PATH:/clang64/bin"
export PATH="$PATH:/mingw32/bin"
export PATH="$PATH:/mingw64/bin"
export PATH="$PATH:/ucrt64/bin"
export PATH="$PATH:$CONDA_PREFIX/bin"
export PATH="$PATH:$CONDA_PREFIX/Library/bin"
export PATH="$PATH:$CONDA_PREFIX/opt/neovim/bin"
export PATH="$PATH:$ZEROBREW_PREFIX/bin"

[[ "$OSTYPE" == "linux-gnu" && ! -e $FONT_LINUX   ]] && firacode-nerdfont-installer     2>/dev/null
[[ "$OSTYPE" == "darwin"    && ! -e $FONT_MACOS   ]] && firacode-nerdfont-installer     2>/dev/null
[[ "$OSTYPE" == "cygwin"    && ! -e $FONT_WINDOWS ]] && firacode-nerdfont-installer.cmd 2>/dev/null

>/dev/null 2>&1 which fzf	       && source <(fzf --zsh)
>/dev/null 2>&1 which eza        && alias ls="eza --all --icons --group-directories-first"
>/dev/null 2>&1 which starship   && eval "$(starship init zsh)"
>/dev/null 2>&1 which zsh-patina && eval "$(zsh-patina activate)"

[[ -n $HOME/.cache/.zcompdump(#qNm.mh+24) ]] && compinit -d "$HOME/.cache/.zcompdump" || compinit -C -d "$HOME/.cache/.zcompdump" # it should be after plugins

# ╭─────────────────╮
# │ yazi cd on exit │
# ╰─────────────────╯

y() { yazi --cwd-file=$HOME/.yazi $@ < /dev/tty; cd "$(cat $HOME/.yazi)"; zle reset-prompt 2>/dev/null; echo -ne "\e[6 q"; }
zle -N y          # creating `yy` keymap
bindkey '\eo' 'y' # \eo = alt + o

# ╭────────────╮
# │ vim cursor │
# ╰────────────╯

zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

# ╭────────────────────╮
# │ zsh-autosuggestion │
# ╰────────────────────╯

# https://github.com/zsh-users/zsh-autosuggestions/blob/v0.3.1/zsh-autosuggestions.zsh
# bindkey --> list current bindings
# zle -la --> list all bindings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

_autosuggest_fetch() {
  POSTDISPLAY=""
  if (( $#BUFFER )); then
    local suggestion="${history[(r)${(b)BUFFER}*]}" # (r) recent, (b) escape glob/regex
    [[ -n $suggestion ]] && POSTDISPLAY="${suggestion#$BUFFER}"
  fi
  region_highlight=()
  (( $#POSTDISPLAY )) && region_highlight+=("$#BUFFER $(($#BUFFER+$#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
}

_autosuggest_right_arrow() {
  if (( $#POSTDISPLAY )); then
    BUFFER+="$POSTDISPLAY"
    POSTDISPLAY=""
    region_highlight=()
    CURSOR=$#BUFFER
  else
    zle .vi-forward-char
  fi
}

_autosuggest_self_insert()     { zle .self-insert; _autosuggest_fetch; }
_autosuggest_backward_delete() { zle .backward-delete-char; _autosuggest_fetch; }
_autosuggest_accept_line()     { zle .accept-line; POSTDISPLAY=""; }
_autosuggest_vi_cmd_mode()     { zle .vi-cmd-mode; POSTDISPLAY=""; }
_autosuggest_altkey_accept()   { zle .vi-cmd-mode; _autosuggest_right_arrow; }
_autosuggest_left_arrow()      { zle .backward-char; POSTDISPLAY=""; }
_autosuggest_complete()        { zle expand-or-complete; POSTDISPLAY=""; }

zle -N self-insert          _autosuggest_self_insert
zle -N backward-delete-char _autosuggest_backward_delete
zle -N accept-line          _autosuggest_accept_line
zle -N vi-cmd-mode          _autosuggest_vi_cmd_mode
zle -N _autosuggest_altkey_accept
zle -N _autosuggest_right_arrow
zle -N _autosuggest_left_arrow
zle -N _autosuggest_complete

bindkey -M viins '\el'  '_autosuggest_altkey_accept' # \e instead of ^[ to stop vi-cmd-mode trigger
bindkey -M viins '\e[C' '_autosuggest_right_arrow'   # \e instead of ^[ to stop vi-cmd-mode trigger
bindkey -M viins '\e[D' '_autosuggest_left_arrow'    # \e instead of ^[ to stop vi-cmd-mode trigger
bindkey -M viins '^I'   '_autosuggest_complete'      # tab should hide suggestion
