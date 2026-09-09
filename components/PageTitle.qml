import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root
  property string title: ""
  property string description: ""
  Layout.fillWidth: true
  spacing: 6

  RowLayout {
    Layout.fillWidth: true
    spacing: 9
    Rectangle { width: 4; height: 24; radius: 2; color: "#91a7ff" }
    Text {
      text: root.title
      color: "#f7f8fc"
      font.pixelSize: 23
      font.weight: Font.DemiBold
    }
  }
  Text {
    Layout.fillWidth: true
    text: root.description
    color: "#9199a8"
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
