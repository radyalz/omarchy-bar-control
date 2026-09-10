import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

QQC.ScrollView {
  id: root

  default property alias content: contentColumn.data
  contentWidth: availableWidth

  // Padding rather than a manual x/y offset so the scrollable area includes
  // the trailing gap and the last section clears the window edge.
  topPadding: 22
  leftPadding: 22
  rightPadding: 22
  bottomPadding: 44

  ColumnLayout {
    id: contentColumn
    width: Math.max(0, root.availableWidth)
    spacing: 14
  }
}
