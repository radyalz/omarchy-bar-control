import QtQuick

Text {
  property string label: ""
  text: label.toUpperCase()
  color: "#7f8ba1"
  font.pixelSize: 10
  font.weight: Font.Bold
  font.letterSpacing: 1.2
  topPadding: 8
}
