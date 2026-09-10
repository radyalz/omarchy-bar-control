import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root
  property var service: null

  Text { text: "Animation type"; color: Color.foreground; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Slide + Fade", "Slide", "Fade"]
    value: root.service ? root.service.animationMode : "Slide + Fade"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.animationMode = value }
  }
  Text {
    Layout.fillWidth: true
    text: "How the bar enters and leaves: slide moves it in from the edge, fade changes its opacity, or both together."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }

  Text { text: "Feel preset"; color: Color.foreground; font.pixelSize: 12 }
  ChoiceGroup {
    Layout.fillWidth: true
    options: ["Smooth", "Snappy", "Soft", "Custom"]
    value: root.service ? root.service.animationPreset : "Smooth"
    enabled: root.service !== null
    onSelected: function(value) { if (root.service) root.service.setAnimationPreset(value) }
  }
  Text {
    Layout.fillWidth: true
    text: "A starting point for the timings and easing below. Editing any of them switches the preset to Custom."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }

  Text {
    text: "Easing family"
    color: root.service && root.service.customCurveEnabled
      ? Qt.alpha(Color.foreground, 0.45) : Color.foreground
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
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }
}
