import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root
  property string text: ""
  property bool active: false
  signal clicked()

  Layout.fillWidth: true
  implicitHeight: 42
  radius: 11
  color: root.active
    ? Qt.rgba(0.38, 0.52, 1, 0.18)
    : Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.055 : 0)
  border.width: 1
  border.color: root.active
    ? Qt.rgba(0.56, 0.67, 1, 0.28) : "transparent"

  Rectangle {
    width: 3
    height: 18
    radius: 2
    anchors.left: parent.left
    anchors.leftMargin: 7
    anchors.verticalCenter: parent.verticalCenter
    color: "#91a7ff"
    opacity: root.active ? 1 : 0
  }
  Text {
    anchors.left: parent.left
    anchors.leftMargin: 18
    anchors.right: parent.right
    anchors.rightMargin: 10
    anchors.verticalCenter: parent.verticalCenter
    text: root.text
    color: root.active ? "#f5f7ff" : "#aeb6c4"
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
