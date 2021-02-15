const Hooks = {}

const $ = (id) => document.getElementById(id)
const map = (iter, fn) => [].map.call(iter, fn)
const forEach = (iter, fn) => [].forEach.call(iter, fn)
const listen = (el, ev, fn) => el.addEventListener(ev, fn)
const ignore = (el, ev, fn) => element.removeEventListener(ev, fn)
const selectChildren = (el) => window.getSelection().selectAllChildren(el)

Hooks.Focus = {
  mounted() {
    this.el.select()
  },
}

Hooks.ContentEditable = {
  mounted() {
    listen(this.el, "dblclick", ({ target }) => {
      this.el.setAttribute("contenteditable", true)
      return selectChildren(target)
    })

    listen(this.el, "keydown", ({ key, target }) => {
      if (key === "Enter") {
        this.saving = true
        const {
          innerText: content,
          dataset: { event, phxTarget },
        } = target
        this.pushEventTo(phxTarget, event, { id: this.el.id, content })
        this.el.setAttribute("contenteditable", false)
        target.blur()
      }
    })

    listen(this.el, "focus", ({ target }) => {
      if (!this.saving) this.originalContent = target.innerText
      this.saving = false
    })

    listen(this.el, "blur", ({ target }) => {
      this.el.setAttribute("contenteditable", false)
      if (!this.saving) target.innerText = this.originalContent
      this.saving = false
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

export default Hooks
