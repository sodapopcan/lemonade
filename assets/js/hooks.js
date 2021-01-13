const Hooks = {};

const listen = (element, eventName, callback) =>
  element.addEventListener(eventName, callback);

Hooks.Focus = {
  mounted() {
    this.el.select();
  },
};

export default Hooks;
