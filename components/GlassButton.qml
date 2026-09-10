import QtQuick
import QtQuick.Layouts
import qs.Commons

Rectangle {
  id: root
  property string text: ""
  property bool primary: false
  signal clicked()

  implicitWidth: label.implicitWidth + 28
  implicitHeight: 36
  radius: 4
  color: root.primary
    ? Qt.alpha(Color.accent, mouse.containsMouse ? 0.42 : 0.28)
    : Qt.alpha(Color.foreground, mouse.containsMouse ? 0.12 : 0.06)
  border.width: 1
  border.color: root.primary
    ? Qt.alpha(Color.accent, 0.6)
    : Qt.alpha(Color.foreground, 0.12)
  opacity: root.enabled ? 1 : 0.45

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: Color.foreground
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
