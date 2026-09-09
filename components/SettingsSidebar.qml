import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts

Rectangle {
  id: root

  property var pageNames: []
  property int currentPage: 0
  property var service: null
  signal pageSelected(int index)

  color: "#13161b"

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 14
    spacing: 8

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      Text {
        text: "Radyalz Bar Control"
        color: "#f3f4f6"
        font.pixelSize: 17
        font.weight: Font.DemiBold
      }

      Text {
        text: "Bar control center"
        color: "#6b7280"
        font.pixelSize: 11
      }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: "#272b33" }

    Repeater {
      model: root.pageNames

      QQC.Button {
        required property string modelData
        required property int index
        Layout.fillWidth: true
        text: modelData
        checkable: true
        checked: root.currentPage === index
        onClicked: root.pageSelected(index)
      }
    }

    Item { Layout.fillHeight: true }
    Rectangle { Layout.fillWidth: true; height: 1; color: "#272b33" }

    Text {
      Layout.fillWidth: true
      text: root.service && root.service.enabled
        ? "Autohide active" : "Autohide inactive"
      color: root.service && root.service.enabled ? "#9ece6a" : "#9ca3af"
      font.pixelSize: 11
    }
  }
}
