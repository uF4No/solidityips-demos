<template>
  <div class="flex flex-col max-w-md mx-auto space-y-4 mt-8">
    <h1 class="text-5xl font-bold mt-12 mb-8 max-w-xl mx-auto">
      Guess the lucky number 🍀🎲
    </h1>

    <p class="text-xl" v-if="walletStore.walletData != null">
      Enter a number between 1 and 100. If you get the lucky number, you'll win
      a prize! Current prize is
      <span class="font-bold text-indigo-600">{{ currentPrize }}ETH</span>
    </p>
    <p v-else class="my-8 text-red-500 font-medium">
      You have to connect your wallet first!
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
    <p
      v-if="showAlert"
      class="text-3xl font-bold"
      :class="isWinner ? `text-green-400` : `text-red-600`"
    >
      <span>{{ isWinner ? `You've won 🎉!!!` : 'Ohh! Try again ' }}</span>
    </p>
    <p v-if="latestNumbers.length > 0">
      Psst! the last numbers played are: {{ latestNumbers.slice(-5) }} so don't
      try any of those 😉
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
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import { useWalletStore } from '@/stores/wallet'
import { Contract, ethers } from 'ethers'

import LuckyNumber from '@/artifacts/solidity/contracts/LuckyNumber.sol/LuckyNumber.json'

export default defineComponent({
  name: 'LuckyNumber',

  setup() {
    const walletStore = useWalletStore()
    const contractAddress = process.env.VUE_APP_ADDRESS_LUCKYN || ''
    const trxInProgress = ref<boolean>(false)
    const isWinner = ref<boolean>(false)
    const showAlert = ref<boolean>(false)

    const number = ref<number | null>(null)
    const currentPrize = ref<number>(0)
    const latestNumbers = ref<number[]>([])

    let contract: Contract
    //@ts-expect-error Window.ethers not TS
    let provider

    const connect = async function () {
      //@ts-expect-error Window.ethers not TS
      if (typeof window.ethereum !== 'undefined') {
        //@ts-expect-error Window.ethers not TS
        provider = new ethers.providers.Web3Provider(window.ethereum)

        contract = new ethers.Contract(
          contractAddress,
          LuckyNumber.abi,
          provider
        )

        console.log('contract :>> ', contract)
        // handle event from contract
        contract.on('LotteryEvent', function (won: boolean) {
          console.log('Checking result!!!')
          showAlert.value = true
          isWinner.value = won
          trxInProgress.value = false
        })
      }
    }

    const getLatestNumbers = async function () {
      latestNumbers.value = []

      try {
        //@ts-expect-error because why not
        const gasPrice = await provider.getGasPrice()
        console.log('gasPrice :>> ', gasPrice.toNumber())
        const data = await contract.getLatestNumbers({
          gasLimit: ethers.utils.hexlify(gasPrice),
          // gasPrice: gasPrice,
        })
        console.log('latest numbers :>> ', data)
        data.forEach((number: number) => {
          //@ts-expect-error because why not
          latestNumbers.value.push(number.toNumber())
        })
      } catch (error) {
        console.error(error)
      }
    }

    const validateNumber = function () {
      if (!number.value || number.value < 0 || number.value > 100) return false
      return true
    }

    const getCurrentPrize = async function () {
      try {
        //@ts-expect-error because why not
        const gasPrice = await provider.getGasPrice()
        console.log('gasPrice :>> ', gasPrice.toNumber())
        const data = await contract.getPrize({
          gasLimit: ethers.utils.hexlify(gasPrice),
          // gasPrice: gasPrice,
        })
        console.log('currentPrize :>> ', data)
        //@ts-expect-error because why not
        currentPrize.value = ethers.utils.formatEther(data)
      } catch (error) {
        console.error(error)
      }
      // }
    }

    const playLottery = async function () {
      if (!validateNumber()) return
      //@ts-expect-error because why not
      if (!provider) connect()
      showAlert.value = false
      trxInProgress.value = true

      // get the account that will pay for the trasaction
      //@ts-expect-error Window.ethers not TS
      const signer = provider.getSigner()
      // as the operation we're going to do is a transaction,
      // we pass the signer instead of the provider
      const contract = new ethers.Contract(
        contractAddress,
        LuckyNumber.abi,
        signer
      )
      try {
        //@ts-expect-error because why not
        const gasPrice = await provider.getGasPrice()
        console.log('gasPrice :>> ', gasPrice.toNumber())
        const txOverrides = {
          // from: this.userAddress,
          // to: this.escrowAddress,
          value: ethers.utils.parseEther('0.0001'),
          // nonce: provider.getTransactionCount(this.userAddress, 'latest'),
          gasLimit: ethers.utils.hexlify(gasPrice),
          // gasPrice: gasPrice,
        }
        const transaction = await contract.playLottery(
          number.value,
          txOverrides
        )

        console.log('transaction :>> ', transaction)
        // wait for the transaction to actually settle in the blockchain
        await transaction.wait()
        number.value = null

        getCurrentPrize()
        getLatestNumbers()
      } catch (error) {
        console.error(error)
        trxInProgress.value = false
      }
      // }
    }

    return {
      playLottery,
      getCurrentPrize,
      validateNumber,
      getLatestNumbers,
      connect,
      number,
      walletStore,
      latestNumbers,
      trxInProgress,
      currentPrize,
      isWinner,
      showAlert,
    }
  },
  async mounted() {
    if (this.walletStore.walletData !== null) {
      console.log('There is a wallet connected!')
      await this.connect()

      this.getCurrentPrize()
      this.getLatestNumbers()
    }
  },
  computed: {
    accAvailable() {
      return useWalletStore().walletData
    },
  },
  watch: {
    async accAvailable(newVal, old) {
      console.log(`updating from ${old} to ${newVal}`)
      await this.connect()
      this.getCurrentPrize()
      this.getLatestNumbers()
    },
  },
})
</script>
