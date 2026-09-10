import QtQuick
import QtQuick.Layouts

InfoCard {
  id: root
  property var service: null

  Text { text: "Animation type"; color: "#cbd1dc"; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Slide + Fade", "Slide", "Fade"]
    value: root.service ? root.service.animationMode : "Slide + Fade"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.animationMode = value }
  }
  Text { text: "Feel preset"; color: "#cbd1dc"; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Smooth", "Snappy", "Soft", "Custom"]
    value: root.service ? root.service.animationPreset : "Smooth"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.setAnimationPreset(value) }
  }
  Text {
    text: "Easing family"
    color: root.service && root.service.customCurveEnabled ? "#7c828e" : "#cbd1dc"
    font.pixelSize: 12
  }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Quad", "Cubic", "Quart", "Quint", "Sine"]
    value: root.service ? root.service.easing : "Cubic"
    enabled: root.service !== null && !(root.service && root.service.customCurveEnabled)
    onSelected: function(value) {
      if (!root.service) return
      root.service.animationPreset = "Custom"; root.service.easing = value
    }
  }
  Text {
    visible: root.service && root.service.customCurveEnabled
    Layout.fillWidth: true
    text: "The custom motion curve is on, so it sets the easing. Turn it off in the Motion curve section to pick an easing family."
    color: "#828b9b"
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }
}
