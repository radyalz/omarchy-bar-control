import QtQuick
import QtQuick.Layouts
import qs.Commons
import "../pages"

Rectangle {
  id: root
  property var pageNames: []
  property int currentPage: 0
  property var service: null
  property bool sidebarCollapsed: false
  signal pageSelected(int index)
  signal closeRequested()

  radius: 4
  clip: true
  color: Qt.rgba(Color.background.r, Color.background.g, Color.background.b, 0.91)
  border.width: 1
  border.color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.12)

  RowLayout {
    anchors.fill: parent; spacing: 0

    SettingsSidebar {
      Layout.preferredWidth: root.sidebarCollapsed ? 0 : 178
      Layout.fillHeight: true
      clip: true
      visible: Layout.preferredWidth > 2
      pageNames: root.pageNames; currentPage: root.currentPage; service: root.service
      onPageSelected: function(index) { root.pageSelected(index) }
      onCollapseRequested: root.sidebarCollapsed = true
      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
      }
    }
    Rectangle {
      Layout.preferredWidth: 1; Layout.fillHeight: true
      visible: !root.sidebarCollapsed
      color: Qt.rgba(1, 1, 1, 0.065)
    }
    StackLayout {
      Layout.fillWidth: true; Layout.fillHeight: true; currentIndex: root.currentPage
      AutohidePage { service: root.service }
      BarPage { service: root.service }
      DiagnosticsPage { service: root.service }
      AboutSupportPage { service: root.service }
    }
  }

  IconButton {
    anchors.top: parent.top; anchors.left: parent.left
    anchors.topMargin: 10; anchors.leftMargin: 10
    visible: root.sidebarCollapsed
    icon: "☰"
    tooltip: "Show sidebar"
    onClicked: root.sidebarCollapsed = false
  }

  IconButton {
    anchors.top: parent.top; anchors.right: parent.right
    anchors.topMargin: 10; anchors.rightMargin: 10
    icon: "✕"
    tooltip: "Close"
    onClicked: root.closeRequested()
  }
  FocusScope { anchors.fill: parent; focus: true; Keys.onEscapePressed: root.closeRequested() }
}
