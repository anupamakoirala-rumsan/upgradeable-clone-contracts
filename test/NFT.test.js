const {upgrades,ethers} = require("hardhat");

describe("NFT",function(){
    let nft;
      before(async function(){
    [owner, addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();
    const NFT = await ethers.getContractFactory("NFT");
    const nftImplementation = await NFT.deploy();
    await nftImplementation.deployed();

    const NFT2 = await ethers.getContractFactory("NFT1");
    const nftImplementation2 = await NFT2.deploy();
    await nftImplementation2.deployed();
    console.log("second", nftImplementation2.address)
    console.log("Deploying NFT Factory.........")

    const NFTProxy = await ethers.getContractFactory("NFTProxy");
    const nftProxy = await NFTProxy.deploy();
    await nftProxy.deployed();
    await nftProxy.initialize(nftImplementation.address)

    const NFTFactory = await ethers.getContractFactory("NFTFactory");
    const nftFactory = await NFTFactory.deploy();
    await nftFactory.deployed();
    console.log("Initializing NFT Factory.........")
    console.log("nftImplementation", nftImplementation.address)
    await nftFactory.initialize(nftImplementation.address)
    console.log("Creating NFT.........")
    const tx = await nftFactory.createNFT("ART", "ART");
   const receipt =  await tx.wait();
   const nftProxyAddress = receipt.events[4].args[0];
   console.log(nftProxyAddress)
    // nft = NFT.attach(nftProxyAddress);

    await nftProxy.upgradeImplementation(nftImplementation2.address);
    nft = NFT2.attach(nftProxyAddress);
    console.log(nft)
    // const implement  =  await upgrades.erc1967.getImplementationAddress(nftImplementation.address);
    // console.log(implement)


    console.log('NFTFactory deployed to:', nftFactory.address);
    console.log('NFT deployed to:', nftImplementation.address);
    })

    it("Should return the name and symbol of nft", async function(){
        assert.equal(await nft.name(), "ART");
        assert.equal(await nft.symbol(), "ART");
    })
    it("Should mint a new token", async function(){
      await nft.mintNft("https://ipfs.io/",addr2.address);
      const balance  = await nft.balanceOf(addr2.address);
      assert.equal(balance, 1);
      const tokenOwner = await nft.ownerOf(0);
      assert.equal(tokenOwner, addr2.address);
      const tokenUri = await nft.tokenURI(0);
      assert.equal(tokenUri,"https://ipfs.io/");
    })
    
})