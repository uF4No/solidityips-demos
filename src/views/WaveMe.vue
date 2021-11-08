<template>
  <div class="home">
    <!-- <img alt="Vue logo" src="../assets/logo.png" /> -->
    <!-- <HelloWorld msg="Welcome to Your Vue.js + TypeScript App" /> -->
    <h1 class="text-5xl font-bold my-8 max-w-xl mx-auto">Send a message 👋</h1>
    <h2 class="text-xl">
      Send a message and it'll be stored in the blockchain!
    </h2>
    <div class="flex flex-col max-w-md mx-auto space-y-4 mt-8">
      <textarea
        v-model="message"
        name=""
        id=""
        cols="30"
        rows="5"
        class="
          border border-pink-500
          focus:border-pink-500
          ring-none
          text-pink-600
          font-medium
          rounded
          p-2
        "
      ></textarea>
      <p v-if="walletStore.walletData == null" class="text-red-500 font-medium">
        You have to connect your wallet!
      </p>
      <button
        @click.once="sendMessage"
        :disabled="walletStore.walletData == null"
        class="px-4 py-2 mt-8 border font-medium rounded"
        :class="
          walletStore.walletData == null
            ? 'border-gray-200 text-gray-400'
            : 'border-pink-500 text-pink-600 hover:shadow-lg shadow-sm'
        "
      >
        Send message 👋
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { useWalletStore } from '@/stores/wallet'
import { ethers } from 'ethers'

import WavePortal from '@/artifacts/solidity/contracts/WavePortal.sol/WavePortal.json'

export default defineComponent({
  name: 'Home',
  components: {
    // HelloWorld,
  },
  setup() {
    const walletStore = useWalletStore()
    const contractAddress = process.env.VUE_APP_ADDRESS_WAVE || ''
    const message = ref('')

    const sendMessage = async function () {
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        //@ts-expect-error Window.ethers not TS
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        // get the account that will pay for the trasaction
        const signer = provider.getSigner()
        // as the operation we're going to do is a transaction,
        // we pass the signer instead of the provider
        const contract = new ethers.Contract(
          contractAddress,
          WavePortal.abi,
          signer
        )
        try {
          const transaction = await contract.sendWave(message.value)

          console.log('transaction :>> ', transaction)
          // wait for the transaction to actually settle in the blockchain
          await transaction.wait()
          message.value = ''
        } catch (error) {
          console.error(error)
        }
      }
    }

    return {
      message,
      walletStore,
      sendMessage,
    }
  },
})
</script>
