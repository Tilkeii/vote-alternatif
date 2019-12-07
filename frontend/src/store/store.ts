import Vue from "vue";
import Vuex, {StoreOptions} from "vuex";
import { IRootState } from './types';
import Metamask from './modules/metamask';

Vue.use(Vuex);

const store: StoreOptions<IRootState> = {
    state: {
        version: "1.0.0"
    },
    modules: {
        Metamask
    },
    plugins: []
};

export default new Vuex.Store<IRootState>(store);