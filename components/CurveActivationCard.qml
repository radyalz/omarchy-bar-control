import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root
  property var service: null

  RowLayout {
    Layout.fillWidth: true
    ColumnLayout {
      Layout.fillWidth: true; spacing: 2
      Text { text: "Custom curve"; color: Color.foreground; font.pixelSize: 14; font.weight: Font.DemiBold }
      Text {
        Layout.fillWidth: true
        text: "Use one Bézier curve for both show and hide motion."
        color: Qt.alpha(Color.foreground, 0.6); font.pixelSize: 11; wrapMode: Text.WordWrap
      }
    }
    GlassToggle {
      checked: root.service ? root.service.customCurveEnabled : false
      enabled: root.service !== null
      onToggled: function(value) { if (root.service) { root.service.customCurveEnabled = value; root.service.animationPreset = "Custom" } }
    }
  }
}
