import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Ui
import "components"
import "pages"

Item {
  id: root

  readonly property string pluginId: "radyalz.bar-control"
  readonly property var pageNames: [
    "Autohide",
    "Placement",
    "Animation",
    "Curve",
    "Appearance",
    "Diagnostics",
    "About",
    "Support"
  ]

  property var shell: null
  property var service: null
  property bool closingFromHost: false
  property int currentPage: 0

  function open(payloadJson) {
    closingFromHost = false
    window.visible = true
    focusScope.forceActiveFocus()
  }

  function close() {
    closingFromHost = true
    window.visible = false
    closingFromHost = false
  }

  function requestClose() {
    window.visible = false
    if (shell && typeof shell.hide === "function")
      shell.hide(root.pluginId)
  }

  FloatingWindow {
    id: window

    visible: false
    implicitWidth: 1040
    implicitHeight: 700
    color: "transparent"

    onVisibleChanged: {
      if (!visible && !root.closingFromHost
          && root.shell && typeof root.shell.hide === "function")
        root.shell.hide(root.pluginId)
    }

    Rectangle {
      anchors.fill: parent
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
          onPageSelected: function(index) { root.currentPage = index }
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
        id: focusScope
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.requestClose()
      }
    }
  }
}
