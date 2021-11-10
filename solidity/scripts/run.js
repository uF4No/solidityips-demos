const main = async () => {
  const [owner, randomPerson, randomPerson2] = await hre.ethers.getSigners()
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  // deploy with some ETH
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  })
  await waveContract.deployed()

  console.log('Contract deployed to:', waveContract.address)
  console.log('Contract deployed by:', owner.address)

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  )
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  )

  let waveCount
  waveCount = await waveContract.getTotalWaves()

  let waveTxn = await waveContract.sendWave('hohoho')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).sendWave('message one')
  await waveTxn.wait()

  waveTxn = await waveContract.connect(randomPerson).sendWave('something else')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  const allWaves = (waveCount = await waveContract.getAllWaves())

  console.log('allWaves :>> ', allWaves)

  let lotteryTxn = await waveContract.connect(randomPerson).playLottery(12, {
    value: hre.ethers.utils.parseEther('0.1'),
  })

  lotteryTxn = await waveContract.connect(randomPerson2).playLottery(33, {
    value: hre.ethers.utils.parseEther('0.1'),
  })
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
