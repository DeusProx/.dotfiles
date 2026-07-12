alias update-mirrors='sudo reflector --verbose -l 50 -p https --sort rate --save /etc/pacman.d/mirrorlist'

# Might need to update metadata database before: `paru -Fy`
binsof() {
  (paru -Flq $1 || return 0) | grep 'bin/..*' | xargs -n1 basename
}

pkgof() {
  paru -Qo "$1"
}

