# Mod4
# Contract ID: 0xA9F18A5D2d51Cdd1391C3dDd69faaeaE5f585411
# DegenGamingToken Smart Contract

## Overview

The `DegenGamingToken` contract is an ERC20-like token smart contract with additional functionality for in-game purchases and rewards. It allows for minting, transferring, and burning of tokens, as well as handling in-game items and rewards.

## Features

- **ERC20 Token Functions**: Mint, transfer, approve, transferFrom, and burn tokens.
- **In-Game Items**: Purchase and redeem items using tokens.
- **Rewards System**: Claim rewards and receive special in-game items.

## Contract Details

### State Variables

- `name`: Token name ("Degen Token").
- `symbol`: Token symbol ("DGN").
- `decimals`: Decimal places for the token (18).
- `totalSupply`: Total supply of tokens.
- `owner`: Address of the contract owner.

### Mappings

- `balances`: Maps addresses to their token balance.
- `allowances`: Maps owner addresses to spender addresses and their allowances.
- `rewards`: Maps player addresses to their reward amounts.
- `playerItems`: Maps player addresses to their items and quantities.

## Events

- `Transfer`: Emitted when tokens are transferred.
- `Approval`: Emitted when an allowance is set.
- `RewardClaimed`: Emitted when rewards are claimed.
- `ItemRedeemed`: Emitted when an item is redeemed.
- `ShieldRewardClaimed`: Emitted when a shield is claimed as a reward.

## Functions

### Constructor

- Initializes the contract with the token's name, symbol, decimals, and adds sample items (Sword and Shield).


### Token Functions

- `mint(address account, uint256 amount)`: Mint new tokens to a specified address.
- `transfer(address recipient, uint256 amount)`: Transfer tokens to a recipient.
- `approve(address spender, uint256 amount)`: Approve a spender to withdraw tokens.
- `transferFrom(address sender, address recipient, uint256 amount)`: Transfer tokens from one address to another.
- `burn(uint256 amount)`: Burn tokens from the caller’s balance.

### In-Game Functions

- `InGamePurchase(uint256 amount)`: Allows players to use tokens for in-game purchases.
- `redeemItem(uint256 itemId, uint256 quantity)`: Redeems a specified quantity of an item, deducting the cost from the player's balance.

### View Functions

- `balanceOf(address account)`: Returns the token balance of an address.
- `getPlayerItemQuantity(address player, uint256 itemId)`: Returns the quantity of a specific item for a player.
- `getPlayerItems(address player)`: Returns all items and their quantities for a player.

## Usage

1. **Mint Tokens**: Use `mint` to add tokens to an address.
2. **Transfer Tokens**: Use `transfer` to send tokens between addresses.
3. **Approve Spender**: Use `approve` to allow a spender to use your tokens.
4. **Redeem Items**: Use `redeemItem` to exchange tokens for in-game items.
5. **Claim Rewards**: Use `claimReward` to receive rewards and special items.


