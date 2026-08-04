import { Accessor } from "ags"
import { Gtk } from "ags/gtk4"
import { createState } from "gnim";

export function Clock() {
  return (
    <box class="module">
      <menubutton>
        <label label={time()} />
        <popover>
          <Gtk.Calendar class="calender"/>
        </popover>
      </menubutton>
    </box>
  )
}

const clockFmt = new Intl.DateTimeFormat("en-GB", {
  weekday: "short",
  day: "2-digit",
  month: "short",
  year: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
  hourCycle: "h23",
});

type Time = {
  [Key in Intl.DateTimeFormatPartTypes]: string
}

function time(): Accessor<string> {
  function update() {
    let time: Time = clockFmt.formatToParts(new Date())
      .reduce((acc: any, part) => {
        acc[part.type] = part.value;
        return acc;
      }, {})

    return `${time.weekday} ${time.day} ${time.month} ${time.year} - ${time.hour}:${time.minute}:${time.second}`
  }

  let [time, setTime] = createState(update())
  setInterval(() => setTime(update()), 25)

  return time;
}


