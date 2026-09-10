import QtQuick
import QtQuick.Layouts

RowLayout {
  id: root

  property string label: ""
  property bool healthy: false
  property string detail: healthy ? "OK" : "Needs attention"

  Layout.fillWidth: true

  Rectangle {
    width: 10
    height: 10
    radius: 4
    color: root.healthy ? "#9ece6a" : "#f7768e"
  }

  Text {
    text: root.label
    color: "#d1d5db"
    font.pixelSize: 13
  }

  Item { Layout.fillWidth: true }

  Text {
    text: root.detail
    color: "#9ca3af"
    font.pixelSize: 12
  }
}
