// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./tokenCreation.sol";

contract InvestorRegistry {
    address public owner;
    ImpactToken public impactToken; // The Impact Token contract

    struct Investor {
        string name;
        string email;
        string nationality;
        string investingPreference;
        bool registered;
        uint tokenNumbers;
        string ipfsFinancialDocumentHash; // Renamed the field for IPFS document hash
    }

    mapping(address => Investor) public investors;

    event InvestorRegistered(
        address indexed investor,
        string name,
        string email,
        string nationality,
        bool registered,
        string ipfsFinancialDocumentHash
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        impactToken = ImpactToken(_tokenAddress); // Set the Impact Token contract address
    }

    function register(
        string calldata name,
        string calldata email,
        string calldata nationality,
        string calldata investingPreference,
        string calldata ipfsDocumentHash
    ) external {
        // Check if the investor is not already registered
        require(
            !investors[msg.sender].registered,
            "Investor already registered"
        );

        // Check if IPFS document hash is not empty
        require(
            bytes(ipfsDocumentHash).length > 0,
            "IPFS document hash cannot be empty"
        );

        // Check if the investor owns Impact Tokens to register
        require(
            impactToken.balanceOf(msg.sender) > 0,
            "You must own Impact Tokens to register"
        );

        // Utilizing Hyperlane for gas optimization
        uint startGas = gasleft();

        // Store investor information in the mapping
        investors[msg.sender] = Investor({
            name: name,
            email: email,
            nationality: nationality,
            investingPreference: investingPreference,
            registered: true,
            tokenNumbers: impactToken.balanceOf(msg.sender),
            ipfsFinancialDocumentHash: ipfsDocumentHash
        });

        // Calculate gas used by Hyperlane
        uint gasUsed = startGas - gasleft();

        // Emit event for successful registration
        emit InvestorRegistered(
            msg.sender,
            name,
            email,
            nationality,
            true,
            ipfsDocumentHash
        );

        // Charge the caller for the gas used by Hyperlane
        impactToken.transferFrom(msg.sender, address(this), gasUsed);
    }
}
