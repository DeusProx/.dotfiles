# load systemd environment
# you can extend the environment by adding files to ~/.config/environment.d/*.conf
export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)

# set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

# zsh options
# see "man 1 zshoptions"
setopt KSH_ARRAYS # arrays shall start with 0

setopt histignorealldups
setopt nosharehistory

# Enable vi mode
bindkey -v

# Keep 999.999.999 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=999999999
SAVEHIST=999999999
HISTFILE=~/.zsh_history

fpath+=~/.config/zsh/.zfunc

# Use modern completion system
autoload -Uz compinit
compinit

CASE_SENSITIVE="true"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Dotfiles
alias dotfiles='/usr/bin/git --git-dir=/home/deusprox/.dotfiles/ --work-tree=/home/deusprox/'

# Load Cargo
. "$HOME/.cargo/env"

# Load Go
if [ -z "$GOPATH" ]; then
  export GOPATH="$HOME"/go
  export PATH=$PATH:$GOPATH/bin
fi

# fuzzy completion and key bindings for fzf
# is installed via go so load after go
source <(fzf --zsh)

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
source <(ng completion script)

# Load Alacritty
source ~/.bash_completion/alacritty

# Open pdf files directly by their name/path
alias -s pdf='open'

# Shows sources for packages if command is not found
source /etc/zsh_command_not_found

# Set nvim as default editor
#   `sudo -e <filepath>` to edit file in nvim with root privileges
export EDITOR=nvim

# Set terminal type
export TERM='screen-256color'

# Load Aliases
for conf in $ZDOTDIR/aliases/*; do source $conf; done
unset conf

# Compose start command
local CMD=""

if [ -z "$TMUX" ]; then # If not in tmux

  if [ -z "$SSH_CLIENT" ]; then
    # Run tmux
    CMD+="(tmux a || tmux)"
  else
    # Run tmux but prevent suspend
    IP=$(echo ${SSH_CLIENT} | cut -d " " -f 1)
    CMD+="(systemd-inhibit --what=idle --why=\"Do not suspend on open ssh connections\" --who=\"ssh (${IP})\" tmux a || tmux)"
  fi

  # Always exit after detaching from tmux
  CMD+=" && exit"

else # If in tmux
  # Show system information and funky ascii art on opening the terminal
  CMD+="/usr/bin/cat ~/.config/neofetch/info"
fi

# run start command
eval "$CMD"
