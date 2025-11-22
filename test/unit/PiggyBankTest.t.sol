//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployPiggyBank} from "../../script/DeployPiggyBank.s.sol";
import {CryptoPiggyBank} from "../../src/CryptoPiggyBank.sol";

contract PiggyBankTest is Test {
    DeployPiggyBank deployer;
    CryptoPiggyBank piggyBank;

    function setUp() public {
        deployer = new DeployPiggyBank();
        piggyBank = deployer.run(5000);
    }

    function testVersionIsFour() public view {
        assertEq(piggyBank.getVersionfromFeed(), 4);
    }
}
