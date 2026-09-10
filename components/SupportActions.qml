import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root
  property var service: null

  Text {
    text: "Project & support"
    color: Color.foreground
    font.pixelSize: 15
    font.weight: Font.DemiBold
  }
  RowLayout {
    Layout.fillWidth: true
    GlassButton {
      text: "GitHub"
      enabled: root.service && root.service.repositoryUrl !== ""
      onClicked: if (root.service) Qt.openUrlExternally(root.service.repositoryUrl)
    }
    GlassButton {
      text: "Report issue"
      enabled: root.service && root.service.issuesUrl !== ""
      onClicked: if (root.service) Qt.openUrlExternally(root.service.issuesUrl)
    }
    Item { Layout.fillWidth: true }
  }
  Text {
    Layout.fillWidth: true
    text: "Use Diagnostics before reporting a problem so the report includes the bar, settings, trigger and integration state."
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 11
    wrapMode: Text.WordWrap
  }
}
