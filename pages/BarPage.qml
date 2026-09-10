import QtQuick
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Placement & appearance"
    description: "Set where the bar lives, then open a section to shape it."
  }

  SectionLabel { label: "Placement" }
  PlacementCard { service: root.service }

  SectionLabel { label: "Appearance" }

  ExpandableSection {
    title: "Surface"
    summary: root.service && root.service.currentTransparent ? "Transparent" : "Solid"

    AppearanceModeCard { service: root.service }
  }

  ExpandableSection {
    title: "Island geometry"
    summary: root.service && root.service.appearanceOverrideEnabled ? "Custom" : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetIslandGeometryDefaults()

    AppearanceGeometry { service: root.service }
  }

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
