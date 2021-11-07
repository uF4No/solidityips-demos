import { defineStore } from 'pinia'

export const useWalletStore = defineStore('wallet', {
  state: () => {
    return { walletData: null }
  },
  // could also be defined as
  // state: () => ({ count: 0 })
  actions: {
    // increment() {
    //   this.count++
    // },
    //@ts-ignore
    saveWalletData(payload: any) {
      this.walletData = payload
    },
  },
})
