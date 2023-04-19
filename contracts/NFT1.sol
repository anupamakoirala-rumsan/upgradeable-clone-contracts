//SPDX-License-Identifier:MIT

pragma solidity 0.8.18;

import "./NFT.sol";

contract NFT1 is NFT{
    uint256 basePrice;
    
    modifier tokenOwner(uint256 id){
        address owner = ownerOf(id);
         require(owner == msg.sender,"NFT: Not owner");
        _;
    }

    ///@notice add the base price
    ///@param _basePrice price to set 
    ///@dev only owner can call 
    function addBasePrice(uint256 _basePrice) public onlyOwner{
        basePrice = _basePrice;
    }

    ///@notice mint nft 
    ///@param _uri token uri of the nft
    ///@param _to address to mint the nft
    ///@dev payable function 
    function nftMint(string memory _uri, address _to) public  payable  {
        require(msg.value == basePrice,"NFT:price mismatch");
        (bool txStatus,) =  owner().call{value:msg.value}('');
        require(txStatus,"Failed to transfer fees");
        super.mintNft(_uri,_to);

    }
    
    ///@notice burn nft 
    ///@param tokenId id to burn
    ///@dev only token owner can call
    function burnNft(uint256 tokenId) public tokenOwner(tokenId){
        _burn(tokenId);
    }


}
