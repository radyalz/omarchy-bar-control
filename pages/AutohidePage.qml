import QtQuick
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Autohide & motion"
    description: "Autohide, reveal behavior, animation timing and the custom motion curve live together here."
  }
  AutohideActivationCard { service: root.service }
  SectionLabel { label: "Reveal" }
  ValueSlider {
    label: "Screen-edge trigger thickness"
    from: 1; to: 50; stepSize: 1; suffix: " px"
    value: root.service ? root.service.triggerThickness : 5
    enabled: root.service !== null
    onEdited: function(value) {
      if (root.service) root.service.triggerThickness = Math.round(value)
    }
  }
  SectionLabel { label: "Animation" }
  AnimationBasics { service: root.service }
  AnimationTiming { service: root.service; showing: true }
  AnimationTiming { service: root.service; showing: false }
  SectionLabel { label: "Curve" }
  MotionCurveSection { service: root.service }
  RowLayout {
    Layout.fillWidth: true
    Item { Layout.fillWidth: true }
    GlassButton {
      text: "Reset motion"
      enabled: root.service !== null
      onClicked: if (root.service) root.service.resetAnimationDefaults()
    }
  }
}
