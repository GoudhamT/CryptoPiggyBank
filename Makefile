-include .env

build:; forge build

compile :; forge compile

deploy-sepolia:
	GOAL_AMOUNT=500000000000000000 forge script script/DeployPiggyBank.s.sol:DeployPiggyBank --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

test:; forge test

gas:; forge snapshot