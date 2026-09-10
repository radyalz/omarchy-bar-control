import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

ColumnLayout {
  id: root
  property string label: ""
  property real from: 0
  property real to: 100
  property real stepSize: 1
  property real value: 0
  property int decimals: 0
  property string suffix: ""
  signal edited(real value)
  Layout.fillWidth: true
  spacing: 5

  RowLayout {
    Layout.fillWidth: true
    Text { text: root.label; color: root.enabled ? "#cbd1dc" : "#626a78"; font.pixelSize: 12 }
    Item { Layout.fillWidth: true }
    Rectangle {
      implicitWidth: valueLabel.implicitWidth + 14; implicitHeight: 24; radius: 8
      color: Qt.rgba(1, 1, 1, 0.055); border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.07)
      Text {
        id: valueLabel; anchors.centerIn: parent
        text: Number(root.value).toFixed(root.decimals) + root.suffix
        color: root.enabled ? "#aeb8cb" : "#626a78"; font.pixelSize: 10
      }
    }
  }
  QQC.Slider {
    id: slider
    Layout.fillWidth: true
    from: root.from; to: root.to; stepSize: root.stepSize
    enabled: root.enabled; onMoved: root.edited(value)

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
      x: slider.leftPadding; y: slider.topPadding + slider.availableHeight / 2 - height / 2
      width: slider.availableWidth; height: 5; radius: 3; color: Qt.rgba(1, 1, 1, 0.09)
      Rectangle { width: parent.width * slider.visualPosition; height: parent.height; radius: 3; color: "#829cff" }
    }
    handle: Rectangle {
      x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
      y: slider.topPadding + slider.availableHeight / 2 - height / 2
      width: 16; height: 16; radius: 8; color: "#f7f9ff"
      border.width: 3; border.color: "#829cff"
    }
  }
}
