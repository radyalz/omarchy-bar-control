import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root
  property string text: ""
  property bool primary: false
  signal clicked()

  implicitWidth: label.implicitWidth + 28
  implicitHeight: 36
  radius: 10
  color: root.primary
    ? Qt.rgba(0.38, 0.52, 1, mouse.containsMouse ? 0.48 : 0.34)
    : Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.10 : 0.055)
  border.width: 1
  border.color: root.primary
    ? Qt.rgba(0.56, 0.67, 1, 0.66)
    : Qt.rgba(1, 1, 1, 0.09)
  opacity: root.enabled ? 1 : 0.45

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: "#f5f7ff"
    font.pixelSize: 12
    font.weight: root.primary ? Font.DemiBold : Font.Medium
  }
  MouseArea {
    id: mouse
    anchors.fill: parent
    enabled: root.enabled
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
