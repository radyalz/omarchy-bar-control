import QtQuick
import "components"

Item {
  id: root

  readonly property string pluginId: "radyalz.bar-control"
  readonly property var pageNames: [
    "Autohide", "Placement", "Animation", "Curve",
    "Appearance", "Diagnostics", "About", "Support"
  ]

  property var shell: null
  property var service: null
  property bool closingFromHost: false
  property int currentPage: 0

  function open(payloadJson) {
    closingFromHost = false
    window.visible = true
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

  SettingsWindow {
    id: window
    pageNames: root.pageNames
    currentPage: root.currentPage
    service: root.service
    onPageSelected: function(index) { root.currentPage = index }
    onCloseRequested: root.requestClose()
    onVisibleChanged: {
      if (!visible && !root.closingFromHost
          && root.shell && typeof root.shell.hide === "function")
        root.shell.hide(root.pluginId)
    }
  }
}
