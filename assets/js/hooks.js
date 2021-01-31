const Hooks = {}

const listen = (element, eventName, callback) =>
  element.addEventListener(eventName, callback)

Hooks.Focus = {
  mounted() {
    this.el.select()
  },
}

Hooks.DateRangePicker = {
  mounted() {
    const input = document.getElementById("date-range-picker")
    const wrapper = document.getElementById("date-range-picker-wrapper")
    const vacationStartsAt = document.getElementById("vacation-starts-at")
    const vacationEndsAt = document.getElementById("vacation-ends-at")
    new Litepicker({
      element: input,
      parentEl: wrapper,
      inlineMode: true,
      singleMode: false,
      disableWeekends: true,
      startDate: vacationStartsAt.value,
      endDate: vacationEndsAt.value,
      firstDay: 0,
      onSelect: (startsAt, endsAt) => {
        vacationStartsAt.value = startsAt.toISOString()
        vacationEndsAt.value = endsAt.toISOString()
      },
    })
  },
}

export default Hooks
