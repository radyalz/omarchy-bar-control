import QtQuick
import QtQuick.Layouts
import qs.Commons
import "../pages"

Rectangle {
  id: root
  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)
  signal closeRequested()

  radius: 20
  clip: true
  color: Qt.rgba(Color.background.r, Color.background.g, Color.background.b, 0.91)
  border.width: 1
  border.color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.12)

  RowLayout {
    anchors.fill: parent; spacing: 0
    SettingsSidebar {
      Layout.preferredWidth: 178; Layout.fillHeight: true
      pageNames: root.pageNames; currentPage: root.currentPage; service: root.service
      onPageSelected: function(index) { root.pageSelected(index) }
    }
    Rectangle { Layout.preferredWidth: 1; Layout.fillHeight: true; color: Qt.rgba(1, 1, 1, 0.065) }
    StackLayout {
      Layout.fillWidth: true; Layout.fillHeight: true; currentIndex: root.currentPage
      AutohidePage { service: root.service }
      BarPage { service: root.service }
      DiagnosticsPage { service: root.service }
      AboutSupportPage { service: root.service }
    }
  }
  GlassButton {
    anchors.top: parent.top; anchors.right: parent.right
    anchors.topMargin: 12; anchors.rightMargin: 12
    text: "×"; onClicked: root.closeRequested()
  }
  FocusScope { anchors.fill: parent; focus: true; Keys.onEscapePressed: root.closeRequested() }
}
