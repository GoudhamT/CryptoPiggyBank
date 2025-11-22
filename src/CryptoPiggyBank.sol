//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "PriceConvertor.sol";

contract CryptoPiggyBank {
    using PriceConvertor for uint256;

    uint256 private immutable i_goalAmount;
    uint256 private s_soFarDeposit;
    AggregatorV3Interface s_aggregatorV3Interface;

    event goalReached(
        address indexed user,
        uint256 indexed amount,
        uint256 usdValue
    );

    constructor(uint256 _goalAmountinUSD, address _priceFeed) {
        i_goalAmount = _goalAmountinUSD * 1e18;
        s_aggregatorV3Interface = AggregatorV3Interface(_priceFeed);
    }

    function deposit() public payable {
        (uint256 convertPriceintDepositValue, uint256 currentETHPrice) = msg
            .value
            .convertETHPriceForAmount(s_aggregatorV3Interface);
        s_soFarDeposit += convertPriceintDepositValue;
        if (s_soFarDeposit >= i_goalAmount) {
            emit goalReached(msg.sender, s_soFarDeposit, currentETHPrice);
        }
    }

    //view functions:
    function getDepositedAmount() public view returns (uint256) {
        return s_soFarDeposit;
    }
}
