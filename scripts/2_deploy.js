const {upgrades,ethers,run} = require("hardhat");

async function main(){

    const NFT = await ethers.getContractFactory("NFT");
    const nftImplementation = await NFT.deploy();

    const NFT2 = await ethers.getContractFactory("NFT1");
    const nftImplementation2 = await NFT2.deploy();
    await nftImplementation2.deployed();
    console.log("Deploying NFT Factory.........")

    // console.log("Deploying NFT Proxy.........");

    // const NFTProxy = await ethers.getContractFactory("NFTProxy");
    // const nftProxy = NFTProxy.attach("0x228A021Be0115fa310703fc1353a6745A602e234");
    // nftProxy.upgradeImplementation("0x447eaE284BFfBe2346Bad26ebb69a561B1825C02");
    const nftProxy = await NFTProxy.deploy();
    await nftProxy.deployed();
    await nftProxy.initialize(nftImplementation.address)
    // const nft =  NFT.attach(nftProxy.address);
    // await nft.initialize("ART", "ART");

    console.log("Deploying NFT Factory.........")

    const NFTFactory = await ethers.getContractFactory("NFTFactory");
    const nftFactory = await NFTFactory.deploy();
    await nftFactory.deployed();
    console.log("Initializing NFT Factory.........")
    await nftFactory.initialize(nftImplementation.address)
    const tx = await nftFactory.createNFT("ART", "ART");
   const receipt =  await tx.wait();
   console.log(receipt.events[4].args[0])
   const nftProxyAddress = receipt.events[4].args[0];
    // const nft = NFT.attach(nftProxyAddress);
  console.log('NFTFactory deployed to:', nftFactory.address);
  console.log('NFT deployed to:', nftImplementation.address);
  console.log('NFT Proxy contract deployed to:', nftProxy.address);
  console.log("second", nftImplementation2.address)




  await run("verify:verify", {
    address: nftFactory.address,

  })

  await run("verify:verify", {
    address: nftImplementation.address,
    
  })

//   await run("verify:verify", {
//     address: nftProxyAddress,
//   })

  await run("verify:verify", {
    address: nftProxy.address,
  })
   
   
}
main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
  });
