// SPDX-License-Identifier: MIT
// Reference from my previous team project "ImpactBridge-Linking-Defi-Sustainability"
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// Import XDC related libraries
import "hyperlane-xdc/contracts/token/XDC.sol";
import "hyperlane-xdc/contracts/bridge/XDCBridge.sol";

contract ImpactToken is ERC20, Ownable, Pausable, XDC {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    // Mint new tokens (onlyOwner)
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Burn tokens (onlyOwner)
    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    // Pause token transfers (onlyOwner)
    function pause() public onlyOwner {
        _pause();
    }

    // Unpause token transfers (onlyOwner)
    function unpause() public onlyOwner {
        _unpause();
    }

    // Override _beforeTokenTransfer to implement custom transfer logic
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);

        // Add your custom transfer logic here
        // For example, check ownership or approval mechanisms
        // Ensure to emit events for transparency
    }

    // Override _afterTokenTransfer to implement post-transfer logic
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        super._afterTokenTransfer(from, to, amount);

        // Add your post-transfer logic here
        // For example, update balances or trigger events
    }
}
