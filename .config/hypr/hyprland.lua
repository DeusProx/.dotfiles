----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output   = '',
  mode     = 'highres',
  position = 'auto',
  scale    = 1,
  vrr      = 1,
  bitdepth = 10,
})

--------------------
--- DEFAULT APPS ---
--------------------

local launcher = 'fuzzel'
local terminal = 'alacritty'
local browser  = 'google-chrome-stable'

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-------------------
--- ENVIRONMENT ---
-------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- TODO: Check if necessary
hl.env('XDG_CURRENT_DESKTOP','Hyprland')
hl.env('XDG_SESSION_DESKTOP','Hyprland')
hl.env('XDG_SESSION_TYPE','wayland')

-- Make the Simple DirectMedia API 3 (SDL3) know you are using a wayland compositor
hl.env('SDL_VIDEODRIVER','wayland')

hl.env('GDK_BACKEND', 'wayland,x11,*')
hl.env('GDK_SCALE','1')
-- hl.env('GTK_THEME','Nord')
hl.env('GTK_THEME','Adwaita:dark')
hl.on('hyprland.start', function ()
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
end)

hl.env('QT_QPA_PLATFORM','wayland;xcb')
hl.env('QT_QPA_PLATFORMTHEME','qt6ct')
hl.env('QT_WAYLAND_DISABLE_WINDOWDECORATION','1')
hl.env('QT_AUTO_SCREEN_SCALE_FACTOR','1')

hl.env('CLUTTER_BACKEND','wayland')

hl.env('MOZ_ENABLE_WAYLAND','1')
hl.env('MOZ_ALLOW_GTK_DARK_THEME','1')
-- https://www.electronjs.org/docs/latest/api/environment-variables
hl.env('ELECTRON_OZONE_PLATFORM_HINT','wayland')

hl.env('MANGOHUD','1')
hl.env('PROTON_MANGOHUD','1')
hl.env('PROTON_ENABLE_WAYLAND','1')
hl.env('PROTON_ENABLE_HDR','1')
hl.env('PROTON_FSR4_UPGRADE','1')
hl.env('PROTON_FSR4_RDNA3_UPGRADE','1')
hl.env('PROTON_FSR4_INDICATOR','0')

hl.env('XCURSOR_SIZE', '24')
hl.env('HYPRCURSOR_SIZE', '24')

-----------------
--- AUTOSTART ---
-----------------

--- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on('hyprland.start', function ()

  -- TODO: Check if necessary
  -- Startup
  -- for XDPH
  hl.exec_cmd('dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
  hl.exec_cmd('dbus-update-activation-environment --systemd --all')
  hl.exec_cmd('systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')

  -- Authentication Agent for hyprland
  hl.exec_cmd('systemctl --user start hyprpolkitagent.service')

  -- reload hyprlands plugin manager so plugins will work
  -- hl.exec_cmd('hyprpm reload -n')

  -- idle handling
  hl.exec_cmd('hypridle ')

  -- load wallpaper
  hl.exec_cmd('swaybg -i ~/.assets/wallpaper/kimitachi007.jpg')

  -- notifications
  hl.exec_cmd('swaync')

  -- environment apps & widgets
  hl.exec_cmd('nm-applet') -- networking
  hl.exec_cmd('waybar')    -- system bar

end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    allow_tearing = false,
    resize_on_border = false,

    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,

    col = {
      active_border = {
        colors = { 'rgba(33ccffee)', 'rgba(00ff99ee)' },
        angle = 45,
      },
      inactive_border = 'rgba(595959aa)',
    }
  }
})

hl.config({
  decoration = {
    rounding = 10,

    blur = {
      -- disable blur since we want to be able to read stuff through the semi-transparent terminal for now
      enabled = false,

      -- but keep full blur settings if we want to disable it at some point
      new_optimizations = true,
      xray = true,

      size = 2,
      passes = 2,

      -- blur in popups look shitty
      -- disable it
      popups = false,
      popups_ignorealpha	= 1.0,
    },
  }
})

hl.config({
  animations = {
    -- We do not like animations
    -- They make everything slow
    -- We just want to be there
    enabled = false
  }
})

hl.config({
  misc = {
    vrr = 1, -- variable refresh rate

    -- make sure stupid stuff is disabled
    disable_splash_rendering = true,
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,

    -- dpms - display power management signaling
    -- deactivates dpms when moving mouse or pressing key
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,

    -- when starting a GUI application from terminal then hide
    enable_swallow = true,
    swallow_regex = '^(a|A)lacritty$',
    swallow_exception_regex	= '^$',
  }
})


hl.config({
  xwayland = {
    force_zero_scaling = true,
  }
})

