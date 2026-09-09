import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  PageTitle {
    title: "Appearance"
    description: "Keep the original Islands look or override its main geometry and transparency."
  }

  AppearanceModeCard { service: root.service }
  AppearanceGeometry { service: root.service }

  RowLayout {
    Layout.fillWidth: true
    Item { Layout.fillWidth: true }

    QQC.Button {
      text: "Restore appearance defaults"
      enabled: root.service !== null
      onClicked: if (root.service) root.service.resetAppearanceDefaults()
    }
  }
}
