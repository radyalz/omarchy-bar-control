import QtQuick
import qs.Ui

Item {
  id: root

  property var bar: null
  property string moduleName: ""
  property var settings: ({})

  implicitWidth: button.implicitWidth
  implicitHeight: bar ? bar.barSize : 28

  WidgetButton {
    id: button
    anchors.centerIn: parent
    bar: root.bar
    text: "A"
    tooltipText: "Radyalz Bar Control settings"

    onPressed: function(mouseButton) {
      if (mouseButton !== Qt.LeftButton || !root.bar)
        return
      root.bar.run("omarchy-shell shell toggle radyalz.bar-control '{}'")
    }
  }
}
