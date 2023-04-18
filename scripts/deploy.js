const {upgrades,ethers} = require("hardhat");

async function main(){

    const NFT = await ethers.getContractFactory("NFT");
    const nftImplementation = await NFT.deploy();

    // console.log("Deploying NFT Proxy.........");

    const NFTProxy = await ethers.getContractFactory("NFTProxy");
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
   console.log(receipt.events[2].args[0])
   const nftProxyAddress = receipt.events[2].args[0];
    const nft = NFT.attach(nftProxyAddress);
    console.log(nft);
  console.log('NFTFactory deployed to:', nftFactory.address);
  console.log('NFT deployed to:', nftImplementation.address);
   
}
main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
  });
