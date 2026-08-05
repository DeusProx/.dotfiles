#!/bin/sh
# curl -fsSL https://raw.githubusercontent.com/DeusProx/.dotfiles/main/.setup/add-dotfiles.sh | sh
set -e # exit on any error

START_TIME=$(date +%s)
READABLE_TIME=$(date +%Y-%m-%dT%H:%M:%S)

# Logging
LOG_PATH="/var/log/.dotfiles-installation-${READABLE_TIME}.log"
mkdir -p $(dirname $LOG_PATH)
exec > >(tee -a "$LOG_PATH") 2>&1

# TODO: Dotfiles repo; First time with HTTPS, but save GIT

GITHUB_USER="DeusProx"
REPO_NAME=".dotfiles"
REPO_BRANCH="main"
REPO_HTTPS="https://github.com/$GITHUB_USER/$REPO_NAME.git"
REPO_GIT="git@github.com:$GITHUB_USER/$REPO_NAME.git"

DOTFILES_PATH="$HOME/$REPO_NAME"

RESET="\033[0m"
RED="\033[31m"
BLUE="\033[36m"

info() { echo -e "... ${BLUE}$@${RESET}"; }
error() { echo -e "\n... ${RED}ERROR: ${1}${RESET}\n"; exit 1; }

info "
$BLUE
Welcome to the installation of my .dotfiles!

This installation will configure your system with the .dotfiles of DeusProx and install several programs to provide a full user experience.
Be aware that you take responsibility for all actions taken.
$RESET"

keep_sudo_alive() {
  (while true; do sudo -n -v; sleep 10; done) &
  trap 'kill $!' EXIT
}
keep_sudo_alive


info "Force refresh of package database"
sudo pacman -Syy

info "Updating installed packages"
sudo pacman -Syu --noconfirm


info "Setting up .dotfiles repo "$REPO_GIT" in $DOTFILES_PATH"
if [ -d "$DOTFILES_PATH" ]; then
  info "$DOTFILES_PATH already exists"
else
  sudo pacman -Sy  --noconfirm --needed git git-lfs

  git init --separate-git-dir=$DOTFILES_PATH
  git remote add origin $REPO_HTTPS
  git remote set-url --push origin $REPO_GIT

  git config set status.showuntrackedfiles no

  git fetch
  git checkout main
fi
info "Setup of .dotfiles complete!"

echo ""
info "Starting installation of system"

info "Installing paru"
if [ $(command -v paru) ]; then
  info "paru is already installed"
else
  # INFO: For now use rustup from arch repo

  # info "Installing rustup"
  # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # source $HOME/.profile

  sudo pacman -Sy  --noconfirm --needed rustup
  rustup default nightly

  PARU_PATH=/tmp/paru
  git clone https://aur.archlinux.org/paru.git $PARU_PATH
  pushd $PARU_PATH

  export MAKEFLAGS="-j$(nproc)"
  makepkg -dci --needed --noconfirm OPTIONS='!debug !docs'

  popd
  rm -rf $PARU_PATH
  info "paru is installed"
fi


info "Installing and Configuring languages"

info "installing golang"
paru -Sy --noconfirm go

info "installing node version manager"
paru -Sy --noconfirm nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts

info "Install Nix"
paru -S nix
sudo systemctl enable --now nix-daemon.service

info "Installing packages"

PKG_VM=(
  spice-vdagent
  xf86-video-vesa
)

PKG_SYSTEM=(
  linux-headers
  kernel-modules-hook # backups kernel on updates to keep the system running until next reboot
  reflector # gets latest mirrors sorted by speed

  fwupd # updating firmware

  # INFO: secrets
  libsecret
  gnome-keyring
  openssh

  # INFO: shell
  zsh

  # INFO: system resource management
  fastfetch
  lshw
  dmidecode # helpful to get info about memory and stuff
  htop
  btop
  nvtop
  amdgpu_top
  brightnessctl
  nvme-cli
  perf

  # INFO: network
  dnsmasq
  openvpn
  iproute2
  wakeonlan
  ethtools
  inetutils # telnet, ping, ...
  bind # nslookup, dig, host
  ldns # drill, modern alternative to dig
  tcpdump
  nmap    # bins: ncat, nmap, nping

  # INFO: web
  curl
  wget

  # INFO: font
  font-manager
  ttf-firacode-nerd
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  noto-fonts-extra

  zip
  unzip
  7zip
)

PKG_AI=(
  ollama
  ollama-rocm
  claude-code
)

PKG_VIRT=(
  docker
  docker-compose
  docker-buildx # TODO: Is this really needed?
  iptables # Seems to be needed to run docker daemon since iptables is not enough
  # INFO: from https://gist.github.com/diffficult/cb8c385e646466b2a3ff129ddb886185
  virt-manager
  libvirt
  qemu-full
  lxc
)

