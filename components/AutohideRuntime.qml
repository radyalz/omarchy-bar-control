import QtQuick

Item {
  id: root

  visible: false
  property var settings: null
  property int edgeHoverCount: 0
  // A transient overlapping layer surface -- e.g. a "Copied to clipboard"
  // notification popping up near the screen edge on copy/paste -- can fire a
  // spurious enter+leave pair on the trigger strip's HoverHandler with no
  // real mouse movement there. Require a hover to hold for a moment before
  // treating it as real, so a blip like that cannot flash the bar open.
  // Leaving reacts immediately; only the reveal is debounced.
  readonly property bool edgeHovered: edgeHoveredConfirmed
  property bool edgeHoveredConfirmed: false

  signal showRequested()

  function setEdgeHovered(hovered) {
    edgeHoverCount = Math.max(0, edgeHoverCount + (hovered ? 1 : -1))
    if (edgeHoverCount > 0) {
      confirmTimer.restart()
    } else {
      confirmTimer.stop()
      edgeHoveredConfirmed = false
    }
  }

  Timer {
    id: confirmTimer
    interval: 70
    repeat: false
    onTriggered: {
      if (root.edgeHoverCount > 0) {
        root.edgeHoveredConfirmed = true
        if (root.settings && root.settings.enabled) root.showRequested()
      }
    }
  }

  Connections {
    target: root.settings
    ignoreUnknownSignals: true

    function onEnabledChanged() {
      if (root.settings.enabled) return
      root.edgeHoverCount = 0
      confirmTimer.stop()
      root.edgeHoveredConfirmed = false
      root.showRequested()
    }
  }
}
