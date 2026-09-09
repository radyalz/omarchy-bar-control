import Quickshell
import qs.Ui

FloatingWindow {
  id: root

  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)
  signal closeRequested()

  visible: false
  implicitWidth: 820
  implicitHeight: 620
  color: "transparent"

  SettingsWindowContent {
    anchors.fill: parent
    pageNames: root.pageNames
    currentPage: root.currentPage
    service: root.service
    onPageSelected: function(index) { root.pageSelected(index) }
    onCloseRequested: root.closeRequested()
  }
}
