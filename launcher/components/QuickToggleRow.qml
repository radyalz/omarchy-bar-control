import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string title: ""
  property string subtitle: ""
  property bool checked: false
  signal toggled(bool checked)

  readonly property color fg: bar ? bar.foreground : Qt.rgba(1, 1, 1, 1)

  width: parent ? parent.width : 300
  implicitHeight: 58
  radius: 4
  color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, mouse.containsMouse ? 0.095 : 0.06)
  border.width: 1
  border.color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.08)

  Column {
    anchors.left: parent.left
    anchors.right: toggle.left
    anchors.leftMargin: 13
    anchors.rightMargin: 12
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
      color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.52)
      font.family: root.bar ? root.bar.fontFamily : "monospace"
      font.pixelSize: 10
      elide: Text.ElideRight
    }
  }

  QuickToggle {
    id: toggle
    anchors.right: parent.right
    anchors.rightMargin: 12
    anchors.verticalCenter: parent.verticalCenter
    bar: root.bar
    checked: root.checked
    onToggled: function(value) { root.toggled(value) }
  }

  MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; acceptedButtons: Qt.NoButton }
}
