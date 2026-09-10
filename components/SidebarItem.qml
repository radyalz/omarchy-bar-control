import QtQuick
import QtQuick.Layouts
import qs.Commons

Rectangle {
  id: root
  property string text: ""
  property bool active: false
  signal clicked()

  Layout.fillWidth: true
  implicitHeight: 42
  radius: 4
  color: root.active
    ? Qt.alpha(Color.accent, 0.18)
    : Qt.alpha(Color.foreground, mouse.containsMouse ? 0.055 : 0)
  border.width: 1
  border.color: root.active ? Qt.alpha(Color.accent, 0.3) : "transparent"

  Rectangle {
    width: 3
    height: 18
    radius: 2
    anchors.left: parent.left
    anchors.leftMargin: 7
    anchors.verticalCenter: parent.verticalCenter
    color: Color.accent
    opacity: root.active ? 1 : 0
  }
  Text {
    anchors.left: parent.left
    anchors.leftMargin: 18
    anchors.right: parent.right
    anchors.rightMargin: 10
    anchors.verticalCenter: parent.verticalCenter
    text: root.text
    color: root.active ? Color.foreground : Qt.alpha(Color.foreground, 0.68)
    font.pixelSize: 12
    font.weight: root.active ? Font.DemiBold : Font.Normal
    elide: Text.ElideRight
  }
  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
