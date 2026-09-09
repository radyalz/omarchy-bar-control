import QtQuick
import QtQuick.Layouts

RowLayout {
  id: root
  default property alias control: controlSlot.data
  property string label: ""
  Layout.fillWidth: true
  spacing: 12

  Text {
    text: root.label
    color: "#cbd1dc"
    font.pixelSize: 12
  }
  Item { Layout.fillWidth: true }
  RowLayout { id: controlSlot; spacing: 8 }
}
