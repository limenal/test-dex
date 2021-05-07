const HDWalletProvider = require("truffle-hdwallet-provider");
require('dotenv').config({
  path: `${__dirname}/dev.env`
})
const MNEMONIC = process.env["Phrase"]
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777" // Match any network id
    },
      ropsten: {
        networkCheckTimeout: 10000,
        provider: function () {
          return new HDWalletProvider(
            MNEMONIC,
            "https://ropsten.infura.io/v3/821ea08c5ab24ab5b4876fb49bbf5102"
          );
      },
      network_id: 3,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true      //make sure this gas allocation isn't over 4M, which is the max
    }
  },
  contracts_directory: './contracts/',
  contracts_build_directory: './src',
  
  compilers: {
    solc: {
      version: "0.8.0",
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}