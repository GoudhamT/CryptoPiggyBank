//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "./PriceConvertor.sol";
import {console} from "forge-std/Script.sol";

contract CryptoPiggyBank {
    using PriceConvertor for uint256;
    /* State Variabels */
    uint256 private immutable i_goalAmount;
    address private immutable i_owner;
    uint256 private s_soFarDeposit;
    AggregatorV3Interface s_aggregatorV3Interface;

    /*errors */
    error PiggyBank__AmountcannotbeZero(uint256 sentAmt);

    /*Events */
    event PiggyBank__goalReached(
        address indexed user,
        uint256 indexed amount,
        uint256 usdValue
    );
    event PiggyBank__amountWithdrawn(
        address indexed user,
        uint256 amountWithdrawn
    );

    /*Modifiers */
    modifier ownerOnly() {
        require(msg.sender == i_owner, "You are not owner");
        _;
    }

    constructor(uint256 _goalAmountinUSD, address _priceFeed) {
        i_goalAmount = _goalAmountinUSD * 1e18;
        s_aggregatorV3Interface = AggregatorV3Interface(_priceFeed);
        i_owner = msg.sender;
        console.log("owner is ", i_owner);
    }

    function deposit() public payable {
        if (msg.value <= 0) {
            revert PiggyBank__AmountcannotbeZero(msg.value);
        }
        (uint256 convertPriceintDepositValue, uint256 currentETHPrice) = msg
            .value
            .convertETHPriceForAmount(s_aggregatorV3Interface);
        s_soFarDeposit += convertPriceintDepositValue;
        if (s_soFarDeposit >= i_goalAmount) {
            emit PiggyBank__goalReached(
                i_owner,
                s_soFarDeposit,
                currentETHPrice
            );
        }
    }

    function withdraw() public ownerOnly {
        require(address(this).balance > 0, "Not having balance");
        uint256 contractBalance = address(this).balance;
        (bool callSuccess, ) = payable(i_owner).call{
            value: address(this).balance
        }("");
        if (callSuccess) {
            emit PiggyBank__amountWithdrawn(i_owner, contractBalance);
        }
    }

    /* view functions */
    function getDepositedAmount() public view returns (uint256) {
        return s_soFarDeposit;
    }

    function getVersionfromFeed() public view returns (uint256) {
        return PriceConvertor.getVersion(s_aggregatorV3Interface);
    }

    function getGoalAmount() public view returns (uint256) {
        return i_goalAmount;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
