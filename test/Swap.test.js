const { assert } = require('chai');
const { ethers } = require('ethers')

const TestToken = artifacts.require("TestToken");
const TestSwap = artifacts.require("TestSwap");
const TestDAI = artifacts.require("TDAI");

require('chai')
    .use(require('chai-as-promised'))
    .should()

const maxUint256 = '11579208923731619542357098500000'

contract('TestSwap', ([owner, buyer]) => {
    let testSwap, testToken, testDAI, testAdress

    before(async () => {
        testSwap = await TestSwap.new()
        testToken = await TestToken.new(testSwap.address)
        await testSwap.setTokenAddr(testToken.address)
        
       // testAddress = ethers.utils.getAddress("0x93eb255827ceA4BB7c2Ca1d137B1279F2985231c")

        testDAI = await TestDAI.new(buyer)
        
        await testSwap.setTestDaiAddr(testDAI.address)
    })

    describe('Test Swap deployment', async () => {
        it('Address set and reserves updated', async() => {
            const address = await testSwap.token()
            const reserves = await testSwap.getReserves()
            assert.equal(address, testToken.address)
            assert.equal(reserves[0], '100000000000000000000')
            assert.equal(reserves[1], '50000000000000000000')
        })
    })

    describe('Buying Tokens', async () => {
        it('Buyer received tokens', async() => {
            
            await testDAI.approve(testSwap.address, '1000000000000000000000000000000', { from: buyer})
            
            let balance = await testDAI.balanceOf(buyer)

            console.log(balance.toString())
            let a = await testSwap.buyTokens(buyer,'1000000000000000000', { from: buyer})
            
            let res = await testToken.balanceOf(buyer)
            assert.equal(res.toString(), '1000000000000000000', 'Buyer got tokens')
        })
        it('Reserves updated', async() => {
            const reserves = await testSwap.getReserves()
            const reserve0 = reserves[0].toString()
            const reserve1 = reserves[1].toString()
            assert.equal(reserve0, '99000000000000000000')
            assert.equal(reserve1, '50505050505050505050')
        })
    })
    describe('Selling Tokens', async () => {
        it('Buyer sold tokens', async() => {
            
            await testToken.approve(testSwap.address, '1000000000000000000000000000000', { from: buyer})
            
            let res = await testToken.balanceOf(buyer)
            console.log(res.toString())
            await testSwap.sellTokens(buyer,'1000000000000000000', { from: buyer})
            res = await testToken.balanceOf(buyer)
            
            // res = res.toString()
            // console.log(res)

            assert.equal(res.toString(), '0', 'Buyer sold tokens')
        })
        it('Reserves updated', async() => {
            const reserves = await testSwap.getReserves()
            const reserve0 = Number(reserves[0])
            const reserve1 = Number(reserves[1])
            assert.equal(reserve0, 100000000000000000000)
            assert.isAtLeast(reserve1, 49999999999990000000)
        })
    })
})