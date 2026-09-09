import QtQuick
import "CurvePlot.js" as CurvePlot

Canvas {
  id: root

  property real x1: 0.25
  property real y1: 0.10
  property real x2: 0.25
  property real y2: 1.00
  property real previewT: 0

  onX1Changed: requestPaint()
  onY1Changed: requestPaint()
  onX2Changed: requestPaint()
  onY2Changed: requestPaint()
  onPreviewTChanged: requestPaint()
  onWidthChanged: requestPaint()
  onHeightChanged: requestPaint()

  onPaint: {
    CurvePlot.paint(
      getContext("2d"), width, height,
      x1, y1, x2, y2, previewT
    )
  }
}
