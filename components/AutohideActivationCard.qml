import QtQuick
import QtQuick.Layouts

InfoCard {
  id: root
  property var service: null

  RowLayout {
    Layout.fillWidth: true
    spacing: 14
    ColumnLayout {
      Layout.fillWidth: true; spacing: 3
      Text { text: "Autohide"; color: "#f4f6fb"; font.pixelSize: 16; font.weight: Font.DemiBold }
      Text {
        Layout.fillWidth: true
        text: root.service && root.service.enabled
          ? "Active · reveal from the screen edge" : "Disabled · bar stays visible"
        color: root.service && root.service.enabled ? "#8fb6ff" : "#8d95a3"
        font.pixelSize: 11; wrapMode: Text.WordWrap
      }
    }
    GlassToggle {
      checked: root.service ? root.service.enabled : false
      enabled: root.service !== null
      onToggled: function(value) { if (root.service) root.service.enabled = value }
    }
  }
}
