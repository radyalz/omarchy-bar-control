import QtQuick

Flow {
  id: root
  property var options: []
  property string value: ""
  signal selected(string value)
  spacing: 7

  Repeater {
    model: root.options
    ChoicePill {
      required property string modelData
      text: modelData
      active: root.value === modelData
      enabled: root.enabled
      onClicked: root.selected(modelData)
    }
  }
}
