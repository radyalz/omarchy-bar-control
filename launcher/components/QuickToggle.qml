import QtQuick

Item {
  id: root

  property bool checked: false
  property color accent: "#7c9cff"
  signal toggled(bool checked)

  implicitWidth: 42
  implicitHeight: 23

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: root.checked
      ? root.accent
      : Qt.rgba(1, 1, 1, 0.12)
    border.width: 1
    border.color: root.checked
      ? Qt.lighter(root.accent, 1.12)
      : Qt.rgba(1, 1, 1, 0.12)

    Behavior on color { ColorAnimation { duration: 130 } }
  }

  Rectangle {
    width: 17
    height: 17
    radius: width / 2
    y: 3
    x: root.checked ? root.width - width - 3 : 3
    color: "#ffffff"
    opacity: root.enabled ? 1 : 0.55
    Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    enabled: root.enabled
    onClicked: root.toggled(!root.checked)
  }
}
