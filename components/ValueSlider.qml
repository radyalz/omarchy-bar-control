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
  spacing: 4

  RowLayout {
    Layout.fillWidth: true

    Text {
      text: root.label
      color: root.enabled ? "#d1d5db" : "#6b7280"
      font.pixelSize: 13
    }

    Item { Layout.fillWidth: true }

    Text {
      text: Number(root.value).toFixed(root.decimals) + root.suffix
      color: root.enabled ? "#9ca3af" : "#5b616b"
      font.pixelSize: 12
    }
  }

  QQC.Slider {
    Layout.fillWidth: true
    from: root.from
    to: root.to
    stepSize: root.stepSize
    value: root.value
    enabled: root.enabled
    onMoved: root.edited(value)
  }
}
