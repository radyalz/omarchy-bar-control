import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

QQC.ScrollView {
  id: root

  default property alias content: contentColumn.data
  contentWidth: availableWidth

  ColumnLayout {
    id: contentColumn
    x: 26
    y: 26
    width: Math.max(0, root.availableWidth - 52)
    spacing: 16
  }
}
