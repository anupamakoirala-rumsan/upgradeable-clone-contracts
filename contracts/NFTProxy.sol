//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import "./NFT.sol";


contract NFTProxy is OwnableUpgradeable,UUPSUpgradeable{

    address private _nftImplementation;

    //Initialize the contract with the address of the implemnatation contract
    function initialize(address implementation) public initializer{
        __Ownable_init();
        _nftImplementation = implementation;
    }
     
     function upgradeImplementation(address newImplementation ) public onlyOwner{
         _nftImplementation = newImplementation;
     }

      // delegate calls to implementation contract
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function _fallback() internal {
        address implementation_ = _nftImplementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation_, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }

    }}