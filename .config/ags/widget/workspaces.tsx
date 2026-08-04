import { With } from "ags"
import { createBinding, For } from "gnim";

import Hyprland from "gi://AstalHyprland";

export function WorkspaceModule() {
  return (
    <box spacing={3}>
      <WorkspaceList />
      <SpecialWorkspace />
    </box>
  )
}

function WorkspaceList() {
  const hypr = Hyprland.get_default();
  const focused = createBinding(hypr, "focused_workspace")
  const workspaces = createBinding(hypr, "workspaces")
    .as(workspaces => {
      workspaces = workspaces.filter(ws => (ws.get_name()?.startsWith('special:') === false)) // TODO: Check
      workspaces.sort((a, b) =>
        (
          isNaN(+a.name) && isNaN(+b.name)
            ? b.name < a.name
            : Math.abs(b.id) < Math.abs(a.id)
        )
          ? 1
          : -1

      )
      return workspaces
    })

  return (
    <box class="module">
      <For each={workspaces}>
        { workspace => (
          <button class={focused(fws => fws.id == workspace.id ? "active" : "")}>
            <label label={workspace.name} />
          </button>
        )}
      </For>
    </box>
  )
}

function SpecialWorkspace() {
  const hypr = Hyprland.get_default();
  const special_workspace = createBinding(hypr, "focused_monitor", "special_workspace", "name")

  return (
    <With value={special_workspace}>
      {(sws) => sws != null && (
        <box class="module">
          <label class="active" label={sws.substring(sws.indexOf(":") + 1)} />
        </box>
      )}
    </With>
  )
}

