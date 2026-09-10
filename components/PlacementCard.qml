import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root
  property var service: null

  Text { text: "Screen edge"; color: Color.foreground; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Top", "Bottom", "Left", "Right"]
    value: root.service
      ? root.service.position.charAt(0).toUpperCase() + root.service.position.slice(1) : "Top"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.setBarPosition(value.toLowerCase()) }
  }
  Text {
    Layout.fillWidth: true
    text: "Which screen edge the bar docks to. Left/Right make it a vertical bar."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }
  ValueSlider {
    label: "Slide distance"
    description: "How far the bar travels off screen when it hides (needs autohide on and a Slide animation). 100% is its full size, so it disappears; lower leaves a sliver visible; above 100% overshoots the edge."
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
