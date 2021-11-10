const main = async () => {
  // const [deployer] = await hre.ethers.getSigners()
  // const accountBalance = await deployer.getBalance()

  // console.log('Deploying contracts with account: ', deployer.address)
  // console.log('Account balance: ', accountBalance.toString())

  // const Token = await hre.ethers.getContractFactory('WavePortal')
  // const portal = await Token.deploy()
  // await portal.deployed()

  // console.log('WavePortal address: ', portal.address)

  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy({})

  const luckyContractFactory = await hre.ethers.getContractFactory(
    'LuckyNumber'
  )
  const luckyContract = await luckyContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.0015'),
  })

  await waveContract.deployed()

  console.log('WavePortal address: ', waveContract.address)

  await luckyContract.deployed()

  console.log('LuckyNumber address: ', luckyContract.address)
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}

runMain()
