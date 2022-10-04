/* eslint-disable */

const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        steel: '#4B5058',
        concrete: '#989AA5',
        fog: '#D0D1DB',
        white: '#FFF',
        bayside: '#5bc3f5',
        'deep-ocean': '#0057bf',
        marina: '#00a4b1',
        'cable-car': '#ef3346',
        'light-gray': '#eee',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
  ],
};