PKG_DESKTOP=(
  sddm # login/display manager

  hyprland # compositor
  qt5-wayland
  qt6-wayland

  # INFO: https://wiki.archlinux.org/title/XDG_Desktop_Portal
  # Also see ~/.config/xdg-desktop-portal/hyprland-portals.conf
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk

  # xwaylandvideobridge # AUR; screensharing with xwayland applications
  hyprpolkitagent # polkit auth agent; controlls system privileges

  hypridle # idle behaviour
  hyprlock

  # INFO: for rebuilding hyprpm at a later stage
  cmake
  meson
  cpio

  fuzzel # launcher
  cliphist #clipboard
  waybar # topbar; will be replaced by AGS
  # aylurs-gtk-shell # AUR package; rather install manually via nix; see bottom
  network-manager-applet # nm-applet
  networkmanager-openvpn

  swaybg # background
  swaync # notification

  # INFO: file manager with plugins
  thunar
  thunar-volman        # automatic volume management
  thunar-shares-plugin # volume/directory share via samba
  gvfs                 # gnome virtual filesysytem
  gvfs-mtp             # media transfer protocol
  gvfs-gphoto2         # picture transfer protocol
  gvfs-smb             # windows file shares
  sambda
  thunar-archive-plugin
  xarchiver
  thunar-media-tags-plugin
  tumbler
  ffmpegthumbnailer

  # INFO: screenshots
  hyprshot
  grim
  slurp

  # INFO: system management
  seahorse              # secrets management
  power-profiles-daemon # provides powerprofilesctl
  pavucontrol           # gui for (pulse) audio control
  blueman
)

PKG_DEV=(
  man-db
  man-pages

  git
  git-lfs
  github-cli

  sl
  tmux
  entr # file-watcher
  less
  alacritty
  gitui
  fzf
  exa
  bat
  tokei
  ripgrep
  devtools
  moreutils # e.g. ts which transforms timestamps
  caddy # local server; subdomain support

  # INFO: Text Editor
  code
  nvim
  tree-sitter-cli

  # INFO: programming
  texlive
  typst
  # rustup # install rust via toolchain; both already installed for paru & dotfiles
  mold
  rust-analyzer
  cargo-asm
  python
  python-pip
  python-venv
  python-scipy

  # INFO: cloud
  aws-cli-v2

  # INFO: documents
  qpdf # merge pdfs etc

  # INFO: database
  dbeaver
  postgresql
)

# user tools, but desktop
PKG_APPS=(
  google-chrome     # AUR
  google-chrome-dev # AUR

  libreoffice-still
  evince # document (e.g. pdf) viewer

  # INFO: image viewer
  imv
  feh
  # nsxiv # This opens as floating window as default

  vlc
  vlc-plugin-all

  inkscape
  gimp
  blender
  # aseprite     # takes too long to compile
  # aseprite-bin # needs the installer downloaded; just utility for paid accounts

  thunderbird
  signal-desktop
  discord

  lact # gpu config tool
  gpu-screen-recorder
  obs-studio # requires qt6
  v4l2loopback-dkms # obs as virtual camera; maybe needs to be activated; See https://wiki.archlinux.org/title/V4l2loopback
)

PKG_GAMING=(
  steam
  gamescope
  gamemode
  mangohud
  proton-ge-custom-bin
)

paru -Syu --noconfirm --needed ${PKG_VM[@]} ${PKG_VIRT} ${PKG_SYSTEM[@]} ${PKG_AI[@]} ${PKG_DESKTOP[@]} ${PKG_DEV[@]} ${PKG_APPS[@]} ${PKG_GAMING[@]}}
info "installed packages"

# TODO: Separate into own scripts?
info "activating packages"
sudo systemctl daemon-reload
sudo chsh -s /bin/zsh $(whoami)
sudo systemctl enable --now linux-modules-cleanup.service

sudo systemctl enable --now --user hyprpolkitagent.service

sudo sed -i 's/# ParallelDownloads = [0-9]*/ParallelDownloads = 20/' /etc/pacman.conf
# sudo systemctl enable --now reflector # INFO: We currently only want to use reflector manually

sudo usermod -aG libvirt $(whoami)
sudo systemctl enable --now libvirtd

# TODO: If installed lact
sudo systemctl enable --now lactd

sudo systemctl enable --now --user ssh-agent.service
sudo systemctl enable --now sshd

# TODO: Check if we want this group
# The wine executable used by proton can automatically set the niceness of a process;
# Consider adding yourself to the games group to make this work by issuing: usermod -a -G games

sudo systemctl enable --now sddm
sudo systemctl enable --now --user hypridle.service

# TODO
sudo systemctl enable --now udisks2
sudo usermod -aG storage $USER


# TODO: Find other way for username. Is the username command working here?
sudo usermod -aG docker $USER

sudo usermod -aG input $USER

END_TIME=$(date +%s)
RUN_TIME=$(($END_TIME - $START_TIME))
M="$(($RUN_TIME / 60))"
S="$(($RUN_TIME % 60))"

info "Full installation was successfull!"
info "Total installation time: ${M}m ${S}s"

# TODO: Following procedures haven't found a way to be maintained well withing this script
#       Execute them manually afterwards

# INFO: For checking out any submodules
#       Requires an ssh key for "private" repos, which we do not have set up yet
# git submodule update --init --recursive

# INFO: AGS i
# nix profile add 'github:aylur/ags#agsFull'
# nix profile add --override-input astal "git+file://$HOME/git/github/Aylur/astal" 'github:aylur/ags/v3.1.2#agsFull' # With current fix for IPC communication

