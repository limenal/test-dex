<script>
  export default {
    name: 'ModalBuy',
    methods: {
      close() {
        this.$emit('close');
      },
    },
  };
</script>

<template>
  <div class="modal-backdrop">
    <div class="modal">
      
      <div id="token">
      <div>
        <p id="token-name">Test Token</p>
        <p id="token-symbol">$TTL</p>
      </div>

      <div>
        <p id="price">{{getCost}} $</p>
        <p id="pool">1/36 available</p>
      </div>
    </div>
    
    <button
          type="button"
          class="btn-green"
          v-on:click="close"
        >
          Close Modal
    </button>
      
    </div>
  </div>
  
</template>
<style>
  .modal-backdrop {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.3);
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .modal {
    background: #FFFFFF;
    box-shadow: 2px 2px 20px 1px;
    overflow-x: auto;
    display: flex;
    flex-direction: column;
    height: 700px;
    width: 400px;
  }

  .modal-header,
  .modal-footer {
    padding: 15px;
    display: flex;
    width: 400px;
  }


  .modal-footer {
    border-top: 1px solid #eeeeee;
    flex-direction: column;
    justify-content: flex-end;
    width: 400px;
  }

  .btn-close {
    position: absolute;
    top: 0;
    right: 0;
    border: none;
    font-size: 20px;
    padding: 10px;
    cursor: pointer;
    font-weight: bold;
    color: #4AAE9B;
    background: transparent;
  }

  .btn-green {
    margin-left:auto;
    margin-right:auto;
    color: white;
    background: #4AAE9B;
    border: 1px solid #4AAE9B;
    border-radius: 2px;
    width: 350px;
  }
</style>
