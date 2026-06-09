# open pdf files directly by their name/path
alias -s pdf='xdg-open'

alias update-mirrors='sudo reflector --verbose -l 50 -p https --sort rate --save /etc/pacman.d/mirrorlist'
alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'

alias reload-audio='systemctl --user restart pipewire pipewire-pulse wireplumber'
alias reload-waybar='pkill waybar 2>/dev/null || true; waybar >/dev/null 2>&1 &!'

