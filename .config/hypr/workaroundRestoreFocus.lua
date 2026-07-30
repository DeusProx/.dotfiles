-- Workaround for for restoring focus on toggling monitor on/off
--
-- See https://github.com/hyprwm/Hyprland/discussions/15554
--

local function restore_focus(target_workspace, target_window)
  -- focus last window
  if target_window then
    hl.dispatch(hl.dsp.focus({ window = target_window }))
  end

  -- cycle workspace
  for _, workspace in ipairs(hl.get_workspaces()) do
    if workspace.id ~= target_workspace.id
        and not workspace.name:match("^special:") then
      hl.dispatch(hl.dsp.focus({ workspace = workspace }))
      break
    end
  end

  -- focus last workspace again
  hl.dispatch(hl.dsp.focus({ workspace = target_workspace }))
end

hl.on("monitor.added", function(monitor)
  if monitor.name == "FALLBACK" or not hl.get_monitor("FALLBACK") then
    return
  end

  -- Capture before FALLBACK migration destroys the history.
  local target_workspace = hl.get_last_workspace()
  local target_window = hl.get_last_window()

  hl.timer(function()
    restore_focus(target_workspace, target_window)
  end, {
    timeout = 500,
    type = "oneshot",
  })
end)

