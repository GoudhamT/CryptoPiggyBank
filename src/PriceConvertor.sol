//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getPrice(
        AggregatorV3Interface _priceFeed
    ) public view returns (uint256) {
        (, int256 currentPrice, , , ) = _priceFeed.latestRoundData();
        return uint256(currentPrice * 1e10);
    }

    function convertETHPriceForAmount(
        uint256 ethAmount,
        AggregatorV3Interface _priceFeed
    ) public view returns (uint256, uint256) {
        uint256 currentPrice = getPrice(_priceFeed);
        uint256 calculateETHAmountInUSD = (ethAmount * currentPrice) / 1e18;
        return (calculateETHAmountInUSD, currentPrice);
    }

    function getVersion(
        AggregatorV3Interface _priceFeed
    ) public view returns (uint256) {
        return _priceFeed.version();
    }
}
