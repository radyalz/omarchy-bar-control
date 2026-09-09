.pragma library

function patch(name) {
  var values = {
    animationPreset: name,
    customCurveEnabled: false
  }

  if (name === "Smooth") {
    values.showSlideDuration = 500
    values.showFadeDuration = 400
    values.hideSlideDuration = 400
    values.hideFadeDuration = 320
    values.easing = "Cubic"
  } else if (name === "Snappy") {
    values.showSlideDuration = 240
    values.showFadeDuration = 180
    values.hideSlideDuration = 200
    values.hideFadeDuration = 150
    values.easing = "Quart"
  } else if (name === "Soft") {
    values.showSlideDuration = 650
    values.showFadeDuration = 520
    values.hideSlideDuration = 540
    values.hideFadeDuration = 420
    values.easing = "Sine"
  }

  return values
}
