autoload -U compinit && compinit -u -d $HOME/.cache/.zcompdump # enable command completion
bindkey -v '^?' backward-delete-char                           # enable vi-mode with backward-delete-char
setopt inc_append_history                                      # save to history after running a command
setopt interactive_comments                                    # allow comments
zstyle ":completion:*" menu select                             # <tab><tab> to enter menu completion
precmd () { printf "\033]0; $(basename ${PWD/~/\~}) \a" }      # tmux/wezterm CWD status/title
fpath=(~/.nix-profile/share/zsh/site-functions/ $fpath)        # activates tab completion for https://github.com/chubin/cheat.sh

# linux keyboard repeat rate, xset doesn't support wayland
(xset b off r rate 190 70 2>/dev/null)

# Change cursor shape for different vi modes.
zle-keymap-select() { [[ $KEYMAP == "vicmd" ]] && echo -ne '\e[2 q' || echo -ne '\e[6 q'; }
zle-line-init() { echo -ne "\e[6 q"; } # use beam shape cursor after ctrl+c or enter or startup
zle -N zle-line-init                   # overwriting zle-line-init
zle -N zle-keymap-select               # overwriting zle-keymap-select

# retronvim's neovim
vi() { nvim -u "$HOME/.vscode/extensions/yeferyv.retronvim/nvim/init.lua" $@; }

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
export BAT_THEME="base16"
export EDITOR="nvim"
export EZA_COLORS="reset:uu=0:ur=0:uw=0:ux=0:ue=0:gu=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:sn=0:di=34"
export FZF_DEFAULT_OPTS='--color "hl:-1:reverse,hl+:-1:reverse" --preview "bat --color=always {}" --preview-window "hidden" --bind "?:toggle-preview" --multi --bind "ctrl-s:select-all+reload:sort --reverse --ignore-case {+f}"'
export HISTFILE="$HOME/.cache/.zsh_history"
export LESSKEYIN="$HOME/.vscode/extensions/yeferyv.retronvim/yazi/lesskey"
# export RETRONVIM_INIT=$(echo $HOME/.vscode/extensions/yeferyv.retronvim*/nvim/init.lua)
export RETRONVIM_INIT="$HOME/.vscode/extensions/yeferyv.retronvim/nvim/init.lua"
export RIPGREP_LINUX="/opt/visual-studio-code/resources/app/node_modules/@vscode/ripgrep/bin:/usr/share/code/resources/app/node_modules/@vscode/ripgrep/bin"
export RIPGREP_MACOS="/Applications/Visual Studio Code.app/resources/app/node_modules/@vscode/ripgrep/bin"
export RIPGREP_MSYS2="$HOME/AppData/Local/Programs/Microsoft VS Code/resources/app/node_modules/@vscode/ripgrep/bin"
export SAVEHIST=10000
export STARSHIP_CONFIG="$HOME/.vscode/extensions/yeferyv.retronvim/zsh/starship.toml"
export SWALLOWER="devour"
export VIMINIT="lua vim.cmd.source(vim.env.RETRONVIM_INIT)"
export YAZI_CONFIG_HOME="$HOME/.vscode/extensions/yeferyv.retronvim/yazi"
source $HOME/.vscode/extensions/yeferyv.retronvim/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $HOME/.vscode/extensions/yeferyv.retronvim/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

[[ "$OSTYPE" == "linux-gnu"    ]] && export PATH="$HOME/.vscode/extensions/yeferyv.retronvim/bin/linux/envs/linux/bin:$HOME/.pixi/bin:$HOME/.local/share/pnpm:$HOME/.local/bin:$RIPGREP_LINUX:$PATH"
[[ "$OSTYPE" == "linux-gnu"    ]] && export PNPM_HOME="$HOME/.local/share/pnpm"
[[ "$OSTYPE" == "linux-gnu"    ]] && export RETRONVIM_BIN="$HOME/.vscode/extensions/yeferyv.retronvim/bin/linux/envs/linux/bin"
[[ "$OSTYPE" == "darwin"       ]] && export PATH="$HOME/.vscode/extensions/yeferyv.retronvim/bin/macos/envs/macos/bin:$HOME/.pixi/bin:$HOME/Library/pnpm:$HOME/.local/bin:$RIPGREP_MACOS:$PATH"
[[ "$OSTYPE" == "darwin"       ]] && export PNPM_HOME="$HOME/Library/pnpm"
[[ "$OSTYPE" == "darwin"       ]] && export RETRONVIM_BIN="$HOME/.vscode/extensions/yeferyv.retronvim/bin/macos/envs/macos/bin"
[[ "$OSTYPE" == "msys"         ]] && export PATH="$PATH:$HOME/.vscode/extensions/yeferyv.retronvim/bin/windows/envs/windows/Library/bin:$HOME/.pixi/bin:$HOME/appdata/local/pnpm:$HOME/.local/bin:$RIPGREP_MSYS2:$PATH"
[[ "$OSTYPE" == "msys"         ]] && export PNPM_HOME="$HOME/appdata/local/pnpm"
[[ "$OSTYPE" != "msys"         ]] && alias  pacman="sudo pacman --noconfirm"
[[ "$TERM_PROGRAM" == "vscode" ]] && source "$(code --locate-shell-integration-path zsh)"
[[ -z $ZDOTDIR                 ]] && export ZDOTDIR="$HOME/.vscode/extensions/yeferyv.retronvim/zsh" # for `nvim -cterm` on Windows should be after `code --locate-shell-integration-path zsh`

eval "$(/usr/local/bin/brew                 shellenv 2>/dev/null)"
eval "$(/opt/homebrew/bin/brew              shellenv 2>/dev/null)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null)"

>/dev/null 2>&1 diff -q $HOME/.zshrc $ZDOTDIR/.zshrc && [[ "$(realpath $HOME/.zshrc)" != "$(realpath $ZDOTDIR/.zshrc)" ]] && source $HOME/.zshrc
>/dev/null 2>&1 which fzf	                           && source <(fzf --zsh)
>/dev/null 2>&1 which eza              	             && alias ls="eza --all --icons --group-directories-first"
>/dev/null 2>&1 which starship                       && eval "$(starship init zsh)"
