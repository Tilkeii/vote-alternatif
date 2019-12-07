import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify';
import Web3 from 'web3';

Vue.config.productionTip = false

// https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
const ethereum = (window as any).ethereum;
ethereum.enable();

const web3 = new Web3(Web3.givenProvider);
console.log('Web3', web3);
console.log('givenProvider', Web3.givenProvider);

const contract_json = require('../../blockchain/build/contracts/AlternativeVote.json');
console.log('ABI', contract_json.abi);
console.log('Address', contract_json.networks[3].address);
const contract = new web3.eth.Contract(contract_json.abi, contract_json.networks[3].address);
console.log('Contract', contract);

contract.events.PhaseChange

web3.eth.getAccounts().then(result => {
    console.log('getAccounts', result);

    // contract.methods.testConnexion().call().then((result: any) => {
    //     console.log('Result testConnexion', result);
    // });

});

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
