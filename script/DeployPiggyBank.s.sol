//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {CryptoPiggyBank} from "../src/CryptoPiggyBank.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployPiggyBank is Script {
    function run(uint256 _goalAmount) public returns (CryptoPiggyBank) {
        HelperConfig helperConfig = new HelperConfig();

        address feedAddress = helperConfig.localNetworkConfig();
        vm.startBroadcast();
        CryptoPiggyBank piggyBank = new CryptoPiggyBank(
            _goalAmount,
            feedAddress
        );
        vm.stopBroadcast();
        return piggyBank;
    }
}
