# 🐷 Crypto Piggy Bank

A decentralized Ethereum-based savings contract that allows users to deposit ETH while tracking their USD-equivalent savings using **Chainlink Price Feeds**. When the savings goal is reached, the contract emits an event, and the owner can withdraw the funds securely.

## 💡 Business Scenario

In traditional finance, users often struggle to track their savings goals across different currencies and investments. This project demonstrates a **smart contract-based piggy bank** that:

- Allows users to deposit ETH into a smart contract.
- Converts deposited ETH to USD using **live Chainlink Price Feeds**.
- Tracks total savings in USD to help users reach a predefined goal.
- Automatically signals when the goal is reached via an event.
- Enables only the contract owner to withdraw the saved ETH safely.

This could be used by:

- Freelancers saving for a milestone in USD while holding ETH.
- Crypto enthusiasts tracking goals without relying on centralized banks.
- Learning use-case for Solidity development, Chainlink integrations, and testing best practices.


---

## ⚙️ Features

| Feature | Description |
|---------|-------------|
| **ETH Deposits** | Users can deposit ETH. Deposits of 0 ETH are rejected. |
| **USD Conversion** | Deposited ETH is converted to USD using Chainlink Price Feeds. |
| **Goal Tracking** | Tracks cumulative deposits and signals when the goal is reached. |
| **Event Logging** | Emits `PiggyBank__goalReached` and `PiggyBank__amountWithdrawn` for transparency. |
| **Owner Withdrawals** | Only contract owner can withdraw ETH, safely transferring the balance. |
| **Testing & Mocks** | Full unit and fuzz tests using **Foundry**, with mock price feeds. |

---

## 🛠 Technical Details

- **Solidity Version**: 0.8.19  
- **Libraries**: Chainlink AggregatorV3Interface  
- **Testing Framework**: Foundry (forge)  
- **Mocking**: MockV3Aggregator simulates Chainlink ETH/USD feeds.  
- **Security**: Checks for zero deposits, owner-only withdrawals, and safe ETH transfers.  

---

## 🚀 Installation

1. Clone the repository:  

```bash
git clone https://github.com/GoudhamT/CryptoPiggyBank.git
cd CryptoPiggyBank

2. Install Foundry:
curl -L https://foundry.paradigm.xyz | bash
foundryup

3. Install dependencies:

forge install

🧪 Running Tests

Run All Tests
forge test -vvv

Run a Single Test Function
forge test --match-test testWithdraw -vvv

Run Fuzz Tests
forge test --fuzz

⚡ Deployment Script
Deploy Locally or on Testnet
forge script script/DeployPiggyBank.s.sol:DeployPiggyBank \
    --fork-url <RPC_URL> \
    --broadcast
Replace <RPC_URL> with your network endpoint (local Anvil, Sepolia, Mainnet).