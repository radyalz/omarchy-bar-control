import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  visible: false
  property bool active: false
  property var snapshot: ({})
  property double suppressReloadUntil: 0

  signal loaded(var data)

  readonly property string settingsPath:
    Quickshell.env("HOME") + "/.config/omarchy/radyalz-bar-control.json"

  function refresh() {
    if (Date.now() >= root.suppressReloadUntil)
      settingsFile.reload()
  }

  function update(patch) {
    var next = JSON.parse(JSON.stringify(root.snapshot || {}))
    next.version = 3
    for (var key in patch)
      next[key] = patch[key]
    root.snapshot = next
    root.suppressReloadUntil = Date.now() + 350
    root.loaded(next)
    settingsFile.setText(JSON.stringify(next, null, 2) + "\n")
  }

  function load(raw) {
    var data = null
    try { data = JSON.parse(String(raw || "{}")) }
    catch (error) { return }
    root.snapshot = data || ({})
    root.loaded(root.snapshot)
  }

  Timer {
    interval: 150
    repeat: true
    running: root.active
    onTriggered: root.refresh()
  }

  FileView {
    id: settingsFile
    path: root.settingsPath
    watchChanges: false
    atomicWrites: true
    printErrors: false
    onLoaded: root.load(text())
    onLoadFailed: root.load("{}")
  }
}
