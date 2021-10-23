module.exports = {
  purge: ["./app/helpers/**/*", "./app/views/**/*"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      borderColor: ["hover"],
    },
  },
  plugins: [],
};
