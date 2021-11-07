// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    mapping(address => uint256) wavesPerUser;

    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function sendWave() public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        wavesPerUser[msg.sender] += 1;

        console.log(
            "Number of waves of %a %s >> ",
            msg.sender,
            wavesPerUser[msg.sender]
        );
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);

        return totalWaves;
    }
}
