import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

InfoCard {
  id: root

  property var service: null

  SettingRow {
    label: "Transparent bar"

    QQC.Switch {
      checked: root.service ? root.service.currentTransparent : false
      enabled: root.service !== null
      onToggled: if (root.service) root.service.setTransparent(checked)
    }
  }

  RowLayout {
    Layout.fillWidth: true

    ColumnLayout {
      Layout.fillWidth: true

      Text {
        text: "Custom island appearance"
        color: "#d1d5db"
        font.pixelSize: 13
      }

      Text {
        text: "Off preserves the original Islands Bar styling."
        color: "#7f8793"
        font.pixelSize: 11
      }
    }

    QQC.Switch {
      checked: root.service ? root.service.appearanceOverrideEnabled : false
      enabled: root.service !== null
      onToggled: if (root.service)
        root.service.appearanceOverrideEnabled = checked
    }
  }
}
