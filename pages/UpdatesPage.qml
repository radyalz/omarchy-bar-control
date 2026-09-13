import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons
import "../components"
import "../Version.js" as Version

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Updates"
    description: "Check GitHub for a newer release, and install it without leaving this window."
  }

  InfoCard {
    RowLayout {
      Layout.fillWidth: true
      spacing: 12
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 3
        Text {
          text: "Installed version " + Version.number
          color: Color.foreground
          font.pixelSize: 14
          font.weight: Font.DemiBold
        }
        Text {
          Layout.fillWidth: true
          text: root.service ? root.service.githubStatusMessage : "Service is not available."
          color: Qt.alpha(Color.foreground, 0.6)
          font.pixelSize: 12
          wrapMode: Text.WordWrap
        }
      }
      GlassButton {
        Layout.alignment: Qt.AlignTop
        text: root.service && root.service.githubStatusLoading ? "Checking…" : "Check for updates"
        enabled: root.service !== null && !root.service.githubStatusLoading
          && !(root.service && root.service.updateInstallActive)
        onClicked: if (root.service) root.service.checkForUpdate()
      }
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 10
    visible: root.service && root.service.updateAvailable && !root.service.updateInstallActive

    InfoCard {
      Layout.fillWidth: true
      RowLayout {
        Layout.fillWidth: true
        spacing: 12
        ColumnLayout {
          Layout.fillWidth: true
          spacing: 3
          Text {
            text: "Update available: " + (root.service ? root.service.latestVersion : "")
            color: Color.accent
            font.pixelSize: 14
            font.weight: Font.DemiBold
          }
          Text {
            Layout.fillWidth: true
            text: "Installing downloads the tagged source from GitHub, then runs its own installer. Your Omarchy shell will restart partway through — this is expected, and this window will close when it does."
            color: Qt.alpha(Color.foreground, 0.6)
            font.pixelSize: 11
            wrapMode: Text.WordWrap
          }
        }
        GlassButton {
          Layout.alignment: Qt.AlignTop
          primary: true
          text: "Install update"
          enabled: root.service !== null
          onClicked: if (root.service) root.service.installUpdate()
        }
        GlassButton {
          Layout.alignment: Qt.AlignTop
          text: "Open release page"
          enabled: root.service && root.service.latestReleaseUrl !== ""
          onClicked: if (root.service) Qt.openUrlExternally(root.service.latestReleaseUrl)
        }
      }
    }
  }

  InfoCard {
    Layout.fillWidth: true
    visible: root.service && root.service.updateInstallActive

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 8

      Text {
        text: root.service ? root.service.updateInstallStage : ""
        color: Color.foreground
        font.pixelSize: 13
        font.weight: Font.DemiBold
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
      }
      QQC.ProgressBar {
        Layout.fillWidth: true
        from: 0; to: 1
        value: root.service ? root.service.updateInstallProgress : 0
        indeterminate: false
      }
      Text {
        Layout.fillWidth: true
        visible: text !== ""
        text: root.service ? root.service.updateInstallDetail : ""
        color: Qt.alpha(Color.foreground, 0.55)
        font.pixelSize: 10
        font.family: "monospace"
        elide: Text.ElideRight
      }
    }
  }

  InfoCard {
    Layout.fillWidth: true
    visible: root.service && root.service.updateInstallError !== ""

    Text {
      Layout.fillWidth: true
      text: root.service ? root.service.updateInstallError : ""
      color: Color.urgent
      font.pixelSize: 12
      wrapMode: Text.WordWrap
    }
  }

  Text {
    Layout.fillWidth: true
    text: "Prefer to do it yourself? git pull the repo and run ./install.sh — this page does exactly that under the hood."
    color: Qt.alpha(Color.foreground, 0.45)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }
}
