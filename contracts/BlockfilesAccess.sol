// Blockfiles.io
// Author: amlug.eth 
// Work in progress.

// Devfund: 0xA8c51eEC9293b5E4E80d43a5eE7e10e707832F36
// Charityfund: 0xfd5bFF20BDc13E4B659dF40f4a431C0625682D01
// Whistleblowerfund: 0x9D200E11D2631D7BEd8700d579e1880b0259bC73
// Treasury: 0xDFaD9bd60E738e29C8891d76039e1A04A9dF2273

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; 
import "./Blockfiles.sol";

contract BlockfilesAccess is
    ERC1155Upgradeable,
    ERC1155SupplyUpgradeable,
    OwnableUpgradeable
{
    using Strings for uint256;

    event NewAccessMinted(address indexed owner, uint256 tokenId);
    struct File {
        uint256 royaltyFee;
        uint256 maxHolders;
    }
    address payable private constant ADDRESS_DEV      = payable(0xA8c51eEC9293b5E4E80d43a5eE7e10e707832F36);
    address payable private constant ADDRESS_CHARITY  = payable(0xfd5bFF20BDc13E4B659dF40f4a431C0625682D01);
    address payable private constant ADDRESS_WHISTLE  = payable(0x9D200E11D2631D7BEd8700d579e1880b0259bC73);
    address payable private constant ADDRESS_TREASURY = payable(0xDFaD9bd60E738e29C8891d76039e1A04A9dF2273);
    uint256 private constant CHARITY_SPLIT = 10;
    
    CountersUpgradeable.Counter private _tokenIdTracker;
    uint256 private devSplit;
    uint256 private whistleblowerSplit;
    uint256 private fee;

    address private blockfilesContractAddress;

    function initialize() public initializer {
        __ERC1155_init("https://api.blockfiles.io/v1/access/metadata/");
        __Ownable_init();
        devSplit = 50;
        whistleblowerSplit = 10;
        fee = 1;
        blockfilesContractAddress = 0x91CCb03f4c965831399F1915c178cb5853FfAD6e;
    }

    function setDevSplit(uint256 newSplit) external payable onlyOwner {
        devSplit = newSplit;
    }

    function setBlockfilesContractAddress(address adr) external payable onlyOwner {
        blockfilesContractAddress = adr;
    }

    function setWhistleblowerSplit(uint256 newSplit) external payable onlyOwner {
        whistleblowerSplit = newSplit;
    }

    function mintAccess(uint256 tokenId, address owner) external payable {
        Blockfiles bf = Blockfiles(blockfilesContractAddress);
        uint256 royaltyFee = bf.getRoyaltyFee(tokenId);
        uint256 maxHolders = bf.getMaxHolders(tokenId);
        
        require(maxHolders == 0 || (maxHolders)>=(totalSupply(tokenId)+1));
        require(msg.value == royaltyFee, "Payment is not matching flat amount.");
        address payable tokenOwner = payable(bf.ownerOf(tokenId));
        uint256 feeAmount = msg.value*fee/100;
        uint256 remainingAmount = msg.value-feeAmount;
        tokenOwner.call{value: remainingAmount}("");
        _mint(owner, tokenId, 1, "");
        emit NewAccessMinted(owner, tokenId);
    }

    function withdraw() public payable onlyOwner {
        uint256 devSplitAmount = address(this).balance*devSplit/100;
        payable(ADDRESS_DEV).call{value: devSplitAmount}("");
        uint256 charitySplitAmount = address(this).balance*CHARITY_SPLIT/100;
        payable(ADDRESS_CHARITY).call{value: charitySplitAmount}("");
        uint256 whistleblowerSplitAmount = address(this).balance*whistleblowerSplit/100;
        payable(ADDRESS_WHISTLE).call{value: whistleblowerSplitAmount}("");
        uint256 treasury = address(this).balance;
        payable(ADDRESS_TREASURY).call{value: treasury}("");
    }

    function setURI(string memory newuri) public payable onlyOwner {
        _setURI(newuri);
    }

    function uri(
        uint256 _id
    ) public view virtual override returns (string memory) {
        return string(abi.encodePacked(super.uri(0), _id.toString()));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155Upgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
