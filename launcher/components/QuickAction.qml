import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string text: ""
  property bool primary: false
  signal clicked()

  readonly property color fg: bar ? bar.foreground : Qt.rgba(1, 1, 1, 1)
  readonly property color accent: bar ? bar.accent : "#7c9cff"

  width: parent ? parent.width : 300
  implicitHeight: 38
  radius: 4
  color: root.primary
    ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, mouse.containsMouse ? 0.44 : 0.3)
    : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, mouse.containsMouse ? 0.1 : 0.055)
  border.width: 1
  border.color: root.primary
    ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.62)
    : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.08)

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
