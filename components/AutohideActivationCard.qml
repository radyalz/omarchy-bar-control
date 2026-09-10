import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root
  property var service: null

  RowLayout {
    Layout.fillWidth: true
    spacing: 14
    ColumnLayout {
      Layout.fillWidth: true; spacing: 3
      Text { text: "Autohide"; color: Color.foreground; font.pixelSize: 16; font.weight: Font.DemiBold }
      Text {
        Layout.fillWidth: true
        text: root.service && root.service.enabled
          ? "Active · reveal from the screen edge" : "Disabled · bar stays visible"
        color: root.service && root.service.enabled ? Color.accent : Qt.alpha(Color.foreground, 0.6)
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
