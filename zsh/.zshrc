autoload -U compinit && compinit -u -d $HOME/.cache/.zcompdump # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion

# linux keyboard repeat rate, xset doesn't support wayland
(xset b off r rate 210 70 2>/dev/null)

# Change cursor shape for different vi modes.
zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

export EXA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export HISTFILE="$HOME/.cache/.zsh_history"
export SAVEHIST=10000
export RETRONVIM_PATH="$HOME/.vscode/extensions/yeferyv.retronvim-0.0.4"
export EDITOR="nvim -u $RETRONVIM_PATH/nvim/init.lua"

# retronvim's neovim
vi() { eval $EDITOR $@; }

# yazi cd on exit (then moves the cursor up and clear until end of line)
y() { yazi --cwd-file=$HOME/.yazi $@; cd "$(cat $HOME/.yazi)"; printf "\x1b[A\x1b[K"; }

# yazi cd on exit (even while writing commands)
yy () { yazi --cwd-file=$HOME/.yazi $@; cd "$(cat $HOME/.yazi)"; zle reset-prompt; echo -ne "\e[6 q"; }
zle -N yy          # creating `yy` keymap
bindkey '\eo' 'yy' # \eo = alt + o

source $RETRONVIM_PATH/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $RETRONVIM_PATH/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
which fzf      >/dev/null 2>&1 && source <(fzf --zsh)
which eza      >/dev/null 2>&1 && alias ls="eza --all --icons --group-directories-first"
which starship >/dev/null 2>&1 && eval "$(starship init zsh)"
which fnm      >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"

[[ "$TERM_PROGRAM" == "vscode" ]] && source "$(code --locate-shell-integration-path zsh)" && [[ -e $HOME/.zshrc ]] && source $HOME/.zshrc || true
