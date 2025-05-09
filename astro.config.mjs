import { defineConfig } from 'astro/config';
import elm from 'vite-plugin-elm';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  vite: {
    plugins: [elm()]
  },
  integrations: [tailwind()]
});