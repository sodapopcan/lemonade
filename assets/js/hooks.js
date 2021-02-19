import Sortable from "sortablejs"

const Hooks = {}

const $ = (id) => document.getElementById(id)
const map = (iter, fn) => [].map.call(iter, fn)
const forEach = (iter, fn) => [].forEach.call(iter, fn)
const set = (el, attr, val) => el.setAttribute(attr, val)
const listen = (el, ev, fn) => el.addEventListener(ev, fn)
const ignore = (el, ev, fn) => element.removeEventListener(ev, fn)
const selectChildren = (el) => window.getSelection().selectAllChildren(el)
const isOverflowing = (el) =>
  el.scrollHeight > el.clientHeight || el.scrollWidth > el.clientWidth

Hooks.Focus = {
  mounted() {
    this.el.select()
  },
}

Hooks.ContentEditable = {
  mounted() {
    listen(this.el, "dblclick", ({ target }) => {
      set(this.el, "contenteditable", true)
      return selectChildren(target)
    })

    listen(this.el, "keydown", ({ key, target }) => {
      if (key === "Enter") {
        this.saving = true
        const {
          innerText: content,
          dataset: { id, event, phxTarget },
        } = target
        this.pushEventTo(phxTarget, event, { id, content })
        set(this.el, "contenteditable", false)
        target.blur()
      }
    })

    listen(this.el, "focus", ({ target }) => {
      if (!this.saving) this.originalContent = target.innerText
      this.saving = false
    })

    listen(this.el, "blur", ({ target }) => {
      set(this.el, "contenteditable", false)
      if (!this.saving) target.innerText = this.originalContent
      this.saving = false
    })
  },
}

Hooks.FocusNewSticky = {
  mounted() {
    listen(this.el, "mouseup", () => {
      const laneId = this.el.dataset.laneId
      const loop = setInterval(() => {
        const el = $(`new-sticky-lane-${laneId}`)
        if (el.style.display === "block") {
          el.focus()
          clearInterval(loop)
        }
      }, 1)
    })
  },
}

Hooks.DateRangePicker = {
  mounted() {
    this.handleEvent("vacations", ({ vacations }) => {
      const input = $("date-range-picker")
      const wrapper = $("date-range-picker-wrapper")
      const vacationStartsAt = $("vacation-starts-at")
      const vacationEndsAt = $("vacation-ends-at")
      new Litepicker({
        element: input,
        parentEl: wrapper,
        inlineMode: true,
        singleMode: false,
        disableWeekends: true,
        startDate: vacationStartsAt.value,
        endDate: vacationEndsAt.value,
        firstDay: 0,
        lockDays: vacations,
        disallowLockDaysInRange: true,
        onSelect: (startsAt, endsAt) => {
          vacationStartsAt.value = startsAt.toISOString()
          vacationEndsAt.value = endsAt.toISOString()
        },
      })
    })
  },
}

/**
 *  Hiding the dragged element is done in app.scss:
 *
 *  .sortable-ghost {
 *    opacity: 0;
 *  }
 */
Hooks.Sortable = {
  mounted() {
    Sortable.create(this.el, {
      draggable: ".sticky",
      animation: 500,
      emptyInsertThreshold: 10,
      group: "sticky-lanes",
      forceFallback: true,
      invertSwap: true,
      onEnd: (e) => {
        const { id, phxTarget } = e.item.dataset
        this.pushEventTo(phxTarget, "move", {
          sticky_id: id,
          from_lane_id: e.from.dataset.id,
          to_lane_id: e.to.dataset.id,
          new_position: e.newIndex,
        })
      },
    })
  },
}

export default Hooks
