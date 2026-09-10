import QtQuick
import QtQuick.Layouts
import qs.Commons

InfoCard {
  id: root

  property var service: null

  RowLayout {
    Layout.fillWidth: true
    spacing: 12

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 3

      Text {
        text: root.service ? root.service.githubStatus : "Unavailable"
        color: root.service && root.service.updateAvailable ? Color.accent : Color.foreground
        font.pixelSize: 15
        font.weight: Font.DemiBold
      }

      Text {
        Layout.fillWidth: true
        text: root.service
          ? root.service.githubStatusMessage
          : "Service is not available."
        color: Qt.alpha(Color.foreground, 0.6)
        font.pixelSize: 12
        wrapMode: Text.WordWrap
      }
    }

    ColumnLayout {
      Layout.alignment: Qt.AlignTop
      spacing: 6
      GlassButton {
        Layout.alignment: Qt.AlignRight
        text: root.service && root.service.githubStatusLoading
          ? "Checking…" : "Check for updates"
        enabled: root.service !== null && !root.service.githubStatusLoading
        onClicked: if (root.service) root.service.checkForUpdate()
      }
      GlassButton {
        Layout.alignment: Qt.AlignRight
        visible: root.service && root.service.updateAvailable
          && root.service.latestReleaseUrl !== ""
        primary: true
        text: "Open release"
        onClicked: if (root.service) Qt.openUrlExternally(root.service.latestReleaseUrl)
      }
    }
  }
}
