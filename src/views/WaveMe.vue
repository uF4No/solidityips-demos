<template>
  <div class="home">
    <h1 class="text-5xl font-bold mt-12 mb-8 max-w-xl mx-auto">
      Send a message 👋 or <br />
      guess the number 🎲
    </h1>
    <h2 class="text-xl">
      Send a message and it'll be stored in the blockchain!
    </h2>
    <p class="my-8" v-if="walletStore.walletData != null">
      People have sent
      <span class="text-indigo-500 font-bold">{{ totalWaves }}</span> messages
      so far
    </p>
    <p v-else class="my-8 text-red-500 font-medium">
      You have to connect your wallet first!
    </p>
    <p class="my-4 font-medium">
      Note: This app works using the Rinkeby blockchain
    </p>
    <div class="flex flex-col max-w-md mx-auto space-y-4 mt-8">
      <textarea
        v-model="message"
        :disabled="walletStore.walletData == null"
        cols="30"
        rows="5"
        class="border ring-none text-pink-600 font-medium rounded p-2"
        :class="
          walletStore.walletData == null
            ? 'border-gray-200 text-gray-400'
            : 'border-pink-500 text-pink-600 hover:shadow-lg shadow-sm'
        "
      ></textarea>

      <button
        @click="sendMessage"
        :disabled="walletStore.walletData == null || trxInProgress"
        class="px-4 py-2 mt-8 border font-medium rounded"
        :class="
          walletStore.walletData == null
            ? 'border-gray-200 text-gray-400'
            : 'border-pink-500 text-pink-600 hover:shadow-lg shadow-sm'
        "
      >
        {{ trxInProgress ? `Sending...` : `Send message 👋` }}
      </button>
      <hr />
      <p class="text-xl">
        Enter a number between 1 and 100. If you get the lucky number, you'll
        win a prize! Current prize is
        <span class="font-bold text-indigo-600">{{ currentPrize }}ETH</span>
      </p>
      <p class="text-xl">
        You'll have to pay 0.0001ETH to participate each time. Prize will
        accumulate until there is a winner.
      </p>
      <input
        :disabled="walletStore.walletData == null"
        class="border ring-none text-indigo-600 font-medium rounded p-2"
        :class="
          walletStore.walletData == null
            ? 'border-gray-200 text-gray-400'
            : 'border-indigo-500 text-indigo-600 hover:shadow-lg shadow-sm'
        "
        type="number"
        min="0"
        max="100"
        v-model="number"
      />
      <p class="text-sm font-medium text-red-600">
        Number must be between 1 and 100 (both included)
      </p>
      <button
        @click="playLottery"
        :disabled="walletStore.walletData == null || trxInProgress"
        class="px-4 py-2 mt-8 border font-medium rounded"
        :class="
          walletStore.walletData == null
            ? 'border-gray-200 text-gray-400'
            : 'border-indigo-500 text-indigo-600 hover:shadow-lg shadow-sm'
        "
      >
        {{ trxInProgress ? `Sending...` : `Guess number 🎲` }}
      </button>
    </div>
    <p class="mt-4 font-bold">All messages 📩</p>
    <ul class="flex flex-col max-w-md my-8 mx-auto">
      <li
        class="p-4 border mt-2 rounded-lg"
        v-for="msg in allMessages"
        :key="msg"
      >
        <div class="text-left">
          <p>
            <span class="font-bold"
              >{{ msg.from.slice(0, 2) }}...{{ msg.from.slice(-4) }}</span
            >
            said:
          </p>
          <blockquote class="italic">{{ msg.text }}</blockquote>
        </div>
        <p class="text-sm mt-4 text-right">posted on {{ msg.datetime }}</p>
        <p></p>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { useWalletStore } from '@/stores/wallet'
import { ethers } from 'ethers'

import WavePortal from '@/artifacts/solidity/contracts/WavePortal.sol/WavePortal.json'

