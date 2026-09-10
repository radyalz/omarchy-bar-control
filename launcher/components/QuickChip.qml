import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string text: ""
  property bool active: false
  signal clicked()

  readonly property color fg: bar ? bar.foreground : Qt.rgba(1, 1, 1, 1)
  readonly property color accent: bar ? bar.accent : "#7c9cff"

  implicitWidth: label.implicitWidth + 22
  implicitHeight: 30
  radius: 4
  color: root.active
    ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.32)
    : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, mouse.containsMouse ? 0.1 : 0.055)
  border.width: 1
  border.color: root.active
    ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.7)
    : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.08)

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
