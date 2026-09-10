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
      ? root.service.barThickness + " px · icons " + root.service.iconScale
        + "% · text " + root.service.fontScale + "%"
      : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetBarSizeDefaults()

    ToggleRow {
      label: "Custom bar size"
      description: "Override the theme's bar thickness, icon scale and text scale."
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
      description: "Scales bar widget icons. Best effort — some Omarchy widgets size their own icons and may not follow."
      from: 60; to: 180; stepSize: 5; suffix: " %"
      value: root.service ? root.service.iconScale : 100
      enabled: root.service && root.service.barSizeOverrideEnabled
      onEdited: function(value) {
        if (root.service) root.service.iconScale = Math.round(value)
      }
    }

    ValueSlider {
      label: "Text scale"
      description: "Nudges the bar's icon-label text size (on top of icon scale). Full shell-wide text scaling is intentionally not done from here — it can crash the shell."
      from: 60; to: 180; stepSize: 5; suffix: " %"
      value: root.service ? root.service.fontScale : 100
      enabled: root.service && root.service.barSizeOverrideEnabled
      onEdited: function(value) {
        if (root.service) root.service.fontScale = Math.round(value)
      }
    }
  }

  ExpandableSection {
    title: "Colors"
    summary: root.customColors ? "Custom" : "Follow theme"
    resettable: true
    onResetRequested: if (root.service) root.service.resetColorDefaults()

    Text { text: "Color source"; color: Color.foreground; font.pixelSize: 12 }
    ChoiceGroup {
      Layout.fillWidth: true
      options: ["Follow theme", "Custom"]
      value: root.customColors ? "Custom" : "Follow theme"
      enabled: root.service !== null
      onSelected: function(value) {
        if (!root.service) return
        var custom = (value === "Custom")
        // Seed the editable values from the live theme colours so Custom
        // starts where Follow theme left off rather than at old defaults.
        if (custom && !root.service.colorOverrideEnabled) {
          root.service.barColor = String(Color.bar.background)
          root.service.islandColor = String(Color.bar.background)
          root.service.textColor = String(Color.bar.text)
          root.service.accentColor = String(Color.bar.active)
        }
        root.service.colorOverrideEnabled = custom
      }
    }
    Text {
      Layout.fillWidth: true
      text: root.customColors
        ? "Editing your own colors. Switch to Follow theme to track the active Omarchy theme again."
        : "Showing the active Omarchy theme colors. Switch to Custom to edit them."
      color: Qt.alpha(Color.foreground, 0.6)
      font.pixelSize: 10
      wrapMode: Text.WordWrap
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.topMargin: 4
      spacing: 16

      ColorField {
        label: "Bar background"
        description: "Fill of the bar window behind every widget."
        value: root.customColors ? root.service.barColor : String(Color.bar.background)
        enabled: root.customColors
        onEdited: function(value) { if (root.service) root.service.barColor = value }
      }
      ColorField {
        label: "Island background"
        description: "The rounded pill drawn behind each individual widget."
        value: root.customColors ? root.service.islandColor : String(Color.bar.background)
        enabled: root.customColors
        onEdited: function(value) { if (root.service) root.service.islandColor = value }
      }
      ColorField {
        label: "Foreground / text"
        description: "Text and glyph colour for widgets that follow the bar palette."
        value: root.customColors ? root.service.textColor : String(Color.bar.text)
        enabled: root.customColors
        onEdited: function(value) { if (root.service) root.service.textColor = value }
      }
      ColorField {
        label: "Accent / active"
        description: "Highlight used for active and urgent widget states."
        value: root.customColors ? root.service.accentColor : String(Color.bar.active)
        enabled: root.customColors
        onEdited: function(value) { if (root.service) root.service.accentColor = value }
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
