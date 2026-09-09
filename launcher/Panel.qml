import QtQuick
import qs.Commons
import qs.Ui

Panel {
  id: root

  moduleName: "radyalz.bar-control-launcher"
  ipcTarget: "radyalz.bar-control-launcher"
  manageIpc: false
  property string view: "main"

  function open() {
    view = "main"
    controller.show()
  }
  function close() {
    view = "main"
    controller.hide()
  }
  function toggle() {
    if (opened) close()
    else open()
  }

  property alias actions: actions

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  LauncherState { id: state }
  LauncherActions { id: actions; bar: root.bar; host: root }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "⚙"
    tooltipText: "Radyalz Bar Control"
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) root.toggle()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(330))
    contentHeight: panel.fittedContentHeight(contentLoader.item ? contentLoader.item.implicitHeight : Style.space(180))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()

      Loader {
        id: contentLoader
        anchors.fill: parent
        source: root.view === "animation" ? "QuickAnimation.qml"
          : root.view === "bar" ? "QuickBar.qml"
          : root.view === "about" ? "QuickAbout.qml" : "QuickMain.qml"
        onLoaded: { item.host = root; item.state = state }
      }
    }
  }
}
