import QtQuick
import qs.Commons

QtObject {
  id: root

  property var bar: null
  property var host: null

  function callControl(method, value) {
    if (!bar || typeof bar.run !== "function") return
    var command = "omarchy-shell radyalz.bar-control " + method
    if (value !== undefined)
      command += " " + Util.shellQuote(String(value))
    bar.run(command)
  }

  function openAdvanced(page) {
    if (!bar || typeof bar.run !== "function") return
    if (host) host.close()
    var payload = JSON.stringify({ page: page })
    bar.run("omarchy-shell shell summon radyalz.bar-control "
      + Util.shellQuote(payload))
  }

  function openUrl(url) {
    if (bar && typeof bar.run === "function")
      bar.run("xdg-open " + Util.shellQuote(url))
  }
}
