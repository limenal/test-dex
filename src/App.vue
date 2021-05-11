<template>

  <div id="app">
     <div id="nav">
      <router-link to="/">Exchanger</router-link>
      <router-link to="/graph">Graph</router-link>
    </div>
    
    <router-view :key="$route.fullPath"/>  
  </div>


</template>

<script>
 //import {ethers} from 'ethers'
 //import TestSwap from './TestSwap.json'
 //import ERC20 from './ERC20.json'
 //import ModalBuy from './components/ModalBuy.vue'
 //import PulseLoader from '@/components/PulseLoader.vue';
 //import TestToken from './TestToken.json'

export default {
  name: 'App',
  components: {
   // PulseLoader,
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
    
      window.location.reload()
    });
    // if(window.ethereum)
    // {
    //   window.ethereum.on('chainChanged ', (chainID) => {
    //   console.log(chainID)
    //   window.location.reload()
      
    // });
    // }
    
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
      isBuying: false,
      isSelling: false,
      isApproving: false,
      chainID: '',
      rightChainID: '',
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
    
    
  }
  
  ,
  created: async function () {

    

    
    
  },
  methods:
  {
    
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
#nav {
  z-index:999;
  position:fixed;
  text-align: left;
  background-color:#d89844;
  padding: 30px;
  padding-left: 57px;
  top:0px;
  width:100%;
}
#nav > * {
margin-right:25px
}
#nav a {
font-size:17px;
  color: white;
  text-decoration: none;
}
#nav a.router-link-exact-active {
  padding-bottom:7px;
border-bottom: 1px solid white
}
</style>
