import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "components"

Item {
  id: root

  property var shell: null
  property var manifest: null

  readonly property var bar: shell ? shell.bar : null
  // New Omarchy versions expose shell.bar as read-only plugin state.
  // Service.qml therefore owns settings only; Bar.qml owns autohide runtime.
  property string position: bar ? String(bar.position || "top") : "top"
  property bool transparent: false
  // Glass look: a light sheen + hairline edge drawn over the islands (the
  // bar's only visible surface). Independent of the override groups below so
  // it works with theme-default geometry too.
  property bool glassEnabled: false

  // --- Autohide activation -------------------------------------------------
  // This is the master module switch exposed in the GUI. Disabling it keeps
  // the plugin installed and configurable, but leaves the bar permanently shown.
  property bool enabled: true

  // --- Reveal --------------------------------------------------------------
  property int triggerThickness: 5

  // --- Animation -----------------------------------------------------------
  property string animationMode: "Slide + Fade"
  property string animationPreset: "Smooth"
  property int showSlideDuration: 500
  property int showFadeDuration: 400
  property int hideSlideDuration: 400
  property int hideFadeDuration: 320
  property int slideDistancePercent: 100
  property string easing: "Cubic"

  // One cubic Bézier segment. The bar appends the implicit end point (1, 1).
  property bool customCurveEnabled: false
  property real curveX1: 0.25
  property real curveY1: 0.10
  property real curveX2: 0.25
  property real curveY2: 1.00

  // --- Appearance ----------------------------------------------------------
  // Off by default so the copied Islands Bar look is preserved exactly until
  // the user explicitly opts into custom appearance values.
  property bool appearanceOverrideEnabled: false
  property int islandEdgeMargin: 8
  property int islandPadding: 8
  property int islandGap: 4
  property int islandInsetTop: 2
  property int islandInsetBottom: 2
  property int islandRadius: 12
  property real islandOpacity: 1.0

  // --- Bar size ----------------------------------------------------------
  // Off by default so the theme's bar thickness and icon sizing are kept.
  property bool barSizeOverrideEnabled: false
  property int barThickness: 32
  property int iconScale: 100

  // --- Colors ----------------------------------------------------------
  // Off by default so the bar tracks the active Omarchy theme.
  property bool colorOverrideEnabled: false
  property string barColor: "#1e1e2e"
  property string islandColor: "#1e1e2e"
  property string textColor: "#cdd6f4"
  property string accentColor: "#89b4fa"

  // --- Project/support metadata -------------------------------------------
  property string repositoryUrl:
    "https://github.com/radyalz/omarchy-bar-control"
  property string issuesUrl: repositoryUrl + "/issues"
  property string statusUrl: ""

  property string githubStatus: "Not checked"
  property string githubStatusMessage:
    "Check for updates to compare this install against the latest GitHub release."
  property bool githubStatusLoading: false
  property string latestVersion: ""
  property string latestReleaseUrl: ""
  property bool updateAvailable: false

  readonly property bool barConnected: bar !== null
  readonly property bool settingsHealthy: settingsLoaded
  readonly property bool triggerActive: enabled && settingsLoaded
  readonly property bool currentTransparent: transparent

  readonly property string settingsPath:
    Quickshell.env("HOME")
      + "/.config/omarchy/radyalz-bar-control.json"

  property bool settingsLoaded: false
  property bool hydrating: false
  // Exact text of the last payload this surface wrote. Used to ignore the
  // watcher echo of our own write instead of the old time-window suppression.
  property string lastWrittenText: ""
  // Last object parsed off disk. saveSettings() merges onto this in-memory
  // copy rather than doing a synchronous reload(), which would re-enter
  // loadSettings() and revert the change that is being saved.
  property var diskData: ({})

  FileView {
    id: settingsFile
    path: root.settingsPath
    // Event-driven: react to writes from the bar popover or any other surface
    // the moment they land, rather than polling the file on a timer. onLoaded
    // keeps diskData current so writes never need a blocking reload.
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadSettings(text())
    onLoadFailed: root.loadSettings("")
    onFileChanged: reload()
  }

  Timer {
    id: saveTimer
    interval: 25
    repeat: false
    onTriggered: root.saveSettings()
  }

  ControlBridge {
    service: root
  }

  function clampInt(value, minimum, maximum, fallback) {
    var n = Number(value)
    if (!isFinite(n))
      return fallback
    return Math.max(minimum, Math.min(maximum, Math.round(n)))
  }

  function clampReal(value, minimum, maximum, fallback) {
    var n = Number(value)
    if (!isFinite(n))
      return fallback
    return Math.max(minimum, Math.min(maximum, n))
  }

  function allowed(value, values, fallback) {
    return values.indexOf(value) !== -1 ? value : fallback
  }

  function hexColor(value, fallback) {
    return /^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(String(value))
      ? String(value) : fallback
  }

  function loadSettings(raw) {
    // The watcher re-delivers our own write; nothing changed, so skip the
    // hydrate cycle. Always process the first load so settingsLoaded latches.
    if (root.settingsLoaded && String(raw) === root.lastWrittenText)
      return

    var firstLoad = !root.settingsLoaded
    var data = null

    if (String(raw || "").trim() !== "") {
      try {
        data = JSON.parse(raw)
      } catch (error) {
        console.warn("radyalz-bar-control: invalid settings:", error)
      }
    }

    root.hydrating = true

    if (data) {
      if (typeof data.enabled === "boolean")
        root.enabled = data.enabled

      var positions = ["top", "bottom", "left", "right"]
      if (positions.indexOf(data.position) !== -1)
        root.position = data.position
      else if (root.bar)
        root.position = String(root.bar.position || "top")

      if (typeof data.transparent === "boolean")
        root.transparent = data.transparent
      if (typeof data.glassEnabled === "boolean")
        root.glassEnabled = data.glassEnabled

      root.triggerThickness =
        root.clampInt(data.triggerThickness, 1, 50, root.triggerThickness)

      root.animationMode = root.allowed(
        data.animationMode,
        ["Slide + Fade", "Slide", "Fade"],
        root.animationMode
      )

      root.animationPreset = root.allowed(
        data.animationPreset,
        ["Smooth", "Snappy", "Soft", "Custom"],
        root.animationPreset
      )

      root.showSlideDuration =
        root.clampInt(data.showSlideDuration, 50, 3000, root.showSlideDuration)
      root.showFadeDuration =
        root.clampInt(data.showFadeDuration, 50, 3000, root.showFadeDuration)
      root.hideSlideDuration =
        root.clampInt(data.hideSlideDuration, 50, 3000, root.hideSlideDuration)
      root.hideFadeDuration =
        root.clampInt(data.hideFadeDuration, 50, 3000, root.hideFadeDuration)
      root.slideDistancePercent =
        root.clampInt(data.slideDistancePercent, 0, 200, root.slideDistancePercent)

      root.easing = root.allowed(
        data.easing,
        ["Quad", "Cubic", "Quart", "Quint", "Sine"],
        root.easing
      )

      if (typeof data.customCurveEnabled === "boolean")
        root.customCurveEnabled = data.customCurveEnabled
      root.curveX1 = root.clampReal(data.curveX1, 0, 1, root.curveX1)
      root.curveY1 = root.clampReal(data.curveY1, -1, 2, root.curveY1)
      root.curveX2 = root.clampReal(data.curveX2, 0, 1, root.curveX2)
      root.curveY2 = root.clampReal(data.curveY2, -1, 2, root.curveY2)

      if (typeof data.appearanceOverrideEnabled === "boolean")
        root.appearanceOverrideEnabled = data.appearanceOverrideEnabled
      root.islandEdgeMargin =
        root.clampInt(data.islandEdgeMargin, 0, 64, root.islandEdgeMargin)
      root.islandPadding =
        root.clampInt(data.islandPadding, 0, 64, root.islandPadding)
      root.islandGap =
        root.clampInt(data.islandGap, 0, 64, root.islandGap)
      root.islandInsetTop =
        root.clampInt(data.islandInsetTop, 0, 40, root.islandInsetTop)
      root.islandInsetBottom =
        root.clampInt(data.islandInsetBottom, 0, 40, root.islandInsetBottom)
      root.islandRadius =
        root.clampInt(data.islandRadius, 0, 64, root.islandRadius)
      root.islandOpacity =
        root.clampReal(data.islandOpacity, 0.05, 1, root.islandOpacity)

      if (typeof data.barSizeOverrideEnabled === "boolean")
        root.barSizeOverrideEnabled = data.barSizeOverrideEnabled
      root.barThickness =
        root.clampInt(data.barThickness, 18, 96, root.barThickness)
      root.iconScale =
        root.clampInt(data.iconScale, 60, 180, root.iconScale)

      if (typeof data.colorOverrideEnabled === "boolean")
        root.colorOverrideEnabled = data.colorOverrideEnabled
      root.barColor = root.hexColor(data.barColor, root.barColor)
      root.islandColor = root.hexColor(data.islandColor, root.islandColor)
      root.textColor = root.hexColor(data.textColor, root.textColor)
      root.accentColor = root.hexColor(data.accentColor, root.accentColor)
    }

    root.hydrating = false
    root.settingsLoaded = true
    root.diskData = (data && typeof data === "object") ? data : ({})
    if (firstLoad && !data)
      root.scheduleSave()
  }

  function scheduleSave() {
    if (!root.settingsLoaded || root.hydrating)
      return
    saveTimer.restart()
  }

  function saveSettings() {
    // Read-modify-write against the in-memory copy of the file. diskData is
    // kept current by the watcher's onLoaded, so merging onto it preserves any
    // keys another surface owns without a synchronous reload() here -- a
    // reload() would re-enter loadSettings() and revert the change being saved.
    var current = JSON.parse(JSON.stringify(root.diskData || ({})))

    var known = {
      version: 3,
      enabled: root.enabled,
      position: root.position,
      transparent: root.transparent,
      glassEnabled: root.glassEnabled,
      triggerThickness: root.triggerThickness,
      animationMode: root.animationMode,
      animationPreset: root.animationPreset,
      showSlideDuration: root.showSlideDuration,
      showFadeDuration: root.showFadeDuration,
      hideSlideDuration: root.hideSlideDuration,
      hideFadeDuration: root.hideFadeDuration,
      slideDistancePercent: root.slideDistancePercent,
      easing: root.easing,
      customCurveEnabled: root.customCurveEnabled,
      curveX1: root.curveX1,
      curveY1: root.curveY1,
      curveX2: root.curveX2,
      curveY2: root.curveY2,
      appearanceOverrideEnabled: root.appearanceOverrideEnabled,
      islandEdgeMargin: root.islandEdgeMargin,
      islandPadding: root.islandPadding,
      islandGap: root.islandGap,
      islandInsetTop: root.islandInsetTop,
      islandInsetBottom: root.islandInsetBottom,
      islandRadius: root.islandRadius,
      islandOpacity: root.islandOpacity,
      barSizeOverrideEnabled: root.barSizeOverrideEnabled,
      barThickness: root.barThickness,
      iconScale: root.iconScale,
      colorOverrideEnabled: root.colorOverrideEnabled,
      barColor: root.barColor,
      islandColor: root.islandColor,
      textColor: root.textColor,
      accentColor: root.accentColor
    }
    for (var key in known)
      current[key] = known[key]

    var serialized = JSON.stringify(current, null, 2) + "\n"
    if (serialized === root.lastWrittenText)
      return
    root.diskData = current
    root.lastWrittenText = serialized
    settingsFile.setText(serialized)
  }

  function setBarPosition(value) {
    var next = root.allowed(
      String(value || "top"),
      ["top", "bottom", "left", "right"],
      "top"
    )

    root.position = next
    root.scheduleSave()
  }

  function setTransparent(value) {
    root.transparent = value === true
    root.scheduleSave()
  }

  function setAnimationPreset(name) {
    var preset = root.allowed(
      name,
      ["Smooth", "Snappy", "Soft", "Custom"],
      "Custom"
    )

    root.animationPreset = preset

    if (preset === "Smooth") {
      root.showSlideDuration = 500
      root.showFadeDuration = 400
      root.hideSlideDuration = 400
      root.hideFadeDuration = 320
      root.easing = "Cubic"
      root.customCurveEnabled = false
    } else if (preset === "Snappy") {
      root.showSlideDuration = 240
      root.showFadeDuration = 180
      root.hideSlideDuration = 200
      root.hideFadeDuration = 150
      root.easing = "Quart"
      root.customCurveEnabled = false
    } else if (preset === "Soft") {
      root.showSlideDuration = 650
      root.showFadeDuration = 520
      root.hideSlideDuration = 540
      root.hideFadeDuration = 420
      root.easing = "Sine"
      root.customCurveEnabled = false
    }
  }

  function resetAnimationDefaults() {
    root.animationMode = "Slide + Fade"
    root.slideDistancePercent = 100
    root.curveX1 = 0.25
    root.curveY1 = 0.10
    root.curveX2 = 0.25
    root.curveY2 = 1.00
    root.setAnimationPreset("Smooth")
  }

  function resetAppearanceDefaults() {
    root.appearanceOverrideEnabled = false
    root.islandEdgeMargin = 8
    root.islandPadding = 8
    root.islandGap = 4
    root.islandInsetTop = 2
    root.islandInsetBottom = 2
    root.islandRadius = 12
    root.islandOpacity = 1.0
    root.glassEnabled = false
  }

  // --- Per-section resets used by the collapsible settings groups ---------

  function resetRevealDefaults() {
    root.triggerThickness = 5
  }

  function resetShowTimingDefaults() {
    root.showSlideDuration = 500
    root.showFadeDuration = 400
  }

  function resetHideTimingDefaults() {
    root.hideSlideDuration = 400
    root.hideFadeDuration = 320
  }

  function resetCurveDefaults() {
    root.customCurveEnabled = false
    root.curveX1 = 0.25
    root.curveY1 = 0.10
    root.curveX2 = 0.25
    root.curveY2 = 1.00
  }

  function resetTravelDefaults() {
    root.slideDistancePercent = 100
  }

  function resetIslandGeometryDefaults() {
    root.islandEdgeMargin = 8
    root.islandPadding = 8
    root.islandGap = 4
    root.islandInsetTop = 2
    root.islandInsetBottom = 2
    root.islandRadius = 12
    root.islandOpacity = 1.0
  }

  function resetBarSizeDefaults() {
    root.barSizeOverrideEnabled = false
    root.barThickness = 32
    root.iconScale = 100
  }

  function resetColorDefaults() {
    root.colorOverrideEnabled = false
    root.barColor = "#1e1e2e"
    root.islandColor = "#1e1e2e"
    root.textColor = "#cdd6f4"
    root.accentColor = "#89b4fa"
  }

  function versionCompare(a, b) {
    var pa = String(a).replace(/^v/i, "").split(/[.\-+]/)
    var pb = String(b).replace(/^v/i, "").split(/[.\-+]/)
    for (var i = 0; i < Math.max(pa.length, pb.length); i++) {
      var na = parseInt(pa[i] || "0", 10)
      var nb = parseInt(pb[i] || "0", 10)
      if (isNaN(na)) na = 0
      if (isNaN(nb)) nb = 0
      if (na !== nb) return na < nb ? -1 : 1
    }
    return 0
  }

  function checkForUpdate() {
    var slug = String(root.repositoryUrl || "")
      .replace(/^https?:\/\/github\.com\//i, "")
      .replace(/\/+$/, "")
    if (slug.split("/").length !== 2) {
      root.githubStatus = "Not configured"
      root.githubStatusMessage =
        "repositoryUrl is not a github.com/owner/repo URL, so updates cannot be checked."
      return
    }

    var current = root.manifest && root.manifest.version
      ? root.manifest.version : ""

    root.githubStatusLoading = true
    root.githubStatus = "Checking"
    root.githubStatusMessage = "Contacting GitHub for the latest release…"
    root.updateAvailable = false

    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
      if (request.readyState !== XMLHttpRequest.DONE)
        return

      root.githubStatusLoading = false

      if (request.status === 404) {
        root.githubStatus = "No releases"
        root.githubStatusMessage =
          "The repository has no published GitHub releases yet."
        return
      }
      if (request.status < 200 || request.status >= 300) {
        root.githubStatus = "Unavailable"
        root.githubStatusMessage =
          "Could not reach the GitHub releases API (HTTP " + request.status + ")."
        return
      }

      try {
        var data = JSON.parse(request.responseText)
        var tag = String(data.tag_name || data.name || "").trim()
        root.latestVersion = tag
        root.latestReleaseUrl = String(data.html_url || "")
        if (!tag) {
          root.githubStatus = "Unknown"
          root.githubStatusMessage = "The latest release did not report a version tag."
          return
        }
        if (current && root.versionCompare(current, tag) < 0) {
          root.updateAvailable = true
          root.githubStatus = "Update available"
          root.githubStatusMessage =
            "Installed " + current + " · latest release " + tag
            + ". Open the release page to download and reinstall."
        } else {
          root.githubStatus = "Up to date"
          root.githubStatusMessage =
            "Installed " + (current || "unknown") + " · latest release " + tag + "."
        }
      } catch (error) {
        root.githubStatus = "Invalid response"
        root.githubStatusMessage = "The GitHub releases API did not return valid JSON."
      }
    }

    request.open("GET", "https://api.github.com/repos/" + slug + "/releases/latest")
    request.setRequestHeader("Accept", "application/vnd.github+json")
    request.send()
  }

  function refreshIssueStatus() {
    if (!root.statusUrl) {
      root.githubStatus = "Not configured"
      root.githubStatusMessage =
        "GitHub status feed is not configured yet."
      return
    }

    root.githubStatusLoading = true
    root.githubStatus = "Checking"
    root.githubStatusMessage = "Contacting the project status feed…"

    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
      if (request.readyState !== XMLHttpRequest.DONE)
        return

      root.githubStatusLoading = false

      if (request.status < 200 || request.status >= 300) {
        root.githubStatus = "Unavailable"
        root.githubStatusMessage =
          "Could not read the GitHub status feed (HTTP "
          + request.status + ")."
        return
      }

      try {
        var data = JSON.parse(request.responseText)
        root.githubStatus = String(data.status || "Unknown")
        root.githubStatusMessage = String(
          data.message || "No project status message was provided."
        )
      } catch (error) {
        root.githubStatus = "Invalid response"
        root.githubStatusMessage =
          "The GitHub status feed did not contain valid JSON."
      }
    }

    request.open("GET", root.statusUrl)
    request.send()
  }

  function diagnosticReport() {
    var version = root.manifest && root.manifest.version
      ? root.manifest.version : "unknown"

    return [
      "Radyalz Bar Control diagnostics",
      "version: " + version,
      "bar connected: " + root.barConnected,
      "autohide enabled: " + root.enabled,
      "trigger active: " + root.triggerActive,
      "settings loaded: " + root.settingsLoaded,
      "position: " + root.position,
      "animation mode: " + root.animationMode,
      "animation preset: " + root.animationPreset,
      "custom curve: " + root.customCurveEnabled,
      "GitHub status: " + root.githubStatus
    ].join("\n")
  }

  onEnabledChanged: root.scheduleSave()
  onPositionChanged: root.scheduleSave()
  onTransparentChanged: root.scheduleSave()
  onGlassEnabledChanged: root.scheduleSave()
  onTriggerThicknessChanged: root.scheduleSave()
  onAnimationModeChanged: root.scheduleSave()
  onAnimationPresetChanged: root.scheduleSave()
  onShowSlideDurationChanged: root.scheduleSave()
  onShowFadeDurationChanged: root.scheduleSave()
  onHideSlideDurationChanged: root.scheduleSave()
  onHideFadeDurationChanged: root.scheduleSave()
  onSlideDistancePercentChanged: root.scheduleSave()
  onEasingChanged: root.scheduleSave()
  onCustomCurveEnabledChanged: root.scheduleSave()
  onCurveX1Changed: root.scheduleSave()
  onCurveY1Changed: root.scheduleSave()
  onCurveX2Changed: root.scheduleSave()
  onCurveY2Changed: root.scheduleSave()
  onAppearanceOverrideEnabledChanged: root.scheduleSave()
  onIslandEdgeMarginChanged: root.scheduleSave()
  onIslandPaddingChanged: root.scheduleSave()
  onIslandGapChanged: root.scheduleSave()
  onIslandInsetTopChanged: root.scheduleSave()
  onIslandInsetBottomChanged: root.scheduleSave()
  onIslandRadiusChanged: root.scheduleSave()
  onIslandOpacityChanged: root.scheduleSave()
  onBarSizeOverrideEnabledChanged: root.scheduleSave()
  onBarThicknessChanged: root.scheduleSave()
  onIconScaleChanged: root.scheduleSave()
  onColorOverrideEnabledChanged: root.scheduleSave()
  onBarColorChanged: root.scheduleSave()
  onIslandColorChanged: root.scheduleSave()
  onTextColorChanged: root.scheduleSave()
  onAccentColorChanged: root.scheduleSave()

}
