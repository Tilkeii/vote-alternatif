<template>
    <v-app>
        <!-- <v-navigation-drawer app>
        </v-navigation-drawer>-->

        <v-app-bar app>
            <v-toolbar-title>Vote</v-toolbar-title>
        </v-app-bar>

        <!-- Sizes your content based upon application components -->
        <v-content>
            <!-- Provides the application the proper gutter -->
            <v-container>
                <!-- If using vue-router -->
                <!-- <router-view></router-view> -->
                <div>
                    <h1>Vote</h1>
                    <v-row>
                        <v-col>
                            <MetamaskError v-if="!metamaskEnable"></MetamaskError>
                            <div v-else-if="loading">Loading...</div>
                            <PhaseRegister :metamaskAddress="metamaskAddress" v-else-if="currentPhase == 0"></PhaseRegister>
                            <PhaseOpen v-else-if="currentPhase == 1"></PhaseOpen>
                            <PhaseClosed v-else-if="currentPhase == 2"></PhaseClosed>
                        </v-col>
                    </v-row>
                </div>
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
    private currentPhase: EPhase | undefined;
    private loading: boolean = true;
    public metamaskEnable: boolean = false;
    public metamaskAddress: string = "";

    public async created() {
        this.loading = true;
        const ethereum = (window as any).ethereum;
        try {
            const accounts = await ethereum.enable();
            this.metamaskAddress = accounts[0];
            console.debug("Current Address : ", this.metamaskAddress);
            this.metamaskEnable = true;
            this.currentPhase = await this.getCurrentPhase();
            console.debug("Current Phase : ", this.currentPhase);
            this.loading = false;
        } catch (error) {
            if (error.code === 4001)
                console.warn("Please connect to MetaMask.");
            else {
                console.error(error);
            }
        }

        ethereum.on("accountsChanged", (accounts: any) => {
            this.metamaskAddress = accounts[0];
            if (accounts[0]) this.metamaskEnable = true;
            else this.metamaskEnable = false;
        });
    }

    public async getCurrentPhase(): Promise<any> {
        return await this.$contract.methods
            .getCurrentPhase()
            .call({ from: this.metamaskAddress });
    }
}

enum EPhase {
    REGISTER,
    OPEN,
    CLOSED
}
</script>
