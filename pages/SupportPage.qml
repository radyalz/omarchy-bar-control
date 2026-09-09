import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  PageTitle {
    title: "Support"
    description: "Open the project repository or report a problem from here."
  }

  InfoCard {
    Text {
      text: "GitHub"
      color: "#f3f4f6"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    RowLayout {
      Layout.fillWidth: true

      QQC.Button {
        text: "Open repository"
        enabled: root.service && root.service.repositoryUrl !== ""
        onClicked: if (root.service) Qt.openUrlExternally(root.service.repositoryUrl)
      }

      QQC.Button {
        text: "Report an issue"
        enabled: root.service && root.service.issuesUrl !== ""
        onClicked: if (root.service) Qt.openUrlExternally(root.service.issuesUrl)
      }

      Item { Layout.fillWidth: true }
    }

    Text {
      Layout.fillWidth: true
      text: root.service && root.service.repositoryUrl !== ""
        ? root.service.repositoryUrl
        : "Repository URL not configured yet."
      color: "#7f8793"
      font.pixelSize: 11
      wrapMode: Text.WrapAnywhere
    }
  }

  InfoCard {
    Text {
      text: "Before reporting a problem"
      color: "#f3f4f6"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    Text {
      Layout.fillWidth: true
      text: "Open Diagnostics first. It shows whether the bar, autohide module, edge trigger, settings file, and GitHub project status are healthy."
      color: "#9ca3af"
      font.pixelSize: 12
      wrapMode: Text.WordWrap
    }
  }
}
