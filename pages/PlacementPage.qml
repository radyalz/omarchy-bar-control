import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  function indexOf(list, value, fallback) {
    var index = list.indexOf(value)
    return index >= 0 ? index : fallback
  }

  PageTitle {
    title: "Placement"
    description: "Move the bar to any screen edge. The reveal trigger follows the bar automatically."
  }

  SectionLabel { label: "Bar edge" }

  InfoCard {
    SettingRow {
      label: "Position"

      QQC.ComboBox {
        model: ["Top", "Bottom", "Left", "Right"]
        currentIndex: root.indexOf(
          ["top", "bottom", "left", "right"],
          root.service ? root.service.position : "top",
          0
        )
        enabled: root.service !== null
        onActivated: function(index) {
          if (root.service)
            root.service.setBarPosition(["top", "bottom", "left", "right"][index])
        }
      }
    }
  }

  SectionLabel { label: "Movement" }

  ValueSlider {
    label: "Slide distance"
    from: 0
    to: 150
    stepSize: 5
    value: root.service ? root.service.slideDistancePercent : 100
    suffix: "%"
    enabled: root.service !== null
    onEdited: function(value) {
      if (!root.service) return
      root.service.animationPreset = "Custom"
      root.service.slideDistancePercent = Math.round(value)
    }
  }

  Text {
    Layout.fillWidth: true
    text: "100% moves the content by one full bar thickness. 0% gives fade-only-looking movement even when Slide is selected."
    color: "#7f8793"
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
