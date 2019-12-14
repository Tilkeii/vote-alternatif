<template>
    <div v-if="!loading">
        <v-row>
            <h1>PhaseOpen</h1>
        </v-row>
        <v-row v-if="!alreadyVoted">
            <v-card class="mx-auto" outlined>
                <v-list flat v-if="candidatesList.length">
                    <v-subheader>Candidates</v-subheader>
                    <v-divider></v-divider>
                    <Draggable
                        v-model="candidatesList"
                        v-bind="{ghostClass: 'ghost'}"
                        :options="{ animation:150 }"
                    >
                        <v-list-item v-for="candidate in candidatesList" :key="candidate">
                            <v-list-item-content>
                                <v-list-item-title>{{ candidate }}</v-list-item-title>
                            </v-list-item-content>
                        </v-list-item>
                    </Draggable>
                </v-list>
                <v-card-title v-else>Aucun candidats</v-card-title>
                <v-divider></v-divider>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn @click="onClickSave" text>Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-row>
        <v-row v-else>
            <p>Tu as deja voté bolosse</p>
        </v-row>
    </div>
</template>

<style lang="scss" scoped>
.ghost {
    opacity: 0;
}
</style>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import Draggable from "vuedraggable";

@Component({
    components: {
        Draggable
    }
})
export default class PhaseOpen extends Vue {
    @Prop() metamaskAddress!: string;
    @Prop() isOwner!: boolean;
    private candidatesList: Array<any> = [];
    private alreadyVoted: boolean = false;
    private loading: boolean = true;

    public async created(): Promise<void> {
        this.loading = true;
        this.$emit('loading', true);
        this.candidatesList = await this.getCandidatesListContract();
        this.alreadyVoted = await this.getAlreadyVoted();
        console.log('Get user vote', await this.getUserVote());
        this.loading = false;
        this.$emit('loading', false);
    }

    private async getCandidatesListContract(): Promise<any> {
        return await this.$contract.methods
            .getCandidatesList()
            .call({ from: this.metamaskAddress });
    }

    private async getAlreadyVoted(): Promise<any> {
        return await this.$contract.methods
            .getAlreadyVoted()
            .call({ from: this.metamaskAddress });
    }

    private async getUserVote(): Promise<any> {
        return await this.$contract.methods
            .getUserVote()
            .call({ from: this.metamaskAddress });
    }

    private async onClickSave(): Promise<any> {
        try {
            await this.$contract.methods
                .giveVotesList(this.candidatesList)
                .send({ from: this.metamaskAddress });
            console.log('Get user vote', await this.getUserVote());
            this.alreadyVoted = true;
        } catch (error) {
            console.error(error);
        }
    }
}
</script>
