// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    event NewWave(address indexed from, uint256 timestamp, string message);

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

        // saves message in array
        allMessages.push(Message(_newMessage, msg.sender, block.timestamp));

        // emit event for web app
        emit NewWave(msg.sender, block.timestamp, _newMessage);

        console.log("AllMessages updated");
    }

    function getAllWaves() public view returns (Message[] memory) {
        return allMessages;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);

        return totalWaves;
    }
}
