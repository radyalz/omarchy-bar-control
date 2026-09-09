import QtQuick

Item {
  id: root

  property real x1: 0.25
  property real y1: 0.10
  property real x2: 0.25
  property real y2: 1.00
  property bool interactive: true
  property real previewT: 0

  signal curveEdited(real x1, real y1, real x2, real y2)

  implicitWidth: 520
  implicitHeight: 300

  function clamp(value, minimum, maximum) {
    return Math.max(minimum, Math.min(maximum, value))
  }

  function pxX(value) {
    return 24 + value * (width - 48)
  }

  function pxY(value) {
    return height - 24 - value * (height - 48)
  }

  function curvePoint(t) {
    var u = 1 - t
    var x = 3 * u * u * t * root.x1
      + 3 * u * t * t * root.x2
      + t * t * t
    var y = 3 * u * u * t * root.y1
      + 3 * u * t * t * root.y2
      + t * t * t
    return { x: x, y: y }
  }

  function play() {
    previewT = 0
    previewAnimation.restart()
  }

  onX1Changed: canvas.requestPaint()
  onY1Changed: canvas.requestPaint()
  onX2Changed: canvas.requestPaint()
  onY2Changed: canvas.requestPaint()
  onPreviewTChanged: canvas.requestPaint()
  onWidthChanged: canvas.requestPaint()
  onHeightChanged: canvas.requestPaint()

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: "#16181d"
    border.width: 1
    border.color: "#343840"
  }

  Canvas {
    id: canvas
    anchors.fill: parent

    onPaint: {
      var ctx = getContext("2d")
      ctx.clearRect(0, 0, width, height)

      var left = 24
      var right = width - 24
      var top = 24
      var bottom = height - 24

      ctx.lineWidth = 1
      ctx.strokeStyle = "#2b2f36"
      for (var i = 0; i <= 4; i++) {
        var gx = left + (right - left) * i / 4
        var gy = top + (bottom - top) * i / 4

        ctx.beginPath()
        ctx.moveTo(gx, top)
        ctx.lineTo(gx, bottom)
        ctx.stroke()

        ctx.beginPath()
        ctx.moveTo(left, gy)
        ctx.lineTo(right, gy)
        ctx.stroke()
      }

      var startX = root.pxX(0)
      var startY = root.pxY(0)
      var endX = root.pxX(1)
      var endY = root.pxY(1)
      var c1x = root.pxX(root.x1)
      var c1y = root.pxY(root.y1)
      var c2x = root.pxX(root.x2)
      var c2y = root.pxY(root.y2)

      ctx.lineWidth = 1.5
      ctx.strokeStyle = "#626976"
      ctx.beginPath()
      ctx.moveTo(startX, startY)
      ctx.lineTo(c1x, c1y)
      ctx.moveTo(endX, endY)
      ctx.lineTo(c2x, c2y)
      ctx.stroke()

      ctx.lineWidth = 3
      ctx.strokeStyle = "#d8dee9"
      ctx.beginPath()
      ctx.moveTo(startX, startY)
      ctx.bezierCurveTo(c1x, c1y, c2x, c2y, endX, endY)
      ctx.stroke()

      function dot(x, y, radius, fill) {
        ctx.fillStyle = fill
        ctx.beginPath()
        ctx.arc(x, y, radius, 0, Math.PI * 2)
        ctx.fill()
      }

      dot(startX, startY, 4, "#8b949e")
      dot(endX, endY, 4, "#8b949e")
      dot(c1x, c1y, 8, "#7aa2f7")
      dot(c2x, c2y, 8, "#bb9af7")

      var p = root.curvePoint(root.previewT)
      dot(root.pxX(p.x), root.pxY(p.y), 6, "#9ece6a")
    }
  }

  MouseArea {
    anchors.fill: parent
    enabled: root.interactive
    hoverEnabled: true
    property int activePoint: 0

    function normalizedX(mouseX) {
      return root.clamp((mouseX - 24) / Math.max(1, root.width - 48), 0, 1)
    }

    function normalizedY(mouseY) {
      return root.clamp((root.height - 24 - mouseY)
        / Math.max(1, root.height - 48), -1, 2)
    }

    onPressed: function(mouse) {
      var dx1 = mouse.x - root.pxX(root.x1)
      var dy1 = mouse.y - root.pxY(root.y1)
      var dx2 = mouse.x - root.pxX(root.x2)
      var dy2 = mouse.y - root.pxY(root.y2)
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

    function updatePoint(mouseX, mouseY) {
      var nx = normalizedX(mouseX)
      var ny = normalizedY(mouseY)

      if (activePoint === 1)
        root.curveEdited(nx, ny, root.x2, root.y2)
      else if (activePoint === 2)
        root.curveEdited(root.x1, root.y1, nx, ny)
    }
  }

  NumberAnimation {
    id: previewAnimation
    target: root
    property: "previewT"
    from: 0
    to: 1
    duration: 1200
    easing.type: Easing.Linear
    onFinished: root.previewT = 0
  }
}
