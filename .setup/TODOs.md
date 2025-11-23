
###########################################

# TODO: Make VM reproducable
  # TODO: tty autologin - https://wiki.alpinelinux.org/wiki/TTY_Autologin
  # TODO: fetch scripts
  # TODO: resizing vm window


###########################################
# timedatectl status
# sudo timedatectl set-ntp true
# timedatectl status

# sleep 10

# TODO: refresh time


###########################################


# TODO: add hyprlock config and check it

# TODO: setup hyprpm
# hyprpm update
# hyprpm reload
# hyprpm add https://github.com/zakk4223/hyprWorkspaceLayouts
# hyprpm enable hyprWorkspaceLayouts

# sudo pacman -Sy --noconfirm mold gcc # rust linking; TODO: Fix
# the configured linker used by cargo; See ~/.cargo/config.toml  # TODO: later

## neovim plugins
# sudo apt install fd-find
# cargo install tree-sitter-cli
# cargo install typst-cli
# cargo install typst-lsp
# npm install -g neovim

# LSPs in actual setup
# angular-language-server angularls
# astro-language-server astro
# awk-language-server awk_ls
# bash-language-server bashls
# clangd
# css-lsp cssls
# cssmodules-language-server cssmodules_ls
# deno denols
# docker-compose-language-service docker_compose_language_service
# dockerfile-language-server dockerls
# eslint-lsp eslint
# html-lsp html
# json-lsp jsonls
# lua-language-server lua_ls
# marksman
# pyright
# rust-analyzer rust_analyzer
# tinymist
# typescript-language-server ts_ls
# typst-lsp
# vue-language-server volar
# wgsl-analyzer wgsl_analyzer

# TODO: Check/Fix Groups?
# Desktop: deusprox adm cdrom sudo dip video plugdev lpadmin lxd sambashare libvirt gamemode docker ollama
# VM: deusprox wheel
#

# THOUGHTS & TODOS
# TODO: Sort this list
#
# TODO: reflector: updates mirrors -> enable service
# TODO: podman -> like docker but better
#
# TODO: Make PWA/SPA apps part of config
# TODO: Does widevine work correctly
# TODO: Netflix cliewnts or PWA?
# TODO: Go htrough https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580
# TODO: Add clipboard manager https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/
# TODO: Add HyprLS the hyprland config lsp https://github.com/hyprland-community/hyprls
# TODO: xwaylandvideobridge: https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/ ; maybe not necessary anymore?
# TODO: Check steamrip
# TODO: EasyEffects?
# TODO: Gparted?
# TODO: calculator? rather terminal?
# TODO: editor? rather terminal?
# TODO: check ZRAMmctl
# TODO: virt-manager+LXC would be cool, but I need a windows VM? Can I install both?
# Balena etcher
# Tor Browser, Brave, Firefox
# Screenkey
# Scribus
# Parsec
# OpenRGB
# TODO: Music Stuff? Sound Recorder? Other creative tools?
# vscode
# thunderbird? other email?
# web cam tool? necessary?
# Document scanner/viewer?
# video player - mpv, vlc
# picture viewer? eye of mate?
# libreoffice
# Terminal file manager? yazi: https://github.com/sxyazi/yazi // DO I really need this? Can't I just use fzf?

# TODO: backups
# TODO: Install games via terminal?

# local Clipboard
# Install command
# paru -Sy --noconfirm


# TODO: ZRAM
# i think it's installed by default correctly, but does it work?
# zram-generator -> yes
# zramswap? (aur)

# TODO: Backups with timeshift


#
# Package lists
#
# pacman -Qqe > ~/pkglist.txt # (q)uitly saves list of (e)xplicitely installed packages from repo
# pacman -Qm                  # lists installed packages (m)anually installed
#
#


# VM STUFF
# TODO: Fix VM Resolution stuff?
# paru -Sy --noconfirm qemu-guest-agent spice-vdagent
# sudo systemctl start spice-vdagentd.service


# TIMEOUT=0
#info "Reboot in $TIMEOUT."
#trap 'echo -e "\nCountdown interrupted. Aborting reboot."; exit 1' INT

#echo "System will reboot in $TIMEOUT seconds. Press Ctrl+C to cancel."

#while [ $TIMEOUT -gt 0 ]; do
#    printf "\rRebooting in %2d seconds... " "$TIMEOUT"
#    sleep 1
#    TIMEOUT=$((TIMEOUT - 1))
#done

# echo -e "\nRebooting now..."
# sudo reboot


















# RUST_LOG=debug upload-server
# git daemon --reuseaddr --base-path=$HOME --export-all --verbose --enable=receive-pack --detach
# livereload -p 3000 --host 0.0.0.0 .

# function overtrap {
#   trap="$1"
#   sig=$(echo $2 | tr [a-z] [A-Z])
#   cur="$(trap -p $sig | sed -nr "s/trap -- '(.*)' $sig\$/\1/p")"
#   if test ${cur:+x}; then
#     trap "{ $trap; }; $cur" $sig
#   else
#     trap "$trap" $sig
#   fi
# }




  # git init --separate-git-dir=$DOTFILES_PATH || error "... warning: Failed to init git repo"

  # git remote add -f origin $REPO_GIT || eror "... warning: Failed to add remote"
  # git remote add -f origin $REPO_HTTPS || eror "... warning: Failed to add remote"

  # git remote set-url origin        $REPO_HTTPS # fetch
  # git remote set-url --push origin $REPO_GIT   # push

  # git fetch $REPO_HTTPS $REPO_BRANCH || error "... warning: Failed to fetch via https"
  # git checkout $REPO_BRANCH || error "... warning: Failed to checkout main"

