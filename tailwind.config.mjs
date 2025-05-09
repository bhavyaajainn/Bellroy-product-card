/** @type {import('tailwindcss').Config} */
export default {
    content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
    theme: {
      extend: {
        colors: {
          bellroy: {
            amber: '#bf6e3b',
            black: '#333333',
            navy: '#1a2b4a',
            green: '#4A5D4E',
            limestone: '#d7d1c5',
          },
        },
        boxShadow: {
          'card': '0 4px 12px rgba(0, 0, 0, 0.1)',
        },
        transitionProperty: {
          'transform': 'transform',
        },
      },
    },
    plugins: [],
  }