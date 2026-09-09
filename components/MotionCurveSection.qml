import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root
  property var service: null
  Layout.fillWidth: true
  spacing: 12

  CurveActivationCard { service: root.service }

  CurveEditor {
    id: editor
    Layout.fillWidth: true
    Layout.preferredHeight: 280
    x1: root.service ? root.service.curveX1 : 0.25
    y1: root.service ? root.service.curveY1 : 0.10
    x2: root.service ? root.service.curveX2 : 0.25
    y2: root.service ? root.service.curveY2 : 1.00
    interactive: root.service !== null
    onCurveEdited: function(x1, y1, x2, y2) {
      if (!root.service) return
      root.service.animationPreset = "Custom"
      root.service.customCurveEnabled = true
      root.service.curveX1 = x1; root.service.curveY1 = y1
      root.service.curveX2 = x2; root.service.curveY2 = y2
    }
  }

  RowLayout {
    Layout.fillWidth: true
    GlassButton { text: "Preview curve"; onClicked: editor.play() }
    GlassButton {
      text: "Reset curve"
      enabled: root.service !== null
      onClicked: if (root.service) {
        root.service.curveX1 = 0.25; root.service.curveY1 = 0.10
        root.service.curveX2 = 0.25; root.service.curveY2 = 1.00
        root.service.animationPreset = "Custom"
      }
    }
    Item { Layout.fillWidth: true }
  }

  CurvePointControls { service: root.service }
}
