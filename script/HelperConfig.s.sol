//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address feedAddress;
    }

    NetworkConfig public localNetworkConfig;

    uint8 private constant MOCK_DECIMALS = 8;
    int56 private constant INITIAL_ANSWER = 2000e8;

    constructor() {
        localNetworkConfig = getAddressbyConfig();
    }

    function getAddressbyConfig() public returns (NetworkConfig memory) {
        if (block.chainid == 11155111) {
            NetworkConfig memory sepoliaConfig = getSepoliaETHAddress();
            return sepoliaConfig;
        } else if (block.chainid == 1) {
            NetworkConfig memory ETHmainConfig = getETHMainnetAddress();
            return ETHmainConfig;
        } else {
            NetworkConfig memory localConfig = getAnvilConfig();
            return localConfig;
        }
    }

    function getSepoliaETHAddress() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            feedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function getETHMainnetAddress() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            feedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return config;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.feedAddress != address(0)) {
            return localNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(
            MOCK_DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();
        NetworkConfig memory config = NetworkConfig({
            feedAddress: address(mock)
        });
        return config;
    }
}
