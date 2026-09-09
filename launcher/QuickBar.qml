import QtQuick
import "components"

Column {
  id: root
  property var host: null
  property var state: null
  spacing: 9

  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "‹  Placement & appearance"
    subtitle: "Back to quick controls"; onClicked: root.host.view = "main"
  }
  QuickSection { bar: root.host ? root.host.bar : null; label: "Position" }
  Flow {
    width: parent.width; spacing: 7
    Repeater {
      model: ["top", "bottom", "left", "right"]
      QuickChip {
        required property string modelData
        bar: root.host ? root.host.bar : null
        text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
        active: root.state && root.state.position === modelData
        onClicked: { root.state.position = modelData; root.host.callControl("setPosition", modelData) }
      }
    }
  }
  QuickToggleRow {
    bar: root.host ? root.host.bar : null; title: "Transparent bar"
    subtitle: "Let the desktop show through"
    checked: root.state ? root.state.transparent : false
    onToggled: function(value) { root.state.transparent = value; root.host.callControl("setTransparent", value) }
  }
  QuickToggleRow {
    bar: root.host ? root.host.bar : null; title: "Custom island appearance"
    subtitle: "Enable padding, radius and opacity controls"
    checked: root.state ? root.state.appearanceOverrideEnabled : false
    onToggled: function(value) { root.state.appearanceOverrideEnabled = value; root.host.callControl("setAppearanceOverride", value) }
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "More bar settings"; primary: true
    onClicked: root.host.openAdvanced(1)
  }
}
