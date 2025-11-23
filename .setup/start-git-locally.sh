parallel :::: \
  "git daemon --reuseaddr --base-path=$HOME --export-all --verbose --enable=receive-pack --detach ~/" \
  "live-server --wait=0 ~/"
