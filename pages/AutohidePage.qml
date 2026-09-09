import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  PageTitle {
    title: "Autohide"
    description: "The autohide feature is an activation module. Turn it on or off here without disabling or uninstalling the plugin."
  }

  InfoCard {
    RowLayout {
      Layout.fillWidth: true
      spacing: 14

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 3

        Text {
          text: "Activate autohide"
          color: "#f3f4f6"
          font.pixelSize: 17
          font.weight: Font.DemiBold
        }

        Text {
          Layout.fillWidth: true
          text: root.service && root.service.enabled
            ? "The edge trigger is controlling the bar."
            : "The bar stays visible. All settings remain editable."
          color: "#9ca3af"
          font.pixelSize: 12
          wrapMode: Text.WordWrap
        }
      }

      QQC.Switch {
        checked: root.service ? root.service.enabled : false
        enabled: root.service !== null
        onToggled: if (root.service) root.service.enabled = checked
      }
    }
  }

  SectionLabel { label: "Reveal" }

  ValueSlider {
    label: "Screen-edge trigger thickness"
    from: 1
    to: 30
    stepSize: 1
    value: root.service ? root.service.triggerThickness : 5
    suffix: " px"
    enabled: root.service !== null
    onEdited: function(value) {
      if (root.service) root.service.triggerThickness = Math.round(value)
    }
  }

  Text {
    Layout.fillWidth: true
    text: "5 px is the default. A larger trigger is easier to hit; a smaller one is less intrusive."
    color: "#7f8793"
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
