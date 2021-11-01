module.exports = {
  purge: ["./app/helpers/**/*", "./app/views/**/*"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    zIndex: {
      "-10": "-10",
    },
  },
  variants: {
    extend: {
      borderColor: ["hover"],
    },
  },
  plugins: [],
};
