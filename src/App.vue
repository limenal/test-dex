<template>

  <div id="app">
    <nav class = "#1e88e5 blue darken-1">
      <div>
        <p id = "account-address">Connected wallet: {{account}}</p>
      </div>
      <div class="nav-wrapper">
        <a class="brand-logo center"></a>
      </div>
    </nav>
    
    <div id="token">
      <div>
        <p id="token-name">Test Token</p>
        <p id="token-symbol">$TTL</p>
      </div>

      <div>
        <p id="price">{{getCostBuy}} $</p>
        <p id="pool">{{currentReserve}} / {{reserveToken}} available</p>
      </div>
    </div>
    
    <div id = "inc-dec">
      <!-- <a class="btn-floating btn-large waves-effect waves-light blue" v-on:click="decreaseAmount"><i class="material-icons">-</i></a>
      
      <a class="btn-floating btn-large waves-effect waves-light blue"  v-on:click="incAmount"><i class="material-icons">+</i></a> -->

      <!-- <p id="tokens-amount">{{amount}}</p> -->
    </div>
    

    <button id="buttonBuy" v-on:click="showBuyModal">Buy</button>
    
    <button id="buttonSell" v-on:click="showSellModal">Sell</button>

    <div v-if="isModal" class="modal">
      <div class="modal-background" v-on:click="closeModal">

      </div>
      <div id="modal">
      
        <div id="token-in-modal">
          <div>
            <p id="token-name">Test Token</p>
            <p id="token-symbol">$TTL</p>
            <p id = "balance">You have: {{getTTLBalance}} TTL</p>
          </div>

          <div>
            <div v-if="isBuyModal">
              <p id="price">{{getCostBuy}} $</p>
            </div>
            <div v-else>
              <p id="price">{{getCostSell}} $</p>
            </div>
            <p id="pool">{{currentReserve}} / {{reserveToken}} available</p>
          
          </div>
        </div>

        
        <div v-if="isBuyModal">
          
          <div v-if="isDaiApproved">
            <div class="input-group">
              <input type="button" value="-" class="button-minus" data-field="quantity" v-on:click="decreaseAmount">
              <input type="number" max="" v-model="amount" name="quantity" class="quantity-field" disabled>
              <input type="button" value="+" class="button-plus" data-field="quantity" v-on:click="incAmount">
            </div>
            <button id="button-modal" v-on:click="buyTokens">Buy</button>
          </div>
          <div v-else>
            <button id="button-modal" v-on:click="approveDai">Approve</button>
            <button id="button-disabled">Buy</button>
          </div>
        </div>
        <div v-else-if="isSellModal">
          
          <div v-if="isTokenApproved">
            <div class="input-group">
              <input type="button" value="-" class="button-minus" data-field="quantity" v-on:click="decreaseAmount">
              <input type="number" max="" v-model="amount" name="quantity" class="quantity-field" disabled>
              <input type="button" value="+" class="button-plus" data-field="quantity" v-on:click="incAmountSelling">
            </div>
            <button id="button-modal" v-on:click = "sellTokens">Sell</button>
          </div>
          <div v-else>
            <button id="button-modal" v-on:click="approveTestToken">Approve</button>
            <button id="button-disabled">Sell</button>
          </div>
        </div>
        
      </div>
      
      
    </div>



    <!-- <button id="buttonSell" v-on:click="showSellModal">Sell</button> -->

    <!-- <div id="buy" v-on:click="showBuyModal">
      <a id="buy" class="waves-effect waves-light btn">Buy</a>
    </div> -->
    


  </div>


</template>

<script>
import {ethers} from 'ethers'
import TestSwap from './TestSwap.json'
import ERC20 from './ERC20.json'
//import ModalBuy from './components/ModalBuy.vue'
//import PulseLoader from '@/components/PulseLoader.vue';
//import TestToken from './TestToken.json'

