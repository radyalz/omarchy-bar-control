import QtQuick
import QtQuick.Layouts
import qs.Commons

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
    color: root.healthy ? "#76d39b" : Color.urgent
  }

  Text {
    text: root.label
    color: Qt.alpha(Color.foreground, 0.8)
    font.pixelSize: 13
  }

  Item { Layout.fillWidth: true }

  Text {
    text: root.detail
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 12
  }
}
