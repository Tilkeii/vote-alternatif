<template>
    <div>
        <h1>Vote</h1>
        <v-row>
            <v-col>
                <MetamaskError v-if="!metamask.enable"></MetamaskError>
            </v-col>
        </v-row>
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import MetamaskError from "@/components/MetamaskError.vue";
import { State } from "vuex-class";
import { IMetamask } from "../store/types";

@Component({
    components: {
        MetamaskError
    }
})
export default class Home extends Vue {
    @State("Metamask") metamask!: IMetamask;

    public created() {
        setTimeout(this.getCurrentPhase, 1000)
    }

    public async getCurrentPhase() {
        const registerCandidate = await this.$contract.methods
            .registerCandidate()
            .send({from: this.metamask.address});
        console.log('registerCandidate', registerCandidate);

        const getCandidatesList = await this.$contract.methods
            .getCandidatesList()
            .call({from: this.metamask.address});
        console.log('getCandidatesList', getCandidatesList);

        const currentPhase = await this.$contract.methods
            .getCurrentPhase()
            .call({from: this.metamask.address});
        console.log('Current Phase', currentPhase);
    }
}
</script>
