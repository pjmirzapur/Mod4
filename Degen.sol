// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DegenGamingToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => uint256) private rewards;

    struct Item {
        string name;
        uint256 cost;
    }

    Item[] public items;
    mapping(address => mapping(uint256 => uint256)) public playerItems; // player address => item ID => quantity

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event RewardClaimed(address indexed player, uint256 amount);
    event ItemRedeemed(address indexed player, uint256 itemId, uint256 quantity);
    event ShieldRewardClaimed(address indexed player, uint256 quantity);


    constructor() {
        name = "Degen Token";
        symbol = "DGN";
        decimals = 18;
        totalSupply = 0;
        owner = msg.sender;

        // Adding sample items
        items.push(Item("Sword", 100));
        items.push(Item("Shield", 150));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");

        balances[account] += amount;
        totalSupply += amount;

        emit Transfer(address(0), account, amount);
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Invalid address");

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(sender != address(0), "Invalid address");
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowances[sender][msg.sender], "Insufficient allowance");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function claimReward() external returns (uint256) {
    uint256 amount = rewards[msg.sender];
    require(amount > 0, "No rewards to claim");

    rewards[msg.sender] = 0;

    // Give the player a shield (item ID 1)
    uint256 shieldItemId = 1;
    playerItems[msg.sender][shieldItemId] += 1; // Increase the quantity of shields

    emit RewardClaimed(msg.sender, amount);
    emit ShieldRewardClaimed(msg.sender, 1); // Log the shield reward

    return amount;
}


    function InGamePurchase(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function redeemItem(uint256 itemId, uint256 quantity) external {
        require(itemId < items.length, "Invalid item ID");
        require(quantity > 0, "Invalid quantity");

        uint256 totalCost = items[itemId].cost * quantity;
        require(totalCost <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= totalCost;
        totalSupply -= totalCost;
        
        playerItems[msg.sender][itemId] += quantity;  // Update the player's item inventory

        emit Transfer(msg.sender, address(0), totalCost);
        emit ItemRedeemed(msg.sender, itemId, quantity);
    }

    function getPlayerItemQuantity(address player, uint256 itemId) external view returns (uint256) {
        return playerItems[player][itemId];
    }

    function getPlayerItems(address player) external view returns (Item[] memory, uint256[] memory) {
        uint256 itemCount = items.length;
        uint256[] memory quantities = new uint256[](itemCount);

        for (uint256 i = 0; i < itemCount; i++) {
            quantities[i] = playerItems[player][i];
        }
        

        return (items, quantities);
    }
}