export default defineComponent({
  name: 'WaveMe',
  components: {},

  setup() {
    const walletStore = useWalletStore()
    const contractAddress = process.env.VUE_APP_ADDRESS_WAVE || ''
    const message = ref('')
    const totalWaves = ref(0)
    const allMessages = ref([])
    const trxInProgress = ref(false)
    const number = ref(0)
    const currentPrize = ref(0)

    const getTotalWaves = async function () {
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        //@ts-expect-error Window.ethers not TS
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        const contract = new ethers.Contract(
          contractAddress,
          WavePortal.abi,
          provider
        )
        try {
          const data = await contract.getTotalWaves()
          console.log('totalWaves :>> ', data)
          totalWaves.value = data
        } catch (error) {
          console.error(error)
        }
      }
    }
    const validateNumber = function () {
      if (number.value < 0 || number.value > 100) return false
      return true
    }

    const getCurrentPrize = async function () {
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        //@ts-expect-error Window.ethers not TS
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        const contract = new ethers.Contract(
          contractAddress,
          WavePortal.abi,
          provider
        )
        try {
          const data = await contract.getPrize()
          console.log('currentPrize :>> ', data)
          //@ts-expect-error because why not
          currentPrize.value = ethers.utils.formatEther(data)
        } catch (error) {
          console.error(error)
        }
      }
    }

    const getAllWaves = async function () {
      allMessages.value = []

      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        //@ts-expect-error Window.ethers not TS
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        const contract = new ethers.Contract(
          contractAddress,
          WavePortal.abi,
          provider
        )
        try {
          const data = await contract.getAllWaves()
          console.log('allWaves :>> ', data)
          data.forEach((wave: any) => {
            allMessages.value.push({
              //@ts-expect-error Window.ethers not TS
              from: wave.from,
              //@ts-expect-error Window.ethers not TS
              text: wave.text,
              //@ts-expect-error Window.ethers not TS
              datetime: new Date(wave.datetime * 1000),
            })
          })
          // allMessages.value = data
        } catch (error) {
          console.error(error)
        }
      }
    }

    const sendMessage = async function () {
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        trxInProgress.value = true
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
          trxInProgress.value = false

          //@ts-expect-error because why not
          this.getAllWaves()
          //@ts-expect-error because why not
          this.getTotalWaves()
        } catch (error) {
          console.error(error)
          trxInProgress.value = false
        }
      }
    }

    const playLottery = async function () {
      if (!validateNumber()) return
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        trxInProgress.value = true
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
          const txOverrides = {
            // from: this.userAddress,
            // to: this.escrowAddress,
            value: ethers.utils.parseEther('0.0001'),
            // nonce: provider.getTransactionCount(this.userAddress, 'latest'),
            // gasLimit: ethers.utils.hexlify(gasPrice),
            // gasPrice: gasPrice,
          }
          const transaction = await contract.playLottery(
            number.value,
            txOverrides
          )

          console.log('transaction :>> ', transaction)
          // wait for the transaction to actually settle in the blockchain
          await transaction.wait()
          number.value = 0
          trxInProgress.value = false

          //@ts-expect-error because why not
          this.getCurrentPrize()
        } catch (error) {
          console.error(error)
          trxInProgress.value = false
        }
      }
    }

    return {
      message,
      number,
      totalWaves,
      allMessages,
      walletStore,
      trxInProgress,
      currentPrize,
      sendMessage,
      getAllWaves,
      getTotalWaves,
      getCurrentPrize,
      playLottery,
    }
  },
  mounted() {
    if (this.walletStore.walletData !== null) {
      console.log('There is a wallet connected!')
      this.getTotalWaves()
      this.getAllWaves()
      this.getCurrentPrize()
    }
  },
  computed: {
    accAvailable() {
      return useWalletStore().walletData
    },
  },
  watch: {
    accAvailable(newVal, old) {
      console.log(`updating from ${old} to ${newVal}`)
      this.getTotalWaves()
      this.getAllWaves()
      this.getCurrentPrize()
    },
  },
})
</script>
