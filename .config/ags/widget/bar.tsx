import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createBinding, createComputed, For } from "gnim";
import { WorkspaceModule } from "./workspaces";
import { Clock } from "./clock";
import { Icon } from './icons'

export default function Bar(monitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  monitor.refreshRate

  return (
    <window
      visible
      name="bar"
      class="bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={ TOP | LEFT | RIGHT }
      application={app}
    >
      <centerbox orientation={Gtk.Orientation.HORIZONTAL}>
        <WorkspaceModule $type="start" />
        <Clock $type="center" />
        <Controls $type="end" />
      </centerbox>
    </window>
  )
}

function Controls() {
  return (
    <box class="module">
      <Audio type="out"/>
      <Audio type="in"/>
      <Brightness />
      <Battery />
      {/* <WLAN /> */}
      <PowerProfile />
      <TrayServices />
      <Suspend />
    </box>
  )
}

import AstalWp from 'gi://AstalWp?version=0.1';
let wp = AstalWp.get_default()

type AudioContext = { type: "out" | "in" }
function Audio(ctx: AudioContext) {
  const name = ctx.type == "out" ? "default_speaker" : "default_microphone"

  const iconName = createBinding(wp, name, "volume_icon")
  const volume = createBinding(wp, name, "volume")
    .as(volume => `${Math.round(volume * 100)}%`)

  return (
    <button
      onClicked={() => wp[name].mute = !wp[name].mute}
      $={onScrolled(volume => wp[name].set_volume(wp[name].volume - (volume * 5) / 100))}
    >
      <box spacing={6}>
        <Icon name={iconName} />
        <label label={volume} />
      </box>
    </button>
  )
}

export function onScrolled(
  callback: (dy: number) => void,
): (widget: Gtk.Widget) => void {
  return widget => {
    const controller = new Gtk.EventControllerScroll({
      flags:
        Gtk.EventControllerScrollFlags.VERTICAL |
        Gtk.EventControllerScrollFlags.DISCRETE,
    })

    controller.connect("scroll", (_, _dx, dy) => {
      callback(dy)
      return true
    })

    widget.add_controller(controller)
  }
}

import AstalPP from "gi://AstalPowerProfiles";
const powerprofiles = AstalPP.get_default()
const profiles = powerprofiles.get_profiles()
  .map(profile => profile.profile)

function PowerProfile() {
  const iconName = createBinding(powerprofiles, "icon_name")
  function cycle() {
    const id = profiles.indexOf(powerprofiles.get_active_profile());
    powerprofiles.set_active_profile(profiles[(id + 1) % profiles.length]);
  }

  return (
    <button onClicked={cycle}>
      <Icon name={iconName} />
    </button>
  )
}

import AstalBrightness from "gi://AstalBrightness";
const astalBrightness = AstalBrightness.get_default();

function Brightness() {
  const isPresent = createBinding(astalBrightness, "backlights", "devices")
    .as(backlights => backlights.length > 0)
  const brightnessValue = createBinding(astalBrightness, "screen", "brightness")
  const brightness = brightnessValue.as(v => `${Math.round(v * 100)}%`)

  return isPresent()
    ? (
      <box
        spacing={6}
        $={onScrolled(delta => astalBrightness.get_screen().set_brightness(Math.max(0, brightnessValue() - delta * 0.05)))}
      >
        <Icon name="display-brightness-symbolic" />
        <label label={brightness}></label>
      </box>
    ) : <></>
}

// TODO: We currently still rely on NetworkManager; This would probably be cooler
// function WLAN() {
//   return <Icon name='network-wireless-symbolic' />
// }

import AstalBattery from "gi://AstalBattery"
const battery = AstalBattery.get_default()

function formatTime(seconds: number): string {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)

  return `${hours}h ${minutes}m`
}

function Battery() {
  const isPresent = createBinding(battery, "isPresent")
  const iconName = createBinding(battery, "iconName")
  const percentage = createBinding(battery, "percentage")
    .as(p => `${Math.round(p * 100)}%`)

  const isCharging = createBinding(battery, "charging")
  const timeToFull = createBinding(battery, "timeToFull")
  const timeToEmpty = createBinding(battery, "timeToEmpty")

  const tooltip = createComputed(() =>
    isCharging()
      ? `Until full: ${formatTime(timeToFull())}`
      : `Until empty: ${formatTime(timeToEmpty())}`
  )

  return (
    isPresent()
      ? (
        <box
          spacing={6}
          tooltipText={tooltip}
        >
          <Icon name={iconName} />
          <label label={percentage} />
        </box>
      ) : <></>
  )
}

import AstalTray from "gi://AstalTray"
import { execAsync } from "ags/process"
import { onCleanup } from "gnim";

function TrayServices() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    const popover = Gtk.PopoverMenu.new_from_model_full(
      item.menuModel,
      Gtk.PopoverMenuFlags.NESTED,
    )
    btn.set_popover(popover)

    const updateActions = () => btn.insert_action_group("dbusmenu", item.actionGroup)
    updateActions()

    const modelHandler = item.connect("notify::menu-model", () => popover.set_menu_model(item.menuModel))
    const actionHandler = item.connect("notify::action-group", updateActions)

    onCleanup(() => {
      item.disconnect(modelHandler)
      item.disconnect(actionHandler)
    })
  }

  return (
    <box>
      <For each={items}>
        { item => (
          <menubutton
            $={(self) => init(self, item)}
            tooltipMarkup={createBinding(item, "tooltipMarkup")}
            overflow={Gtk.Overflow.HIDDEN}
          >
            <image gicon={createBinding(item, "gicon")}></image>
          </menubutton>
        )}
      </For>
    </box>
  )
}

function Suspend() {
  return (
    <button onClicked={() => execAsync([ 'systemctl', 'suspend' ])}>
      <Icon name={"weather-clear-night-symbolic"} />
    </button>
  )
}

