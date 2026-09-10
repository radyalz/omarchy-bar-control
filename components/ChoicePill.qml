import QtQuick

Rectangle {
  id: root
  property string text: ""
  property bool active: false
  signal clicked()

  implicitWidth: label.implicitWidth + 22
  implicitHeight: 31
  radius: 6
  color: root.active
    ? Qt.rgba(0.38, 0.52, 1, 0.34)
    : Qt.rgba(1, 1, 1, mouse.containsMouse ? 0.095 : 0.045)
  border.width: 1
  border.color: root.active
    ? Qt.rgba(0.56, 0.67, 1, 0.70)
    : Qt.rgba(1, 1, 1, 0.08)

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: root.active ? "#f7f9ff" : "#cbd1dc"
    font.pixelSize: 11
    font.weight: root.active ? Font.DemiBold : Font.Normal
  }
  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
