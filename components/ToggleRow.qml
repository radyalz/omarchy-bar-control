import QtQuick
import QtQuick.Layouts
import qs.Commons

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
      color: root.enabled ? Color.foreground : Qt.alpha(Color.foreground, 0.4)
      font.pixelSize: 12
    }
    Text {
      visible: root.description !== ""
      Layout.fillWidth: true
      text: root.description
      color: Qt.alpha(Color.foreground, root.enabled ? 0.55 : 0.3)
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
