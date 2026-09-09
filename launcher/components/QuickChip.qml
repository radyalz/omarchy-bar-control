import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string text: ""
  property bool active: false
  signal clicked()

  implicitWidth: label.implicitWidth + 22
  implicitHeight: 30
  radius: height / 2
  color: root.active
    ? Qt.rgba(0.38, 0.52, 1, 0.34)
    : Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.10 : 0.055)
  border.width: 1
  border.color: root.active
    ? Qt.rgba(0.55, 0.66, 1, 0.70)
    : Qt.rgba(1, 1, 1, 0.08)

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: root.bar ? root.bar.foreground : "white"
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 11
    font.bold: root.active
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
