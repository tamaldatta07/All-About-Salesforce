import { LightningElement } from 'lwc';

export default class ConditionalRenderingDemo extends LightningElement {
    isVisible = false;

    handleClick(){
        this.isVisible = true;
    }
}