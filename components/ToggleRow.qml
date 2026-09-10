import QtQuick
import QtQuick.Layouts

// Label (+ optional description) on the left, a switch aligned to the right.
// Shared by every "Custom ..." opt-in so they line up the same way.
RowLayout {
  id: root
  property string label: ""
  property string description: ""
  property bool checked: false
  signal toggled(bool checked)

  Layout.fillWidth: true
  spacing: 14

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2
    Text {
      text: root.label
      color: root.enabled ? "#d7dce6" : "#626a78"
      font.pixelSize: 12
    }
    Text {
      visible: root.description !== ""
      Layout.fillWidth: true
      text: root.description
      color: root.enabled ? "#7f8793" : "#5c636f"
      font.pixelSize: 10
      wrapMode: Text.WordWrap
    }
  }

  GlassToggle {
    Layout.alignment: Qt.AlignVCenter
    checked: root.checked
    enabled: root.enabled
    onToggled: function(value) { root.toggled(value) }
  }
}
