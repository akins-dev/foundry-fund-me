// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306 --> sepolia
        // Address 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF --> zksync
        // ABI -> Interface
        (, int256 price,,,) = priceFeed.latestRoundData(); // return price in 8 decimals
        return uint256(price * 1e10); // convert to 18 decimals
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountinUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountinUsd; // returns in 18 decimals - because of precision
    }
}
