import QtQuick
import qs.Commons

Text {
  property string label: ""
  text: label.toUpperCase()
  color: Qt.alpha(Color.foreground, 0.55)
  font.pixelSize: 10
  font.weight: Font.Bold
  font.letterSpacing: 1.2
  topPadding: 8
}
