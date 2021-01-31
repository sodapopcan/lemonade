module.exports = {
  purge: [
    "../lib/**/*.ex",
    "../lib/**/*.leex",
    "../lib/**/*.eex",
    "./js/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      display: ["hover", "group-hover"],
      visibility: ["hover", "group-hover"],
    },
  },
  plugins: [],
}
