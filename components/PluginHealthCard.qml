import QtQuick

InfoCard {
  id: root

  property var service: null

  StatusRow {
    label: "Bar is running"
    healthy: root.service ? root.service.barConnected : false
    detail: root.service && root.service.barConnected ? "" : "The replacement bar hasn't loaded — try reinstalling."
  }

  StatusRow {
    label: "Settings are saved"
    healthy: root.service ? root.service.settingsHealthy : false
    detail: root.service && root.service.settingsHealthy ? "" : "Changes you make may not be kept."
  }

  StatusRow {
    label: "Autohide"
    healthy: root.service ? root.service.triggerActive : false
    detail: root.service && root.service.enabled
      ? (root.service.triggerActive ? "On and working" : "On, but waiting for the bar")
      : "Turned off in Autohide & motion"
  }

  StatusRow {
    label: "Screen-edge reveal"
    healthy: root.service ? root.service.triggerActive : false
    detail: root.service && root.service.triggerActive
      ? "Touch the " + root.service.position + " " + root.service.triggerThickness + " px of the screen to bring the bar back"
      : "Not active"
  }
}
