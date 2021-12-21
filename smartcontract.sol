// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Bank {
    string public bank_name;
    string public bank_address;


    uint public number_of_accounts = 0;

    mapping (address =>uint) balances;

    mapping (address => KYC) record;
    
    struct KYC {
        uint customer_ID;
        string full_name;
        string profession;
        string Date_of_Birth;
        address Wallet;
    }

    modifier onlyRegistered(address cAddress) {
        require(record[cAddress].customer_ID > 0, "Not Registered");
        _;
    }

    function addaccount(string memory full_name, string memory profession, string memory Date_of_Birth) public{
    require(record[msg.sender].customer_ID == 0, "Available");
    KYC memory Newrecord;
    Newrecord.full_name = full_name;
    Newrecord.profession = profession;
    Newrecord.Date_of_Birth = Date_of_Birth;
    Newrecord.Wallet = msg.sender;
    number_of_accounts += 1;
    Newrecord.customer_ID = number_of_accounts;
    record[msg.sender]= Newrecord;
    
    }
    
    function getRecordInfo(address customerAddress) private view onlyRegistered(msg.sender) returns(KYC memory) {
        return record[customerAddress];
    }

    function transfer(address _to, uint amount) public onlyRegistered(msg.sender)  {
        require(amount <= balances[msg.sender]);
        payable(_to).transfer(amount);
        balances[msg.sender] -= amount;
    }

    function Withdraw(uint amount) public onlyRegistered(msg.sender) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        
    }

    function getBalance() public view onlyRegistered(msg.sender) returns (uint) {
        return address(this).balance;
    }
}