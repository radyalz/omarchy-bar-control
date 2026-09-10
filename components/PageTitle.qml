import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: root
  property string title: ""
  property string description: ""
  Layout.fillWidth: true
  spacing: 6

  RowLayout {
    Layout.fillWidth: true
    spacing: 9
    Rectangle { width: 4; height: 24; radius: 2; color: Color.accent }
    Text {
      text: root.title
      color: Color.foreground
      font.pixelSize: 23
      font.weight: Font.DemiBold
    }
  }
  Text {
    Layout.fillWidth: true
    text: root.description
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
