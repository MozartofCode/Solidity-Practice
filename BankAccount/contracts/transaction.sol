// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract Transactions {

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public requests;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Request(address indexed from, address indexed to, uint256 value);

    constructor() {
        balances[msg.sender] = 10000;
    }

    function sendMoney(address receiver, uint256 amount) public returns (bool sufficient) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalance(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function requestMoney(address receiver, uint256 amount) public {
        requests[receiver][msg.sender] += amount;
        emit Request(msg.sender, receiver, amount);
    }

    function approveRequest(address requester, uint256 amount) public returns (bool sufficient) {
        uint256 requestedAmount = requests[msg.sender][requester];
        require(requestedAmount >= amount, "Requested amount is less than the approval amount");
        require(balances[msg.sender] >= amount, "Insufficient balance to fulfill the request");

        requests[msg.sender][requester] -= amount;
        balances[msg.sender] -= amount;
        balances[requester] += amount;
        emit Transfer(msg.sender, requester, amount);
        return true;
    }
}
