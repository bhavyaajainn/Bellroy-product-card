/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        bellroy: {
          black: '#333333',
          navy: '#1a2b4a',
          olive: '#4A5D4E',
          bronze: '#b36d3e', // The active color in the screenshot
          stone: '#d7d1c5',
        },
        gray: {
          50: 'rgb(247 247 247)', // Exact color from reference
          100: '#f5f5f5',
          200: '#efefef', // Adjusted to match the button color in screenshot
          300: '#d4d4d4',
          400: '#a3a3a3',
          500: '#737373',
          600: '#525252',
          700: '#404040',
          800: '#333333', // Adjusted to match text color
          900: '#171717',
        }
      },
      fontFamily: {
        sans: ['Lato', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'sans-serif'],
      },
      fontSize: {
        'sm': ['14px', '20px'],
        'base': ['16px', '24px'],
        'lg': ['18px', '26px'],
      },
      ringWidth: {
        '2': '2px',
      },
      ringOffsetWidth: {
        '0': '0px',
      }
    },
  },
  plugins: [],
}