current_windows() {
  hyprctl clients -j \
    | jq \
      --argjson id "$(hyprctl activeworkspace -j | jq '.id')" \
      '.[] | select(.workspace.id == $id)'
}
