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
        text: root.service ? root.service.githubStatus : "Unavailable"
        color: "#f3f4f6"
        font.pixelSize: 15
        font.weight: Font.DemiBold
      }

      Text {
        Layout.fillWidth: true
        text: root.service
          ? root.service.githubStatusMessage
          : "Service is not available."
        color: "#8b93a0"
        font.pixelSize: 12
        wrapMode: Text.WordWrap
      }
    }

    QQC.Button {
      text: root.service && root.service.githubStatusLoading
        ? "Checking…" : "Check status"
      enabled: root.service !== null && !root.service.githubStatusLoading
      onClicked: if (root.service) root.service.refreshIssueStatus()
    }
  }
}
