import QtQuick
import QtQuick.Layouts
import qs.Commons

Rectangle {
  id: root
  default property alias content: contentColumn.data

  Layout.fillWidth: true
  implicitHeight: contentColumn.implicitHeight + 28
  radius: 4
  color: Qt.alpha(Color.foreground, 0.045)
  border.width: 1
  border.color: Qt.alpha(Color.foreground, 0.075)

  Rectangle {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 2
    radius: 2
    color: Color.accent
    opacity: 0.48
  }
  ColumnLayout {
    id: contentColumn
    x: 14
    y: 14
    width: Math.max(0, parent.width - 28)
    spacing: 10
  }
}