export default {
  name: 'App',
  components: {
    //PulseLoader,
    //ModalBuy
    
  },
  mounted:async function () {
    
    window.ethereum.on('accountsChanged', (accounts) => {
      
      if(this.account != accounts[0])
      {
        this.account = accounts[0]
      }
      
      if(this.account == this.ownerAccount)
      {
        this.isOwner = true
      }
      else 
      {
        this.isOwner = false
      }
      
      window.location.reload();
    });
  },
  data()
  {
      return {
      accounts: [],
      flag: false,
      isApproved: false,
      isBuyModal: false,
      isSellModal:false,
      isDaiApproved: false,
      isTokenApproved: false,
      account: '',
      ownerAccount: '0x209f495b808fff06bd1e63a64243ad7b4be3d55e',
      reserveToken: 0,
      currentReserve:0,
      reserveDAI: '',
      invariant: '',
      amount: '1',
      balanceDAI: '',
      balanceTTL: '',
      cost: 0,
      newPrice: 0,
      isOwner: false,
      maxInt256: '115792089237316195423570985008687907853269900'
    }
  },
  computed:
  {
    getCostBuy: function()
    {
      if(this.amount == 0) return ''
      let newTokenReserve = Number(this.currentReserve) - Number(this.amount)
      
      console.log(this.currentReserve)
      console.log(this.amount)
      console.log(this.invariant)
      console.log(newTokenReserve)
      let newDAIReserve = Number(this.invariant) / newTokenReserve
      console.log(newDAIReserve)
      let cost = newDAIReserve - Number(this.reserveDAI)  
      console.log(cost)
      return cost.toString()
      
    },
    getCostSell: function()
    {
      if(this.amount == 0) return ''
      let newTokenReserve = Number(this.currentReserve) + Number(this.amount)
      
      console.log(this.currentReserve)
      console.log(this.amount)
      console.log(this.invariant)
      console.log(newTokenReserve)
      let newDAIReserve = Number(this.invariant) / newTokenReserve
      console.log(newDAIReserve)
      let cost = Number(this.reserveDAI) - newDAIReserve  
      console.log(cost)
      return cost.toString()

    },
    isModal: function()
    {
      if(this.isBuyModal || this.isSellModal)
      {
        return true
      }
      else return false
    },
    getTTLBalance()
    {
      return parseInt(this.balanceTTL).toString()
    }
    
  }
  
  ,
  created: async function () {
    
    let accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    let account = accounts[0]
    this.account = account
    
    if(this.account == this.ownerAccount)
    {
      this.isOwner = true
    }
    else
    {
      this.isOwner = false;
    }
    const provider = new ethers.providers.Web3Provider(window.ethereum)

    let address = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
    let addressTestToken = '0x556b2a9CbAF23F36AbA28E3a92439c8F0568bb6F'
    let addressDai = '0xad6d458402f60fd3bd25163575031acdce07538d'

    const daiContract = new ethers.Contract(addressDai, ERC20.abi, provider)
    const tokenContract = new ethers.Contract(addressTestToken, ERC20.abi, provider)
    const swapContract = new ethers.Contract(address, TestSwap.abi, provider)
    
    let daiAllowance = await daiContract.allowance(this.account, address);
    if(daiAllowance.toString().length != 1){
      this.isDaiApproved = true
    }
    let tokenAllowance = await tokenContract.allowance(this.account, address);
    if(tokenAllowance.toString().length != 1){
      this.isTokenApproved = true
    }

    let a = await tokenContract.totalSupply()
    this.reserveToken = parseInt(ethers.utils.formatUnits( a.toString(), 18))
    let cur = await swapContract.getReserves()
    this.currentReserve = parseInt(ethers.utils.formatUnits( cur[0].toString(), 18))
    this.reserveDAI = ethers.utils.formatUnits( cur[1].toString(), 18)
    let b = await swapContract.getInvariant()
    this.invariant = Math.ceil(ethers.utils.formatUnits(b.toString(), 36)) 
    
    let balanceTTL = await tokenContract.balanceOf(this.account)
    this.balanceTTL = ethers.utils.formatUnits(balanceTTL.toString(), 18)

    let balanceDAI = await daiContract.balanceOf(this.account)
    this.balanceDAI = ethers.utils.formatUnits(balanceDAI.toString(), 18)

    
    
  },
  methods:
  {
    async getAccountAddress()
    {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      const account = accounts[0]
      this.account = account
    },
    async approveTestToken()
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let addressTestToken = '0x556b2a9CbAF23F36AbA28E3a92439c8F0568bb6F'
      let addressOfTestSwap = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const testTokenContract = new ethers.Contract(addressTestToken, ERC20.abi, provider)
      
      let a = await testTokenContract.connect(provider.getSigner()).approve(addressOfTestSwap, ethers.utils.parseUnits(this.maxInt256, 18));
      console.log(a)
      let tx = await a.wait()
      console.log(tx)
      this.isTokenApproved = true
    },
    async approveDai()
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let addressDai = '0xad6d458402f60fd3bd25163575031acdce07538d'
      let addressOfTestSwap = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const daiContract = new ethers.Contract(addressDai, ERC20.abi, provider)
      
      let a = await daiContract.connect(provider.getSigner()).approve(addressOfTestSwap, ethers.utils.parseUnits(this.maxInt256, 18));
      console.log(a)
      let tx = await a.wait()
      console.log(tx)
      this.isDaiApproved = true
    },
    async sellTokens()
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let addressTestToken = '0x556b2a9CbAF23F36AbA28E3a92439c8F0568bb6F'
      let addressOfTestSwap = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const swapContract = new ethers.Contract(addressOfTestSwap, TestSwap.abi, provider)
      const testTokenContract = new ethers.Contract(addressTestToken, ERC20.abi, provider)
         
      
      let _amount = ethers.utils.parseUnits(this.amount, 18)
      let tokensSold = this.amount
      console.log(swapContract, testTokenContract)
      console.log("SELL")
      
      let allowance = await testTokenContract.allowance(this.account, addressOfTestSwap);
      
      if(allowance.toString().length != 1)
      {
        this.flag = false;
        let res = await swapContract.connect(provider.getSigner()).swapExactTTLforDAI(
        this.account,
        _amount
        )
        let tx = await res.wait()
        console.log(tx)
        this.updateBalances()
        this.updateReservesAfterSell(tokensSold)
      }
      else{
        this.flag = true;
      }
    },
    async buyTokens()
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let addressDai = '0xad6d458402f60fd3bd25163575031acdce07538d'
      let addressOfTestSwap = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const swapContract = new ethers.Contract(addressOfTestSwap, TestSwap.abi, provider)
      const daiContract = new ethers.Contract(addressDai, ERC20.abi, provider)
      console.log(daiContract)
      let _amount = ethers.utils.parseUnits(this.amount, 18)
      let tokensBought = this.amount
      console.log(swapContract)
      let allowance = await daiContract.allowance(this.account, addressOfTestSwap);
      console.log("BUY")
      console.log(_amount)
      
      if(allowance.toString().length != 1)
      {
        this.flag = false;
        let res = await swapContract.connect(provider.getSigner()).swapDAIforExactTTL(
        this.account,
        _amount
        )
        let tx = await res.wait()
        console.log(tx)
        this.updateBalances()
        this.updateReserves(tokensBought)
      }
      else{
        this.flag = true;
      }
    },
    async updateBalances()
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)

      let addressTestToken = '0x556b2a9CbAF23F36AbA28E3a92439c8F0568bb6F'
      let addressDai = '0xad6d458402f60fd3bd25163575031acdce07538d'

      const daiContract = new ethers.Contract(addressDai, ERC20.abi, provider)
      const tokenContract = new ethers.Contract(addressTestToken, ERC20.abi, provider)

      let balanceTTL = await tokenContract.balanceOf(this.account)
      this.balanceTTL = ethers.utils.formatUnits(balanceTTL.toString(), 18)

      let balanceDAI = await daiContract.balanceOf(this.account)
      this.balanceDAI = ethers.utils.formatUnits(balanceDAI.toString(), 18)
    },
  
    incAmount()
    {
      if(this.amount < this.reserveToken)
      {
        let _amount = Number(this.amount)
        this.amount = (_amount + 1).toString();
        //this.getCost()
      }
      
    },
    incAmountSelling()
    {
      if(Number(this.amount) < Number(this.balanceTTL))
      {
        let _amount = Number(this.amount)
        this.amount = (_amount + 1).toString();
        //this.getCost()
      }
    },
    decreaseAmount()
    {
      if(this.amount!=1)
      {
        let _amount = Number(this.amount)
        this.amount = (_amount - 1).toString();
        
      }
      //this.getCost()
    },
    changeSwap()
    {
      if(this.swap == true)
      {
        this.swap = false
      }
      else{
        this.swap = true
      }
      console.log(this.swap)
    },
    showBuyModal() {
      this.isSellModal = false;
      this.isBuyModal = true;
    },
    showSellModal()
    {
      this.isSellModal = true;
      this.isBuyModal = false;
    },
    closeModal()
    {
      this.isBuyModal = false;
      this.isSellModal = false;
      this.amount = "1"
    },
    async updateReserves(tokensBought)
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let address = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const swapContract = new ethers.Contract(address, TestSwap.abi, provider)
      
      this.currentReserve -= parseInt(tokensBought)
      let cur = await swapContract.getReserves()
      this.reserveDAI = ethers.utils.formatUnits( cur[1].toString(), 18)
    },
    async updateReservesAfterSell(tokensSold)
    {
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      let address = '0x7ED49bB36f915d327301B4CD4Cb90DAAf20d1B7F'
      const swapContract = new ethers.Contract(address, TestSwap.abi, provider)
      this.currentReserve += parseInt(tokensSold)
      let cur = await swapContract.getReserves()
      this.reserveDAI = ethers.utils.formatUnits( cur[1].toString(), 18)
    }
    
  }
}
</script>

