import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createBinding, For  } from "gnim";
import { WorkspaceModule } from "./workspaces";
import { Clock } from "./clock";

// Install ags with newer astal declarations:
// nix profile add --override-input astal github:aylur/astal 'github:aylur/ags/v3.1.2#agsFull'
//
// Install ags with local astal repo (e.g. for fixes):
// nix profile add --override-input astal "git+file://$HOME/git/github/Aylur/astal" 'github:aylur/ags/v3.1.2#agsFull'

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
      <ScreenBrightness />
      <PowerProfile />
      {/* <WLAN /> */}
      {/* <Battery /> */}
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

  const icon = createBinding(wp, name, "volume_icon")
  const volume = createBinding(wp, name, "volume")
    .as(volume => `${Math.round(volume * 100)}%`)

  return (
    <button
      onClicked={() => wp[name].mute = !wp[name].mute}
      $={onScrolled(volume => wp[name].set_volume(wp[name].volume - (volume * 5) / 100))}
    >
      <box>
        <label label={volume} />
        <image iconName={icon} />
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
  const icon = createBinding(powerprofiles, "icon_name")
  function cycle() {
    const id = profiles.indexOf(powerprofiles.get_active_profile());
    powerprofiles.set_active_profile(profiles[(id + 1) % profiles.length]);
  }

  return (
    <button onClicked={cycle}>
      <image iconName={icon} />
    </button>
  )
}

import AstalBrightness from "gi://AstalBrightness";

function ScreenBrightness() {
  const brightnessValu = createBinding(AstalBrightness.get_default(), "screen", "brightness")
    .as(v => `${Math.round(v * 100)}%`)
    // .as(v => `${v}`)

  return brightnessValu() != "-100%"
    ? <label label={brightnessValu}></label>
    : <></>
}

// TODO: We currently still rely on NetworkManager; This would probably be cooler
// function WLAN() {
//   return <Icon name='network-wireless-symbolic' />
// }

// TODO: We need that for the laptop
// function Battery() {
//   return <Icon name='battery' />
// }

import AstalTray from "gi://AstalTray"
import { execAsync } from "ags/process"
import { Icon } from './icons'

function TrayServices() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => btn.insert_action_group("dbusmenu", item.actionGroup))
    // TODO: Should we tidy up?
    // const handler = item.connect("notify::action-group", () => btn.insert_action_group("dbusmenu", item.actionGroup))
    // btn.connect("destroy", () => item.disconnect(handler))
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

