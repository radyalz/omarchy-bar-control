import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  visible: false
  property bool enabled: true
  property string animationMode: "Slide + Fade"
  property string animationPreset: "Smooth"
  property bool customCurveEnabled: false
  property string position: "top"
  property bool transparent: false
  property bool appearanceOverrideEnabled: false

  readonly property string settingsPath:
    Quickshell.env("HOME") + "/.config/omarchy/radyalz-bar-control.json"

  function load(raw) {
    var data = null
    try { data = JSON.parse(String(raw || "{}")) }
    catch (error) { return }
    if (typeof data.enabled === "boolean") root.enabled = data.enabled
    if (typeof data.animationMode === "string") root.animationMode = data.animationMode
    if (typeof data.animationPreset === "string") root.animationPreset = data.animationPreset
    if (typeof data.customCurveEnabled === "boolean")
      root.customCurveEnabled = data.customCurveEnabled
    if (typeof data.position === "string") root.position = data.position
    if (typeof data.transparent === "boolean") root.transparent = data.transparent
    if (typeof data.appearanceOverrideEnabled === "boolean")
      root.appearanceOverrideEnabled = data.appearanceOverrideEnabled
  }

  FileView {
    id: settingsFile
    path: root.settingsPath
    watchChanges: true
    printErrors: false
    onLoaded: root.load(text())
    onLoadFailed: root.load("{}")
    onFileChanged: reload()
  }
}
