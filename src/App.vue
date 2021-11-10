<template>
  <div class="flex flex-col h-screen justify-between">
    <NavBar />

    <router-view class="container max-w-8xl mx-auto mb-auto px-4" />
    <div class="py-8 border-t bg-gray-200 font-medium">
      <router-link to="/">Home</router-link> |
      <router-link :to="{ name: 'WaveMe' }">Wave me 👋</router-link> |
      <router-link :to="{ name: 'WaveMe' }">Lucky number 🎲</router-link> |

      <router-link :to="{ name: 'About' }">About</router-link>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import NavBar from '@/components/NavBar.vue'
export default defineComponent({
  setup() {
    return {}
  },
  components: { NavBar },
})
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
