// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    mapping(address => uint256) wavesPerUser;
    struct Message {
        string text;
        address from;
        uint256 datetime;
    }
    Message[] allMessages;

    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function sendWave(string memory _newMessage) public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        wavesPerUser[msg.sender] += 1;

        console.log(
            "Number of waves of %a %s >> ",
            msg.sender,
            wavesPerUser[msg.sender]
        );
        Message memory newMessage = Message(
            _newMessage,
            msg.sender,
            block.timestamp
        );

        allMessages.push(newMessage);

        console.log("AllMessages updated");
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);

        return totalWaves;
    }
}
