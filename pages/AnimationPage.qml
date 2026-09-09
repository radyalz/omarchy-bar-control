import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root

  property var service: null

  PageTitle {
    title: "Animation"
    description: "Choose what the bar does, how it feels, and how quickly each part moves."
  }

  AnimationBasics { service: root.service }
  AnimationTiming { service: root.service; showing: true }
  AnimationTiming { service: root.service; showing: false }

  RowLayout {
    Layout.fillWidth: true
    Item { Layout.fillWidth: true }

    QQC.Button {
      text: "Reset animation"
      enabled: root.service !== null
      onClicked: if (root.service) root.service.resetAnimationDefaults()
    }
  }
}
