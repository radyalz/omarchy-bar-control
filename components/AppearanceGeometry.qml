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
    label: "Edge margin"
    description: "Gap between the outer islands and the screen edge."
    from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandEdgeMargin : 8
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandEdgeMargin", value) }
  }

  ValueSlider {
    label: "Padding"
    description: "Space between a widget's content and the edge of its island."
    from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandPadding : 8
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandPadding", value) }
  }

  ValueSlider {
    label: "Gap"
    description: "Space between one island and the next along the bar."
    from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandGap : 4
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandGap", value) }
  }

  ValueSlider {
    label: "Inset"
    description: "How far each island is pulled in from the bar's full thickness."
    from: 0; to: 20; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandInset : 2
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandInset", value) }
  }

  ValueSlider {
    label: "Corner radius"
    description: "Roundness of the island corners. 0 is square."
    from: 0; to: 64; stepSize: 1; suffix: " px"
    value: root.service ? root.service.islandRadius : 12
    enabled: root.editable
    onEdited: function(value) { root.setInteger("islandRadius", value) }
  }

  ValueSlider {
    label: "Island opacity"
    description: "Transparency of the island fill. 1.00 is solid."
    from: 0.05; to: 1; stepSize: 0.01; decimals: 2
    value: root.service ? root.service.islandOpacity : 1
    enabled: root.editable
    onEdited: function(value) { if (root.service) root.service.islandOpacity = value }
  }

  function setInteger(name, value) {
    if (root.service) root.service[name] = Math.round(value)
  }
}
