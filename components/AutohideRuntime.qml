import QtQuick

Item {
  id: root

  visible: false
  property var shell: null
  property var fallback: null
  property var liveService: null
  readonly property var settings: liveService || fallback
  property int edgeHoverCount: 0
  readonly property bool edgeHovered: edgeHoverCount > 0

  signal showRequested()
  signal barConfigRequested()

  function resolveLiveService() {
    var next = null
    try {
      if (root.shell && typeof root.shell.serviceFor === "function")
        next = root.shell.serviceFor("radyalz.bar-control")
    } catch (error) { }
    if (next !== root.liveService) root.liveService = next
  }

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

  Timer {
    interval: 200
    repeat: true
    running: root.shell !== null
    onTriggered: root.resolveLiveService()
  }

  Component.onCompleted: root.resolveLiveService()
  onShellChanged: root.resolveLiveService()

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
