import QtQuick
import QtQuick.Layouts
import qs.Commons

// One colour row: label (+ optional description), a preview swatch, and a hex
// text field. Accepts #rrggbb or #aarrggbb; the field border turns red while
// the text is not a valid hex colour, and only valid values are emitted.
RowLayout {
  id: root
  property string label: ""
  property string description: ""
  property string value: "#000000"
  signal edited(string value)

  Layout.fillWidth: true
  spacing: 12

  function valid(text) {
    return /^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(String(text))
  }

  function commit() {
    var v = hexInput.text.trim().toLowerCase()
    if (v.length > 0 && v.charAt(0) !== "#")
      v = "#" + v
    if (root.valid(v)) {
      hexInput.text = v
      root.edited(v)
    } else {
      hexInput.text = root.value
    }
  }

  onValueChanged: if (!hexInput.activeFocus) hexInput.text = root.value

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2
    Text {
      text: root.label
      color: root.enabled ? Color.foreground : Qt.alpha(Color.foreground, 0.4)
      font.pixelSize: 12
    }
    Text {
      visible: root.description !== ""
      Layout.fillWidth: true
      text: root.description
      color: Qt.alpha(Color.foreground, root.enabled ? 0.6 : 0.35)
      font.pixelSize: 10
      wrapMode: Text.WordWrap
    }
  }

  Rectangle {
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 22
    implicitHeight: 22
    radius: 4
    opacity: root.enabled ? 1 : 0.4
    color: root.valid(root.value) ? root.value : "transparent"
    border.width: 1
    border.color: Qt.alpha(Color.foreground, 0.2)
  }

  Rectangle {
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 100
    implicitHeight: 26
    radius: 4
    color: root.enabled ? Qt.alpha(Color.foreground, 0.06) : Qt.alpha(Color.foreground, 0.03)
    border.width: 1
    border.color: hexInput.activeFocus
      ? Color.accent
      : (root.valid(hexInput.text) ? Qt.alpha(Color.foreground, 0.1) : Color.urgent)

    TextInput {
      id: hexInput
      anchors.fill: parent
      anchors.leftMargin: 8
      anchors.rightMargin: 8
      verticalAlignment: TextInput.AlignVCenter
      clip: true
      enabled: root.enabled
      color: root.enabled ? Color.foreground : Qt.alpha(Color.foreground, 0.4)
      selectionColor: Color.accent
      font.pixelSize: 11
      selectByMouse: true
      text: root.value
      onEditingFinished: root.commit()
      Keys.onReturnPressed: root.commit()
      Keys.onEnterPressed: root.commit()
    }
  }
}
