import QtQuick

InfoCard {
  id: root
  property var service: null
  readonly property string version:
    service && service.manifest && service.manifest.version
      ? service.manifest.version : "0.2.3"

  Text {
    text: "Radyalz Bar Control"
    color: "#f3f4f6"
    font.pixelSize: 21
    font.weight: Font.DemiBold
  }
  Text {
    text: "Version " + root.version + "  ·  MIT"
    color: "#9ca3af"
    font.pixelSize: 12
  }
  Text {
    width: parent.width
    text: "Created by Radman Alizadeh (Radyalz). A graphical control layer for Omarchy bar autohide, motion, placement and appearance."
    color: "#c1c7d0"
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
