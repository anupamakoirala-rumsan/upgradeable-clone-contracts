//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';

contract NFT is Initializable, UUPSUpgradeable,OwnableUpgradeable,ERC721Upgradeable,ERC721URIStorageUpgradeable{

    using CountersUpgradeable for CountersUpgradeable.Counter;
    ///@notice tracks the token ids
    CountersUpgradeable.Counter private tokenIds;


    event NFTMinted(uint256 indexed tokenId, address indexed owner, address minter);

    ///@notice initialize during proxy contract deployment
    ///@param name name of the nft
    ///@param symbol symbol of the nft
    ///@dev called only once during contract deployment
    function initialize(string memory name, string memory symbol) public initializer{
       __ERC721_init(name, symbol);
       __Ownable_init();
    }

    ///@notice safeguard from unauthorized upgrades
    ///@dev required for uups upgradeable contracts
    function _authorizeUpgrade(address) internal override onlyOwner{}

    ///@notice mint nft 
    ///@param _uri token uri of the nft
    ///@param _to address to mint the nft
    ///@dev can be called by any one 
    function mintNft(string memory _uri, address _to) public  virtual{
        uint256 id = tokenIds.current();
        _safeMint(_to, id);
        _setTokenURI(id, _uri);
        tokenIds.increment();
        emit NFTMinted(id, _to, msg.sender);

    }
    ///@notice returns the current token id value
    function getCurrentTokenId() public view returns(uint256 id){
        return tokenIds.current();
    }

    ///@notice increments the tokenId
    function incrementTokenId()internal {
        tokenIds.increment();

    }

    //overrides the base contracts function
    function tokenURI(uint256 _tokenId) public view virtual override(ERC721Upgradeable,ERC721URIStorageUpgradeable) returns (string memory) {
       return super.tokenURI(_tokenId);
   }


   function _burn(uint256 _tokenId) internal override(ERC721Upgradeable,ERC721URIStorageUpgradeable){
      super._burn(_tokenId);
   }
    
}
