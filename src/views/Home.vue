<template>
  <div class="home">
    <!-- <img alt="Vue logo" src="../assets/logo.png" /> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" /> -->
    <h1 class="text-5xl font-bold my-8 max-w-xl mx-auto">
      Hey! This is a blockchain demo app!
    </h1>
    <h2 class="text-xl">Send a wave and it'll be stored in the blockchain!</h2>
    <button
      class="
        px-4
        py-2
        mt-8
        border border-pink-500
        text-pink-600
        font-medium
        rounded
        hover:shadow-lg
        shadow-sm shadow-pink
      "
    >
      Send wave 👋
    </button>
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
