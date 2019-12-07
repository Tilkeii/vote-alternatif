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
                <router-view></router-view>
            </v-container>
        </v-content>

        <v-footer app>
            <!-- -->
        </v-footer>
    </v-app>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";

@Component
export default class App extends Vue {}
</script>
