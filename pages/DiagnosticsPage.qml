import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
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
    Layout.fillWidth: true; Layout.preferredHeight: 210
    readOnly: true; wrapMode: TextEdit.NoWrap
    color: "#c8cfda"; selectionColor: "#5d72bd"
    text: root.service ? root.service.diagnosticReport() : "Radyalz Bar Control service is not available."
    background: Rectangle {
      radius: 6; color: Qt.rgba(1, 1, 1, 0.04)
      border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.07)
    }
  }
}
