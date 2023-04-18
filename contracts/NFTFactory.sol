import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import "./NFTProxy.sol";
import "./NFT.sol";

pragma solidity 0.8.18;

contract NFTFactory is OwnableUpgradeable{
    address private _nftImplementation;
    address[] public deployedNfts;

    event nftCreated(address nftAddress);

    function initialize(address implementation) public initializer{
        __Ownable_init();
        _nftImplementation = implementation;
    }
    
    function upgradeImplementation(address newImplementation ) public onlyOwner{
        _nftImplementation = newImplementation;
    }

    function createNFT(string memory name, string memory symbol) public returns (address) {
        address nft = ClonesUpgradeable.clone(_nftImplementation);
        NFT(nft).initialize(name, symbol);
        NFTProxy proxy = new NFTProxy();
        proxy.initialize(nft);
        emit nftCreated(nft);
        deployedNfts.push(nft);
        return nft;
    }
}