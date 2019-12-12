<template>
    <div>
        <v-row>
            <h1>PhaseRegister</h1>
        </v-row>
        <v-row>
            <v-card class="mx-auto" outlined>
                <v-list flat v-if="candidatesList.length">
                    <v-subheader>Candidates</v-subheader>
                    <v-divider></v-divider>
                    <v-list-item v-for="candidate in candidatesList" :key="candidate">
                        <v-list-item-content>
                            <v-list-item-title>{{ candidate }}</v-list-item-title>
                        </v-list-item-content>
                    </v-list-item>
                </v-list>
                <v-card-title v-else>Aucun candidats</v-card-title>
            </v-card>
        </v-row>
        <v-row justify="center">
            <v-col class="flex-grow-0">
                <v-btn @click="registerCandidateContract" outlined class="mx-2">Register</v-btn>
            </v-col>
        </v-row>
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop, Watch } from "vue-property-decorator";

@Component
export default class PhaseRegister extends Vue {
    @Prop() metamaskAddress!: string;
    @Prop() isOwner!: boolean;
    private candidatesList: Array<any> = [];

    public async created(): Promise<void> {
        this.candidatesList = await this.getCandidatesListContract();
        console.debug("Candidates List : ", this.candidatesList);

        /**
         * Web3 event
         */

        this.$contract.events.CandidateAdded({}, (error: any, event: any) => {
            if (!error) {
                console.debug("Candidate Added : ", event);
                this.candidatesList.push(event.returnValues.candidate);
            } else {
                console.error(error);
            }
        });

        this.$contract.events.ResetVote({}, (error: any, event: any) => {
            if (!error) {
                console.debug("Reset Vote : ", event);
                this.candidatesList = [];
            } else {
                console.error(error);
            }
        });
    }

    private async getCandidatesListContract() {
        return await this.$contract.methods
            .getCandidatesList()
            .call({ from: this.metamaskAddress });
    }

    private async registerCandidateContract(): Promise<any> {
        return await this.$contract.methods
            .registerCandidate()
            .send({ from: this.metamaskAddress });
    }

    @Watch("candidatesList")
    onCandidatesListChanged(val: any, newVal: any) {
        console.log("OnCandidatesListChanged", val, newVal);
    }
}
</script>
