import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  default property alias content: contentColumn.data

  Layout.fillWidth: true
  implicitHeight: contentColumn.implicitHeight + 28
  radius: 12
  color: "#171a20"
  border.width: 1
  border.color: "#2d323b"

  ColumnLayout {
    id: contentColumn
    x: 14
    y: 14
    width: Math.max(0, parent.width - 28)
    spacing: 10
  }
}
