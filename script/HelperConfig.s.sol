// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Deploy mocks when we are on a local anvil chain
// Keep track of contract addresses accross different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local anvil chain, we will deploy mocks
    // Othewise, grab the price feed address from the chain

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    uint8 public constant DECIMALS = 8; // Number of decimals for the price feed
    int256 public constant INITIAL_PRICE = 2000e8; // Initial price for the mock price feed (2000 USD with 8 decimals)

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia chain ID
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            // Anvil chain ID
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else if (block.chainid == 1) {
            // Ethereum Mainnet chain ID
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            // If we are on a chain that is not supported, we revert
            revert("No active network config found");
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD price feed address
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // don't redeploy if network config already exists
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Deploy the mocks
        // 2. Return the mock price feed address

        vm.startBroadcast(); // basically saying 'start deploying' like foundry's --broadcast flag
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed) // Use the mock price feed address
        });
        return anvilConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // Ethereum Mainnet ETH/USD price feed address
        });
        return mainnetConfig;
    }
}
