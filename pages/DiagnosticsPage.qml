import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  PageTitle {
    title: "Diagnostics"
    description: "Local plugin health plus the optional project-status feed from GitHub."
  }

  PluginHealthCard { service: root.service }
  SectionLabel { label: "GitHub project status" }
  ProjectStatusCard { service: root.service }
  SectionLabel { label: "Diagnostic report" }

  QQC.TextArea {
    Layout.fillWidth: true
    Layout.preferredHeight: 220
    readOnly: true
    wrapMode: TextEdit.NoWrap
    text: root.service
      ? root.service.diagnosticReport()
      : "Radyalz Bar Control service is not available."
  }
}
