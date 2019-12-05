import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import Web3 from 'web3';

Vue.config.productionTip = false

const web3 = new Web3(Web3.givenProvider);
console.log('Web3', web3);
console.log('givenProvider', Web3.givenProvider);

const contract_json = require('../../blockchain/build/contracts/AlternativeVote.json');
console.log('ABI', contract_json.abi);
console.log('Address', contract_json.networks[3].address);
const contract = new web3.eth.Contract(contract_json.abi, contract_json.networks[3].address);
console.log('Contract', contract);

web3.eth.getAccounts(console.log).then((result: any) => {
    console.log('Get Account', result);
});

contract.methods.testConnexion().call().then((result: any) => {
    console.log('Result', result);
});

new Vue({
	router,
	store,
	render: h => h(App)
}).$mount('#app')
