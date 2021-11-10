// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    event NewWave(address indexed from, uint256 timestamp, string message);
    event LotteryEvent(bool isWinner);

    mapping(address => uint256) wavesPerUser;
    struct Message {
        string text;
        address from;
        uint256 datetime;
    }
    Message[] allMessages;

    uint256 secretNumber;
    uint256 ticketPrice = 0.0001 ether;

    struct Lottery {
        uint256 number;
        uint256 price;
    }

    Lottery[] lotteryHistory;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        secretNumber = 33;
        console.log("The secret number is %s", secretNumber);
    }

    // generates a semi random number between 0 and 100
    function random() private view returns (uint256) {
        uint256 randomHash = uint256(
            keccak256(abi.encodePacked(block.timestamp))
        );
        uint256 randomHash2 = uint256(
            keccak256(abi.encodePacked(block.difficulty))
        );

        return ((randomHash % 100) * (randomHash2 % 100)) % 100;
    }

    function getPrize() public view returns (uint256) {
        return address(this).balance;
    }

    function playLottery(uint256 _number) public payable {
        console.log("Current balance is ", address(this).balance);
        require(msg.value >= ticketPrice, "Minimum value is 0.0001 ETH!");
        if (_number != secretNumber) {
            console.log("Ohhhhh");
            emit LotteryEvent(false);
        }

        // if number sent is correct, send money and reset number
        if (_number == secretNumber) {
            emit LotteryEvent(true);

            console.log("WINNEEEERRRR");

            (bool success, ) = (msg.sender).call{value: address(this).balance}(
                ""
            );
            console.log("success %s", success);
            if (success) {
                secretNumber = random();

                console.log("Balance after win is ", address(this).balance);
                console.log("The secret number is %s", secretNumber);
            }
        }
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
