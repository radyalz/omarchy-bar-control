import QtQuick
import QtQuick.Layouts
import qs.Commons

ColumnLayout {
  id: root

  property var service: null

  Layout.fillWidth: true
  spacing: 12

  SectionLabel { label: "Control points" }
  Text {
    Layout.fillWidth: true
    text: "The two handles of the cubic Bézier curve, same as dragging them on the graph. X is time (0–1); Y is progress and can go past 0–1 for anticipation or overshoot."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }

  ValueSlider {
    label: "X1"
    from: 0; to: 1; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.curveX1 : 0.25
    enabled: root.service !== null
    onEdited: function(value) { root.setPoint("curveX1", value) }
  }

  ValueSlider {
    label: "Y1"
    from: -1; to: 2; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.curveY1 : 0.10
    enabled: root.service !== null
    onEdited: function(value) { root.setPoint("curveY1", value) }
  }

  ValueSlider {
    label: "X2"
    from: 0; to: 1; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.curveX2 : 0.25
    enabled: root.service !== null
    onEdited: function(value) { root.setPoint("curveX2", value) }
  }

  ValueSlider {
    label: "Y2"
    from: -1; to: 2; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.curveY2 : 1.00
    enabled: root.service !== null
    onEdited: function(value) { root.setPoint("curveY2", value) }
  }

  function setPoint(name, value) {
    if (!root.service) return
    root.service.customCurveEnabled = true
    root.service.animationPreset = "Custom"
    root.service[name] = value
  }
}
