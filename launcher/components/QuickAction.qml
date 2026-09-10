import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string text: ""
  property bool primary: false
  signal clicked()

  width: parent ? parent.width : 300
  implicitHeight: 38
  radius: 4
  color: root.primary
    ? Qt.rgba(0.38, 0.52, 1, mouse.containsMouse ? 0.46 : 0.34)
    : Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.10 : 0.055)
  border.width: 1
  border.color: root.primary
    ? Qt.rgba(0.55, 0.66, 1, 0.68)
    : Qt.rgba(1, 1, 1, 0.08)

  Text {
    anchors.centerIn: parent
    text: root.text
    color: root.bar ? root.bar.foreground : "white"
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 11
    font.bold: root.primary
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
