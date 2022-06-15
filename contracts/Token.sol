// SPDX-License-Identifier: Vishal
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{

       address public admin;
       uint public totalsupply;

       constructor(string memory name,string memory symbol,uint _totalSupply)ERC20(name,symbol){
              admin=msg.sender;
              totalsupply=_totalSupply;
       }

       function updateAdmin(address _newadmin) private{
           require(msg.sender==admin,"only admin can update the newAdmin");
           admin=_newadmin;
       }
          /// for adding the new tokens
    //    function mint(address account,uint amount) public returns(bool){
    //          require(msg.sender==admin,"only owner can mint");
    //          uint totalSupply = totalSupply();
    //          require(totalupply.add(amount)<=totalsupply,"exceeding limit");
    //          _mint(account,amount);
    //    }
}