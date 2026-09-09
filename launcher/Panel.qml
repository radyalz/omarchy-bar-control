import QtQuick
import qs.Commons
import qs.Ui

Panel {
  id: root

  moduleName: "radyalz.bar-control-launcher"
  ipcTarget: "radyalz.bar-control-launcher"
  property string view: "main"

  function callControl(method, value) {
    if (!bar) return
    var command = "omarchy-shell radyalz.bar-control " + method
    if (value !== undefined) command += " " + bar.shellQuote(String(value))
    bar.run(command)
  }
  function openAdvanced(page) {
    if (!bar) return
    close()
    var payload = JSON.stringify({ page: page })
    bar.run("omarchy-shell shell summon radyalz.bar-control " + bar.shellQuote(payload))
  }
  function openUrl(url) {
    if (bar) bar.run("xdg-open " + bar.shellQuote(url))
  }

  onOpenedChanged: if (!opened) view = "main"
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  LauncherState { id: state }

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
