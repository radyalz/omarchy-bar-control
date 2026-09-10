import QtQuick

Rectangle {
  id: root

  property var bar: null
  property string title: ""
  property string subtitle: ""
  property bool checked: false
  signal toggled(bool checked)

  width: parent ? parent.width : 300
  implicitHeight: 58
  radius: 6
  color: Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.095 : 0.06)
  border.width: 1
  border.color: Qt.rgba(1, 1, 1, 0.08)

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
      color: root.bar
        ? Qt.rgba(root.bar.foreground.r, root.bar.foreground.g,
            root.bar.foreground.b, 0.52) : "#8b93a0"
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
    checked: root.checked
    onToggled: function(value) { root.toggled(value) }
  }

  MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; acceptedButtons: Qt.NoButton }
}
