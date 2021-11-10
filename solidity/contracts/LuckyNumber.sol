// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract LuckyNumber {
    event LotteryEvent(bool isWinner);

    uint256 secretNumber;
    uint256 ticketPrice = 0.0001 ether;
    uint256[] latestNumbers;

    struct Lottery {
        uint256 number;
        uint256 price;
    }

    Lottery[] lotteryHistory;

    constructor() payable {
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

    function getLatestNumbers() public view returns (uint256[] memory) {
        return latestNumbers;
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

            (bool success, ) = (msg.sender).call{
                value: (address(this).balance * 80) / 100
            }("");

            require(success, "Failed to send the prize to the winner");

            secretNumber = random();

            console.log("Balance after win is ", address(this).balance);
            console.log("The secret number is %s", secretNumber);
            // reset latestNumbers
            delete latestNumbers;
        }
        latestNumbers.push(_number);
    }
}
