pragma solidity ^0.5.10;


contract PiaTronDapp{

  uint public piatronInvestors;      
  uint public piatronTotalInvested;  
 

  struct Deposit {    //투자정보 
    
    uint amount; //   투자금액   
    uint at;     //  투자금액 투자일 
  }
  struct Investor {
    bool registered; //      투자등록시 투자자의 포지션 금액, 투자일  
    address referrer; //         상위 카테고리 주소 
    uint referral_counter; //      하위 집합의 수
    Deposit[] deposits; //          모든투자목록
    uint invested; //       //총 투자금액 
   
  }


  mapping (address=>Investor) public investors;
  bool private _paused;

  address payable public owner;

  event eventInvestedAt(address user,uint value); //

  constructor( address payable   _owner ) public{    //
   /////////// owner=msg.sender;
    owner = _owner;  // 배포시 오너 등록하게 처리함.. 
    _paused=false;

  }


  function invest( address referrer) public minimumInvest(msg.value) payable{

    if(!investors[msg.sender].registered){ // 
      piatronInvestors++;
      investors[msg.sender].registered=true;

      if(investors[referrer].registered && referrer!=msg.sender){    // 
        investors[msg.sender].referrer=referrer;
        investors[referrer].referral_counter++;
      }
    } else {
      
    }

    investors[msg.sender].invested+=msg.value;
    piatronTotalInvested+=msg.value;
 
    investors[msg.sender].deposits.push(Deposit( msg.value,block.number));   //??

    owner.transfer(msg.value );  //오너에게 100%전달
    emit eventInvestedAt(msg.sender,msg.value); //
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