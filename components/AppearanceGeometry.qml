import QtQuick
import QtQuick.Layouts

ColumnLayout {
  id: root

  property var service: null
  readonly property bool editable:
    root.service && root.service.appearanceOverrideEnabled

  Layout.fillWidth: true
  spacing: 12

  SectionLabel { label: "Island geometry" }

  ValueSlider {
    label: "Edge margin"; from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandEdgeMargin : 8
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandEdgeMargin", value) }
  }

  ValueSlider {
    label: "Padding"; from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandPadding : 8
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandPadding", value) }
  }

  ValueSlider {
    label: "Gap"; from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandGap : 4
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandGap", value) }
  }

  ValueSlider {
    label: "Inset"; from: 0; to: 20; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandInset : 2
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandInset", value) }
  }

  ValueSlider {
    label: "Corner radius"; from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandRadius : 12
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandRadius", value) }
  }

  ValueSlider {
    label: "Island opacity"; from: 0.05; to: 1; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.islandOpacity : 1
    enabled: root.editable
    onEdited: function(value) { if (root.service) root.service.islandOpacity = value }
  }

  function setInteger(name, value) {
    if (root.service) root.service[name] = Math.round(value)
  }
}
