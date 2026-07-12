alias update-mirrors='sudo reflector --verbose -l 50 -p https --sort rate --save /etc/pacman.d/mirrorlist'

# Might need to update metadata database before: `paru -Fy`
paru-show-executables() {
  paru -Flq $1 | grep 'bin/..*' | xargs -n1 basename
}

