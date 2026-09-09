import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root

  property string title: ""
  property string description: ""

  Layout.fillWidth: true
  spacing: 5

  Text {
    text: root.title
    color: "#f3f4f6"
    font.pixelSize: 26
    font.weight: Font.DemiBold
  }

  Text {
    Layout.fillWidth: true
    text: root.description
    color: "#9ca3af"
    font.pixelSize: 13
    wrapMode: Text.WordWrap
  }
}