<style>
/* @import "~materialize-css/dist/css/materialize.min.css"; */
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  
  
}
#account-address{
  margin-top:0;
  margin-left: 60%;
}
div 
{ 
  border-radius: 10px;
}
#token{
  position:relative;
  margin-left: auto;
  margin-right: auto;
  margin-top:100px;
  height: 400px;
  width: 350px;
  background:#2e2d2d;
}
#inc-dec{
  top:10px;
  
  position:relative;
  margin-left: auto;
  margin-right: auto;
  width: 350px;
}

#token-name{

  position: relative;
  top:30px;
  left:30px;
  text-align: left;
  font-size: 150%;
  color:white;
}
#token-symbol{
  position: relative;
  top:10px;
  left:30px;
  text-align: left;
  font-size: 110%;
  color:#626776;
}
#balance{
  position: relative;
  top:10px;
  left:30px;
  text-align: left;
  font-size: 110%;
  color:#ffffff;
}
#price{
  position: relative;
  top:190px;
  left:30px;
  text-align: left;
  font-size: 150%;
  color:white;
}
#pool{
  position: relative;
  top:170px;
  left:30px;
  text-align: left;
  font-size: 120%;
  color:#9f9f9f;
}

#tokens-amount{
  position: relative;
  margin-left:auto;
  margin-right:auto;
  width:120px;
  border:1px solid rgb(233, 230, 230);
  font-size:120%;
  cursor: default;
}
#buy{
  position: relative;
  margin-left:auto;
  margin-right:auto;
  border-radius: 10px;
  width:350px;
}
input,
textarea {
  border: 1px solid #eeeeee;
  box-sizing: border-box;
  margin: 0;
  outline: none;
  padding: 10px;
}

