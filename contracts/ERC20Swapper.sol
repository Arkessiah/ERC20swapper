// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

import "../interfaces/IERC20Swapper.sol";
import "../interfaces/IDex.sol";


/// @title ERC20Swapper
contract ERC20Swapper is IERC20Swapper,ReentrancyGuard, Pausable, Ownable {
    address public dexAddress; //Storage variable for Dex contract's address

    /// @dev The event is executed when Dex address is changed 
    /// @param newDex The address of the new DEX to be set
    event DexChanged(address indexed newDex);

    /// @dev The event is executed when Ether is withdrawn from the contract
    /// @param owner The address of the owner
    /// @param balance The balance of the owner
    event EtherWithdrawn(address indexed owner, uint balance);

    /// @dev The event is executed when ERC20 Tokens are withdrawn from the contract
    /// @param token The address of the ERC20 token
    /// @param owner The address of the owner
    /// @param balance The balance of the owner
    event ERC20TokensWithdrawn(address indexed token, address indexed owner, uint balance);

    constructor() Ownable(msg.sender) {
     
    }

    /// @dev swaps the `msg.value` Ether to at least `minAmount` of tokens in `address`, or reverts
    /// @param token The address of ERC-20 token to swap
    /// @param minAmount The minimum amount of tokens transferred to msg.sender
    /// @return The actual amount of transferred tokens
    function swapEtherToToken(address token, uint minAmount) public payable override whenNotPaused nonReentrant returns (uint) {
        require(msg.value > 0, "Send Ether to swap");
        require(dexAddress != address(0), "DEX Address not set");

        IDex dex = IDex(dexAddress);

        uint tokenAmount = dex.swapEtherToToken{value: msg.value}(token, minAmount);
        require(tokenAmount >= minAmount, "Insufficient output amount of tokens");

        return tokenAmount;
    }


    /// @notice Update the address of the DEX contract
    /// @dev Sets a new DEX address for token swaps. This can only be called by the owner
    /// @param  _newDex The address of the new DEX
    function setDex(address _newDex) public onlyOwner {
        require(_newDex != address(0), "Invalid DEX address");
        dexAddress = _newDex;
        emit DexChanged(_newDex);
    }

    /// @notice Pauses the contract, disabling the function of swapping tokens
    /// @dev Triggers stopped state, preventing calls to functions marked with `whenNotPaused`
    function pause() public onlyOwner {
        _pause();
    }

    /// @notice Unpauses the contract, disabling the function of swapping tokens
    /// @dev Returns to no pausado state, allowing calls to functions marked with `whenNotPaused`
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @notice Allows the owner to withdraw all ether held in the contract in the event of risk or upgrade to a new contract
    /// @dev Transfers all Ether held by the contract to the owner address. This can only be called by the owner.
    function withdrawEther() public onlyOwner {
        uint balance = address(this).balance;
        payable(owner()).transfer(balance);
        emit EtherWithdrawn(owner(), balance);
    }   

    /// @notice Allows the owner to withdraw all ERC20 Tokens held in the contract in the event of risk or upgrade to a new contract
    /// @dev Transfers all ERC20 Tokens held by the contract to the owner address. This can only be called by the owner.
    function withdrawERC20Tokens(address _token) public onlyOwner {
        IERC20 token = IERC20(_token);
        token.transfer(owner(), token.balanceOf(address(this)));
        emit ERC20TokensWithdrawn(_token, owner(), token.balanceOf(address(this)));
    }
}