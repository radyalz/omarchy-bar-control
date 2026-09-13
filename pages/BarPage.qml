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
    summary: {
      if (!root.service) return "Solid"
      var parts = []
      parts.push(root.service.currentTransparent ? "Transparent" : "Solid")
      if (root.service.glassEnabled) parts.push("Glass")
      return parts.join(" · ")
    }

    Component {
      ColumnLayout {
        spacing: 12
        ToggleRow {
          label: "Transparent bar"
          description: "Let the wallpaper show through the bar surface."
          checked: root.service ? root.service.currentTransparent : false
          enabled: root.service !== null
          onToggled: function(value) { if (root.service) root.service.setTransparent(value) }
        }
        ToggleRow {
          label: "Glass islands"
          description: "A sheen + edge highlight over each island, and asks Hyprland to blur behind this bar specifically. Needs your compositor's own blur switched on overall (e.g. via the omablur plugin) — this only opts the bar into it. Pairs well with a transparent bar."
          checked: root.service ? root.service.glassEnabled : false
          enabled: root.service !== null
          onToggled: function(value) { if (root.service) root.service.glassEnabled = value }
        }
        ValueSlider {
          label: "Blur strength"
          description: "Compositor blur intensity (Hyprland's global decoration:blur:size/passes — the same setting the omablur plugin's own blur slider controls, shared with the rest of the desktop, not just this bar)."
          from: 0; to: 100; stepSize: 5; suffix: " %"
          value: root.service ? root.service.glassBlurStrength : 50
          enabled: root.service && root.service.glassEnabled
          visible: root.service && root.service.glassEnabled
          onEdited: function(value) { if (root.service) root.service.glassBlurStrength = Math.round(value) }
        }
      }
    }
  }

  ExpandableSection {
    title: "Island geometry"
    summary: root.service && root.service.appearanceOverrideEnabled ? "Custom" : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetIslandGeometryDefaults()

    Component {
      ColumnLayout {
        spacing: 12
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
    }
  }

  ExpandableSection {
    title: "Bar size"
    summary: root.service && root.service.barSizeOverrideEnabled
      ? root.service.barThickness + " px · icons " + root.service.iconScale + "%"
      : "Theme default"
    resettable: true
    onResetRequested: if (root.service) root.service.resetBarSizeDefaults()

    Component {
      ColumnLayout {
        spacing: 12
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
          description: "Scales the bar's icon size and icon-label text together. Best effort — some Omarchy widgets size their own icons and may not follow."
          from: 60; to: 180; stepSize: 5; suffix: " %"
          value: root.service ? root.service.iconScale : 100
          enabled: root.service && root.service.barSizeOverrideEnabled
          onEdited: function(value) {
            if (root.service) root.service.iconScale = Math.round(value)
          }
        }
      }
    }
  }

  ExpandableSection {
    title: "Colors"
    summary: root.customColors ? "Custom" : "Follow theme"
    resettable: true
    onResetRequested: if (root.service) root.service.resetColorDefaults()

    Component {
      ColumnLayout {
        spacing: 12

        Text { text: "Color source"; color: Color.foreground; font.pixelSize: 12 }
        ChoiceGroup {
          Layout.fillWidth: true
          options: ["Follow theme", "Custom"]
          value: root.customColors ? "Custom" : "Follow theme"
          enabled: root.service !== null
          onSelected: function(value) {
            if (!root.service) return
            var custom = (value === "Custom")
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
