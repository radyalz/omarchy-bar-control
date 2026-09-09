import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

InfoCard {
  id: root

  property var service: null

  function indexOf(list, value, fallback) {
    var index = list.indexOf(value)
    return index >= 0 ? index : fallback
  }

  SettingRow {
    label: "Animation type"

    QQC.ComboBox {
      model: ["Slide + Fade", "Slide", "Fade"]
      currentIndex: root.indexOf(
        model,
        root.service ? root.service.animationMode : "Slide + Fade",
        0
      )
      enabled: root.service !== null
      onActivated: function(index) {
        if (root.service) root.service.animationMode = model[index]
      }
    }
  }

  SettingRow {
    label: "Feel preset"

    QQC.ComboBox {
      model: ["Smooth", "Snappy", "Soft", "Custom"]
      currentIndex: root.indexOf(
        model,
        root.service ? root.service.animationPreset : "Smooth",
        0
      )
      enabled: root.service !== null
      onActivated: function(index) {
        if (root.service) root.service.setAnimationPreset(model[index])
      }
    }
  }

  SettingRow {
    label: "Easing family"

    QQC.ComboBox {
      model: ["Quad", "Cubic", "Quart", "Quint", "Sine"]
      currentIndex: root.indexOf(
        model,
        root.service ? root.service.easing : "Cubic",
        1
      )
      enabled: root.service !== null
        && !(root.service && root.service.customCurveEnabled)
      onActivated: function(index) {
        if (!root.service) return
        root.service.animationPreset = "Custom"
        root.service.easing = model[index]
      }
    }
  }
}
