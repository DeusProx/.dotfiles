#!/bin/sh

icons=$(
  find /usr/share/icons ~/.local/share/icons -type f \( -name '*.svg' -o -name '*.png' \) \
    | sed 's!.*/!!; s/\.[^.]*$//' \
    | sort -u \
    | jq -R \
    | jq -s
)

cat > ./widget/iconlist.ts <<EOF
const icons = $icons as const;

export type Icons = typeof icons[number];
EOF

