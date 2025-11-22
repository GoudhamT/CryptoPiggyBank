//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {CryptoPiggyBank} from "../src/CryptoPiggyBank.sol";

contract DeployPiggyBank is Script {
    function run(
        uint256 _goalAmount,
        address _feed
    ) public returns (CryptoPiggyBank) {
        vm.startBroadcast();
        CryptoPiggyBank piggyBank = new CryptoPiggyBank(_goalAmount, _feed);
        vm.stopBroadcast();
        return piggyBank;
    }
}
