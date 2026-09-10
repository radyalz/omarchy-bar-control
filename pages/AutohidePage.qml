import QtQuick
import QtQuick.Layouts
import "../components"

SettingsPage {
  id: root
  property var service: null

  PageTitle {
    title: "Autohide & motion"
    description: "Pick a feel preset up top, then open a section to fine-tune it."
  }

  AutohideActivationCard { service: root.service }

  SectionLabel { label: "Presets" }
  AnimationBasics { service: root.service }

  SectionLabel { label: "Fine tuning" }

  ExpandableSection {
    title: "Reveal"
    summary: root.service ? root.service.triggerThickness + " px trigger" : ""
    resettable: true
    onResetRequested: if (root.service) root.service.resetRevealDefaults()

    Component {
      ValueSlider {
        label: "Screen-edge trigger thickness"
        description: "Width of the invisible strip along the edge that brings the bar back."
        from: 1; to: 50; stepSize: 1; suffix: " px"
        value: root.service ? root.service.triggerThickness : 5
        enabled: root.service !== null
        onEdited: function(value) {
          if (root.service) root.service.triggerThickness = Math.round(value)
        }
      }
    }
  }

  ExpandableSection {
    title: "Show animation"
    summary: root.service
      ? root.service.showSlideDuration + " / " + root.service.showFadeDuration + " ms" : ""
    resettable: true
    onResetRequested: if (root.service) root.service.resetShowTimingDefaults()

    Component { AnimationTiming { service: root.service; showing: true } }
  }

  ExpandableSection {
    title: "Hide animation"
    summary: root.service
      ? root.service.hideSlideDuration + " / " + root.service.hideFadeDuration + " ms" : ""
    resettable: true
    onResetRequested: if (root.service) root.service.resetHideTimingDefaults()

    Component { AnimationTiming { service: root.service; showing: false } }
  }

  ExpandableSection {
    title: "Motion curve"
    summary: root.service && root.service.customCurveEnabled ? "Custom curve" : "Off"
    resettable: true
    onResetRequested: if (root.service) root.service.resetCurveDefaults()

    Component { MotionCurveSection { service: root.service } }
  }

  RowLayout {
    Layout.fillWidth: true
    Item { Layout.fillWidth: true }
    GlassButton {
      text: "Reset all motion"
      enabled: root.service !== null
      onClicked: if (root.service) root.service.resetAnimationDefaults()
    }
  }
}
