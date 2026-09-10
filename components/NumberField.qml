import QtQuick
import QtQuick.Layouts

// Compact editable numeric field. Parses on Enter / focus-out, clamps to
// [from, to], snaps to stepSize, then emits edited(). Stays in sync with an
// external value while it does not have focus.
Rectangle {
  id: root

  property real value: 0
  property real from: 0
  property real to: 100
  property real stepSize: 1
  property int decimals: 0
  property string suffix: ""

  signal edited(real value)

  implicitWidth: root.decimals > 0 ? 84 : 72
  implicitHeight: 26
  radius: 4
  color: root.enabled ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(1, 1, 1, 0.03)
  border.width: 1
  border.color: input.activeFocus ? "#829cff" : Qt.rgba(1, 1, 1, 0.10)

  function formatted(n) {
    return Number(n).toFixed(root.decimals)
  }

  function syncText() {
    if (!input.activeFocus)
      input.text = root.formatted(root.value)
  }

  function commit() {
    var n = Number(input.text)
    if (!isFinite(n)) {
      input.text = root.formatted(root.value)
      return
    }
    n = Math.max(root.from, Math.min(root.to, n))
    if (root.stepSize > 0)
      n = Math.round(n / root.stepSize) * root.stepSize
    n = Number(n.toFixed(root.decimals))
    input.text = root.formatted(n)
    root.edited(n)
  }

  onValueChanged: root.syncText()

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    spacing: 2

    TextInput {
      id: input
      Layout.fillWidth: true
      verticalAlignment: TextInput.AlignVCenter
      horizontalAlignment: TextInput.AlignHCenter
      clip: true
      enabled: root.enabled
      color: root.enabled ? "#e6eaf3" : "#6b7280"
      selectionColor: "#829cff"
      font.pixelSize: 11
      selectByMouse: true
      inputMethodHints: Qt.ImhFormattedNumbersOnly
      text: root.formatted(root.value)
      onEditingFinished: root.commit()
      Keys.onReturnPressed: root.commit()
      Keys.onEnterPressed: root.commit()
    }

    Text {
      visible: root.suffix !== ""
      text: root.suffix.trim()
      color: root.enabled ? "#7f8793" : "#5c636f"
      font.pixelSize: 10
    }
  }
}
