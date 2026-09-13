import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Diagnostics"
    description: "Checks that the bar, its settings and autohide are all working. Look for updates on the Updates page."
  }
  PluginHealthCard { service: root.service }
  SectionLabel { label: "Full report" }
  Text {
    Layout.fillWidth: true
    text: "Copy this and paste it into a GitHub issue if you're reporting a problem — it has your versions and current settings, nothing personal."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 11
    wrapMode: Text.WordWrap
  }
  QQC.TextArea {
    Layout.fillWidth: true
    // Grow with the window instead of sitting in a fixed short box.
    Layout.preferredHeight: Math.max(260, root.availableHeight - 300)
    readOnly: true
    wrapMode: TextEdit.NoWrap
    color: Color.foreground
    selectionColor: Qt.alpha(Color.accent, 0.5)
    font.family: "monospace"
    text: root.service ? root.service.diagnosticReport() : "Radyalz Bar Control service is not available."
    background: Rectangle {
      radius: 4
      color: Qt.alpha(Color.foreground, 0.04)
      border.width: 1
      border.color: Qt.alpha(Color.foreground, 0.09)
    }
  }
}
