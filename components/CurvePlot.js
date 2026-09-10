.pragma library

function clamp(value, minimum, maximum) {
  return Math.max(minimum, Math.min(maximum, value))
}

function pxX(width, value) {
  return 24 + value * (width - 48)
}

function pxY(height, value) {
  return height - 24 - value * (height - 48)
}

function curvePoint(t, x1, y1, x2, y2) {
  var u = 1 - t
  return {
    x: 3 * u * u * t * x1 + 3 * u * t * t * x2 + t * t * t,
    y: 3 * u * u * t * y1 + 3 * u * t * t * y2 + t * t * t
  }
}

function dot(ctx, x, y, radius, fill) {
  ctx.fillStyle = fill
  ctx.beginPath()
  ctx.arc(x, y, radius, 0, Math.PI * 2)
  ctx.fill()
}

function paint(ctx, width, height, x1, y1, x2, y2, previewT, colors) {
  colors = colors || {}
  var cGrid = colors.grid || "#2b2f36"
  var cGuide = colors.guide || "#626976"
  var cCurve = colors.curve || "#d8dee9"
  var cEnd = colors.endpoint || "#8b949e"
  var cHandle = colors.handle || "#7aa2f7"
  var cPreview = colors.preview || "#9ece6a"

  ctx.clearRect(0, 0, width, height)
  var left = 24
  var right = width - 24
  var top = 24
  var bottom = height - 24

  ctx.lineWidth = 1
  ctx.strokeStyle = cGrid
  for (var i = 0; i <= 4; i++) {
    var gx = left + (right - left) * i / 4
    var gy = top + (bottom - top) * i / 4
    ctx.beginPath(); ctx.moveTo(gx, top); ctx.lineTo(gx, bottom); ctx.stroke()
    ctx.beginPath(); ctx.moveTo(left, gy); ctx.lineTo(right, gy); ctx.stroke()
  }

  var startX = pxX(width, 0)
  var startY = pxY(height, 0)
  var endX = pxX(width, 1)
  var endY = pxY(height, 1)
  var c1x = pxX(width, x1)
  var c1y = pxY(height, y1)
  var c2x = pxX(width, x2)
  var c2y = pxY(height, y2)

  ctx.lineWidth = 1.5
  ctx.strokeStyle = cGuide
  ctx.beginPath()
  ctx.moveTo(startX, startY); ctx.lineTo(c1x, c1y)
  ctx.moveTo(endX, endY); ctx.lineTo(c2x, c2y)
  ctx.stroke()

  ctx.lineWidth = 3
  ctx.strokeStyle = cCurve
  ctx.beginPath()
  ctx.moveTo(startX, startY)
  ctx.bezierCurveTo(c1x, c1y, c2x, c2y, endX, endY)
  ctx.stroke()

  dot(ctx, startX, startY, 4, cEnd)
  dot(ctx, endX, endY, 4, cEnd)
  dot(ctx, c1x, c1y, 8, cHandle)
  dot(ctx, c2x, c2y, 8, cHandle)

  var p = curvePoint(previewT, x1, y1, x2, y2)
  dot(ctx, pxX(width, p.x), pxY(height, p.y), 6, cPreview)
}
