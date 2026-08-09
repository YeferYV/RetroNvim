# ╭───────────────╮
# │ shell configs │
# ╰───────────────╯

# time zsh -i -c exit                                              # to calculate startup time
autoload -U compinit                                               # enable command completion
bindkey -v '^?' backward-delete-char                               # enable vi-mode with backward-delete-char
setopt share_history                                               # share history across sessions
setopt append_history                                              # required by fzf and autosuggestions
setopt inc_append_history                                          # save to history after running a command
setopt interactive_comments                                        # allow comments
zstyle ":completion:*" menu select                                 # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }          # tmux/wezterm CWD status/title
[[ "$OSTYPE" == "cygwin" ]] && export HOME="/c/Users/$USERNAME"    # for git-bash / msys2 home
[[ -v TERAX_USER_ZDOTDIR ]] && export ZDOTDIR=$TERAX_USER_ZDOTDIR  # terax v.8.6 shell integration changes ZDOTDIR

alias  apt="sudo apt -y"
alias  grep="grep --color=auto"
alias  ll="ls -l"
alias  pacman='$(test $APPDATA && echo "pacman --noconfirm" || echo "sudo pacman --noconfirm")'

export BAT_THEME="base16"
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window=hidden --bind "?:toggle-preview" --multi'
export HISTFILE="$HOME/.cache/.zsh_history"
export HISTSIZE=10000 # fzf-history-widget by default searches latest 16 entries
export LESS="--ignore-case"                 # bat search case insensitive
export LESSKEYIN="$ZDOTDIR/../yazi/lesskey" # bat keymaps
export LESSHISTFILE="-"                     # bat no history
export MANROFFOPT="-c"                      # man pages colored
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"
export PAGER="less -R --use-color --color=d+g --color=u+r --color=Pyk --color=Syk"
export PNPM_HOME="$HOME/.local/share/pnpm" # $(pnpm setup)
export SAVEHIST=10000
export SHELL="zsh" # for nvim terminal if bash is the default shell
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
export VIMINIT="lua vim.cmd.source(vim.env.ZDOTDIR .. [[/../nvim/init.lua]])" # luafile theorically is faster then `source` and `dofile`
export YAZI_CONFIG_HOME="$ZDOTDIR/../yazi"
export ZSH_PATINA_CONFIG_PATH="$ZDOTDIR/zsh-patina.toml" # zsh-patina restart ---> after changing zsh-patina.toml
export ZEROBREW_ROOT="$HOME/.local/share/zerobrew"
export ZEROBREW_PREFIX="$HOME/.local/share/zerobrew/prefix"
export PKG_CONFIG_PATH="$ZEROBREW_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

export PATH="/bin:/usr/bin:$PATH"                              # for ~/.pixi/envs/retronvim/bin/zsh.exe
export PATH="$HOME/.local/bin:$PATH"                           # uv binaries
export PATH="$HOME/.local/share/npm/bin:$PATH"                 # npm binaries
export PATH="$HOME/.pixi/envs/retronvim/bin:$PATH"             # for ~/.pixi/envs/retronvim/bin/zsh
export PATH="$HOME/.pixi/envs/retronvim/Library/bin:$PATH"     # for ~/.pixi/envs/retronvim/bin/zsh
export PATH="$HOME/.pixi/envs/retronvim/Library/usr/bin:$PATH" # for ~/.pixi/envs/retronvim/bin/zsh
export PATH="$HOME/.pixi/envs/retrovim/bin:$PATH"              # for ~/.pixi/envs/retrovim/bin/zsh
export PATH="$HOME/.pixi/envs/retrovim/Library/bin:$PATH"      # for ~/.pixi/envs/retrovim/bin/zsh
export PATH="$HOME/.pixi/envs/retrovim/Library/usr/bin:$PATH"  # for ~/.pixi/envs/retrovim/bin/zsh
export PATH="$HOME/.pixi/bin:$PATH"
export PATH="$PATH:$PNPM_HOME"                            # $(pnpm setup)
export PATH="$PATH:$PNPM_HOME/bin"                        # $(pnpm setup)
export PATH="$PATH:$PNPM_HOME/global/5/node_modules/.bin" # $(pnpm approve-builds -g)
export PATH="$PATH:$ZEROBREW_PREFIX/bin"

