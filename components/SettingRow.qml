import QtQuick
import QtQuick.Layouts

RowLayout {
  id: root

  default property alias control: controlSlot.data
  property string label: ""

  Layout.fillWidth: true

  Text {
    text: root.label
    color: "#d1d5db"
    font.pixelSize: 13
  }

  Item { Layout.fillWidth: true }

  RowLayout {
    id: controlSlot
    spacing: 8
  }
}
