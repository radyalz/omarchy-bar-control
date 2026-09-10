import QtQuick
import QtQuick.Controls as QQC

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
  color: mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(1, 1, 1, 0.045)
  border.width: 1
  border.color: Qt.rgba(1, 1, 1, 0.09)

  Text {
    anchors.centerIn: parent
    text: root.icon
    color: "#dfe3ec"
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

  QQC.ToolTip {
    parent: root
    visible: root.tooltip !== "" && mouse.containsMouse
    text: root.tooltip
    delay: 350
  }
}
