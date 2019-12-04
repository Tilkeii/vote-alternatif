import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.productionTip = false

// const web3 = require('web3'); 
// const contract = require('truffle-contract');
import Web3 from 'web3';
import contract from 'truffle-contract';

const web3 = new Web3(Web3.givenProvider);
const SC_artifacts = require('../../blockchain/build/contracts/AlternativeVote.json');
const SC = contract(SC_artifacts);


new Vue({
	router,
	store,
	render: h => h(App)
}).$mount('#app')
