import QtQuick
import "components"

Column {
  id: root
  property var host: null
  property var state: null
  spacing: 9

  QuickNavRow {
    bar: root.host ? root.host.bar : null; title: "‹  About & support"
    subtitle: "Back to quick controls"; onClicked: root.host.view = "main"
  }
  QuickHeader {
    width: parent.width; bar: root.host ? root.host.bar : null
    title: "Radyalz Bar Control"; subtitle: "v0.2.3 · Radman Alizadeh (Radyalz) · MIT"
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "Open GitHub"
    onClicked: root.host.openUrl("https://github.com/radyalz/omarchy-bar-control")
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "Report an issue"
    onClicked: root.host.openUrl("https://github.com/radyalz/omarchy-bar-control/issues")
  }
  QuickAction {
    bar: root.host ? root.host.bar : null; text: "Diagnostics & project info"; primary: true
    onClicked: root.host.openAdvanced(2)
  }
}
