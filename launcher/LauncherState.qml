import QtQuick
import "LauncherPresets.js" as Presets

Item {
  id: root

  visible: false
  property bool active: false
  property bool enabled: true
  property string animationMode: "Slide + Fade"
  property string animationPreset: "Smooth"
  property bool customCurveEnabled: false
  property string position: "top"
  property bool transparent: false
  property bool appearanceOverrideEnabled: false

  function apply(data) {
    if (typeof data.enabled === "boolean") root.enabled = data.enabled
    if (typeof data.animationMode === "string") root.animationMode = data.animationMode
    if (typeof data.animationPreset === "string") root.animationPreset = data.animationPreset
    if (typeof data.customCurveEnabled === "boolean") root.customCurveEnabled = data.customCurveEnabled
    if (typeof data.position === "string") root.position = data.position
    if (typeof data.transparent === "boolean") root.transparent = data.transparent
    if (typeof data.appearanceOverrideEnabled === "boolean")
      root.appearanceOverrideEnabled = data.appearanceOverrideEnabled
  }

  function refresh() { store.refresh() }
  function setEnabled(value) { store.update({ enabled: value === true }) }
  function setAnimationMode(value) { store.update({ animationMode: String(value) }) }
  function setPosition(value) { store.update({ position: String(value) }) }
  function setTransparent(value) { store.update({ transparent: value === true }) }
  function setAppearanceOverride(value) {
    store.update({ appearanceOverrideEnabled: value === true })
  }
  function setCustomCurve(value) {
    var active = value === true
    var patch = { customCurveEnabled: active }
    if (active) patch.animationPreset = "Custom"
    store.update(patch)
  }

  function setAnimationPreset(value) {
    store.update(Presets.patch(String(value)))
  }

  LauncherSettingsStore {
    id: store
    active: root.active
    onLoaded: function(data) { root.apply(data) }
  }

  onActiveChanged: if (active) store.refresh()
}
