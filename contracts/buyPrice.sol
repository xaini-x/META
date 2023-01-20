
// SPDX-License-Identifier: MIT
pragma solidity  0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
contract landPriceing is Ownable {
    
    struct User {
        string land;
        uint256 amount;
    }
    
 struct specialLand {
        bool exist;
        uint256 amount;
    }

    mapping(string => specialLand) private indexOf;
   
    function setPrice(string calldata landType , uint amount) external onlyOwner{
        indexOf[landType].amount = amount;
        indexOf[landType].exist = true;
    }
    
    function getAmount(string calldata landType ) public view returns(uint){
        require(indexOf[landType].exist == true ,"no type");
return indexOf[landType].amount;  
    }

}
