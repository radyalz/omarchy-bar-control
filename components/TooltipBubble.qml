import QtQuick
import qs.Commons

// Lightweight hover tooltip: appears below its parent after a short delay,
// fading in with a small downward slide and fading out faster. Not a Popup, so
// it has no overlay dependency and the animation is fully controlled here.
Rectangle {
  id: root
  property string text: ""
  property bool shown: false
  property int delay: 350

  anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
  anchors.top: parent ? parent.bottom : undefined
  anchors.topMargin: opacity > 0.5 ? 6 : 1
  z: 9999

  visible: opacity > 0.01 && root.text !== ""
  opacity: 0
  radius: 4
  color: Qt.rgba(Color.tooltip.background.r, Color.tooltip.background.g,
                 Color.tooltip.background.b, 0.98)
  border.width: 1
  border.color: Qt.alpha(Color.tooltip.border, 0.6)
  implicitWidth: label.implicitWidth + 16
  implicitHeight: label.implicitHeight + 10

  Behavior on opacity { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
  Behavior on anchors.topMargin { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }

  Timer {
    id: showTimer
    interval: root.delay
    onTriggered: root.opacity = 1
  }
  onShownChanged: {
    if (root.shown && root.text !== "") {
      showTimer.restart()
    } else {
      showTimer.stop()
      root.opacity = 0
    }
  }

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: Color.tooltip.text
    font.pixelSize: 10
  }
}
