<template>
    <div>
        <h1>PhaseRegister</h1>
        <div v-for="candidate in candidatesList" :key="candidate">
            {{ candidate }}
        </div>
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class PhaseRegister extends Vue {
    @Prop() metamaskAddress!: string;
    public candidatesList: Array<any> = [];

    public async created() {
        this.candidatesList = await this.getCandidatesList();
        console.debug("Candidates List : ", this.candidatesList);
    }

    public async getCandidatesList() {
        return await this.$contract.methods
            .getCandidatesList()
            .call({ from: this.metamaskAddress });
    }
}
</script>
