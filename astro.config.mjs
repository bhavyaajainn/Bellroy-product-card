import { defineConfig } from 'astro/config';
import elm from 'vite-plugin-elm';

export default defineConfig({
  vite: {
    plugins: [elm()]
  }
});