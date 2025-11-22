//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployPiggyBank} from "../../script/DeployPiggyBank.s.sol";
import {CryptoPiggyBank} from "../../src/CryptoPiggyBank.sol";

contract PiggyBankTest is Test {
    DeployPiggyBank deployer;
    CryptoPiggyBank piggyBank;
    uint256 private constant GOAL_AMOUNT = 5000;

    error PiggyBank__AmountcannotbeZero(uint256 amount);

    event PiggyBank__amountWithdrawn(
        address indexed user,
        uint256 amountWithdrawn
    );

    function setUp() public {
        console.log("who is deploying contract", msg.sender);
        deployer = new DeployPiggyBank();
        piggyBank = deployer.run(GOAL_AMOUNT);
    }

    function testVersionIsFour() public view {
        assertEq(piggyBank.getVersionfromFeed(), 4);
    }

    function testCompareGoalAmount() public view {
        assertEq(piggyBank.getGoalAmount(), (GOAL_AMOUNT * 1e18));
    }

    function testOwnerIsSender() public {
        console.log("sender is %s", msg.sender);
        console.log("Address is %s", address(this));
        assertEq(piggyBank.getOwner(), msg.sender);
    }

    function testDepositWithNoETH() public {
        uint256 sendingValue = 0;
        vm.expectRevert(
            abi.encodeWithSelector(
                PiggyBank__AmountcannotbeZero.selector,
                sendingValue
            )
        );
        piggyBank.deposit();
    }

    function testMockPriceAnswer() public {
        uint256 mockInitialAnswer = 2000e18;
        piggyBank.deposit{value: 1 ether}();

        assertEq(piggyBank.getDepositedAmount(), mockInitialAnswer);
    }

    function testWithdrawNotOwner() public {
        address JOHN = makeAddr("john");
        vm.prank(JOHN);
        vm.expectRevert();
        piggyBank.withdraw();
    }

    function testWithdraw() public {
        address JOHN = makeAddr("john");
        uint256 depositAmount = 3 ether;
        vm.deal(JOHN, 10 ether);
        vm.prank(JOHN);
        piggyBank.deposit{value: depositAmount}();
        // uint256 contractBalance = piggyBank.getDepositedAmount();
        uint256 contractBalance = address(piggyBank).balance;
        console.log("deposit amt is ", contractBalance);
        vm.expectEmit(true, false, false, true);
        emit PiggyBank__amountWithdrawn(piggyBank.getOwner(), contractBalance);
        vm.prank(piggyBank.getOwner());
        piggyBank.withdraw();
        // emit PiggyBank__amountWithdrawn(piggyBank.getOwner(), contractBalance);
    }
}
