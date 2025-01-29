autoload -U compinit && compinit -u -d $HOME/.cache/.zcompdump # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }      # tmux/wezterm CWD status/title

# linux keyboard repeat rate, xset doesn't support wayland
(xset b off r rate 190 70 2>/dev/null)

# Change cursor shape for different vi modes.
zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

# export LC_ALL=C.UTF-8 # `locale` lists all user's locale https://wiki.archlinux.org/title/Locale
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window "hidden" --bind "?:toggle-preview"'
export HISTFILE="$HOME/.cache/.zsh_history"
export PATH="$HOME/.pixi/bin:$HOME/.local/bin:$HOME/.local/share/pnpm:$HOME/Library/pnpm:$PATH"
export SAVEHIST=10000
export STARSHIP_CONFIG="$HOME/.vscode/extensions/yeferyv.retronvim/zsh/starship.toml"
export EDITOR='nvim -u "$HOME/.vscode/extensions/yeferyv.retronvim/nvim/init.lua"'

# retronvim's neovim
vi() { eval $EDITOR $@; }

# yazi cd on exit (then moves the cursor up and clear until end of line)
y() { yazi --cwd-file=$HOME/.yazi $@; cd "$(cat $HOME/.yazi)"; printf "\x1b[A\x1b[K"; }

# yazi cd on exit (even while writing commands)
yy () { yazi --cwd-file=$HOME/.yazi $@ < /dev/tty; cd "$(cat $HOME/.yazi)"; zle reset-prompt; echo -ne "\e[6 q"; }
zle -N yy          # creating `yy` keymap
bindkey '\eo' 'yy' # \eo = alt + o

source $HOME/.vscode/extensions/yeferyv.retronvim/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $HOME/.vscode/extensions/yeferyv.retronvim/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
which fzf      >/dev/null 2>&1 && source <(fzf --zsh)
which eza      >/dev/null 2>&1 && alias ls="eza --all --icons --group-directories-first"
which starship >/dev/null 2>&1 && eval "$(starship init zsh)"

[[ -z "$SOURCE_ZSHRC" ]] && export SOURCE_ZSHRC=true && [[ -e $HOME/.zshrc ]] && source $HOME/.zshrc # && echo "sourced"
[[ "$TERM_PROGRAM" == "vscode" ]] && source "$(code --locate-shell-integration-path zsh)"
