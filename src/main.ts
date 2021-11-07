import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

import './assets/css/style.css'

import { createPinia } from 'pinia'

createApp(App).use(router).use(createPinia()).mount('#app')
