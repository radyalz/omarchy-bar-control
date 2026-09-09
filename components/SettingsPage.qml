import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

QQC.ScrollView {
  id: root

  default property alias content: contentColumn.data
  contentWidth: availableWidth

  ColumnLayout {
    id: contentColumn
    x: 22
    y: 22
    width: Math.max(0, root.availableWidth - 44)
    spacing: 14
  }
}
