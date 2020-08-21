pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, TimedCrowdsale,CappedCrowdsale, RefundablePostDeliveryCrowdsale {
    // @TODO: Fill in the constructor parameters!
    constructor(
        uint rate,
        address payable wallet,
        PupperCoin token, 
        uint open_time,
        uint close_time,
        uint goal
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(open_time, close_time)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint open_time;
    uint close_time;
    uint goal=300;
// @TODO: Fill in the constructor parameters!
    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {
        // create the Puppercoin token and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);
        
        open_time=now;
        close_time=open_time+24 weeks;

        // create the PupperCoinSale and tell it about the token
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, open_time, close_time, goal);
        token_sale_address = address(token_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}