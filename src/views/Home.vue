<template>
  <div class="home">
    <!-- <img alt="Vue logo" src="../assets/logo.png" /> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" /> -->
    <h1 class="text-5xl font-bold my-8 max-w-xl mx-auto">
      Hey! This is a blockchain demos portal!
    </h1>
    <h2 class="text-xl">
      Choose one of the options from the menu to see different blockchain
      applications in action!
    </h2>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
// import HelloWorld from '@/components/HelloWorld.vue' // @ is an alias to /src

export default defineComponent({
  name: 'Home',
  components: {
    // HelloWorld,
  },
  setup() {
    // const storeWave = async () => {}
    // const connectWallet = async () => {}

    return {
      // connectWallet,
      // storeWave,
    }
  },
})
</script>
