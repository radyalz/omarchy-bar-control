import QtQuick
import "CurvePlot.js" as CurvePlot

MouseArea {
  id: root

  property real x1: 0.25
  property real y1: 0.10
  property real x2: 0.25
  property real y2: 1.00
  property int activePoint: 0

  signal curveEdited(real x1, real y1, real x2, real y2)

  hoverEnabled: true

  function normalizedX(mouseX) {
    return CurvePlot.clamp(
      (mouseX - 24) / Math.max(1, width - 48), 0, 1
    )
  }

  function normalizedY(mouseY) {
    return CurvePlot.clamp(
      (height - 24 - mouseY) / Math.max(1, height - 48), -1, 2
    )
  }

  function updatePoint(mouseX, mouseY) {
    var nx = normalizedX(mouseX)
    var ny = normalizedY(mouseY)
    if (activePoint === 1)
      curveEdited(nx, ny, x2, y2)
    else if (activePoint === 2)
      curveEdited(x1, y1, nx, ny)
  }

  onPressed: function(mouse) {
    var dx1 = mouse.x - CurvePlot.pxX(width, x1)
    var dy1 = mouse.y - CurvePlot.pxY(height, y1)
    var dx2 = mouse.x - CurvePlot.pxX(width, x2)
    var dy2 = mouse.y - CurvePlot.pxY(height, y2)
    var d1 = Math.sqrt(dx1 * dx1 + dy1 * dy1)
    var d2 = Math.sqrt(dx2 * dx2 + dy2 * dy2)
    activePoint = d1 <= d2 ? 1 : 2
    updatePoint(mouse.x, mouse.y)
  }

  onPositionChanged: function(mouse) {
    if (pressed)
      updatePoint(mouse.x, mouse.y)
  }

  onReleased: activePoint = 0
  onCanceled: activePoint = 0
}
