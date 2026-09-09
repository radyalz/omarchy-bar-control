import QtQuick

Item {
  id: root

  visible: false
  property var settings: null
  property int edgeHoverCount: 0
  readonly property bool edgeHovered: edgeHoverCount > 0

  signal showRequested()

  function setEdgeHovered(hovered) {
    edgeHoverCount = Math.max(0, edgeHoverCount + (hovered ? 1 : -1))
    if (hovered && settings && settings.enabled)
      showRequested()
  }

  Connections {
    target: root.settings
    ignoreUnknownSignals: true

    function onEnabledChanged() {
      if (root.settings.enabled) return
      root.edgeHoverCount = 0
      root.showRequested()
    }
  }
}
