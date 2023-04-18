//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';


contract NFTProxy is ClonesUpgradeable, UUPSUpgradeable, OwnableUpgradeable{

    address private _nftImplementation;

    //Initialize the contract with the address of the implemnatation contract
    function initialize(address nftImplementation) public initializer{
        _nftImplementation = nftImplementation;
    }

    //Override the _authorizeUpgrade function to allow only the owner to upgrade the contract
    function _authorizeUpgrade(address) internal override onlyOwner{}

    // Override the _upgradeTo function to set the address of the new implementation contract
    function _upgradeTo(address newImplementation) internal override {
        _implementation = newImplementation;
    }

    // Override the _implementation function to return the address of the implementation contract
    function _implementation() internal view override returns (address) {
        return _implementation;
    }
}