//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast => Not paying gas
        // We dont want to pay gas to deploy HelperConfig
        HelperConfig helperConfig = new HelperConfig();
        (address priceFeedAddress) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        // After startBroadcast => Paying gas
        FundMe fundMe = new FundMe(priceFeedAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}
