import QtQuick

Item {
  id: root

  property real x1: 0.25
  property real y1: 0.10
  property real x2: 0.25
  property real y2: 1.00
  property bool interactive: true
  property real previewT: 0

  signal curveEdited(real x1, real y1, real x2, real y2)

  implicitWidth: 520
  implicitHeight: 300

  function play() {
    previewT = 0
    previewAnimation.restart()
  }

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: "#16181d"
    border.width: 1
    border.color: "#343840"
  }

  CurveCanvas {
    anchors.fill: parent
    x1: root.x1
    y1: root.y1
    x2: root.x2
    y2: root.y2
    previewT: root.previewT
  }

  CurveHandleArea {
    anchors.fill: parent
    enabled: root.interactive
    x1: root.x1
    y1: root.y1
    x2: root.x2
    y2: root.y2
    onCurveEdited: function(x1, y1, x2, y2) {
      root.curveEdited(x1, y1, x2, y2)
    }
  }

  NumberAnimation {
    id: previewAnimation
    target: root
    property: "previewT"
    from: 0
    to: 1
    duration: 1200
    easing.type: Easing.Linear
    onFinished: root.previewT = 0
  }
}
