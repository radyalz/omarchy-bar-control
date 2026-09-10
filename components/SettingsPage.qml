import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons

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

  QQC.ScrollBar.vertical: QQC.ScrollBar {
    id: vbar
    parent: root
    x: root.width - width
    y: 0
    height: root.height
    width: 12
    policy: size < 1 ? QQC.ScrollBar.AlwaysOn : QQC.ScrollBar.AsNeeded
    padding: 3

    contentItem: Rectangle {
      implicitWidth: 6
      radius: 3
      color: vbar.pressed
        ? Color.accent
        : (vbar.hovered ? Qt.alpha(Color.accent, 0.75) : Qt.alpha(Color.foreground, 0.32))
      opacity: vbar.active || vbar.policy === QQC.ScrollBar.AlwaysOn ? 1 : 0.6
      Behavior on color { ColorAnimation { duration: 120 } }
      Behavior on opacity { NumberAnimation { duration: 120 } }
    }
    background: Rectangle {
      color: Qt.alpha(Color.foreground, 0.06)
      radius: 3
    }
  }

  ColumnLayout {
    id: contentColumn
    width: Math.max(0, root.availableWidth)
    spacing: 14
  }
}
