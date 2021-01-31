const Hooks = {}

const $ = (id) => document.getElementById(id)
const listen = (element, eventName, callback) =>
  element.addEventListener(eventName, callback)

Hooks.Focus = {
  mounted() {
    this.el.select()
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
