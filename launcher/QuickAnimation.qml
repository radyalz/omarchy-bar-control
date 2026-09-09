import QtQuick
import "components"

Column {
  id: root
  property var host: null
  property var state: null
  spacing: 9

  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "‹  Animation & curve"
    subtitle: "Back to quick controls"; onClicked: root.host.view = "main"
  }
  QuickSection { bar: root.host ? root.host.bar : null; label: "Feel" }
  Flow {
    width: parent.width; spacing: 7
    Repeater {
      model: ["Smooth", "Snappy", "Soft"]
      QuickChip {
        required property string modelData
        bar: root.host ? root.host.bar : null; text: modelData
        active: root.state && root.state.animationPreset === modelData
        onClicked: { root.state.animationPreset = modelData; root.host.callControl("setAnimationPreset", modelData) }
      }
    }
  }
  QuickSection { bar: root.host ? root.host.bar : null; label: "Motion" }
  Flow {
    width: parent.width; spacing: 7
    Repeater {
      model: ["Slide + Fade", "Slide", "Fade"]
      QuickChip {
        required property string modelData
        bar: root.host ? root.host.bar : null; text: modelData
        active: root.state && root.state.animationMode === modelData
        onClicked: { root.state.animationMode = modelData; root.host.callControl("setAnimationMode", modelData) }
      }
    }
  }
  QuickToggleRow {
    bar: root.host ? root.host.bar : null; title: "Custom curve"
    subtitle: "Use your Bézier curve for show and hide"
    checked: root.state ? root.state.customCurveEnabled : false
    onToggled: function(value) { root.state.customCurveEnabled = value; root.host.callControl("setCustomCurve", value) }
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "Edit timing & curve"; primary: true
    onClicked: root.host.openAdvanced(0)
  }
}
