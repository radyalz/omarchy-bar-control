import QtQuick
import "../components"

SettingsPage {
  id: root

  property var service: null
  readonly property string version:
    service && service.manifest && service.manifest.version
      ? service.manifest.version : "0.2.3"

  PageTitle {
    title: "About"
    description: "Radyalz Bar Control for Omarchy."
  }

  InfoCard {
    Text {
      text: "Radyalz Bar Control"
      color: "#f3f4f6"
      font.pixelSize: 22
      font.weight: Font.DemiBold
    }

    Text {
      text: "Version " + root.version
      color: "#9ca3af"
      font.pixelSize: 12
    }

    Text {
      width: parent.width
      text: "Animated edge-triggered autohide, configurable motion, custom Bézier curves, placement, and Islands-style appearance controls."
      color: "#c1c7d0"
      font.pixelSize: 13
      wrapMode: Text.WordWrap
    }
  }

  InfoCard {
    Text {
      text: "Credits & license"
      color: "#f3f4f6"
      font.pixelSize: 15
      font.weight: Font.DemiBold
    }

    Text {
      width: parent.width
      text: "Created by Radman Alizadeh (Radyalz) and licensed under MIT. The bar began from raavail's Islands Bar and retains its MIT attribution; the autohide service, settings system, animation controls, and GUI are implemented for this plugin."
      color: "#9ca3af"
      font.pixelSize: 12
      wrapMode: Text.WordWrap
    }
  }
}
