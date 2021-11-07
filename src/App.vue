<template>
  <div class="flex flex-col h-screen justify-between">
    <NavBar />
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link> |

      <!-- <router-link :to="{ name: 'Greeter' }">Greeter</router-link> -->
    </div>
    <router-view class="container max-w-8xl mx-auto mb-auto" />
    <div class="py-8 border-t">
      <router-link to="/">Home</router-link> |
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
