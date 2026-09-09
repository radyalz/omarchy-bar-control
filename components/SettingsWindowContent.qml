import QtQuick
import QtQuick.Layouts
import "../pages"

Rectangle {
  id: root

  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)
  signal closeRequested()

  color: "#0f1115"

  RowLayout {
    anchors.fill: parent
    spacing: 0

    SettingsSidebar {
      Layout.preferredWidth: 220
      Layout.fillHeight: true
      pageNames: root.pageNames
      currentPage: root.currentPage
      service: root.service
      onPageSelected: function(index) { root.pageSelected(index) }
    }

    Rectangle {
      Layout.preferredWidth: 1
      Layout.fillHeight: true
      color: "#272b33"
    }

    StackLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      currentIndex: root.currentPage

      AutohidePage { service: root.service }
      PlacementPage { service: root.service }
      AnimationPage { service: root.service }
      CurvePage { service: root.service }
      AppearancePage { service: root.service }
      DiagnosticsPage { service: root.service }
      AboutPage { service: root.service }
      SupportPage { service: root.service }
    }
  }

  FocusScope {
    anchors.fill: parent
    focus: true
    Keys.onEscapePressed: root.closeRequested()
  }
}
