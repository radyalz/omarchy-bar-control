import QtQuick
import QtQuick.Layouts

InfoCard {
  id: root
  property var service: null

  Text { text: "Screen edge"; color: "#cbd1dc"; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Top", "Bottom", "Left", "Right"]
    value: root.service
      ? root.service.position.charAt(0).toUpperCase() + root.service.position.slice(1) : "Top"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.setBarPosition(value.toLowerCase()) }
  }
  ValueSlider {
    label: "Slide distance"
    from: 0; to: 200; stepSize: 5; suffix: "%"
    value: root.service ? root.service.slideDistancePercent : 100
    enabled: root.service !== null
    onEdited: function(value) {
      if (!root.service) return
      root.service.animationPreset = "Custom"
      root.service.slideDistancePercent = Math.round(value)
    }
  }
}
