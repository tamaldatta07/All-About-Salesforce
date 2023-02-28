import { LightningElement } from 'lwc';

export default class Looping extends LightningElement {
    carList = ["Ford","Tata","Audi","Maruti"]


    ceoList = [
        {
            id:1,
            company:"Google",
            name:"Sundar Pichai"
        },
        {
            id:2,
            company:"Apple",
            name:"Tim Cook"
        }
    ]
}