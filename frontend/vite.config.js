import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'


export default defineConfig({
  plugins: [react()],
  

  server: {
    host: '0.0.0.0',  
    port: 5173,
    strictPort: true,
    watch: {
      usePolling: true  
    }
  },
 
  preview: {
    host: '0.0.0.0',
    port: 3000,
    strictPort: true
  },
  
  build: {
    outDir: 'dist',
    sourcemap: false,  
    minify: 'esbuild',  
    chunkSizeWarningLimit: 1000,  
    rollupOptions: {
      output: {
        manualChunks: {
          'react-vendor': ['react', 'react-dom', 'react-router-dom'],
          'ui-vendor': ['lucide-react', 'framer-motion'],
        }
      }
    }
  },
  
  envPrefix: 'VITE_',
})