// Blockfiles.io
// Author: amlug.eth 
// Work in progress.

// Devfund: 0xA8c51eEC9293b5E4E80d43a5eE7e10e707832F36
// Charityfund: 0xfd5bFF20BDc13E4B659dF40f4a431C0625682D01
// Whistleblowerfund: 0x9D200E11D2631D7BEd8700d579e1880b0259bC73
// Treasury: 0xDFaD9bd60E738e29C8891d76039e1A04A9dF2273

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

abstract contract Blockfiles
{
    event NewFileMinted(address indexed owner, uint256 tokenId);
    struct File {
        uint256 royaltyFee;
        uint256 maxHolders;
    }
    address payable public constant ADDRESS_DEV      = payable(0xA8c51eEC9293b5E4E80d43a5eE7e10e707832F36);
    address payable public constant ADDRESS_CHARITY  = payable(0xfd5bFF20BDc13E4B659dF40f4a431C0625682D01);
    address payable public constant ADDRESS_WHISTLE  = payable(0x9D200E11D2631D7BEd8700d579e1880b0259bC73);
    address payable public constant ADDRESS_TREASURY = payable(0xDFaD9bd60E738e29C8891d76039e1A04A9dF2273);
    uint256 public constant CHARITY_SPLIT = 10;
    
    uint256 public pricePerMB;
    bool public uploadOpen;
    uint256 public devSplit;
    uint256 public whistleblowerSplit;

    mapping(uint256 => File) public files;
    mapping(uint256 => string) public customMetadataUris;

    function getRoyaltyFee(uint256 tokenId) public view virtual returns (uint256);
    function getMaxHolders(uint256 tokenId) public view virtual returns (uint256);
    function ownerOf(uint256 tokenId) public view virtual returns (address);
}
