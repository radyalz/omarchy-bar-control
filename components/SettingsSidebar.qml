import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root
  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)
  color: Qt.rgba(1, 1, 1, 0.018)

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 14
    spacing: 7
    ColumnLayout {
      Layout.fillWidth: true; spacing: 2
      Text { text: "Radyalz"; color: "#f5f7fc"; font.pixelSize: 17; font.weight: Font.DemiBold }
      Text { text: "BAR CONTROL"; color: "#75839c"; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1.4 }
    }
    Rectangle { Layout.fillWidth: true; height: 1; color: Qt.rgba(1, 1, 1, 0.07) }
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
    Rectangle { Layout.fillWidth: true; height: 1; color: Qt.rgba(1, 1, 1, 0.07) }
    RowLayout {
      Layout.fillWidth: true
      Rectangle { width: 7; height: 7; radius: 4; color: root.service && root.service.enabled ? "#76d39b" : "#697180" }
      Text {
        text: root.service && root.service.enabled ? "Autohide active" : "Autohide inactive"
        color: "#8792a4"; font.pixelSize: 10
      }
    }
  }
}
