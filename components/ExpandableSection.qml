import QtQuick
import QtQuick.Layouts
import qs.Commons

// Collapsible group. Header shows the title and, while collapsed, a short
// summary of the current values; the body holds whatever is declared inside.
// Collapsed by default so the page opens as a short list of presets and
// section headers. The body slides + fades open.
ColumnLayout {
  id: root

  property string title: ""
  property string summary: ""
  property bool expanded: false
  property bool resettable: false
  signal resetRequested()

  default property alias content: body.data

  Layout.fillWidth: true
  spacing: 0

  Rectangle {
    Layout.fillWidth: true
    implicitHeight: 38
    radius: 4
    color: headerMouse.containsMouse
      ? Qt.alpha(Color.foreground, 0.06) : Qt.alpha(Color.foreground, 0.03)
    border.width: 1
    border.color: Qt.alpha(Color.foreground, 0.08)
    Behavior on color { ColorAnimation { duration: 110 } }

    // Declared first so the header controls below render on top and take their
    // own clicks; the plain Text items do not consume events, so clicks on the
    // rest of the header fall through to here.
    MouseArea {
      id: headerMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.expanded = !root.expanded
    }

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 11
      anchors.rightMargin: 8
      spacing: 8

      Text {
        text: "▸"
        rotation: root.expanded ? 90 : 0
        color: Qt.alpha(Color.foreground, 0.65)
        font.pixelSize: 10
        Behavior on rotation { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
      }
      Text {
        text: root.title
        color: Color.foreground
        font.pixelSize: 13
        font.weight: Font.DemiBold
      }
      Item { Layout.fillWidth: true }
      Text {
        visible: root.summary !== "" && !root.expanded
        text: root.summary
        color: Qt.alpha(Color.foreground, 0.55)
        font.pixelSize: 11
        elide: Text.ElideRight
        Layout.maximumWidth: 240
      }
      IconButton {
        visible: root.resettable && root.expanded
        icon: "↺"
        tooltip: "Reset this section"
        onClicked: root.resetRequested()
      }
    }
  }

  Item {
    id: bodyClip
    Layout.fillWidth: true
    Layout.preferredHeight: root.expanded ? body.implicitHeight + 16 : 0
    clip: true
    opacity: root.expanded ? 1 : 0
    Behavior on Layout.preferredHeight {
      NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
    }
    Behavior on opacity { NumberAnimation { duration: 130 } }

    ColumnLayout {
      id: body
      x: 4
      y: root.expanded ? 10 : 2
      width: bodyClip.width - 8
      spacing: 12
      Behavior on y { NumberAnimation { duration: 170; easing.type: Easing.OutCubic } }
    }
  }
}
