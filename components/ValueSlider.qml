import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons

// One compact setting row: label (+ optional description) on the left, a slider
// in the middle, an editable number field on the right. Collapses to a stack
// when the row is too narrow to hold all three side by side.
ColumnLayout {
  id: root
  property string label: ""
  property string description: ""
  property real from: 0
  property real to: 100
  property real stepSize: 1
  property real value: 0
  property int decimals: 0
  property string suffix: ""
  signal edited(real value)

  Layout.fillWidth: true
  spacing: 4

  readonly property bool stacked: root.width > 0 && root.width < 430

  GridLayout {
    Layout.fillWidth: true
    columns: root.stacked ? 1 : 3
    columnSpacing: 12
    rowSpacing: 6

    ColumnLayout {
      Layout.fillWidth: root.stacked
      Layout.preferredWidth: root.stacked ? -1 : 172
      spacing: 1
      Text {
        text: root.label
        color: root.enabled ? Color.foreground : Qt.alpha(Color.foreground, 0.4)
        font.pixelSize: 12
      }
      Text {
        visible: root.description !== ""
        Layout.fillWidth: true
        text: root.description
        color: root.enabled ? Qt.alpha(Color.foreground, 0.6) : Qt.alpha(Color.foreground, 0.35)
        font.pixelSize: 10
        wrapMode: Text.WordWrap
      }
    }

    QQC.Slider {
      id: slider
      Layout.fillWidth: true
      implicitHeight: 24
      topPadding: 0
      bottomPadding: 0
      from: root.from
      to: root.to
      stepSize: root.stepSize
      snapMode: QQC.Slider.SnapAlways
      enabled: root.enabled
      onMoved: root.edited(value)

      // Track root.value while the user is not dragging. A plain
      // `value: root.value` binding is destroyed the first time the handle is
      // moved, after which resets, presets and external edits stop moving it.
      Binding {
        target: slider
        property: "value"
        value: root.value
        when: !slider.pressed
        restoreMode: Binding.RestoreBinding
      }

      background: Rectangle {
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 160
        implicitHeight: 5
        width: slider.availableWidth
        height: 5
        radius: 2
        color: Qt.alpha(Color.foreground, 0.12)
        Rectangle {
          width: parent.width * slider.visualPosition
          height: parent.height
          radius: 2
          color: Color.accent
        }
      }
      handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        width: 16
        height: 16
        radius: 4
        color: Color.foreground
        border.width: 3
        border.color: Color.accent
      }
    }

    NumberField {
      Layout.alignment: Qt.AlignVCenter
      value: root.value
      from: root.from
      to: root.to
      stepSize: root.stepSize
      decimals: root.decimals
      suffix: root.suffix
      enabled: root.enabled
      onEdited: function(v) { root.edited(v) }
    }
  }
}
