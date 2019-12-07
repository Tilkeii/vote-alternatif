import Vue from "vue";
import Vuex, {StoreOptions} from "vuex";
import { IRootState } from './types';

Vue.use(Vuex);

const store: StoreOptions<IRootState> = {
    state: {
        version: "1.0.0",
        metamaskEnabled: false
    },
    modules: {
    },
    plugins: []
};

export default new Vuex.Store<IRootState>(store);