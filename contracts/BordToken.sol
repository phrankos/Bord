// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract BordTokens is
    ERC20("Bord Token", "BRD"),
    ERC20Burnable,
    Ownable(msg.sender)
{

    uint public tokenBuyPrice = 0.00050 ether;
    uint public tokenSellPrice = 0.00045 ether;
    

    function setTokenBuyPrice(uint256 _newTokenBuyPrice) public onlyOwner {
        tokenBuyPrice = _newTokenBuyPrice;
    }
    function setTokenSellPrice(uint256 _newTokenSellPrice) public onlyOwner {
        tokenSellPrice = _newTokenSellPrice;
    }
    function resetTokenBuyPrice() public onlyOwner {
        tokenBuyPrice = 0.00050 ether;
    }
    function resetTokenSellPrice() public onlyOwner {
        tokenSellPrice = 0.00045 ether;
    }

    function myBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function buyTokens(uint amount) public payable {
        require(msg.value >= tokenBuyPrice * amount, "Insufficient funds");
        // Transfer token to the msg.sender
        mint(msg.sender, amount * 10 ** decimals());
    }

    event ContractBalance(uint256 balance);
    function sellTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");

        // Calculate the amount of ether to transfer to the seller
        uint256 etherAmount = amount * tokenSellPrice;

        // Burn the tokens sold
        _burn(msg.sender, amount * 10 ** decimals());

        // Emit the contract balance
        emit ContractBalance(address(this).balance);

        // Transfer ether to the seller
        (bool success, ) = msg.sender.call{value: etherAmount}("");
        console.log(etherAmount);
        require(success, "Transfer failed");

        // Emit the contract balance
        emit ContractBalance(address(this).balance);
    }

    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

/*
    ETH     BRD 	   USD
0.00034       -   	  1.00
0.00050       1   	  1.45
0.00250       5    	  7.25
0.00500      10  	 14.51
0.02500      50  	 72.54
0.05000     100 	145.09
0.25000     500 	725.44
0.25000     500 	725.44

Role         Transaction        Price
ASKERS
            Create  TASK     >= 3 BRD
            Edit    TASK        1 BRD
            Delete  TASK        1 BRD
            Fail    TASK        0 BRD
            Pass    TASK        0 BRD
DOERS
            Accept  TASK        0 BRD
            Submit  TASK        0 BRD
            Abandon TASK        0 BRD
            Dispute TASK        0 BRD


*/
