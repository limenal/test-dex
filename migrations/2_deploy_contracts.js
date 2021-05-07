const TestToken = artifacts.require("TestToken");
const TestSwap = artifacts.require("TestSwap");
const TestDAI = artifacts.require("TDAI");
//const LiquidityPool = artifacts.require("LiquidityPool");

module.exports = async function(deployer) {
    
    // Deploy Test Swap
    await deployer.deploy(TestSwap);
    const testSwap = await TestSwap.deployed()

    // Deploy Test Token
    await deployer.deploy(TestToken, testSwap.address);
    const token = await TestToken.deployed()
    // Set token address
    await testSwap.setTokenAddr(token.address);

};