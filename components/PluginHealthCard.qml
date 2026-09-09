import QtQuick

InfoCard {
  id: root

  property var service: null

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
