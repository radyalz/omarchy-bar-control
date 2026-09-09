import QtQuick

Item {
  id: root

  visible: false
  property var shell: null
  property var fallback: null
  readonly property var liveService:
    shell && typeof shell.serviceFor === "function"
      ? shell.serviceFor("radyalz.bar-control") : null
  readonly property var settings: liveService || fallback
  property int edgeHoverCount: 0
  readonly property bool edgeHovered: edgeHoverCount > 0

  signal showRequested()
  signal barConfigRequested()

  function setEdgeHovered(hovered) {
    edgeHoverCount = Math.max(0, edgeHoverCount + (hovered ? 1 : -1))
    if (hovered && settings && settings.enabled)
      showRequested()
  }

  onLiveServiceChanged: {
    if (!liveService) return
    barConfigRequested()
    if (!liveService.enabled) showRequested()
  }

  Connections {
    target: root.liveService
    ignoreUnknownSignals: true

    function onEnabledChanged() {
      if (root.liveService.enabled) return
      root.edgeHoverCount = 0
      root.showRequested()
    }

    function onPositionChanged() { root.barConfigRequested() }
    function onTransparentChanged() { root.barConfigRequested() }
  }
}
