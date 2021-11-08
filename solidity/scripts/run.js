const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy()
  await waveContract.deployed()

  console.log('Contract deployed to:', waveContract.address)
  console.log('Contract deployed by:', owner.address)

  let waveCount
  waveCount = await waveContract.getTotalWaves()

  let waveTxn = await waveContract.sendWave('hohoho')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).sendWave('message one')
  await waveTxn.wait()

  waveTxn = await waveContract.connect(randomPerson).sendWave('something else')
  await waveTxn.wait()

  waveTxn = await waveContract.connect(randomPerson).sendWave('yada yada')
  await waveTxn.wait()

  waveTxn = await waveContract.connect(randomPerson).sendWave('wooooooo')
  await waveTxn.wait()

  waveCount = await waveContract.getTotalWaves()

  const allWaves = (waveCount = await waveContract.getAllWaves())

  console.log('allWaves :>> ', allWaves)
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
