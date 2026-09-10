import QtQuick
import QtQuick.Layouts
import qs.Commons

Rectangle {
  id: root
  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)
  signal collapseRequested()
  color: Qt.alpha(Color.foreground, 0.018)

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 14
    spacing: 7
    RowLayout {
      Layout.fillWidth: true
      spacing: 8
      IconButton {
        icon: "☰"
        tooltip: "Hide sidebar"
        onClicked: root.collapseRequested()
      }
      Text {
        Layout.fillWidth: true
        text: "Bar Control"
        color: Color.foreground
        font.pixelSize: 15
        font.weight: Font.DemiBold
        elide: Text.ElideRight
      }
    }
    Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Color.foreground, 0.07) }
    Repeater {
      model: root.pageNames
      SidebarItem {
        required property string modelData
        required property int index
        text: modelData; active: root.currentPage === index
        onClicked: root.pageSelected(index)
      }
    }
    Item { Layout.fillHeight: true }
    Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Color.foreground, 0.07) }
    RowLayout {
      Layout.fillWidth: true
      Rectangle { width: 7; height: 7; radius: 4; color: root.service && root.service.enabled ? "#76d39b" : Qt.alpha(Color.foreground, 0.4) }
      Text {
        text: root.service && root.service.enabled ? "Autohide active" : "Autohide inactive"
        color: Qt.alpha(Color.foreground, 0.6); font.pixelSize: 10
      }
    }
    Rectangle { Layout.fillWidth: true; height: 1; color: Qt.alpha(Color.foreground, 0.07) }
    Text {
      Layout.fillWidth: true
      text: "© 2026 Radyalz"
      color: Qt.alpha(Color.foreground, 0.4)
      font.pixelSize: 10
      elide: Text.ElideRight
    }
  }
}
