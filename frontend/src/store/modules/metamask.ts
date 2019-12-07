import { Module, VuexModule, Mutation, Action } from "vuex-module-decorators";
import { IMetamask } from '../types';

@Module
export default class Metamask extends VuexModule implements IMetamask {
    public enable: boolean = false;
    public address: string = '';
    
    @Mutation
    public setMetamask(bool: boolean): void {
        this.enable = bool;
    }

    @Mutation
    public setAddress(newAddress: string): void {
        this.address = newAddress;
    }
}