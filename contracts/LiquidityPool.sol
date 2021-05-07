
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquidityPool
{
    
    using SafeMath for uint256;

    struct Reserve
    {
        uint256 reserve0; //Test Tokens reserve
        uint256 reserve1; //DAI reserve
       // uint256 invariant; 
    }
    
    Reserve public reserve;
  
    //Update reserves
    function update(uint256 _reserve0, uint256 _reserve1) 
    internal
    {
        reserve.reserve0 = _reserve0;
        reserve.reserve1 = _reserve1;
    }
    
    
    function getReserves() public view returns (uint256, uint256)
    {
        return (reserve.reserve0, reserve.reserve1);
    }
    
    //Get reserve1*  reserve2 for reserve1 * reserve2 = invariant formula
    function getInvariant() public view returns (uint256) 
    {
        return reserve.reserve0.mul(reserve.reserve1);
    }

    
}