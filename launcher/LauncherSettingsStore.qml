import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  visible: false
  property bool active: false
  property var snapshot: ({})
  // Exact text of the last payload this surface wrote, so the watcher echo of
  // our own write is ignored instead of being suppressed on a time window.
  property string lastWrittenText: ""

  signal loaded(var data)

  readonly property string settingsPath:
    Quickshell.env("HOME") + "/.config/omarchy/radyalz-bar-control.json"

  function refresh() {
    settingsFile.reload()
  }

  function readDisk() {
    // blockLoading makes reload() + text() synchronous.
    settingsFile.reload()
    try {
      var raw = settingsFile.text()
      if (String(raw || "").trim() !== "")
        return JSON.parse(raw) || {}
    } catch (error) { }
    return JSON.parse(JSON.stringify(root.snapshot || {}))
  }

  function update(patch) {
    // Merge onto the current on-disk contents, never onto the cached snapshot:
    // the popover may have been closed while the advanced panel or the bar
    // changed settings, which would make snapshot stale and revert them.
    var next = root.readDisk()
    next.version = 3
    for (var key in patch)
      next[key] = patch[key]
    root.snapshot = next
    root.loaded(next)

    var serialized = JSON.stringify(next, null, 2) + "\n"
    if (serialized === root.lastWrittenText)
      return
    root.lastWrittenText = serialized
    settingsFile.setText(serialized)
  }

  function load(raw) {
    var data = null
    try { data = JSON.parse(String(raw || "{}")) }
    catch (error) { return }
    root.snapshot = data || ({})
    root.loaded(root.snapshot)
  }

  FileView {
    id: settingsFile
    path: root.settingsPath
    // Event-driven live sync with the bar and the advanced panel.
    watchChanges: true
    // Synchronous reload() + text() for the read-modify-write in update().
    blockLoading: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.load(text())
    onLoadFailed: root.load("{}")
    onFileChanged: reload()
  }
}
