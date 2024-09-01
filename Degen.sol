// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract degenStudio is ERC20, Ownable {

    string tokenName = "Degen";
    string tokenSymbol = "DGN";
    mapping(address => uint256) private balances;
    mapping (address => uint[]) public ownedItems;
    mapping (uint => uint[2]) public storeItemsManagement;
    string public storeItemNames = "0. Prashant (500) 1. Sea_Monkey (100) 2. Chain_Smoker (200)";
    struct requestStructure {
        address user;
        uint price;
        uint choice;
        uint buyORsell;
    }
    requestStructure[] requests;

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    constructor(uint _startingSupply) ERC20(tokenName, tokenSymbol) Ownable(msg.sender) {
        _mint(msg.sender, _startingSupply);
        storeItemsManagement[0] = [500, 5];
        storeItemsManagement[1] = [100, 3];
        storeItemsManagement[2] = [200, 2];
    }

    function mint(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Invalid amount");

        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function burn(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }


    function reward(address _player, uint _tokenAmount) public onlyOwner {
        _transfer(msg.sender, _player, _tokenAmount);
    }

    function walletBalance(address _user) public view returns (uint) {
        return balanceOf(_user);
    }

    function buyItem(uint8 _choice) public returns (bool) {
        if (storeItemsManagement[_choice][1] != 0) { 
            if (walletBalance(msg.sender) >= storeItemsManagement[_choice][0]) {
                ownedItems[msg.sender].push(_choice);
                storeItemsManagement[_choice][1] -= 1;
                _transfer(msg.sender, owner(), storeItemsManagement[_choice][0]);
                return true;
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }

    function makeSellRequest(uint _choice, uint _whatPrice) public returns (bool) {
        bool check = false;
        for (uint i = 0; i < ownedItems[msg.sender].length; i++)
        {
            if (ownedItems[msg.sender][i] == _choice) {
                check = true;
                break;
            }
        }
        if (check == true) {
            requests.push(requestStructure(msg.sender, _choice, _whatPrice, 0));
            return true;
        }
        else {
            return false;
        }
    }

    function fulfillRequest(uint _requestNum) public returns (bool) {
        if (requests[_requestNum].buyORsell == 0) {
            if (walletBalance(msg.sender) >= requests[_requestNum].price) {
                _transfer(msg.sender, requests[_requestNum].user, requests[_requestNum].price);
                ownedItems[msg.sender].push(requests[_requestNum].choice);
                for (uint i = 0; i < ownedItems[requests[_requestNum].user].length; i++)
                {
                    if (ownedItems[requests[_requestNum].user][i] == requests[_requestNum].choice) {
                        removeOwnership(requests[_requestNum].user, i);
                        break;
                    }
                }
                removeRequest(_requestNum);
                return true;
            }
            return false;
        }
        else {
            bool check = false;
            uint i;
            for (i = 0; i < ownedItems[msg.sender].length; i++)
            {
                if (ownedItems[msg.sender][i] == requests[_requestNum].choice) {
                    check = true;
                    break;
                }
            }
            if (check = true) {
                removeOwnership(msg.sender, i);
                _transfer(requests[_requestNum].user, msg.sender, requests[_requestNum].price);
                ownedItems[requests[_requestNum].user].push(requests[_requestNum].choice);
                removeRequest(_requestNum);
                return true;
            } 
            return false;
        }
    }

    function listRequests() public view  returns (requestStructure[] memory) {
        return requests;
    }

    function showPossessions(address user) public view returns (uint[] memory) {
        return ownedItems[user];
    }

    function removeRequest(uint index) public {
        for (uint i = index; i < requests.length - 1; i++) {
            requests[i] = requests[i + 1];
        }
        requests.pop();
    }

    function removeOwnership(address user,uint index) public {
        for (uint i = index; i < ownedItems[user].length - 1; i++) {
            ownedItems[user][i] = ownedItems[user][i + 1];
        }
        ownedItems[user].pop();
    }
}
