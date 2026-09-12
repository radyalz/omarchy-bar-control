import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons

// Popup HSV colour picker: saturation/value square, hue slider, alpha slider
// and a hex field. Emits picked() with an #aarrggbb string as the user drags.
QQC.Popup {
  id: root

  property string value: "#ffffffff"
  signal picked(string hex)

  padding: 10
  focus: true
  closePolicy: QQC.Popup.CloseOnEscape | QQC.Popup.CloseOnPressOutside
  implicitWidth: 228
  implicitHeight: 298

  enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 110 } }
  exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 90 } }

  property real hue: 0
  property real sat: 0
  property real val: 1
  property real alpha: 1
  property bool syncing: false

  readonly property color parsed:
    /^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(root.value) ? root.value : "#ffffffff"
  readonly property color current: Qt.hsva(root.hue, root.sat, root.val, root.alpha)

  function clamp01(x) { return Math.max(0, Math.min(1, x)) }

  function hex2(n) {
    var s = Math.round(root.clamp01(n) * 255).toString(16)
    return s.length < 2 ? "0" + s : s
  }
  function toHex() {
    var c = root.current
    return "#" + hex2(c.a) + hex2(c.r) + hex2(c.g) + hex2(c.b)
  }

  function loadFrom() {
    root.syncing = true
    var c = root.parsed
    root.hue = c.hsvHue < 0 ? 0 : c.hsvHue
    root.sat = c.hsvSaturation
    root.val = c.hsvValue
    root.alpha = c.a
    root.syncing = false
  }
  function emitPick() {
    if (!root.syncing) root.picked(root.toHex())
  }

  onAboutToShow: loadFrom()

  background: Rectangle {
    color: Qt.rgba(Color.background.r, Color.background.g, Color.background.b, 0.98)
    border.color: Qt.alpha(Color.foreground, 0.18)
    border.width: 1
    radius: 4
  }

  contentItem: ColumnLayout {
    spacing: 8

    Item {
      Layout.preferredWidth: 208
      Layout.preferredHeight: 150

      Canvas {
        id: sv
        anchors.fill: parent
        onPaint: {
          var ctx = getContext("2d")
          ctx.fillStyle = Qt.hsva(root.hue, 1, 1, 1)
          ctx.fillRect(0, 0, width, height)
          var gx = ctx.createLinearGradient(0, 0, width, 0)
          gx.addColorStop(0, "rgba(255,255,255,1)")
          gx.addColorStop(1, "rgba(255,255,255,0)")
          ctx.fillStyle = gx
          ctx.fillRect(0, 0, width, height)
          var gy = ctx.createLinearGradient(0, 0, 0, height)
          gy.addColorStop(0, "rgba(0,0,0,0)")
          gy.addColorStop(1, "rgba(0,0,0,1)")
          ctx.fillStyle = gy
          ctx.fillRect(0, 0, width, height)
        }
      }
      Rectangle {
        width: 12; height: 12; radius: 6
        border.width: 2; border.color: "#ffffff"
        color: "transparent"
        x: root.sat * parent.width - width / 2
        y: (1 - root.val) * parent.height - height / 2
      }
      MouseArea {
        anchors.fill: parent
        function handle(mx, my) {
          root.sat = root.clamp01(mx / width)
          root.val = root.clamp01(1 - my / height)
          root.emitPick()
        }
        onPressed: function(m) { handle(m.x, m.y) }
        onPositionChanged: function(m) { if (pressed) handle(m.x, m.y) }
      }
      Connections { target: root; function onHueChanged() { sv.requestPaint() } }
      Component.onCompleted: sv.requestPaint()
    }

    // Hue
    Rectangle {
      Layout.fillWidth: true
      implicitHeight: 14
      radius: 3
      gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.000; color: "#ff0000" }
        GradientStop { position: 0.167; color: "#ffff00" }
        GradientStop { position: 0.333; color: "#00ff00" }
        GradientStop { position: 0.500; color: "#00ffff" }
        GradientStop { position: 0.667; color: "#0000ff" }
        GradientStop { position: 0.833; color: "#ff00ff" }
        GradientStop { position: 1.000; color: "#ff0000" }
      }
      Rectangle {
        width: 4; height: parent.height + 4; y: -2
        color: "#ffffff"; border.width: 1; border.color: "#000000"
        x: root.hue * (parent.width - width)
      }
      MouseArea {
        anchors.fill: parent
        function handle(mx) { root.hue = root.clamp01(mx / width); root.emitPick() }
        onPressed: function(m) { handle(m.x) }
        onPositionChanged: function(m) { if (pressed) handle(m.x) }
      }
    }

    // Alpha
    RowLayout {
      Layout.fillWidth: true
      Text { text: "Opacity"; color: Qt.alpha(Color.foreground, 0.7); font.pixelSize: 10 }
      Item { Layout.fillWidth: true }
      Text {
        text: Math.round(root.alpha * 100) + "%"
        color: Color.foreground
        font.pixelSize: 10
      }
    }
    Rectangle {
      Layout.fillWidth: true
      implicitHeight: 14
      radius: 3
      color: "#808080"
      Rectangle {
        anchors.fill: parent
        radius: 3
        gradient: Gradient {
          orientation: Gradient.Horizontal
          GradientStop { position: 0; color: Qt.hsva(root.hue, root.sat, root.val, 0) }
          GradientStop { position: 1; color: Qt.hsva(root.hue, root.sat, root.val, 1) }
        }
      }
      Rectangle {
        width: 4; height: parent.height + 4; y: -2
        color: "#ffffff"; border.width: 1; border.color: "#000000"
        x: root.alpha * (parent.width - width)
      }
      MouseArea {
        anchors.fill: parent
        function handle(mx) { root.alpha = root.clamp01(mx / width); root.emitPick() }
        onPressed: function(m) { handle(m.x) }
        onPositionChanged: function(m) { if (pressed) handle(m.x) }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 8
      Rectangle {
        implicitWidth: 24; implicitHeight: 24; radius: 4
        color: root.current
        border.width: 1; border.color: Qt.alpha(Color.foreground, 0.2)
      }
      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 26
        radius: 4
        color: Qt.alpha(Color.foreground, 0.06)
        border.width: 1
        border.color: hexIn.activeFocus ? Color.accent : Qt.alpha(Color.foreground, 0.12)
        TextInput {
          id: hexIn
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8
          verticalAlignment: TextInput.AlignVCenter
          clip: true
          color: Color.foreground
          selectionColor: Color.accent
          selectByMouse: true
          font.pixelSize: 11
          text: root.toHex()
          onEditingFinished: {
            var v = text.trim().toLowerCase()
            if (v.length > 0 && v.charAt(0) !== "#") v = "#" + v
            if (/^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(v)) {
              root.value = v
              root.loadFrom()
              root.emitPick()
            } else {
              text = root.toHex()
            }
          }
        }
      }
    }
  }
}
