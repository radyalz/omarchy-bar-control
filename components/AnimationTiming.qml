import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

ColumnLayout {
  id: root

  property var service: null
  property bool showing: true

  Layout.fillWidth: true
  spacing: 12

  SectionLabel { label: root.showing ? "Show" : "Hide" }

  ValueSlider {
    label: "Slide duration"
    description: root.showing
      ? "How long the bar takes to slide into view when revealed."
      : "How long the bar takes to slide out of view when hidden."
    from: 50
    to: 3000
    stepSize: 50
    value: root.service
      ? (root.showing ? root.service.showSlideDuration : root.service.hideSlideDuration)
      : (root.showing ? 500 : 400)
    suffix: " ms"
    enabled: root.service !== null
    onEdited: function(value) {
      if (!root.service) return
      root.service.animationPreset = "Custom"
      if (root.showing)
        root.service.showSlideDuration = Math.round(value)
      else
        root.service.hideSlideDuration = Math.round(value)
    }
  }

  ValueSlider {
    label: "Fade duration"
    description: root.showing
      ? "How long the bar takes to fade in when revealed."
      : "How long the bar takes to fade out when hidden."
    from: 50
    to: 3000
    stepSize: 50
    value: root.service
      ? (root.showing ? root.service.showFadeDuration : root.service.hideFadeDuration)
      : (root.showing ? 400 : 320)
    suffix: " ms"
    enabled: root.service !== null
    onEdited: function(value) {
      if (!root.service) return
      root.service.animationPreset = "Custom"
      if (root.showing)
        root.service.showFadeDuration = Math.round(value)
      else
        root.service.hideFadeDuration = Math.round(value)
    }
  }
}
