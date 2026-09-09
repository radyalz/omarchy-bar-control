import QtQuick
import QtQuick.Layouts

InfoCard {
  id: root
  property var service: null

  SettingRow {
    label: "Transparent bar"
    GlassToggle {
      checked: root.service ? root.service.currentTransparent : false
      enabled: root.service !== null
      onToggled: function(value) { if (root.service) root.service.setTransparent(value) }
    }
  }
  RowLayout {
    Layout.fillWidth: true
    ColumnLayout {
      Layout.fillWidth: true; spacing: 2
      Text { text: "Custom island appearance"; color: "#d7dce6"; font.pixelSize: 12 }
      Text { text: "Enable geometry and opacity controls."; color: "#7f8793"; font.pixelSize: 10 }
    }
    GlassToggle {
      checked: root.service ? root.service.appearanceOverrideEnabled : false
      enabled: root.service !== null
      onToggled: function(value) { if (root.service) root.service.appearanceOverrideEnabled = value }
    }
  }
}
