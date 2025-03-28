/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      fontFamily: {
        'chillax': ['Chillax-Regular'],
        'chillax-medium': ['Chillax-Medium'],
        'chillax-semibold': ['Chillax-Semibold'],
        'chillax-bold': ['Chillax-Bold'],
        'satoshi': ['Satoshi-Regular'],
        'satoshi-medium': ['Satoshi-Medium'],
        'satoshi-bold': ['Satoshi-Bold'],
      },
      colors: {
        'text': {
          50: '#070b13',
          100: '#0e1625',
          200: '#1b2c4b',
          300: '#294270',
          400: '#365896',
          500: '#446ebb',
          600: '#698bc9',
          700: '#8fa8d6',
          800: '#b4c5e4',
          900: '#dae2f1',
          950: '#ecf0f8',
        },
        'background': {
          50: '#070c13',
          100: '#0e1825',
          200: '#1b304b',
          300: '#294870',
          400: '#366096',
          500: '#4478bb',
          600: '#6993c9',
          700: '#8faed6',
          800: '#b4c9e4',
          900: '#dae4f1',
          950: '#ecf1f8',
        },
        'primary': {
          50: '#070d12',
          100: '#0f1924',
          200: '#1d3349',
          300: '#2c4c6d',
          400: '#3a6692',
          500: '#497fb6',
          600: '#6d99c5',
          700: '#92b2d3',
          800: '#b6cce2',
          900: '#dbe6f0',
          950: '#edf2f8',
        },
        'secondary': {
          50: '#080712',
          100: '#100f24',
          200: '#1f1d49',
          300: '#2f2c6d',
          400: '#3f3a92',
          500: '#4e49b6',
          600: '#726dc5',
          700: '#9592d3',
          800: '#b8b6e2',
          900: '#dcdbf0',
          950: '#ededf8',
        },
        'accent': {
          50: '#0b0712',
          100: '#150f24',
          200: '#2a1d49',
          300: '#3f2c6d',
          400: '#543a92',
          500: '#6a49b6',
          600: '#876dc5',
          700: '#a592d3',
          800: '#c3b6e2',
          900: '#e1dbf0',
          950: '#f0edf8',
        },
       },
       
    },
  },
  plugins: [],
}

