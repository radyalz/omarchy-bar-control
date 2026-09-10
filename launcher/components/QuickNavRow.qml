import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string title: ""
  property string subtitle: ""
  property string badge: ""
  signal clicked()

  readonly property color fg: bar ? bar.foreground : Qt.rgba(1, 1, 1, 1)
  readonly property color accent: bar ? bar.accent : "#7c9cff"

  width: parent ? parent.width : 300
  implicitHeight: 54
  radius: 4
  color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, mouse.containsMouse ? 0.1 : 0.045)
  border.width: 1
  border.color: mouse.containsMouse
    ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.34)
    : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.07)

  Column {
    anchors.left: parent.left
    anchors.right: tail.left
    anchors.leftMargin: 13
    anchors.rightMargin: 10
    anchors.verticalCenter: parent.verticalCenter
    spacing: 2
    Text {
      text: root.title
      color: root.bar ? root.bar.foreground : "white"
      font.family: root.bar ? root.bar.fontFamily : "monospace"
      font.pixelSize: 13
      font.bold: true
    }
    Text {
      width: parent.width
      text: root.subtitle
      color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.5)
      font.family: root.bar ? root.bar.fontFamily : "monospace"
      font.pixelSize: 10
      elide: Text.ElideRight
    }
  }

  Text {
    id: tail
    anchors.right: parent.right
    anchors.rightMargin: 13
    anchors.verticalCenter: parent.verticalCenter
    text: root.badge !== "" ? root.badge + "  ›" : "›"
    color: root.accent
    font.pixelSize: 13
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
