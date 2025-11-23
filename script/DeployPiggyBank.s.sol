//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;
import {Script, console} from "forge-std/Script.sol";
import {CryptoPiggyBank} from "../src/CryptoPiggyBank.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployPiggyBank is Script {
    function run() public returns (CryptoPiggyBank) {
        uint256 goalAmount = vm.envUint("GOAL_AMOUNT");
        HelperConfig helperConfig = new HelperConfig();

        address feedAddress = helperConfig.localNetworkConfig();
        console.log("Deployer inside script:", msg.sender);
        vm.startBroadcast();
        console.log("user starting broadcast:", msg.sender);
        CryptoPiggyBank piggyBank = new CryptoPiggyBank(
            goalAmount,
            feedAddress
        );
        console.log("user stopping broadcast:", msg.sender);
        vm.stopBroadcast();
        return piggyBank;
    }
}
