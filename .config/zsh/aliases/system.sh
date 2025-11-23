# open pdf files directly by their name/path
alias -s pdf='open'

alias update-mirrors='sudo reflector --verbose -l 50 -p https --sort rate --save /etc/pacman.d/mirrorlist'
alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'

