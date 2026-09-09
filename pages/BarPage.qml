import QtQuick
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Placement & appearance"
    description: "Move the bar, tune its travel distance, and shape the Islands-style surface in one place."
  }
  SectionLabel { label: "Placement" }
  PlacementCard { service: root.service }
  SectionLabel { label: "Appearance" }
  AppearanceModeCard { service: root.service }
  AppearanceGeometry { service: root.service }
  RowLayout {
    Layout.fillWidth: true
    Item { Layout.fillWidth: true }
    GlassButton {
      text: "Restore appearance defaults"
      enabled: root.service !== null
      onClicked: if (root.service) root.service.resetAppearanceDefaults()
    }
  }
}
