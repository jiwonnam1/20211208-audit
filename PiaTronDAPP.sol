pragma solidity ^0.5.10;


contract PiaTronDapp{

  uint public piatronInvestors;      
  uint public piatronTotalInvested;  
 

  struct Deposit {   
    uint amount; 
    uint at;     
  }
  struct Investor {
    bool registered; 
    address referrer; 
    uint referral_counter; 
    Deposit[] deposits; 
    uint invested; 
  }


  mapping (address=>Investor) public investors;
  bool private _paused;

  address payable public owner;

  event eventInvestedAt(address user,uint value); 

  constructor( address payable   _owner ) public{   
    owner = _owner;  
    _paused=false;

  }


  function invest( address referrer) public minimumInvest(msg.value) payable{

    if(!investors[msg.sender].registered){ 
      piatronInvestors++;
      investors[msg.sender].registered=true;

      if(investors[referrer].registered && referrer!=msg.sender){    
        investors[msg.sender].referrer=referrer;
        investors[referrer].referral_counter++;
      }
    } else {
      
    }

    investors[msg.sender].invested+=msg.value;
    piatronTotalInvested+=msg.value;
 
    investors[msg.sender].deposits.push(Deposit( msg.value,block.number));  

    owner.transfer(msg.value );  
    emit eventInvestedAt(msg.sender,msg.value); 
  }


  function pause() public onlyOwner ifNotPaused{
    _paused=true;
  }

  function unpause() public onlyOwner ifPaused{
    _paused=false;
  }

  // function kill() public onlyOwner{
  //   selfdestruct(owner);
  // }

  modifier onlyOwner(){
    require(owner==msg.sender,"Only owner !");
    _;
  }

  modifier minimumInvest(uint val){
    require(val>= 1000000,"Minimum invest is 1 TRX");
    _;
  }

  modifier ifPaused(){
    require(_paused,"");
    _;
  }

  modifier ifNotPaused(){
    require(!_paused,"");
    _;
  }


}