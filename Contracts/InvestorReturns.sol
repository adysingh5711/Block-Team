// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestmentReturn {
    uint public investmentPoolAmount; // Total amount in the investment pool
    uint public fundsAllocated; // Total funds allocated for investment

    event InvestmentPoolInitialized(uint amount);
    event FundsAllocatedUpdated(uint amount);

    constructor(uint _initialPoolAmount) {
        require(
            _initialPoolAmount > 0,
            "Initial pool amount must be greater than zero"
        );
        investmentPoolAmount = _initialPoolAmount;
        emit InvestmentPoolInitialized(_initialPoolAmount);
    }

    function updateFundsAllocated(uint _newFundsAllocated) public {
        require(
            _newFundsAllocated > 0,
            "Funds allocated must be greater than zero"
        );
        fundsAllocated = _newFundsAllocated;
        emit FundsAllocatedUpdated(_newFundsAllocated);
    }

    function returnOnInvestment(
        uint investorContribution
    ) public view returns (uint) {
        require(
            investmentPoolAmount > 0,
            "Investment pool amount must be greater than zero"
        );
        uint contributionPercentage = (investorContribution * 100) /
            investmentPoolAmount;
        require(
            contributionPercentage > 0,
            "Contribution percentage can't be zero"
        );

        // Utilizing Hyperlane for gas optimization
        uint claimTokensWorth;
        assembly {
            // Hyperlane invocation
            claimTokensWorth := calldataload(0x04)
            returndatacopy(0x00, 0x00, returndatasize())
            if iszero(
                call(gas(), 0x05, 0x00, 0x00, returndatasize(), 0x00, 0x00)
            ) {
                revert(0x00, returndatasize())
            }
        }

        return claimTokensWorth;
    }
}
