// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "contracts/LiquidityPool.sol";
import "contracts/TestToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "contracts/TDAI.sol";


contract TestSwap is LiquidityPool, Ownable
{
    using SafeMath for uint256;

    TestToken public token;
    
    ERC20 public usdtToken;

    ERC20 public tDAI;
    
    bool public flag = false;

    // reserve1 * reserve2 = invariant
    uint256 public invariant; 
    
    constructor()
    {
        usdtToken = ERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);
        //token = _token;
        
        //reserve.reserve1 = 1000000000000000000000;
        //reserve0 = token.balanceOf(msg.sender);
    }
    
    event AddressSet(address addr);

    event TokensBought(address buyer, uint256 _value, uint256 _amount);

    event TokensSold(address seller, uint256 _value, uint256 _amount);

    function setTokenPrice(uint256 _price) public onlyOwner
    {
        uint256 daiReserve = TestToken(token).totalSupply().mul(_price);
        update(TestToken(token).totalSupply(), daiReserve);
    }

    function setTokenAddr(TestToken _token) 
    public
    onlyOwner
    {
        token = _token;
        update(token.balanceOf(address(this)), 50000000000000000000);
        invariant = getInvariant();
        emit AddressSet(address(token));
    }

    function setTestDaiAddr(address _tDAI)
    public
    onlyOwner
    {
        tDAI = ERC20(_tDAI);
    }

    function getTokenAddress() public view returns(address)
    {
        return address(token);
    }

    function swapExactDAIforTTL(address to, uint256 amountIn) 
    public
    payable
    {
        (uint256 _reserve0, uint256 _reserve1) = getReserves();
        uint256 newDaiReserve = _reserve1.add(amountIn);

        uint256 newTokenReserve = invariant.div(newDaiReserve);
        uint256 amountOut = _reserve0 - newTokenReserve;
        
        usdtToken.transferFrom(to, address(this), amountIn);
        //tDAI.transferFrom(buyer, address(this), amountIn);
        TestToken(token).transfer(to, amountOut);

        update(newTokenReserve, newDaiReserve);
        emit TokensBought(to, amountIn, amountOut);

    }
    function swapExactTTLforDAI(address to, uint256 amountIn) 
    public
    payable
    {
        (uint256 _reserve0, uint256 _reserve1) = getReserves();
        uint256 newTokenReserve = _reserve0.add(amountIn);


        uint256 newDaiReserve = invariant.div(newTokenReserve);
        uint256 amountOut = _reserve1 - newDaiReserve;
        
        
        //tDAI.transfer(to, amountOut);
        TestToken(token).transferFrom(to, address(this), amountIn);
        usdtToken.transfer(to, amountOut);

        update(newTokenReserve, newDaiReserve);
        emit TokensBought(to, amountIn, amountOut);

    }
    

    function swapDAIforExactTTL(address buyer, uint256 amountOut)
    public 
    payable
    {
        //path = _path;
        
        (uint256 _reserve0, uint256 _reserve1) = getReserves();
        uint256 previousReserve1 = _reserve1;
         
        require(_reserve0 >= amountOut);
        uint256 newReserve0 = _reserve0.sub(amountOut);
        uint256 newReserve1;
        if(newReserve0 == 0)
        {
            newReserve1 = invariant.mul(1000);
        }
        else{
            newReserve1 = invariant.div(newReserve0);
        }

        uint256 value = newReserve1.sub(previousReserve1);
        
        //require(tDAI.balanceOf(buyer) >= value);
        require(usdtToken.balanceOf(buyer) >= value);
        require(token.balanceOf(address(this)) >= amountOut);

        usdtToken.transferFrom(buyer, address(this), value);
        //tDAI.transferFrom(buyer, address(this), value);
        TestToken(token).transfer(buyer, amountOut);

        update(newReserve0, newReserve1);
        emit TokensBought(buyer, value, amountOut);
    }
    
}