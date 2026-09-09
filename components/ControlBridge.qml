import QtQuick
import Quickshell.Io

Item {
  id: root

  property var service: null

  function boolValue(value) {
    return value === true || String(value).toLowerCase() === "true"
  }

  IpcHandler {
    target: "radyalz.bar-control"

    function setEnabled(value) {
      if (root.service) root.service.enabled = root.boolValue(value)
    }
    function setPosition(value) {
      if (root.service) root.service.setBarPosition(String(value))
    }
    function setTransparent(value) {
      if (root.service) root.service.setTransparent(root.boolValue(value))
    }
    function setAppearanceOverride(value) {
      if (root.service)
        root.service.appearanceOverrideEnabled = root.boolValue(value)
    }
    function setAnimationPreset(value) {
      if (root.service) root.service.setAnimationPreset(String(value))
    }
    function setAnimationMode(value) {
      if (root.service) root.service.animationMode = String(value)
    }
    function setCustomCurve(value) {
      if (!root.service) return
      root.service.customCurveEnabled = root.boolValue(value)
      root.service.animationPreset = "Custom"
    }
  }
}
