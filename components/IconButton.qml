import QtQuick
import qs.Commons
import qs.Ui

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
  border.color: Qt.alpha(Color.foreground, 0.1)

  Text {
    anchors.centerIn: parent
    text: root.icon
    color: Qt.alpha(Color.foreground, 0.85)
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

  PanelToolTip {
    visible: root.tooltip !== "" && mouse.containsMouse
    text: root.tooltip
    delay: 350
  }
}
