import QtQuick
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "About & support"
    description: "Project information, license, repository and support links."
  }
  ProjectAboutCard { service: root.service }
  SupportActions { service: root.service }
}
