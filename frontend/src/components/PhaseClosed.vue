<template>
    <div>
        <h1>PhaseClosed</h1>
    </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class PhaseClosed extends Vue {
    @Prop() metamaskAddress!: string;
    @Prop() isOwner!: boolean;

    public async created(): Promise<void> {}
}
</script>
