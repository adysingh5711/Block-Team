// SPDX-License-Identifier: MIT
// Reference from my previous team project "ImpactBridge-Linking-Defi-Sustainability"
pragma solidity >=0.5.0 <=0.9.0;

import "InvestorReturns.sol";

contract FundAllocationVote {
    uint256 public minThreshold;
    uint256 public yesVotes;
    uint256 public totalVotes;
    uint256 public poolFunds;
    uint256 public requestedAmount;

    // Project vote counts: [0] = yes, [1] = no
    mapping(uint256 => uint256[2]) public ProjectVotes;
    mapping(uint256 => bool) public ProjectVerify;

    // Investor holdings of Impact Tokens
    mapping(address => uint256) public investors;

    constructor(
        uint256 _minThreshold,
        uint256 _poolFunds,
        uint256 _requestedAmount
    ) {
        minThreshold = _minThreshold;
        poolFunds = _poolFunds;
        requestedAmount = _requestedAmount;
    }

    modifier onEsgApproved {
        // Additional gas optimization can be done here
        // Ensure the ESG score check is optimized
        _;
    }

    function castVote(
        uint256 projectId,
        uint256 choice,
        uint256 voteCount
    ) public onEsgApproved {
        require(choice == 1 || choice == 2, "Wrong Choice");
        require(ProjectVerify[projectId] == true, "Not Valid Project");
        require(
            voteCount <= investors[msg.sender] && investors[msg.sender] > 0,
            "Not enough Impact Token"
        );
        ProjectVotes[projectId][choice - 1] += voteCount;
        investors[msg.sender] -= voteCount;
    }

    function calculateAllocation(uint256 projectId) internal view returns (uint256) {
        uint256 yesVote = ProjectVotes[projectId][0];
        uint256 noVote = ProjectVotes[projectId][1];

        uint256 yesPercentage = (yesVote * 100) / (yesVotes + noVote);
        uint256 Allocation = (yesPercentage * poolFunds) / 100;

        if (Allocation < minThreshold) {
            Allocation += minThreshold - Allocation;
        }

        return Allocation > requestedAmount ? requestedAmount : Allocation;
    }

    function transferFund(uint256 projectId) private view {
        uint256 allocatedFund = calculateAllocation(projectId);
        // Additional logic for transferring funds can be optimized here
    }
}
