module.exports = {
  purge: ["./app/helpers/**/*", "./app/views/**/*"],
  darkMode: false, // or 'media' or 'class'
  theme: {},
  variants: {
    extend: {
      borderColor: ["hover"],
    },
  },
  plugins: [],
};