input[type="button"] {
  -webkit-appearance: button;
  cursor: pointer;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}

.input-group {
  clear: both;
  margin: 15px 0;
  position: relative;
}

.input-group input[type='button'] {
  background-color: #eeeeee;
  min-width: 38px;
  width: auto;
  transition: all 300ms ease;
}

.input-group .button-minus,
.input-group .button-plus {
  font-weight: bold;
  height: 38px;
  padding: 0;
  width: 38px;
  position: relative;
}

.input-group .quantity-field {
  position: relative;
  height: 38px;
  left: -6px;
  text-align: center;
  width: 62px;
  display: inline-block;
  font-size: 13px;
  margin: 0 0 5px;
  resize: vertical;
}
.quantity-field{
  background:white;
}
.button-plus {
  left: -13px;
}
#buttonBuy{
  position: relative;
  top:20px;
  margin-left:auto;
  margin-right:auto;
  background-color: #d89844;
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: block;
  font-size: 16px;
  border-radius: 10px;
  width:350px;
  cursor:pointer;

}
#buttonSell{
  margin-left:auto;
  margin-right:auto;
  position: relative;
  top:40px;
  background-color: #d89844;
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: block;
  font-size: 16px;
  border-radius: 10px;
  width:350px;
  cursor:pointer;
}
input[type="number"] {
  -moz-appearance: textfield;
  -webkit-appearance: none;
}
.modal-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.3);   
}
#modal{
  margin: auto;
  position: absolute;
  top: 0; left: 0; bottom: 0; right: 0;
  width:350px;
  height: 600px;
  background:white;
  /* overflow-x: auto;
  flex-direction: column; */
  
}
#token-in-modal{
  position:relative;
  
  margin-top:-25px;
  margin-left: auto;
  margin-right: auto;
  height: 400px;
  width:350px;
  background:#2e2d2d;
}
#button-modal{
  position: relative;
  margin-left:auto;
  margin-right:auto;
  margin-top:30px;
  background-color: #d89844;
  border: none;
  color: white;
  padding: 15px 20px;
  text-align: center;
  text-decoration: none;
  display: block;
  font-size: 16px;
  border-radius: 10px;
  width:200px;
  cursor:pointer;
}
#button-disabled{
position: relative;
  margin-left:auto;
  margin-right:auto;
  margin-top:30px;
  background-color: #9e9e9d;
  border: none;
  color: white;
  padding: 15px 20px;
  text-align: center;
  text-decoration: none;
  display: block;
  font-size: 16px;
  border-radius: 10px;
  width:200px;
}
</style>
