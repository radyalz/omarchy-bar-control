import QtQuick

QtObject {
  id: root

  property var host: null
  property var bar: null
  property var controller: null
  property var state: null

  function releasePopout() {
    if (bar && typeof bar.releasePopout === "function" && host)
      bar.releasePopout(host)
  }

  function open() {
    if (!host || !controller) return
    host.view = "main"
    if (state && typeof state.refresh === "function") state.refresh()
    if (bar && typeof bar.requestPopout === "function")
      bar.requestPopout(host)
    controller.show()
  }

  function close() {
    if (!host || !controller) return
    host.view = "main"
    controller.hide()
    releasePopout()
  }

  function toggle(opened) {
    if (opened) close()
    else open()
  }

  function syncOpened(opened) {
    if (!opened) releasePopout()
  }
}
