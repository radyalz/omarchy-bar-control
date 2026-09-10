import QtQuick

Item {
  id: root

  property var bar: null
  property bool checked: false
  property color accent: bar ? bar.accent : "#7c9cff"
  readonly property color fg: bar ? bar.foreground : "#ffffff"
  signal toggled(bool checked)

  implicitWidth: 42
  implicitHeight: 23

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: root.checked
      ? root.accent
      : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.12)
    border.width: 1
    border.color: root.checked
      ? Qt.lighter(root.accent, 1.12)
      : Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.12)

    Behavior on color { ColorAnimation { duration: 130 } }
  }

  Rectangle {
    width: 17
    height: 17
    radius: 4
    y: 3
    x: root.checked ? root.width - width - 3 : 3
    color: root.fg
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
