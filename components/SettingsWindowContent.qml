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
  border.color: Qt.alpha(Color.foreground, 0.12)

  readonly property color sep: Qt.alpha(Color.foreground, 0.09)

  // Original layout: one RowLayout. When the sidebar is collapsed the content
  // just gets top/bottom margin to clear the two strips, which are plain
  // anchored overlays outside the layout flow.
  RowLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.topMargin: root.sidebarCollapsed ? 39 : 0
    anchors.bottomMargin: root.sidebarCollapsed ? 29 : 0
    spacing: 0

    SettingsSidebar {
      Layout.preferredWidth: root.sidebarCollapsed ? 0 : 178
      Layout.fillHeight: true
      clip: true
      visible: Layout.preferredWidth > 2
      pageNames: root.pageNames
      currentPage: root.currentPage
      service: root.service
      onPageSelected: function(index) { root.pageSelected(index) }
      onCollapseRequested: root.sidebarCollapsed = true
      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
      }
    }
    Rectangle {
      Layout.preferredWidth: 1
      Layout.fillHeight: true
      visible: !root.sidebarCollapsed
      color: root.sep
    }
    StackLayout {
      id: stack
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: root.currentPage

      // Each page is built the first time it is opened, then kept. Opening the
      // window only pays for the first page.
      Loader {
        property bool seen: false
        active: stack.currentIndex === 0 || seen
        onActiveChanged: if (active) seen = true
        sourceComponent: Component { AutohidePage { service: root.service } }
      }
      Loader {
        property bool seen: false
        active: stack.currentIndex === 1 || seen
        onActiveChanged: if (active) seen = true
        sourceComponent: Component { BarPage { service: root.service } }
      }
      Loader {
        property bool seen: false
        active: stack.currentIndex === 2 || seen
        onActiveChanged: if (active) seen = true
        sourceComponent: Component { DiagnosticsPage { service: root.service } }
      }
      Loader {
        property bool seen: false
        active: stack.currentIndex === 3 || seen
        onActiveChanged: if (active) seen = true
        sourceComponent: Component { AboutSupportPage { service: root.service } }
      }
    }
  }

  // Collapsed: slim top strip.
  Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 38
    visible: root.sidebarCollapsed

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 8
      anchors.rightMargin: 8
      spacing: 8
      IconButton {
        Layout.alignment: Qt.AlignVCenter
        icon: "☰"
        tooltip: "Show sidebar"
        onClicked: root.sidebarCollapsed = false
      }
      Text {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        text: "Bar Control"
        color: Color.foreground
        font.pixelSize: 14
        font.weight: Font.DemiBold
        elide: Text.ElideRight
      }
      IconButton {
        Layout.alignment: Qt.AlignVCenter
        icon: "✕"
        tooltip: "Close"
        onClicked: root.closeRequested()
      }
    }
    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: 1
      color: root.sep
    }
  }

  // Collapsed: slim bottom strip.
  Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 28
    visible: root.sidebarCollapsed

    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      height: 1
      color: root.sep
    }
    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 14
      anchors.rightMargin: 14
      spacing: 8
      Rectangle {
        Layout.alignment: Qt.AlignVCenter
        width: 7
        height: 7
        radius: 4
        color: root.service && root.service.enabled ? "#76d39b" : Qt.alpha(Color.foreground, 0.4)
      }
      Text {
        Layout.alignment: Qt.AlignVCenter
        text: root.service && root.service.enabled ? "Autohide active" : "Autohide inactive"
        color: Qt.alpha(Color.foreground, 0.6)
        font.pixelSize: 10
      }
      Item { Layout.fillWidth: true }
      Text {
        Layout.alignment: Qt.AlignVCenter
        text: "© 2026 Radyalz"
        color: Qt.alpha(Color.foreground, 0.45)
        font.pixelSize: 10
      }
    }
  }

  // Expanded: the close control floats in the top-right corner.
  IconButton {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 10
    anchors.rightMargin: 10
    visible: !root.sidebarCollapsed
    icon: "✕"
    tooltip: "Close"
    onClicked: root.closeRequested()
  }

  FocusScope { anchors.fill: parent; focus: true; Keys.onEscapePressed: root.closeRequested() }
}
