<template>
    <div>
        <v-row>
            <h1>PhaseOpen</h1>
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
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class PhaseOpen extends Vue {
    @Prop() metamaskAddress!: string;
    @Prop() isOwner!: boolean;
    private candidatesList: Array<any> = []; 

    public async created(): Promise<void> {
        this.candidatesList = await this.getCandidatesList();
    }

    private async getCandidatesList() {
        return await this.$contract.methods
            .getCandidatesList()
            .call({ from: this.metamaskAddress });
    }
}
</script>
