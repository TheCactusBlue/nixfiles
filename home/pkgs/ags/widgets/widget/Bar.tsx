import app from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import { execAsync } from "ags/process";
import { createPoll } from "ags/time";

import Hypr from "gi://AstalHyprland";

const hypr = Hypr.get_default();

function Workspaces() {
  const workspaces = [...hypr.workspaces].sort((a, b) =>
    a.name.localeCompare(b.name)
  );
  return (
    <box>
      {workspaces.map((x) => (
        <button
          $type="start"
          onClicked={() => {
            console.log(x.name);
          }}
        >
          <label label={`${x.id}`} />
        </button>
      ))}
    </box>
  );
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 1000, "date");
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <Workspaces />
    </window>
  );
}
