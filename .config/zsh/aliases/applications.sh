# you shall calculate easily
calc() {
  awk "BEGIN {print $*}";
}
alias calc='noglob calc' # Necessary so * (multiplication) does not get expanded
alias c='calc'

# Just leaving this here as an example for easy calculation; has float rounding problems
# calc() {
#   echo $(( $@ ))
# }

# you shall use neovim!
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# you shall use bat!
alias cat='bat --style="header,grid"'

# you shall watch the file while transpiling latex
latex-watch() {
  echo $1 | entr pdflatex $1
}
alias wlatex='latex-watch'

