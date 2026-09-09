import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

InfoCard {
  id: root

  property var service: null

  RowLayout {
    Layout.fillWidth: true

    ColumnLayout {
      Layout.fillWidth: true

      Text {
        text: "Use custom curve"
        color: "#f3f4f6"
        font.pixelSize: 15
        font.weight: Font.DemiBold
      }

      Text {
        Layout.fillWidth: true
        text: "When enabled, this curve replaces the easing family for both show and hide motion."
        color: "#8b93a0"
        font.pixelSize: 12
        wrapMode: Text.WordWrap
      }
    }

    QQC.Switch {
      checked: root.service ? root.service.customCurveEnabled : false
      enabled: root.service !== null
      onToggled: if (root.service) {
        root.service.customCurveEnabled = checked
        root.service.animationPreset = "Custom"
      }
    }
  }
}
