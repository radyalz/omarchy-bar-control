import QtQuick

Column {
  id: root

  property var bar: null
  property string title: ""
  property string subtitle: ""
  spacing: 3

  Text {
    text: root.title
    color: root.bar ? root.bar.foreground : "white"
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 17
    font.bold: true
  }

  Text {
    width: parent.width
    text: root.subtitle
    color: root.bar
      ? Qt.rgba(root.bar.foreground.r, root.bar.foreground.g,
          root.bar.foreground.b, 0.58)
      : "#9ca3af"
    font.family: root.bar ? root.bar.fontFamily : "monospace"
    font.pixelSize: 11
    wrapMode: Text.WordWrap
  }
}
