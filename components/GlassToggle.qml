import QtQuick

Item {
  id: root
  property bool checked: false
  property color accent: "#7f9cff"
  signal toggled(bool checked)

  implicitWidth: 44
  implicitHeight: 24

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: root.checked ? root.accent : Qt.rgba(1, 1, 1, 0.10)
    border.width: 1
    border.color: root.checked
      ? Qt.lighter(root.accent, 1.14) : Qt.rgba(1, 1, 1, 0.10)
    Behavior on color { ColorAnimation { duration: 140 } }
  }
  Rectangle {
    width: 18; height: 18; radius: 4; y: 3
    x: root.checked ? root.width - width - 3 : 3
    color: "white"
    opacity: root.enabled ? 1 : 0.55
    Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
  }
  MouseArea {
    anchors.fill: parent
    enabled: root.enabled
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggled(!root.checked)
  }
}
