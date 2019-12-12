<template>
    <v-app>
        <!-- <v-navigation-drawer app>
        </v-navigation-drawer>-->

        <v-app-bar app>
            <v-toolbar-title>Vote</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items>
                <v-btn text @click="resetVoteToDefaultContract" v-if="isOwnerProp">Reset Vote</v-btn>
                <v-btn text @click="setCurrentPhaseContract" v-if="isOwnerProp">Close Vote</v-btn>
                <v-btn text v-if="isOwnerProp">Get Winner</v-btn>
            </v-toolbar-items>
        </v-app-bar>

        <!-- Sizes your content based upon application components -->
        <v-content>
            <!-- Provides the application the proper gutter -->
            <v-container>
                <!-- If using vue-router -->
                <!-- <router-view></router-view> -->
                <!-- <h1>Vote</h1> -->
                <v-row align="center" justify="center">
                    <v-col cols="6">
                        <MetamaskError v-if="!metamaskEnable"></MetamaskError>
                        <div v-else-if="loading">Loading...</div>
                        <PhaseRegister
                            v-else-if="currentPhase == 0"
                            :metamaskAddress="metamaskAddress"
                            :isOwner="isOwnerProp"
                        ></PhaseRegister>
                        <PhaseOpen
                            v-else-if="currentPhase == 1"
                            :metamaskAddress="metamaskAddress"
                            :isOwner="isOwnerProp"
                        ></PhaseOpen>
                        <PhaseClosed
                            v-else-if="currentPhase == 2"
                            :metamaskAddress="metamaskAddress"
                            :isOwner="isOwnerProp"
                        ></PhaseClosed>
                    </v-col>
                </v-row>
            </v-container>
        </v-content>

        <v-footer app>
            <!-- -->
        </v-footer>
    </v-app>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Watch } from "vue-property-decorator";
import MetamaskError from "@/components/MetamaskError.vue";
import PhaseRegister from "@/components/PhaseRegister.vue";
import PhaseOpen from "@/components/PhaseOpen.vue";
import PhaseClosed from "@/components/PhaseClosed.vue";

@Component({
    components: {
        MetamaskError,
        PhaseRegister,
        PhaseOpen,
        PhaseClosed
    }
})
export default class App extends Vue {
    private currentPhase: EPhase = EPhase.REGISTER;
    private loading: boolean = true;
    private metamaskEnable: boolean = false;
    private metamaskAddress: string = "";
    private isOwnerProp: boolean = false;

    public async created(): Promise<void> {
        this.loading = true;
        const ethereum = (window as any).ethereum;
        try {
            const accounts = await ethereum.enable();
            this.metamaskAddress = accounts[0];
            console.debug("Current Address : ", this.metamaskAddress);
            this.metamaskEnable = true;
            this.currentPhase = Number(await this.getCurrentPhaseContract());
            console.debug("Current Phase : ", this.currentPhase);
            this.isOwnerProp = await this.isOwnerContract();
            console.debug("Is Owner : ", this.isOwnerProp);
            this.loading = false;
        } catch (error) {
            if (error.code === 4001)
                console.warn("Please connect to MetaMask.");
            else {
                console.error(error);
            }
        }

        /**
         * Metamask event when account changed
         */

        ethereum.on("accountsChanged", async (accounts: any) => {
            this.metamaskAddress = accounts[0];
            if (accounts[0]) this.metamaskEnable = true;
            else this.metamaskEnable = false;
            this.isOwnerProp = await this.isOwnerContract();
            console.debug("Is Owner : ", this.isOwnerProp);
        });

        /**
         * Web3 event
         */

        this.$contract.events.PhaseChange({}, (error: any, event: any) => {
            if (!error) {
                console.debug("Phase Change : ", event);
                this.currentPhase = Number(event.returnValues.newPhase);
            } else {
                console.error(error);
            }
        });
    }

    private async getCurrentPhaseContract(): Promise<any> {
        return await this.$contract.methods
            .getCurrentPhase()
            .call({ from: this.metamaskAddress });
    }

    private async isOwnerContract(): Promise<any> {
        return await this.$contract.methods
            .isOwner()
            .call({ from: this.metamaskAddress });
    }

    private async resetVoteToDefaultContract(): Promise<any> {
        return await this.$contract.methods
            .resetVoteToDefault()
            .send({ from: this.metamaskAddress });
    }

    private async setCurrentPhaseContract(): Promise<any> {
        return await this.$contract.methods
            .setCurrentPhase(1)
            .send({ from: this.metamaskAddress });
    }
}

enum EPhase {
    REGISTER,
    OPEN,
    CLOSED
}
</script>
