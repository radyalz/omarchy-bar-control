import QtQuick
import "../Version.js" as Version
import qs.Commons

InfoCard {
  id: root
  property var service: null
  readonly property string version:
    service && service.manifest && service.manifest.version
      ? service.manifest.version : Version.number

  Text {
    text: Version.name
    color: Color.foreground
    font.pixelSize: 21
    font.weight: Font.DemiBold
  }
  Text {
    text: "Version " + root.version + "  ·  " + Version.license
    color: Qt.alpha(Color.foreground, 0.6)
    font.pixelSize: 12
  }
  Text {
    width: parent.width
    text: "Created by " + Version.author + ". A graphical control layer for Omarchy bar autohide, motion, placement and appearance."
    color: Qt.alpha(Color.foreground, 0.85)
    font.pixelSize: 12
    wrapMode: Text.WordWrap
  }
}
