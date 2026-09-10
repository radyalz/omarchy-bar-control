import QtQuick
import qs.Commons

// Small square icon button with a hover tooltip. Used where a text button
// would be too bulky (e.g. a section's Reset control).
Rectangle {
  id: root
  property string icon: ""
  property string tooltip: ""
  signal clicked()

  implicitWidth: 24
  implicitHeight: 24
  radius: 4
  opacity: root.enabled ? 1 : 0.4
  color: Qt.alpha(Color.foreground, mouse.containsMouse ? 0.12 : 0.05)
  border.width: 1
  border.color: mouse.containsMouse ? Qt.alpha(Color.accent, 0.5) : Qt.alpha(Color.foreground, 0.1)
  Behavior on color { ColorAnimation { duration: 110 } }
  Behavior on border.color { ColorAnimation { duration: 110 } }

  Text {
    anchors.centerIn: parent
    text: root.icon
    color: mouse.containsMouse ? Color.foreground : Qt.alpha(Color.foreground, 0.85)
    font.pixelSize: 12
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    enabled: root.enabled
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }

  TooltipBubble {
    text: root.tooltip
    shown: mouse.containsMouse
  }
}
