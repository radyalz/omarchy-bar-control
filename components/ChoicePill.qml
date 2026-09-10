import QtQuick
import qs.Commons

Rectangle {
  id: root
  property string text: ""
  property bool active: false
  signal clicked()

  implicitWidth: label.implicitWidth + 22
  implicitHeight: 31
  radius: 4
  opacity: root.enabled ? 1 : 0.38
  color: root.active
    ? Qt.alpha(Color.accent, 0.30)
    : Qt.alpha(Color.foreground, mouse.containsMouse ? 0.10 : 0.05)
  border.width: 1
  border.color: root.active
    ? Qt.alpha(Color.accent, 0.7)
    : Qt.alpha(Color.foreground, 0.09)

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: root.active ? Color.foreground : Qt.alpha(Color.foreground, 0.8)
    font.pixelSize: 11
    font.weight: root.active ? Font.DemiBold : Font.Normal
  }
  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
