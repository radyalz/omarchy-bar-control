import QtQuick
import QtQuick.Layouts
import qs.Commons

RowLayout {
  id: root
  default property alias control: controlSlot.data
  property string label: ""
  Layout.fillWidth: true
  spacing: 12

  Text {
    text: root.label
    color: Qt.alpha(Color.foreground, 0.85)
    font.pixelSize: 12
  }
  Item { Layout.fillWidth: true }
  RowLayout { id: controlSlot; spacing: 8 }
}
