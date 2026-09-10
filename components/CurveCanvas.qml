import QtQuick
import qs.Commons
import "CurvePlot.js" as CurvePlot

Canvas {
  id: root

  property real x1: 0.25
  property real y1: 0.10
  property real x2: 0.25
  property real y2: 1.00
  property real previewT: 0

  // Canvas 2D strokeStyle/fillStyle accept colour values directly, so pass the
  // theme colours straight through.
  readonly property var plotColors: ({
    grid: Qt.alpha(Color.foreground, 0.12),
    guide: Qt.alpha(Color.foreground, 0.4),
    curve: Color.foreground,
    endpoint: Qt.alpha(Color.foreground, 0.55),
    handle: Color.accent,
    preview: "#76d39b"
  })

  onX1Changed: requestPaint()
  onY1Changed: requestPaint()
  onX2Changed: requestPaint()
  onY2Changed: requestPaint()
  onPreviewTChanged: requestPaint()
  onWidthChanged: requestPaint()
  onHeightChanged: requestPaint()
  onPlotColorsChanged: requestPaint()

  onPaint: {
    CurvePlot.paint(
      getContext("2d"), width, height,
      x1, y1, x2, y2, previewT, plotColors
    )
  }
}
