# load systemd environment
# you can extend the environment by adding files to ~/.config/environment.d/*.conf
export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)

export PATH="$PATH:/home/deusprox/.local/bin"

# Enable vi mode
bindkey -v

# set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1
RPS1='%D{%H:%M:%S}'

# INFO: see "man 1 zshoptions"
setopt ksharrays           # arrays shall start with 0
setopt interactivecomments # allows comments, e.g. `echo Hello # World` -> `Hello`

# history handling
setopt incappendhistory    # appends incrementally
setopt extendedhistory     # extends with timestamps
setopt histignorealldups   # prevents duplicates
setopt histreduceblanks    # removes excessive blanks
setopt nosharehistory      # does not share history between terminal

HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999

fpath+=~/.config/zsh/.zfunc

# globbing/expansion
setopt extendedglob
setopt markdirs            # appends / to directy paths
setopt numericglobsort

# extend directory handling
setopt autocd              # `~/downloads` -> `cd ~/downloads`
setopt autoparamslash      # adds / when completing directory paths
setopt autopushd           # pushes old path onto directory stack
setopt cdablevars          # `test=~/downloads` & `test` -> `cd ~/downloads`
setopt cdsilent            # never print the working directory after a `cd` command
setopt chasedots
setopt chaselinks
setopt pushdsilent         # never print the directory stack after a `pushd` or `popd` command
setopt pushdignoredups     # do not push multiple copies of the the same directory onto the directory stack
setopt pushdminus          # exchanges meaning of '+' and '-' when used with a number to specify a directory in the stack

# load modern completion system
autoload -Uz compinit
compinit

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

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31=0'
zstyle ':completion:*:*:kill:*:processes' command 'ps -u $USER --no-headers -o pid,%cpu,tty,cputime,cmd --sort=-start_time'
zstyle ':completion:*:*:kill:*:processes' sort false
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always

# load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load Cargo
. "$HOME/.cargo/env"

# load Go
if [ -z "$GOPATH" ]; then
  export GOPATH="$HOME"/go
  export PATH=$PATH:$GOPATH/bin
fi

# load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set nvim as default editor
#   `sudo -e <filepath>` to edit file in nvim with root privileges
export EDITOR=nvim

# Set terminal type
export TERM='screen-256color'

# Load Aliases
for conf in $ZDOTDIR/aliases/*; do source $conf; done
unset conf

# Compose start command
# local CMD=""
#
# if [ -z "$TMUX" ]; then # If not in tmux
#
#   if [ -z "$SSH_CLIENT" ]; then
#     # Run tmux
#     CMD+="(exec tmux attach || exec tmux new-session)"
#   else
#     # Run tmux but prevent suspend
#     IP=$(echo ${SSH_CLIENT} | cut -d " " -f 1)
#     CMD+="(systemd-inhibit --what=idle --why=\"Do not suspend on open ssh connections\" --who=\"ssh (${IP})\" tmux a || tmux)"
#   fi
#
#   # Always exit after detaching from tmux
#   CMD+=" && exit"
#
# else # If in tmux
#   # Show system information and funky ascii art on opening the terminal
#   CMD+="fastfetch"
# fi
#
# # run start command
# eval "$CMD"

# fastfetch

