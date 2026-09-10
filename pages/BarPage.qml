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

  ExpandableSection {
    title: "Bar size"
    summary: root.service && root.service.barSizeOverrideEnabled
      ? root.service.barThickness + " px · " + root.service.iconScale + "%"
      : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetBarSizeDefaults()

    RowLayout {
      Layout.fillWidth: true
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text { text: "Custom bar size"; color: "#d7dce6"; font.pixelSize: 12 }
        Text {
          text: "Override the theme's bar thickness and icon scale."
          color: "#7f8793"; font.pixelSize: 10
        }
      }
      GlassToggle {
        checked: root.service ? root.service.barSizeOverrideEnabled : false
        enabled: root.service !== null
        onToggled: function(value) {
          if (root.service) root.service.barSizeOverrideEnabled = value
        }
      }
    }

    ValueSlider {
      label: "Bar thickness"
      description: "Height on a top/bottom bar, width on a left/right bar."
      from: 18; to: 96; stepSize: 1; suffix: " px"
      value: root.service ? root.service.barThickness : 32
      enabled: root.service && root.service.barSizeOverrideEnabled
      onEdited: function(value) {
        if (root.service) root.service.barThickness = Math.round(value)
      }
    }

    ValueSlider {
      label: "Icon scale"
      description: "Best effort — some Omarchy widgets size their own icons and may not follow."
      from: 60; to: 180; stepSize: 5; suffix: " %"
      value: root.service ? root.service.iconScale : 100
      enabled: root.service && root.service.barSizeOverrideEnabled
      onEdited: function(value) {
        if (root.service) root.service.iconScale = Math.round(value)
      }
    }
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
