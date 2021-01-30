// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import Hooks from "./hooks"
import "alpinejs"
import Litepicker from "litepicker"

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to)
      }
    },
  },
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (info) => NProgress.start())
window.addEventListener("phx:page-loading-stop", (info) => NProgress.done())

window.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("date-range-picker")
  if (!input) return;
  const wrapper = document.getElementById("date-range-picker-wrapper")
  const vacationStartsAt = document.getElementById("vacation-starts-at")
  const vacationEndsAt = document.getElementById("vacation-ends-at")
  new Litepicker({
    element: input,
    parentEl: wrapper,
    inlineMode: true,
    singleMode: false,
    disableWeekends: true,
    firstDay: 0,
    onSelect: (startsAt, endsAt) => {
      vacationStartsAt.value = startsAt.toISOString()
      vacationEndsAt.value = endsAt.toISOString()
    }
  })
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
