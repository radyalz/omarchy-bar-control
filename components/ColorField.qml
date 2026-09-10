import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import qs.Commons

// One colour row: label + swatch + hex field, with the description on its own
// full-width line below. Accepts #rrggbb or #aarrggbb; the hex border turns red
// while the text is not a valid colour, and only valid values are emitted.
// Clicking the swatch opens an HSV picker, which is only instantiated on demand.
ColumnLayout {
  id: root
  property string label: ""
  property string description: ""
  property string value: "#000000"
  property bool pickerOpen: false
  signal edited(string value)

  Layout.fillWidth: true
  spacing: 3

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

  RowLayout {
    Layout.fillWidth: true
    spacing: 12

    Text {
      Layout.fillWidth: true
      text: root.label
      color: root.enabled ? Color.foreground : Qt.alpha(Color.foreground, 0.4)
      font.pixelSize: 12
      elide: Text.ElideRight
    }

    Rectangle {
      id: swatch
      Layout.alignment: Qt.AlignVCenter
      implicitWidth: 22
      implicitHeight: 22
      radius: 4
      opacity: root.enabled ? 1 : 0.4
      color: root.valid(root.value) ? root.value : "transparent"
      border.width: 1
      border.color: root.pickerOpen ? Color.accent : Qt.alpha(Color.foreground, 0.2)

      MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.pickerOpen = !root.pickerOpen
      }

      Loader {
        active: root.pickerOpen
        sourceComponent: ColorPicker {
          value: root.value
          onPicked: function(hex) { root.edited(hex) }
          onClosed: root.pickerOpen = false
          Component.onCompleted: {
            var wp = swatch.mapToItem(null, 0, 0)
            var winW = (swatch.Window && swatch.Window.width > 0) ? swatch.Window.width : 820
            var winH = (swatch.Window && swatch.Window.height > 0) ? swatch.Window.height : 620
            var overRight = (wp.x + implicitWidth) - (winW - 10)
            x = overRight > 0 ? -overRight : 0
            var below = swatch.height + 6
            var overBottom = (wp.y + below + implicitHeight) - (winH - 10)
            y = overBottom > 0 ? -(implicitHeight + 6) : below
            open()
          }
        }
      }
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

  Text {
    visible: root.description !== ""
    Layout.fillWidth: true
    text: root.description
    color: Qt.alpha(Color.foreground, root.enabled ? 0.6 : 0.35)
    font.pixelSize: 10
    wrapMode: Text.WordWrap
  }
}
