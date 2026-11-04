alias update-mirrors='sudo reflector --verbose -l 50 -p https --sort rate --save /etc/pacman.d/mirrorlist'

alias remove-orphans='sudo pacman -Rns $(pacman -Qdtq)'

# Might need to update metadata database before: `paru -Fy`
binsof() {
  (pacman -Flq $1 || return 0) | grep 'bin/..*' | xargs -n1 basename
}

pkgof() {
  pacman -Qo "$1"
}