hl.config({
  debug = {
    overlay = false, -- causes high cpu load if activated
    damage_blink = false, -- causes flashy areas on updates

    -- we want logs!
    disable_logs = false,
    disable_time = false,
  }
})

---------------
--- LAYOUTS ---
---------------

hl.config({
  general = {
    layout = 'dwindle',
  },

  -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
  dwindle = {
    preserve_split = true,
  },

  -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
  master = {
    new_status = 'master',
    special_scale_factor = 0.8,
    mfact = 0.55,
    allow_small_split = true,
    orientation = 'center',
  },

})

hl.workspace_rule({
  workspace = 'name:browser',
  layout = 'master',
})

-------------
--- INPUT ---
-------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout  = 'de',
    kb_variant = '',
    kb_model   = '',
    kb_options = '',
    kb_rules   = '',

    repeat_delay = 250, -- default 600
    repeat_rate  =  50, -- default  25
    follow_mouse = 2,
    sensitivity  = 0, -- between -1.0 - 1.0, 0 means no modification.

    touchpad = {
        natural_scroll = true,
        scroll_factor  = 2.5,
    }
  }
})

hl.gesture({
  fingers   = 3,
  direction = 'horizontal',
  action    = 'workspace',
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = 'SUPER'
local moveMod = 'SHIFT'

-- common
hl.bind(mainMod .. ' + ' .. moveMod .. ' + ESCAPE', hl.dsp.exec_cmd('systemctl suspend'))
hl.bind(mainMod .. ' + Q', hl.dsp.window.close())                      -- [Q]uit
hl.bind(mainMod .. ' + V', hl.dsp.window.float({ action = 'toggle' })) -- [V]loating ;)
hl.bind(mainMod .. ' + P', hl.dsp.window.pin())                        -- [P]in

-- apps
hl.bind(mainMod .. ' + T', hl.dsp.exec_cmd(terminal))     -- [T]erminal
hl.bind(mainMod .. ' + SPACE', hl.dsp.exec_cmd(launcher)) -- '[SPACE]'-laucher

local layout_cmd = {
  dwindle = hl.dsp.layout('togglesplit'),
  master = hl.dsp.layout('swapwithmaster'),
}
hl.bind(mainMod .. ' + F', function ()
  local layout = hl.get_active_workspace().tiled_layout;
  local cmd = layout_cmd[layout];
  if cmd then
    hl.dispatch(cmd)
  end
end)

-- notifications
hl.bind(mainMod ..  ' + N', hl.dsp.exec_cmd('swaync-client -t'))
hl.on("workspace.active", function ()
  if hl.get_active_workspace().name == 'gaming' then
    hl.exec_cmd('swaync-client --dnd-on')
  else
    hl.exec_cmd('swaync-client --dnd-off')
  end
end)

-- move focus (arrows)
hl.bind(mainMod .. ' + left',  hl.dsp.focus({ direction = 'left' }))
hl.bind(mainMod .. ' + right', hl.dsp.focus({ direction = 'right' }))
hl.bind(mainMod .. ' + up',    hl.dsp.focus({ direction = 'up' }))
hl.bind(mainMod .. ' + down',  hl.dsp.focus({ direction = 'down' }))

-- move focus (vim)
hl.bind(mainMod .. ' + H', hl.dsp.focus({ direction = 'left' }))
hl.bind(mainMod .. ' + L', hl.dsp.focus({ direction = 'right' }))
hl.bind(mainMod .. ' + K', hl.dsp.focus({ direction = 'up' }))
hl.bind(mainMod .. ' + J', hl.dsp.focus({ direction = 'down' }))

-- move window (arrows)
hl.bind(mainMod .. ' + ' .. moveMod .. ' + left',  hl.dsp.window.move({ direction = 'left' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + right', hl.dsp.window.move({ direction = 'right' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + up',    hl.dsp.window.move({ direction = 'up' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + down',  hl.dsp.window.move({ direction = 'down' }))

-- move window (vim)
hl.bind(mainMod .. ' + ' .. moveMod .. ' + H', hl.dsp.window.move({ direction = 'left' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + L', hl.dsp.window.move({ direction = 'right' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + K', hl.dsp.window.move({ direction = 'up' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + J', hl.dsp.window.move({ direction = 'down' }))

-- named workspaces
hl.bind(mainMod .. ' + G', hl.dsp.focus({ workspace = 'name:gaming' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + G', hl.dsp.window.move({ workspace = 'name:gaming' }))
hl.bind(mainMod .. ' + B', hl.dsp.focus({ workspace = 'name:browser' }))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + B', hl.dsp.window.move({ workspace = 'name:browser' }))

-- special workspace | scratchpad
hl.bind(mainMod .. ' + S', hl.dsp.workspace.toggle_special('terminal'))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + S', hl.dsp.window.move({ workspace = 'special:terminal'}))
hl.bind(mainMod .. ' + I', hl.dsp.workspace.toggle_special('incognito'))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + I', hl.dsp.window.move({ workspace = 'special:incognito'}))
hl.bind(mainMod .. ' + M', hl.dsp.workspace.toggle_special('music'))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + M', hl.dsp.window.move({ workspace = 'special:music'}))
hl.bind(mainMod .. ' + C', hl.dsp.workspace.toggle_special('communication'))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + C', hl.dsp.window.move({ workspace = 'special:communication'}))

-- switch workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. ' + ' .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. ' + ' .. moveMod .. ' + ' .. key, hl.dsp.window.move({ workspace = i }))
end

hl.config({ binds = { allow_workspace_cycles = true } })

-- # rotate through workspace (arrows); but control sucks
hl.bind(mainMod .. ' + CONTROL + left', hl.dsp.focus({ workspace = 'e-1'}))
hl.bind(mainMod .. ' + CONTROL + right', hl.dsp.focus({ workspace = 'e+1'}))

-- # rotate through workspace (vim); but control sucks
hl.bind(mainMod .. ' + CONTROL + h', hl.dsp.focus({ workspace = 'e-1'}))
hl.bind(mainMod .. ' + CONTROL + l', hl.dsp.focus({ workspace = 'e+1'}))

-- # rotate workspaces (scroll)
hl.bind(mainMod .. ' + mouse_up', hl.dsp.focus({ workspace = 'e-1'}))
hl.bind(mainMod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e+1'}))

-- # move to last workspace
hl.bind(mainMod .. ' + tab', hl.dsp.focus({ workspace = 'previous'}))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- brightness control
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd('brightnessctl set 10%-'))
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd('brightnessctl set 10%+'))

-- volume control
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+'))
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-'))
hl.bind('XF86AudioMute',        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'))
hl.bind('XF86AudioMicMute',     hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle # This currently does not work with my keyboard'))

-- media control
hl.bind('XF86AudioPlay',  hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
hl.bind('XF86AudioNext',  hl.dsp.exec_cmd('playerctl next'),       { locked = true })
hl.bind('XF86AudioPrev',  hl.dsp.exec_cmd('playerctl previous'),   { locked = true })

-- screenshots
hl.env('HYPRSHOT_DIR', os.getenv('HOME') .. '/images/screenshots')

hl.bind('PRINT', hl.dsp.exec_cmd('hyprshot -m output -m active'))
hl.bind(mainMod .. ' + PRINT', hl.dsp.exec_cmd('hyprshot -m window -m active'))
hl.bind(mainMod .. ' + ' .. moveMod .. ' + PRINT', hl.dsp.exec_cmd('hyprshot -m region'))

----------------------------
--- Windows & Workspaces ---
----------------------------

hl.window_rule({
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  match = { class = '^(xdg-desktop-portal-.*)$' },
  float = true,
  center = true,
})

local browser_cmd = browser .. ' --profile-directory="Default" --restore-last-session'
hl.workspace_rule({
  workspace = 'name:browser',
  on_created_empty = browser_cmd,
})
local browser_window_rule = hl.window_rule({
  match = { class = '^(google-chrome)$' },
  workspace = 'name:browser',
  enabled = false,
})
hl.on('hyprland.start', function ()
  browser_window_rule:set_enabled(true)
  hl.exec_cmd(browser_cmd, { workspace = 'name:browser silent' })
  browser_window_rule:set_enabled(false)
end)


hl.workspace_rule({
  workspace = 'name:gaming',
  on_created_empty = 'steam',
})
hl.window_rule({
  match = { class = '^([Ss]team)$' },
  workspace = 'name:gaming silent'
})
hl.on('hyprland.start', function ()
  hl.exec_cmd('steam', { workspace = 'name:gaming silent' })
end)

hl.workspace_rule({
  workspace = 'special:terminal',
  on_created_empty = terminal,
})

hl.workspace_rule({
  workspace = 'special:incognito',
  on_created_empty = browser .. ' --incognito',
})

hl.window_rule({
  match = { class = '^([dD]iscord)$' },
  workspace = 'special:communication silent',
})
hl.on('hyprland.start', function ()
  hl.exec_cmd('signal-desktop', { workspace = 'special:communication silent' })
  hl.exec_cmd('thunderbird', { workspace = 'special:communication silent' })
  hl.exec_cmd('discord', { workspace = 'special:communication silent' })
end)

hl.workspace_rule({
  workspace = 'special:music',
  on_created_empty = 'gtk-launch Tidal',
})
hl.on('hyprland.start', function ()
  hl.exec_cmd('gtk-launch Tidal', { workspace = 'special:music silent' })
end)
