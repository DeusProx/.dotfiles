# This files contains my general aliases for zsh

# reload zsh configuration
alias reload-zsh='exec zsh'

# extend directory handling
setopt auto_cd            # automatically triggers change directory command when path was provided instead of a command, `~/downloads` executes `cd ~/downloads`
setopt auto_pushd         # automatically pushes old path onto directory stack for later retrieval, e.g. `cd -<number>`
setopt cdable_vars        # automatically expands variable as path for cd, e.g. with the variable `test=~/downloads` the command `test` executes `cd ~/downloads`

# directory handling options
setopt cd_silent          # never print the working directory after a `cd` command
setopt pushd_silent       # never print the directory stack after a `pushd` or `popd` command
setopt pushd_ignore_dups  # do not push multiple copies of the the same directory onto the directory stack
setopt pushd_minus        # exchanges meaning of '+' and '-' when used with a number to specify a directory in the stack

# change directory aliases
alias ~='cd ~'
alias -- -="cd -"

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

# list directory alias
alias ls='exa'
alias l='ls -lah'

# nicer aliases for sudo because it feels nice to be nice
alias please='sudo'
alias plz='sudo'

