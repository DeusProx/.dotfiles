# open pdf files directly by their name/path
alias -s pdf='xdg-open'

alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'

alias reload-audio='systemctl --user restart pipewire pipewire-pulse wireplumber'

alias reload-waybar='pkill waybar 2>/dev/null || true; waybar >/dev/null 2>&1 &!'
alias watch-waybar='find ~/.config/waybar -type f | entr -p zsh -ic reload-waybar'
alias debug-waybar='env GTK_DEBUG=interactive waybar'

# TODO: Not necessary once Hot Module Replacement hits
# See https://github.com/Aylur/ags/issues/724
alias watch-ags='find ~/.config/ags -type f | entr -r zsh -c "ags run"'

