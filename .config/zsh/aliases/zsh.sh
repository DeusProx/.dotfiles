# This files contains my general aliases for zsh

# reload zsh configuration
alias reload-zsh='exec zsh'

# change directory aliases
alias ~='cd ~'
alias -- -="cd -"

# add several alias commands to change directory; see comments in loop for more information
ddot='..'
ddotPath='..'

for i ({1..9})
do
  alias "$ddot"="cd $ddotPath"  # adds new command, e.g. `....` executes `cd ../../..`
  alias "..$i"="cd $ddotPath"   # adds new command, e.g. `..3` executes `cd ../../..`
  alias "$i"="cd -$i"           # adds new command, e.g. `3` executes `cd -3`

  ddot="$ddot."
  ddotPath="$ddotPath/.."
done

unset ddot ddotPath i

# Home and End key bindings
bindkey '\e[H' beginning-of-line
bindkey '\eOH' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\eOF' end-of-line

# list directory alias
alias ls='exa'
alias l='ls -lah'

# nicer aliases for sudo because it feels nice to be nice
alias please='sudo'
alias plz='sudo'

