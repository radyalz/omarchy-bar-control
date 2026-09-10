import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string title: ""
  property string subtitle: ""
  property string badge: ""
  signal clicked()

  width: parent ? parent.width : 300
  implicitHeight: 54
  radius: 4
  color: Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.10 : 0.045)
  border.width: 1
  border.color: mouse.containsMouse
    ? Qt.rgba(0.49, 0.61, 1, 0.34)
    : Qt.rgba(1, 1, 1, 0.07)

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
      color: root.bar
        ? Qt.rgba(root.bar.foreground.r, root.bar.foreground.g,
            root.bar.foreground.b, 0.50) : "#8b93a0"
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
    color: "#91a7ff"
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
