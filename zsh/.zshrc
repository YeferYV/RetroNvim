# time zsh -i -c exit                                          # to calculate startup time
autoload -U compinit                                           # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt share_history                                           # share history across sessions
setopt append_history                                          # required by fzf and autosuggestions
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }      # tmux/wezterm CWD status/title

# luafile seems faster then `source` and `dofile`
export VIMINIT="luafile $CONDA_PREFIX/opt/retronvim/nvim/init.lua" # luafile expect a windows's path

[[ "$OSTYPE" == "cygwin"                           ]] && export HOME="/c/Users/$USERNAME"
[[ "$OSTYPE" == "cygwin" && -e $CONDA_PREFIX       ]] && export CONDA_PREFIX=${$(/bin/cygpath --unix $CONDA_PREFIX)%/} # fixes `command not found` on d: drive

alias  apt="sudo apt -y"
alias  grep="grep --color=auto"
alias  ll="ls -l"
alias  pacman='$(test $APPDATA && echo "pacman --noconfirm" || echo "sudo pacman --noconfirm")'

export BAT_THEME="base16"
export CONDA_PREFIX=${CONDA_PREFIX:-$HOME/.pixi/envs/retronvim}
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window=hidden --bind "?:toggle-preview" --multi'
export HISTFILE="$HOME/.cache/.zsh_history"
export HISTSIZE=10000 # fzf-history-widget by default searches latest 16 entries
export LESS="--ignore-case"                                 # bat search case insensitive
export LESSKEYIN="$CONDA_PREFIX/opt/retronvim/yazi/lesskey" # bat keymaps
export LESSHISTFILE="-"                                     # bat no history
export MANPATH="/opt/homebrew/share/man:$MANPATH";
export MANROFFOPT="-c"                                                   # man pages colored
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"
export PAGER="less -R --use-color --color=d+g --color=u+r --color=Pyk --color=Syk"
export PNPM_HOME="$HOME/.local/share/pnpm" # $(pnpm setup)
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
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="$HOME/appdata/local/mise/shims:$PATH"
export PATH="$PATH:/clang64/bin"
export PATH="$PATH:/mingw32/bin"
export PATH="$PATH:/mingw64/bin"
export PATH="$PATH:/ucrt64/bin"
export PATH="$PATH:$CONDA_PREFIX/bin"
export PATH="$PATH:$CONDA_PREFIX/Library/bin"
export PATH="$PATH:$CONDA_PREFIX/opt/neovim/bin"
export PATH="$PATH:$PNPM_HOME" # $(pnpm setup)
export PATH="$PATH:$PNPM_HOME/global/5/node_modules/.bin" # $(pnpm approve-builds -g)
export PATH="$PATH:$ZEROBREW_PREFIX/bin"

>/dev/null 2>&1 which hyprctl    && hyprctl --quiet keyword input:repeat_delay 300
>/dev/null 2>&1 which hyprctl    && hyprctl --quiet keyword input:repeat_rate 50
>/dev/null 2>&1 which fzf	       && source <(fzf --zsh)
>/dev/null 2>&1 which eza        && alias ls="eza --all --icons --group-directories-first"
>/dev/null 2>&1 which starship   && eval "$(starship init zsh)"
>/dev/null 2>&1 which zsh-patina && eval "$(zsh-patina activate)"

[[ -e $CONDA_PREFIX/opt/retronvim/zsh/plugins/zsh-autosuggestions ]] && source $CONDA_PREFIX/opt/retronvim/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -n $HOME/.cache/.zcompdump(#qNm.mh+24)                         ]] && compinit -d "$HOME/.cache/.zcompdump" || compinit -C -d "$HOME/.cache/.zcompdump" # it should be after plugins

# ╭─────────────────╮
# │ yazi cd on exit │
# ╰─────────────────╯

# https://github.com/crynta/terax-ai/issues/932
# OSC 11 and DECRQM sequences leaks on yazi inside terax on linux/macos workaround
y() {

  if [[ ! -v APPDATA && -v TERAX_TERMINAL || -e /run/WSL ]]; then
    nvim -c 'set showtabline=0 laststatus=0' -c 'autocmd TermClose * qa!' -c "term yazi --cwd-file=$HOME/.yazi $@"
  else
    yazi --cwd-file=$HOME/.yazi $@ < /dev/tty
  fi

  cd "$(cat $HOME/.yazi)"
  zle reset-prompt 2>/dev/null || printf "\x1b[A\x1b[K";
  echo -ne "\e[6 q" # beam cursor
}

zle -N y
bindkey '\eo' 'y' # \eo = alt + o

# ╭────────────╮
# │ vim cursor │
# ╰────────────╯

zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select
