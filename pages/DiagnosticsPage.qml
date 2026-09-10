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
    description: "Local plugin health and the optional GitHub project-status feed."
  }
  PluginHealthCard { service: root.service }
  SectionLabel { label: "GitHub project status" }
  ProjectStatusCard { service: root.service }
  SectionLabel { label: "Diagnostic report" }
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
