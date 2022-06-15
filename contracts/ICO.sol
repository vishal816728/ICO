// SPDX-License-Identifier: Vishal
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Token.sol";

contract ICO{
    struct Sale{
        address investor;
        uint amount;
        bool tokenWithdrawn;
    }

    mapping(address=>Sale) public sales;

    address public admin;
    uint public end;
    uint public duration;
    uint public price;
    uint public availableTokens;
    uint public maxpurchase;
    uint public minpurchase;

    Token public token;
    IERC20 public dai=IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    constructor(address _tokenaddress, 
    uint _duration,
    uint _price,
    uint _availableTokens,
    uint _maxpurchase,
    uint _minpurchase) {
        token=Token(_tokenaddress);
       require(_duration>0,"duration cannot be 0");
       require(_price>0,"price should not be 0");
       require(_availableTokens>0 && _availableTokens<=token.totalsupply(),
       "total supply exceeds");
       require(_minpurchase>0,"minimum purchase must be greater than 0");
       require(_maxpurchase>0 && _maxpurchase<=_availableTokens,"not enough available tokens");
       
       admin =msg.sender;
       duration=_duration;
       price=_price;
       availableTokens=_availableTokens;
       maxpurchase=_maxpurchase;
       minpurchase=_minpurchase;
    }

    //modifiers


    modifier icoActive(){
        require(end>0 && block.timestamp<end && availableTokens>0,"one condition is failed");
        _;
    }

    modifier icoNotActive(){
        require(end==0,"ico not active");
        _;
    }

    modifier icoEnded(){
        require(end>0 && (block.timestamp>end || availableTokens==0),"ico is ended");
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender==admin,
        "only admin can send it");
        _;
    }

    // start the ico
     function start() external icoNotActive() onlyAdmin(){
         end=block.timestamp+duration;
     }
     
     function buy(uint tokenAmount)  public icoActive() {
          require(tokenAmount>=minpurchase && tokenAmount<=maxpurchase,
          "you are exceeding the limit");
           require(tokenAmount<=availableTokens,
           "not enough tokens available to pruchase the tokens");
           dai.transferFrom(msg.sender,address(this),tokenAmount);
           availableTokens-=tokenAmount;
           sales[msg.sender]=Sale(
               msg.sender,
               tokenAmount,
               false
           );
     }
     //  functional modifiers will make sure withdrawal of tokens only occurs 
    //  when token is in secondary market

     function withdrawToken() public icoEnded() icoNotActive(){
          Sale storage sale=sales[msg.sender];
          require(sale.amount>0,"purchase first");
          require(sale.tokenWithdrawn==false,"you have already withdraw the token");
          sale.tokenWithdrawn=true;
          sale.amount=0;
        //   payable(msg.sender).transfer(sale.amount);
        // or you can also achieve the same result by
        token.transfer(sale.investor,sale.amount);
     }

         function withdrawDai(uint amount)
        external
        onlyAdmin()
        icoEnded() {
        dai.transfer(admin, amount);
    }
}