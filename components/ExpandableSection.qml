import QtQuick
import QtQuick.Layouts
import qs.Commons

// Collapsible group. Header shows the title and, while collapsed, a short
// summary of the current values; the body holds whatever is declared inside.
// Collapsed by default so the page opens as a short list of presets and
// section headers. The body animates its height + fades.
ColumnLayout {
  id: root

  property string title: ""
  property string summary: ""
  property bool expanded: false
  property bool resettable: false
  signal resetRequested()

  // Keep `body` a DIRECT child of this ColumnLayout: the default-property alias
  // and the layout both depend on that. Do not wrap it in another Item.
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

  ColumnLayout {
    id: body
    Layout.fillWidth: true
    Layout.leftMargin: 4
    Layout.rightMargin: 4
    Layout.topMargin: root.expanded ? 10 : 0
    Layout.bottomMargin: root.expanded ? 6 : 0
    // Animate the height between 0 and the natural content height; clip so the
    // content is hidden while collapsing. maximumHeight pins it so the parent
    // layout does not stretch it back.
    Layout.preferredHeight: root.expanded ? body.implicitHeight : 0
    Layout.maximumHeight: root.expanded ? body.implicitHeight : 0
    clip: true
    opacity: root.expanded ? 1 : 0
    spacing: 12
    Behavior on Layout.preferredHeight {
      NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
    }
    Behavior on Layout.maximumHeight {
      NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
    }
    Behavior on opacity { NumberAnimation { duration: 130 } }
  }
}
