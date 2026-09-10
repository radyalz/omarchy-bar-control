import QtQuick
import QtQuick.Layouts

// Collapsible group. Header shows the title and, while collapsed, a short
// summary of the current values; the body holds whatever is declared inside.
// Collapsed by default so the page opens as a short list of presets and
// section headers.
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
    color: headerMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.055) : Qt.rgba(1, 1, 1, 0.03)
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.07)

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
        text: root.expanded ? "▾" : "▸"
        color: "#9aa3b2"
        font.pixelSize: 10
      }
      Text {
        text: root.title
        color: "#e9edf5"
        font.pixelSize: 13
        font.weight: Font.DemiBold
      }
      Item { Layout.fillWidth: true }
      Text {
        visible: root.summary !== "" && !root.expanded
        text: root.summary
        color: "#818a99"
        font.pixelSize: 11
        elide: Text.ElideRight
        Layout.maximumWidth: 240
      }
      GlassButton {
        visible: root.resettable && root.expanded
        text: "Reset"
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
    visible: root.expanded
    spacing: 12
  }
}
