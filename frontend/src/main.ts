import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store/store'
import vuetify from './plugins/vuetify';
import Web3 from 'web3';

Vue.config.productionTip = false

/**
 * Connexion with metamask
 */
const ethereum = (window as any).ethereum;
ethereum.enable().then((accounts: any) => {
    store.commit('setMetamask', true);
    store.commit('setAddress', accounts[0]);
}).catch((error: any) => {
    if(error.code === 4001)
        console.warn('Please connect to MetaMask.')
    else {
        console.error(error);
    }
})

ethereum.on('accountsChanged', function (accounts: any) {
    store.commit('setAddress', accounts[0]);
})

/**
 * Connexion with Web3
 */
const web3 = new Web3(Web3.givenProvider);
console.log('Web3', web3);
console.log('givenProvider', Web3.givenProvider);
const contract_json = require('../../blockchain/build/contracts/AlternativeVote.json');
console.log('ABI', contract_json.abi);
console.log('Address', contract_json.networks[3].address);
const contract = new web3.eth.Contract(contract_json.abi, contract_json.networks[3].address);
console.log('Contract', contract);

/**
 * Vuejs global variable
 */
Vue.prototype.$web3 = web3;
Vue.prototype.$contract = contract;

new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
