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
  rustup default stable

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


info "Installing packages"

PKG_VM=(
  spice-vdagent
  xf86-video-vesa
)

PKG_SYSTEM=(
  linux-headers
  reflector # gets latest mirrors sorted by speed
  zsh
  fastfetch

  htop
  btop
  nvtop
  radeontop

  curl
  wget

  net_tools # ifconfig, ...
  inetutils # telnet, ping, ...
  brightnessctl
  nvme-cli
)

PKG_AI=(
  ollama
)

PKG_DESKTOP=(
  sddm # login/display manager

  hyprland # compositor
  qt5-wayland
  qt6-wayland
  xdg-desktop-portal-hyprland # screensharing
  # xwaylandvideobridge # AUR; screensharing with xwayland applications
  hyprpolkitagent # polkit auth agent; controlls system privileges

  hypridle
  hyprlock

  # for rebuilding hyprpm at a later stage
  cmake
  meson
  cpio

  fuzzel # launcher
  hypridle # idle behaviour
  waybar # topbar
  network-manager-applet # nm-applet

  swaybg waypaper # background
  swaync # notification
  hyprshot # screenshots

  # file manager with plugins
  thunar
  thunar-archive-plugin
  thunar-media-tags-plugin
  thunar-shares-plugin
  thunar-volman

  # screenshots + screensharing deps
  grim
  slurp
)

PKG_NVIM=(
  nvim
  tree-sitter-cli
)

PKG_DEV=(
  man-db
  man-pages

  git
  git-lfs
  github-cli
  openssh

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
)

# user tools, but desktop
PKG_APPS=(
  google-chrome
  google-chrome-dev

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
)

PKG_OTHERS=(
  texlive

  # from https://gist.github.com/diffficult/cb8c385e646466b2a3ff129ddb886185
  virt-manager
  libvirt
  qemu-full
  lxc
  dnsmasq
  dmidecode

  dbeaver
  postgresql
)

paru -Syu --noconfirm --needed ${PKG_VM[@]} ${PKG_SYSTEM[@]} ${PKG_AI[@]} ${PKG_DESKTOP[@]} ${PKG_NVIM[@]} ${PKG_DEV[@]} ${PKG_APPS[@]} ${PKG_GAMING[@]} ${PKG_OTHERS[@]}
info "installed packages"

info "activating packages"
sudo chsh -s /bin/zsh $(whoami)

sudo systemctl enable sddm

sudo systemctl enable --now --user hyprpolkitagent.service

sudo systemctl enable --now --user ssh-agent.service

sudo sed -i 's/# ParallelDownloads = [0-9]*/ParallelDownloads = 20/' /etc/pacman.conf
# sudo systemctl enable --now reflector # INFO: We currently only want to use reflector manually

sudo usermod -aG libvirt $(whoami)
sudo systemctl enable --now libvirtd


END_TIME=$(date +%s)
RUN_TIME=$(($END_TIME - $START_TIME))
M="$(($RUN_TIME / 60))"
S="$(($RUN_TIME % 60))"

info "Full installation was successfull!"
info "Total installation time: ${M}m ${S}s"

