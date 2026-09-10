import QtQuick
import QtQuick.Layouts
import qs.Commons
import "../components"

SettingsPage {
  id: root
  property var service: null

  readonly property bool customColors: root.service && root.service.colorOverrideEnabled

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

    ToggleRow {
      label: "Transparent bar"
      description: "Let the wallpaper show through the bar surface."
      checked: root.service ? root.service.currentTransparent : false
      enabled: root.service !== null
      onToggled: function(value) { if (root.service) root.service.setTransparent(value) }
    }
  }

  ExpandableSection {
    title: "Island geometry"
    summary: root.service && root.service.appearanceOverrideEnabled ? "Custom" : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetIslandGeometryDefaults()

    ToggleRow {
      label: "Custom island appearance"
      description: "Enable the geometry and opacity controls below."
      checked: root.service ? root.service.appearanceOverrideEnabled : false
      enabled: root.service !== null
      onToggled: function(value) {
        if (root.service) root.service.appearanceOverrideEnabled = value
      }
    }

    AppearanceGeometry { service: root.service }
  }

  ExpandableSection {
    title: "Bar size"
    summary: root.service && root.service.barSizeOverrideEnabled
      ? root.service.barThickness + " px · " + root.service.iconScale + "%"
      : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetBarSizeDefaults()

    ToggleRow {
      label: "Custom bar size"
      description: "Override the theme's bar thickness and icon scale."
      checked: root.service ? root.service.barSizeOverrideEnabled : false
      enabled: root.service !== null
      onToggled: function(value) {
        if (root.service) root.service.barSizeOverrideEnabled = value
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

  ExpandableSection {
    title: "Colors"
    summary: root.customColors ? "Custom" : "Follow theme"
    resettable: true
    onResetRequested: if (root.service) root.service.resetColorDefaults()

    Text { text: "Color source"; color: "#cbd1dc"; font.pixelSize: 12 }
    ChoiceGroup {
      Layout.fillWidth: true
      options: ["Follow theme", "Custom"]
      value: root.customColors ? "Custom" : "Follow theme"
      enabled: root.service !== null
      onSelected: function(value) {
        if (root.service) root.service.colorOverrideEnabled = (value === "Custom")
      }
    }
    Text {
      Layout.fillWidth: true
      text: root.customColors
        ? "Editing your own colors. Switch to Follow theme to track the active Omarchy theme again."
        : "Showing the active Omarchy theme colors. Switch to Custom to edit them."
      color: "#828b9b"
      font.pixelSize: 10
      wrapMode: Text.WordWrap
    }

    ColorField {
      label: "Bar background"
      value: root.customColors ? root.service.barColor : String(Color.bar.background)
      enabled: root.customColors
      onEdited: function(value) { if (root.service) root.service.barColor = value }
    }
    ColorField {
      label: "Island background"
      value: root.customColors ? root.service.islandColor : String(Color.bar.background)
      enabled: root.customColors
      onEdited: function(value) { if (root.service) root.service.islandColor = value }
    }
    ColorField {
      label: "Foreground / text"
      value: root.customColors ? root.service.textColor : String(Color.bar.text)
      enabled: root.customColors
      onEdited: function(value) { if (root.service) root.service.textColor = value }
    }
    ColorField {
      label: "Accent / active"
      value: root.customColors ? root.service.accentColor : String(Color.bar.active)
      enabled: root.customColors
      onEdited: function(value) { if (root.service) root.service.accentColor = value }
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
