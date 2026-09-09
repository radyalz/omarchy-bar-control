import QtQuick
import "components"

Column {
  id: root
  property var host: null
  property var state: null
  spacing: 9

  QuickHeader {
    width: parent.width; bar: root.host ? root.host.bar : null
    title: "Bar Control"; subtitle: "Quick controls"
  }
  QuickSection { bar: root.host ? root.host.bar : null; label: "Autohide" }
  QuickToggleRow {
    bar: root.host ? root.host.bar : null
    title: "Autohide"; subtitle: root.state && root.state.enabled ? "Active" : "Bar stays visible"
    checked: root.state ? root.state.enabled : false
    onToggled: function(value) { root.state.setEnabled(value) }
  }
  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "Animation & curve"
    subtitle: root.state ? root.state.animationMode : "Slide + Fade"
    badge: root.state ? root.state.animationPreset : "Smooth"
    onClicked: root.host.view = "animation"
  }
  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "Placement & appearance"
    subtitle: root.state ? root.state.position.charAt(0).toUpperCase() + root.state.position.slice(1) : "Top"
    badge: root.state && root.state.transparent ? "Glass" : "Solid"
    onClicked: root.host.view = "bar"
  }
  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "About & support"
    subtitle: "Version, GitHub and diagnostics"
    onClicked: root.host.view = "about"
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "Open advanced editor"; primary: true
    onClicked: root.host.actions.openAdvanced(0)
  }
}