[[ -e /data/data/com.termux ]] && export LD_LIBRARY_PATH="$(echo ~/.pixi/envs/*/lib | tr ' ' ':'):$LD_LIBRARY_PATH" # fixes lib**.so not found inside termux/proot-distro
[[ -e /data/data/com.termux ]] && export PATH="$(echo ~/.pixi/envs/*/bin | tr ' ' ':'):$PATH" # workaround for termux/proot-distro it should be before ~/.pixi/bin path

# ╭─────────────────╮
# │ yazi cd on exit │
# ╰─────────────────╯

y() {
  yazi --cwd-file=$HOME/.yazi $@ < /dev/tty # </dev/tty to create a tty (for neovim) from subshells for zle

  cd "$(cat $HOME/.yazi)"
  zle reset-prompt 2>/dev/null || printf "\x1b[A\x1b[K"; # prints up-arrow and clear-line if you type y<cr>
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


# ╭─────────────────────╮
# │ zsh-autosuggestions │
# ╰─────────────────────╯

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# 1. The fetch logic (runs on every redraw)
_autosuggest_fetch() {
  POSTDISPLAY=""
  region_highlight=()

  # Skip during isearch
  [[ "$WIDGET" == *isearch* ]] && return

  # Skip if buffer is empty OR editing in the middle of the line
  if (( $#BUFFER )) && (( CURSOR == $#BUFFER )); then
    # (r) reverse search, (b) escape glob characters in BUFFER
    local suggestion="${history[(r)${(b)BUFFER}*]}"
    if [[ -n "$suggestion" ]]; then
      POSTDISPLAY="${suggestion#$BUFFER}"
      # Highlight only the suggested portion
      region_highlight+=("$#BUFFER $(($#BUFFER + $#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
    fi
  fi
}

# 2. Clear suggestion
_autosuggest_clear() {
  POSTDISPLAY=""
  # region_highlight=() # it also clears zsh-patina syntax highlighting
}

# 3. Accept suggestion
_autosuggest_accept() {
  if (( CURSOR == $#BUFFER )) && (( $#POSTDISPLAY )); then
    BUFFER+="$POSTDISPLAY"
    CURSOR=$#BUFFER
    POSTDISPLAY=""
    region_highlight=()
    zle .reset-prompt
  else
    # If not at the end of the line, just act as a normal Right Arrow
    zle .forward-char
  fi
}
zle -N _autosuggest_accept

# 5. Bind Right Arrow (and Alt+Right) to accept
bindkey -M viins '\e[C' _autosuggest_accept
bindkey -M viins '\el'  _autosuggest_accept

# 4. Use add-zle-hook-widget (hooks INTO widgets, doesn't replace them)
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _autosuggest_fetch
add-zle-hook-widget isearch-update  _autosuggest_fetch
add-zle-hook-widget line-finish     _autosuggest_clear


# ╭─────────╮
# │ plugins │
# ╰─────────╯

>/dev/null 2>&1 which hyprctl    && hyprctl --quiet keyword input:repeat_delay 300
>/dev/null 2>&1 which hyprctl    && hyprctl --quiet keyword input:repeat_rate 50
>/dev/null 2>&1 which fzf        && source <(fzf --zsh)
>/dev/null 2>&1 which eza        && alias ls="eza --all --icons --group-directories-first"
>/dev/null 2>&1 which starship   && eval "$(starship init zsh)"
>/dev/null 2>&1 which zsh-patina && eval "$(zsh-patina activate)"

# compinit should be after plugins for msys2
[[ -n $HOME/.cache/.zcompdump(#qNm.mh+24) ]] && compinit -u -d "$HOME/.cache/.zcompdump" || compinit -u -C -d "$HOME/.cache/.zcompdump"

