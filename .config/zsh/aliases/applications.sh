# you shall calculate easily
calc() {
  echo "$(( $@ ))"
}
alias c='calc'

# you shall use neovim!
alias v='nvim'
alias nv='nvim'
alias vi='nvim'
alias vim='nvim'
alias nano='nvim'

# Edit Neovim Config
alias editnvim='nvim ~/.config/nvim/'
alias envim='editnvim'
# alias env='editnvim' # NOOO! We don't overwrite env! Are you insane?
alias ev='editnvim'

# you shall use bat!
alias cat='bat --style="header,grid"'

