import QtQuick

Text {
  property var bar: null
  property string label: ""

  text: label.toUpperCase()
  color: bar
    ? Qt.rgba(bar.foreground.r, bar.foreground.g, bar.foreground.b, 0.46)
    : "#7f8793"
  font.family: bar ? bar.fontFamily : "monospace"
  font.pixelSize: 10
  font.bold: true
  font.letterSpacing: 1.1
}
