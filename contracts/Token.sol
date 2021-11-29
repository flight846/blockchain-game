pragma solidity 0.8.10;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC721, Ownable {
    struct Pet {
        uint8 damage; // 0-255
        uint8 magic;
        uint256 lastMeal;
        uint256 endurance; // 24 hours
    }

    uint256 nextId = 0;

    mapping(uint256 => Pet) private _tokenDetails;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(uint8 damage, uint8 magic, uint8 endurance) public onlyOwner {
        _safeMint(msg.sender, 0);
        _tokenDetails[nextId] = Pet(damage, magic, block.timestamp, endurance);
        nextId++;
    }

    function feed(uint256 tokenId) public {
        Pet storage pet = _tokenDetails[nextId];
        require(pet.lastMeal + pet.endurance > block.timestamp);
        _tokenDetails[nextId].lastMeal = block.timestamp;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        Pet storage pet = _tokenDetails[nextId];
        require(pet.lastMeal + pet.endurance > block.timestamp); // Pet still alive
    }
}
