import { LightningElement, track } from 'lwc';

export default class DataBindingDemo extends LightningElement {

    /***Data binding example*/
    Example = "Hello Salesforce"
    Example_JS = "LWC"
    //method
    changeHandler(event){
        this.Example_JS = event.target.value;
    }


    /***@track binding example*/
    //Creating an Object
    // @track address
    address={
        city :'Bankura',
        postalCode : 722136,
        country : 'India'
    }
    trackHandler(event){
        // this.address.city = event.target.value;
        this.address = {...this.address, "city":event.target.value} //to avoid "track" we can do it this way
    }

    /***getter example*/
    users = ["Moto","Ram","Lenovo"]
    num1 = 10
    num2 = 20
    get firstUser(){
        return this.users[0]
    }
    get addNumbers(){
        return this.num1 + this.num2
    }
}