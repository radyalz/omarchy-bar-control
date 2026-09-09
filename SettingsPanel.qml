import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Ui
import "components"

Item {
  id: root

  readonly property string pluginId: "radyalz.bar-control"
  property var shell: null
  property var service: null
  property bool closingFromHost: false
  property int currentPage: 0

  function open(payloadJson) {
    closingFromHost = false
    window.visible = true
    focusScope.forceActiveFocus()
  }

  function close() {
    closingFromHost = true
    window.visible = false
    closingFromHost = false
  }

  function requestClose() {
    window.visible = false
    if (shell && typeof shell.hide === "function")
      shell.hide(root.pluginId)
  }

  function indexOf(list, value, fallback) {
    var index = list.indexOf(value)
    return index >= 0 ? index : fallback
  }

  readonly property var pageNames: [
    "Autohide",
    "Placement",
    "Animation",
    "Curve",
    "Appearance",
    "Diagnostics",
    "About",
    "Support"
  ]

  component PageTitle: ColumnLayout {
    property string title: ""
    property string description: ""
    Layout.fillWidth: true
    spacing: 5

    Text {
      text: parent.title
      color: "#f3f4f6"
      font.pixelSize: 26
      font.weight: Font.DemiBold
    }

    Text {
      Layout.fillWidth: true
      text: parent.description
      color: "#9ca3af"
      font.pixelSize: 13
      wrapMode: Text.WordWrap
    }
  }

  component SectionLabel: Text {
    property string label: ""
    text: label
    color: "#e5e7eb"
    font.pixelSize: 16
    font.weight: Font.DemiBold
    topPadding: 10
  }

  component InfoCard: Rectangle {
    default property alias content: contentColumn.data
    Layout.fillWidth: true
    implicitHeight: contentColumn.implicitHeight + 28
    radius: 12
    color: "#171a20"
    border.width: 1
    border.color: "#2d323b"

    ColumnLayout {
      id: contentColumn
      x: 14
      y: 14
      width: Math.max(0, parent.width - 28)
      spacing: 10
    }
  }

  component ValueSlider: ColumnLayout {
    id: sliderRoot
    property string label: ""
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property real value: 0
    property int decimals: 0
    property string suffix: ""
    signal edited(real value)

    Layout.fillWidth: true
    spacing: 4

    RowLayout {
      Layout.fillWidth: true
      Text {
        text: sliderRoot.label
        color: sliderRoot.enabled ? "#d1d5db" : "#6b7280"
        font.pixelSize: 13
      }
      Item { Layout.fillWidth: true }
      Text {
        text: Number(sliderRoot.value).toFixed(sliderRoot.decimals) + sliderRoot.suffix
        color: sliderRoot.enabled ? "#9ca3af" : "#5b616b"
        font.pixelSize: 12
      }
    }

    QQC.Slider {
      Layout.fillWidth: true
      from: sliderRoot.from
      to: sliderRoot.to
      stepSize: sliderRoot.stepSize
      value: sliderRoot.value
      enabled: sliderRoot.enabled
      onMoved: sliderRoot.edited(value)
    }
  }

  component StatusRow: RowLayout {
    property string label: ""
    property bool healthy: false
    property string detail: healthy ? "OK" : "Needs attention"
    Layout.fillWidth: true

    Rectangle {
      width: 10
      height: 10
      radius: 5
      color: parent.healthy ? "#9ece6a" : "#f7768e"
    }

    Text {
      text: parent.label
      color: "#d1d5db"
      font.pixelSize: 13
    }

    Item { Layout.fillWidth: true }

    Text {
      text: parent.detail
      color: "#9ca3af"
      font.pixelSize: 12
    }
  }

  FloatingWindow {
    id: window
    visible: false
    implicitWidth: 1040
    implicitHeight: 700
    color: "transparent"

    onVisibleChanged: {
      if (!visible && !root.closingFromHost
          && root.shell && typeof root.shell.hide === "function")
        root.shell.hide(root.pluginId)
    }

    Rectangle {
      anchors.fill: parent
      color: "#0f1115"

      RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
          Layout.preferredWidth: 220
          Layout.fillHeight: true
          color: "#13161b"
          border.width: 0

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              Text {
                text: "Radyalz Bar Control"
                color: "#f3f4f6"
                font.pixelSize: 17
                font.weight: Font.DemiBold
              }

              Text {
                text: "Bar control center"
                color: "#6b7280"
                font.pixelSize: 11
              }
            }

            Rectangle {
              Layout.fillWidth: true
              height: 1
              color: "#272b33"
            }

            Repeater {
              model: root.pageNames

              QQC.Button {
                required property string modelData
                required property int index
                Layout.fillWidth: true
                text: modelData
                checkable: true
                checked: root.currentPage === index
                onClicked: root.currentPage = index
              }
            }

            Item { Layout.fillHeight: true }

            Rectangle {
              Layout.fillWidth: true
              height: 1
              color: "#272b33"
            }

            Text {
              Layout.fillWidth: true
              text: root.service && root.service.enabled
                ? "Autohide active" : "Autohide inactive"
              color: root.service && root.service.enabled
                ? "#9ece6a" : "#9ca3af"
              font.pixelSize: 11
            }
          }
        }

        Rectangle {
          Layout.preferredWidth: 1
          Layout.fillHeight: true
          color: "#272b33"
        }

        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true

          StackLayout {
            anchors.fill: parent
            currentIndex: root.currentPage

            // ------------------------------------------------------ Autohide
            QQC.ScrollView {
              id: autohideScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, autohideScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Autohide"
                  description: "The autohide feature is an activation module. Turn it on or off here without disabling or uninstalling the plugin."
                }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 3

                      Text {
                        text: "Activate autohide"
                        color: "#f3f4f6"
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                      }

                      Text {
                        Layout.fillWidth: true
                        text: root.service && root.service.enabled
                          ? "The edge trigger is controlling the bar."
                          : "The bar stays visible. All settings remain editable."
                        color: "#9ca3af"
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                      }
                    }

                    QQC.Switch {
                      checked: root.service ? root.service.enabled : false
                      enabled: root.service !== null
                      onToggled: if (root.service) root.service.enabled = checked
                    }
                  }
                }

                SectionLabel { label: "Reveal" }

                ValueSlider {
                  label: "Screen-edge trigger thickness"
                  from: 1
                  to: 30
                  stepSize: 1
                  value: root.service ? root.service.triggerThickness : 5
                  suffix: " px"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) root.service.triggerThickness = Math.round(value)
                  }
                }

                Text {
                  Layout.fillWidth: true
                  text: "5 px is the default. A larger trigger is easier to hit; a smaller one is less intrusive."
                  color: "#7f8793"
                  font.pixelSize: 12
                  wrapMode: Text.WordWrap
                }

                Item { Layout.fillHeight: true; implicitHeight: 18 }
              }
            }

            // ----------------------------------------------------- Placement
            QQC.ScrollView {
              id: placementScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, placementScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Placement"
                  description: "Move the bar to any screen edge. The reveal trigger follows the bar automatically."
                }

                SectionLabel { label: "Bar edge" }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true

                    Text {
                      text: "Position"
                      color: "#d1d5db"
                      font.pixelSize: 13
                    }

                    Item { Layout.fillWidth: true }

                    QQC.ComboBox {
                      id: positionCombo
                      model: ["Top", "Bottom", "Left", "Right"]
                      currentIndex: root.indexOf(
                        ["top", "bottom", "left", "right"],
                        root.service ? root.service.position : "top",
                        0
                      )
                      enabled: root.service !== null
                      onActivated: function(index) {
                        if (root.service)
                          root.service.setBarPosition(
                            ["top", "bottom", "left", "right"][index]
                          )
                      }
                    }
                  }
                }

                SectionLabel { label: "Movement" }

                ValueSlider {
                  label: "Slide distance"
                  from: 0
                  to: 150
                  stepSize: 5
                  value: root.service ? root.service.slideDistancePercent : 100
                  suffix: "%"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.animationPreset = "Custom"
                      root.service.slideDistancePercent = Math.round(value)
                    }
                  }
                }

                Text {
                  Layout.fillWidth: true
                  text: "100% moves the content by one full bar thickness. 0% gives a fade-only-looking movement even when Slide is selected."
                  color: "#7f8793"
                  font.pixelSize: 12
                  wrapMode: Text.WordWrap
                }
              }
            }

            // ----------------------------------------------------- Animation
            QQC.ScrollView {
              id: animationScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, animationScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Animation"
                  description: "Choose what the bar does, how it feels, and how quickly each part moves."
                }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true

                    Text {
                      text: "Animation type"
                      color: "#d1d5db"
                      font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                    QQC.ComboBox {
                      id: modeCombo
                      model: ["Slide + Fade", "Slide", "Fade"]
                      currentIndex: root.indexOf(
                        model,
                        root.service ? root.service.animationMode : "Slide + Fade",
                        0
                      )
                      enabled: root.service !== null
                      onActivated: function(index) {
                        if (root.service)
                          root.service.animationMode = model[index]
                      }
                    }
                  }

                  RowLayout {
                    Layout.fillWidth: true

                    Text {
                      text: "Feel preset"
                      color: "#d1d5db"
                      font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                    QQC.ComboBox {
                      id: presetCombo
                      model: ["Smooth", "Snappy", "Soft", "Custom"]
                      currentIndex: root.indexOf(
                        model,
                        root.service ? root.service.animationPreset : "Smooth",
                        0
                      )
                      enabled: root.service !== null
                      onActivated: function(index) {
                        if (root.service)
                          root.service.setAnimationPreset(model[index])
                      }
                    }
                  }

                  RowLayout {
                    Layout.fillWidth: true

                    Text {
                      text: "Easing family"
                      color: "#d1d5db"
                      font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                    QQC.ComboBox {
                      id: easingCombo
                      model: ["Quad", "Cubic", "Quart", "Quint", "Sine"]
                      currentIndex: root.indexOf(
                        model,
                        root.service ? root.service.easing : "Cubic",
                        1
                      )
                      enabled: root.service !== null
                        && !(root.service && root.service.customCurveEnabled)
                      onActivated: function(index) {
                        if (root.service) {
                          root.service.animationPreset = "Custom"
                          root.service.easing = model[index]
                        }
                      }
                    }
                  }
                }

                SectionLabel { label: "Show" }

                ValueSlider {
                  label: "Slide duration"
                  from: 50; to: 1500; stepSize: 10
                  value: root.service ? root.service.showSlideDuration : 500
                  suffix: " ms"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.animationPreset = "Custom"
                      root.service.showSlideDuration = Math.round(value)
                    }
                  }
                }

                ValueSlider {
                  label: "Fade duration"
                  from: 50; to: 1500; stepSize: 10
                  value: root.service ? root.service.showFadeDuration : 400
                  suffix: " ms"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.animationPreset = "Custom"
                      root.service.showFadeDuration = Math.round(value)
                    }
                  }
                }

                SectionLabel { label: "Hide" }

                ValueSlider {
                  label: "Slide duration"
                  from: 50; to: 1500; stepSize: 10
                  value: root.service ? root.service.hideSlideDuration : 400
                  suffix: " ms"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.animationPreset = "Custom"
                      root.service.hideSlideDuration = Math.round(value)
                    }
                  }
                }

                ValueSlider {
                  label: "Fade duration"
                  from: 50; to: 1500; stepSize: 10
                  value: root.service ? root.service.hideFadeDuration : 320
                  suffix: " ms"
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.animationPreset = "Custom"
                      root.service.hideFadeDuration = Math.round(value)
                    }
                  }
                }

                RowLayout {
                  Layout.fillWidth: true
                  Item { Layout.fillWidth: true }
                  QQC.Button {
                    text: "Reset animation"
                    enabled: root.service !== null
                    onClicked: if (root.service) root.service.resetAnimationDefaults()
                  }
                }
              }
            }

            // --------------------------------------------------------- Curve
            QQC.ScrollView {
              id: curveScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, curveScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Curve"
                  description: "Shape the cubic Bézier curve directly. Drag either control point and preview the motion dot."
                }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                      Layout.fillWidth: true
                      Text {
                        text: "Use custom curve"
                        color: "#f3f4f6"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                      }
                      Text {
                        Layout.fillWidth: true
                        text: "When enabled, this curve replaces the easing family for both show and hide motion."
                        color: "#8b93a0"
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                      }
                    }
                    QQC.Switch {
                      checked: root.service ? root.service.customCurveEnabled : false
                      enabled: root.service !== null
                      onToggled: if (root.service) {
                        root.service.customCurveEnabled = checked
                        root.service.animationPreset = "Custom"
                      }
                    }
                  }
                }

                CurveEditor {
                  id: curveEditor
                  Layout.fillWidth: true
                  Layout.preferredHeight: 320
                  x1: root.service ? root.service.curveX1 : 0.25
                  y1: root.service ? root.service.curveY1 : 0.10
                  x2: root.service ? root.service.curveX2 : 0.25
                  y2: root.service ? root.service.curveY2 : 1.00
                  interactive: root.service !== null
                  onCurveEdited: function(x1, y1, x2, y2) {
                    if (!root.service) return
                    root.service.animationPreset = "Custom"
                    root.service.customCurveEnabled = true
                    root.service.curveX1 = x1
                    root.service.curveY1 = y1
                    root.service.curveX2 = x2
                    root.service.curveY2 = y2
                  }
                }

                RowLayout {
                  Layout.fillWidth: true
                  QQC.Button {
                    text: "Preview curve"
                    onClicked: curveEditor.play()
                  }
                  QQC.Button {
                    text: "Reset curve"
                    enabled: root.service !== null
                    onClicked: if (root.service) {
                      root.service.curveX1 = 0.25
                      root.service.curveY1 = 0.10
                      root.service.curveX2 = 0.25
                      root.service.curveY2 = 1.00
                      root.service.animationPreset = "Custom"
                    }
                  }
                  Item { Layout.fillWidth: true }
                }

                SectionLabel { label: "Control points" }

                ValueSlider {
                  label: "X1"
                  from: 0; to: 1; stepSize: 0.01; decimals: 2
                  value: root.service ? root.service.curveX1 : 0.25
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.customCurveEnabled = true
                      root.service.animationPreset = "Custom"
                      root.service.curveX1 = value
                    }
                  }
                }

                ValueSlider {
                  label: "Y1"
                  from: -1; to: 2; stepSize: 0.01; decimals: 2
                  value: root.service ? root.service.curveY1 : 0.10
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.customCurveEnabled = true
                      root.service.animationPreset = "Custom"
                      root.service.curveY1 = value
                    }
                  }
                }

                ValueSlider {
                  label: "X2"
                  from: 0; to: 1; stepSize: 0.01; decimals: 2
                  value: root.service ? root.service.curveX2 : 0.25
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.customCurveEnabled = true
                      root.service.animationPreset = "Custom"
                      root.service.curveX2 = value
                    }
                  }
                }

                ValueSlider {
                  label: "Y2"
                  from: -1; to: 2; stepSize: 0.01; decimals: 2
                  value: root.service ? root.service.curveY2 : 1.00
                  enabled: root.service !== null
                  onEdited: function(value) {
                    if (root.service) {
                      root.service.customCurveEnabled = true
                      root.service.animationPreset = "Custom"
                      root.service.curveY2 = value
                    }
                  }
                }
              }
            }

            // ---------------------------------------------------- Appearance
            QQC.ScrollView {
              id: appearanceScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, appearanceScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Appearance"
                  description: "Keep the original Islands look or override its main geometry and transparency."
                }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true
                    Text {
                      text: "Transparent bar"
                      color: "#d1d5db"
                      font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                    QQC.Switch {
                      checked: root.service ? root.service.currentTransparent : false
                      enabled: root.service !== null
                      onToggled: if (root.service) root.service.setTransparent(checked)
                    }
                  }

                  RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                      Layout.fillWidth: true
                      Text {
                        text: "Custom island appearance"
                        color: "#d1d5db"
                        font.pixelSize: 13
                      }
                      Text {
                        text: "Off preserves the original Islands Bar styling."
                        color: "#7f8793"
                        font.pixelSize: 11
                      }
                    }
                    QQC.Switch {
                      checked: root.service
                        ? root.service.appearanceOverrideEnabled : false
                      enabled: root.service !== null
                      onToggled: if (root.service)
                        root.service.appearanceOverrideEnabled = checked
                    }
                  }
                }

                SectionLabel { label: "Island geometry" }

                ValueSlider {
                  label: "Edge margin"
                  from: 0; to: 40; stepSize: 1
                  value: root.service ? root.service.islandEdgeMargin : 8
                  suffix: " px"
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandEdgeMargin = Math.round(value)
                  }
                }

                ValueSlider {
                  label: "Padding"
                  from: 0; to: 32; stepSize: 1
                  value: root.service ? root.service.islandPadding : 8
                  suffix: " px"
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandPadding = Math.round(value)
                  }
                }

                ValueSlider {
                  label: "Gap"
                  from: 0; to: 32; stepSize: 1
                  value: root.service ? root.service.islandGap : 4
                  suffix: " px"
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandGap = Math.round(value)
                  }
                }

                ValueSlider {
                  label: "Inset"
                  from: 0; to: 12; stepSize: 1
                  value: root.service ? root.service.islandInset : 2
                  suffix: " px"
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandInset = Math.round(value)
                  }
                }

                ValueSlider {
                  label: "Corner radius"
                  from: 0; to: 40; stepSize: 1
                  value: root.service ? root.service.islandRadius : 12
                  suffix: " px"
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandRadius = Math.round(value)
                  }
                }

                ValueSlider {
                  label: "Island opacity"
                  from: 0.05; to: 1; stepSize: 0.01; decimals: 2
                  value: root.service ? root.service.islandOpacity : 1
                  enabled: root.service && root.service.appearanceOverrideEnabled
                  onEdited: function(value) {
                    if (root.service) root.service.islandOpacity = value
                  }
                }

                RowLayout {
                  Layout.fillWidth: true
                  Item { Layout.fillWidth: true }
                  QQC.Button {
                    text: "Restore Islands defaults"
                    enabled: root.service !== null
                    onClicked: if (root.service) root.service.resetAppearanceDefaults()
                  }
                }
              }
            }

            // --------------------------------------------------- Diagnostics
            QQC.ScrollView {
              id: diagnosticsScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, diagnosticsScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Diagnostics"
                  description: "Local plugin health plus the optional project-status feed from GitHub."
                }

                InfoCard {
                  StatusRow {
                    label: "Bar loaded"
                    healthy: root.service ? root.service.barConnected : false
                  }
                  StatusRow {
                    label: "Settings file"
                    healthy: root.service ? root.service.settingsHealthy : false
                  }
                  StatusRow {
                    label: "Autohide module"
                    healthy: root.service ? root.service.triggerActive : false
                    detail: root.service && root.service.enabled
                      ? (root.service.triggerActive ? "Active" : "Waiting for bar")
                      : "Disabled by user"
                  }
                  StatusRow {
                    label: "Edge trigger"
                    healthy: root.service ? root.service.triggerActive : false
                    detail: root.service && root.service.triggerActive
                      ? root.service.triggerThickness + " px" : "Inactive"
                  }
                }

                SectionLabel { label: "GitHub project status" }

                InfoCard {
                  RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                      Layout.fillWidth: true
                      Text {
                        text: root.service ? root.service.githubStatus : "Unavailable"
                        color: "#f3f4f6"
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                      }
                      Text {
                        Layout.fillWidth: true
                        text: root.service
                          ? root.service.githubStatusMessage
                          : "Service is not available."
                        color: "#8b93a0"
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                      }
                    }
                    QQC.Button {
                      text: root.service && root.service.githubStatusLoading
                        ? "Checking…" : "Check status"
                      enabled: root.service !== null
                        && !root.service.githubStatusLoading
                      onClicked: if (root.service) root.service.refreshIssueStatus()
                    }
                  }
                }

                SectionLabel { label: "Diagnostic report" }

                QQC.TextArea {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 220
                  readOnly: true
                  wrapMode: TextEdit.NoWrap
                  text: root.service
                    ? root.service.diagnosticReport()
                    : "Radyalz Bar Control service is not available."
                }
              }
            }

            // --------------------------------------------------------- About
            QQC.ScrollView {
              id: aboutScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, aboutScroll.availableWidth - 52)
                spacing: 16

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
                    text: "Version " + (
                      root.service && root.service.manifest
                        && root.service.manifest.version
                        ? root.service.manifest.version : "0.1.0"
                    )
                    color: "#9ca3af"
                    font.pixelSize: 12
                  }
                  Text {
                    Layout.fillWidth: true
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
                    Layout.fillWidth: true
                    text: "The bar began from raavail's Islands Bar and retains its MIT attribution. The autohide service, settings system, animation controls, and GUI are implemented for this plugin."
                    color: "#9ca3af"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                  }
                }
              }
            }

            // ------------------------------------------------------- Support
            QQC.ScrollView {
              id: supportScroll
              contentWidth: availableWidth

              ColumnLayout {
                x: 26
                y: 26
                width: Math.max(0, supportScroll.availableWidth - 52)
                spacing: 16

                PageTitle {
                  title: "Support"
                  description: "Project links stay disabled until the public GitHub repository is configured."
                }

                InfoCard {
                  Text {
                    text: "GitHub"
                    color: "#f3f4f6"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                  }

                  RowLayout {
                    Layout.fillWidth: true
                    QQC.Button {
                      text: "Open repository"
                      enabled: root.service && root.service.repositoryUrl !== ""
                      onClicked: if (root.service)
                        Qt.openUrlExternally(root.service.repositoryUrl)
                    }
                    QQC.Button {
                      text: "Report an issue"
                      enabled: root.service && root.service.issuesUrl !== ""
                      onClicked: if (root.service)
                        Qt.openUrlExternally(root.service.issuesUrl)
                    }
                    Item { Layout.fillWidth: true }
                  }

                  Text {
                    Layout.fillWidth: true
                    text: root.service && root.service.repositoryUrl !== ""
                      ? root.service.repositoryUrl
                      : "Repository URL not configured yet."
                    color: "#7f8793"
                    font.pixelSize: 11
                    wrapMode: Text.WrapAnywhere
                  }
                }

                InfoCard {
                  Text {
                    text: "Before reporting a problem"
                    color: "#f3f4f6"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                  }
                  Text {
                    Layout.fillWidth: true
                    text: "Open Diagnostics first. It shows whether the bar, autohide module, edge trigger, settings file, and GitHub project status are healthy."
                    color: "#9ca3af"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                  }
                }
              }
            }
          }

          FocusScope {
            id: focusScope
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: root.requestClose()
          }
        }
      }
    }
  }
}
