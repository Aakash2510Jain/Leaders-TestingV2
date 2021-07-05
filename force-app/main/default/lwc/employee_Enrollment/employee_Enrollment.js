import { LightningElement ,api, wire, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { loadScript } from "lightning/platformResourceLoader";
import { NavigationMixin } from 'lightning/navigation'; 
import getAssignmentListinitial from '@salesforce/apex/AssSelectionLwcHelper.getAssignmentListinitial';
import SelfAssesmentValues from '@salesforce/apex/SelfAssForAppHelper.SelfAssesmentValues';
import OnePagerValues from '@salesforce/apex/SelfAssForAppHelper.OnePagerValues';
import SelfAssesmentResCreation from '@salesforce/apex/SelfAssForAppHelper.SelfAssesmentResCreation';
import OnePagerResCreation from '@salesforce/apex/SelfAssForAppHelper.OnePagerResCreation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import Contact__c from '@salesforce/schema/Application__c.Contact__c';
import Status_Summary_Line__c  from '@salesforce/schema/Application__c.Status_Summary_Line__c';
import Origin__c  from '@salesforce/schema/Application__c.Origin__c';
import Mandate__c  from '@salesforce/schema/Application__c.Mandate__c';
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Birthdate  from '@salesforce/schema/Contact.Birthdate';
import Office_City__c  from '@salesforce/schema/Contact.Office_City__c';
import LinkedIn_URL__c  from '@salesforce/schema/Contact.LinkedIn_URL__c';
import Phone  from '@salesforce/schema/Contact.Phone';
import job_Area__c  from '@salesforce/schema/Contact.job_Area__c';
import Office_State__c  from '@salesforce/schema/Contact.Office_State__c';
import Country__c  from '@salesforce/schema/Contact.Country__c';
import Email  from '@salesforce/schema/Contact.Email';
import hasCV__c  from '@salesforce/schema/Contact.hasCV__c';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';
import getApplicationList from '@salesforce/apex/AssSelectionLwcHelper.getApplicationList';
import getSelfAssIdandOPId from '@salesforce/apex/AssSelectionLwcHelper.getSelfAssIdandOPId';
import getDocsForAss from '@salesforce/apex/AssSelectionLwcHelper.getDocsForAss';
import CONFETTI from "@salesforce/resourceUrl/confetti";
import SWEETALERT from "@salesforce/resourceUrl/sweetalert";

export default class RegistraionPage extends NavigationMixin(LightningElement) {


    connectedCallback() {
        debugger;
        Promise.all([
          loadScript(this, SWEETALERT),
          loadScript(this, CONFETTI)
        ])
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Dependencies loaded successfully",
                variant: "Success"
              })
            );
            this.setUpCanvas();
          })
          .catch(error => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error",
                message: error.message,
                variant: error
              })
            );
          });
      }

    @api recordId ; //Conid
    @api conId ;
    @api appId ;
    @api objectApiName = 'Contact';
    @api objectName = 'Application__c';
    @api assId;
    @api appList;
    frameURLSelf;
    frameURLOP;
    onePagerlist;
    selfasslist;
    selfAssId;
    onePagerId;
    regid;
    isCreatingOP;
    heading;
    showSelfAssTemp;
    selectedAppId;
    appView = false;
    areAppsAvailable = false;
    showWarning = true;
    showSpinner = false;
    showTable = false;
    showSecondPage = true;
    isModalOpen = false;
    isModalDocsOpen = false;
    isModalDocsViewOpen = false;
    isSelfAssOpen =false;
    assView = false;
    selfAss = false;
    isCreatingApp = false;
    showProgress = true;
    showreg = false;
    showAss = false;
    showMainPage = true;
    areDetailsVisible = false;
    JobDescId ;
    ResStratId ;
    EmpPrfId;
    ExecSummId ;
    attFound = false;
    noAttFound = false;
    viewAttForDoc = false;
    modalWithAssDocs = false;
    fields = [FirstName,LastName,Email,Birthdate,Office_State__c,LinkedIn_URL__c,job_Area__c,Phone];

    @track columns = [
        {  
            label: "Assignment Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Industry',
            fieldName: 'Industry_Types__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Company Name',
            fieldName: 'Mandate_Company_Name__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Language',
            fieldName: 'Language__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Ass Start Date',
            fieldName: 'Mandate_Start_Date__c',
            type: 'date',
            sortable: true
        },
        {
            label: 'Ass End Date',
            fieldName: 'Mandate_End_Date__c',
            type: 'date',
            sortable: true
        },
        {type: "button", typeAttributes: {  
            label: 'Apply',  
            name: 'Apply',  
            title: 'Apply',  
            disabled: false,  
            value: 'Apply',  
            iconPosition: 'right'  
        }},{type: "button", typeAttributes: {  
            label: 'View Docs',  
            name: 'Docs',  
            title: 'Docs',  
            disabled: false,  
            value: 'Apply',  
            iconPosition: 'right'  
        }},  
    ];
    @track columnForApp = [
        {  
            label: "Application Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Assignment Start Date',
            fieldName: 'Mandate_Start_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Status Summary Line',
            fieldName: 'Status_Summary_Line__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Company Name',
            fieldName: 'mandate_company_name__c',
            type: 'text',
            sortable: true
        },
        {type: "button", typeAttributes: {  
            label: 'View Docs',  
            name: 'View Docs',  
            title: 'View Docs',  
            disabled: false,  
            value: 'Docs',  
            iconPosition: 'right'  
        }},
    ];

    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }

    handleChange() {
        this.showSecondPage = true;
        this.showMainPage = false;
    }

    regExisting(){
        debugger;
        this.showSecondPage = false;
        this.existUserData = true;
    }

    regNew() {
        this.showSecondPage = false;
        this.showreg = true;
        this.areDetailsVisible = true;
        this.showMainPage = false;
    }
    
    handleSubmit(event){
        console.log('Account detail : ',event.detail.fields);
        
    }
    
    handleSuccessCon(event) {
        debugger;
        this.areDetailsVisible = false;
        //this.areAppsAvailable = true;
         debugger;
       this.conId = event.detail.id;
       this.getAssignmentListinitial();
       //this.assView = true;
       //alert(event.detail.id);
       swal("Congrats", "Your Record Has Been Created sucessfully", "success");
       confetti({
        particleCount: 100,
        spread: 70,
        origin: {
          y: 0.6
        }
      });
    }

    openAppModel(){
        debugger;
        this.areAppsAvailable = false;
        this.assView = true;
        this.showProgress = false;
    }

    updateRegId(event){
        debugger;
       this.regid = event.target.value;
    }

    showData(){
        debugger;
        this.showSpinner = true;
        const conId = this.regid;
        getApplicationList({ conID:conId})
        .then(result => {
              this.appList = result;

              if (result) {
                debugger;
                console.log('result'+result);
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]); //cloning object  
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.appList = tempOppList;
            }
         });
        this.existUserData =false;
        this.showSpinner = false;
        this.appView = true; 
    }
    showDataOfNewCon(){
        debugger;
        this.showSpinner = true;
        const conId = this.conId;
        getApplicationList({ conID:conId})
        .then(result => {
              this.appList = result;

              if (result) {
                debugger;
                console.log('result'+result);
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]); //cloning object  
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.appList = tempOppList;
            }
         });
    }

    closeiframe(){
     debugger;
     this.showSelfAssTemp = false;
    }

    openDocsModal(event){
        debugger;
        this.selectedAppId =  event.detail.row.Id;  

        getSelfAssIdandOPId({ appID:this.selectedAppId})
        .then(result => {
            this.JobDescId = result.SelfAssId;
            this.ResStratId = result.OnePagerId
            this.EmpPrfId = result.SelfAssId;
            this.ExecSummId = result.OnePagerId
        });

        this.areAppsAvailable = false;
        this.appView = false;
        this.showProgress = false;
        this.isModalDocsViewOpen = true;
    }

    
    viewAtt(event){
        debugger;

        
        if(event.currentTarget.title == 'EXECUTIVE'){
            if(this.ExecSummId != undefined){
            this.noAttFound = false;
            this.heading = 'EXECUTIVE - SUMMARY';
            this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.ExecSummId;
            this.attFound = true;
            }else{
                this.heading = 'EXECUTIVE-SUMMARY';
                this.attFound = false;
                this.noAttFound = true;
                }
            }
            else if(event.currentTarget.title == 'Job'){
            if(this.JobDescId != undefined){
            this.noAttFound = false;
            this.heading = 'JOB-DESCRIPTION';
            this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.JobDescId;
            this.attFound = true;
            }else{
                this.heading = 'JOB-DESCRIPTION';
                this.attFound = false;
                this.noAttFound = true;
                }
        }else if(event.currentTarget.title == 'PROFILE'){
            if(this.EmpPrfId != undefined){
            this.noAttFound = false;
            this.heading = 'EMPLOYEE - PROFILE';
            this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.EmpPrfId;
            this.attFound = true;
            }else{
                this.heading = 'EMPLOYEE - PROFILE';
                this.attFound = false;
                this.noAttFound = true;
                }
        }else{
            if(this.ResStratId != undefined){
            this.noAttFound = false;
            this.heading = 'RESEARCH STRATEGY';
            this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.ResStratId;
            this.attFound = true;
            }else{
                this.heading = 'RESEARCH STRATEGY';
                this.attFound = false;
                this.noAttFound = true;
                }
        }
        this.showSelfAssTemp = true;
         
    }

    /*@track error;
    @track accList ;
    @wire(getAssignmentListinitial)
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            debugger;
            console.log('Assignment Data');
            console.log(data);
            this.conid;
            var tempOppList = [];  
            for (var i = 0; i < data.length; i++) {  
             let tempRecord = Object.assign({}, data[i]); //cloning object  
             tempRecord.recordLink = "/" + tempRecord.Id;  
             tempOppList.push(tempRecord);  
            }
            this.accList = tempOppList;
        } else if (error) {
            this.error = error;
        }
    }*/
    
    getAssignmentListinitial(event){
        debugger;
        //this.selectedAppId =  event.detail.row.Id;  
        getAssignmentListinitial({ conId:this.conId})
        .then(result => {
            //accList = result;
            var tempOppList = [];  
            for (var i = 0; i < result.length; i++) {  
             let tempRecord = Object.assign({}, result[i]); //cloning object  
             tempRecord.recordLink = "/" + tempRecord.Id;  
             tempOppList.push(tempRecord);  
            }
            this.accList = tempOppList;
            this.assView = true;
        });

        //this.areAppsAvailable = false;
        
        //this.showProgress = false;
        //this.isModalDocsViewOpen = true;
    }
  //
  openfileUploadApp(event){
    debugger;
    const file = event.target.files[0]
    var reader = new FileReader()
    reader.onload = () => {
        var base64 = reader.result.split(',')[1]
        this.fileData = {
            'filename': file.name,
            'base64': base64,
            'recordId': this.selectedAppId 
        }
        console.log(this.fileData)
    }
    reader.readAsDataURL(file)
    }

    createApp(){
            debugger;
            this.conId = this.regid;
            this.showProgress = false;
            this.assView = true;
            this.appView = false;
    }

    handleSortdata(event) {
        debugger;
        this.sortBy = event.detail.fieldName;
         
        
        if(event.detail.fieldName == 'recordLink'){
            event.detail.fieldName = 'Name'; 
        }
        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        debugger;
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.accList));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.accList = parseData;

    }

    //fileData
    openfileUploadapp(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.appId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
   
    openfileUploadSelApp(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.selectedAppId 
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
    
    openSelfAssModel(event) {
        debugger;
        this.isSelfAssOpen = true;
        this.isModalDocsOpen = false;
        this.assId;
        SelfAssesmentValues({ mandateRecId:this.assId})
        .then(result => {
            this.selfasslist = result[0];
            this.onePagerlist = result[1];
            console.log('hi::'+result);
        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
    }

    handleClick(){
        debugger;
        const {base64, filename, recordId} = this.fileData
        uploadFile({ base64, filename, recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
            
            swal("Congrats", title+" Succesfully Uploaded", "success");
           /* const evt = new ShowToastEvent({
                title: 'Succesfully Uploaded',
                message: title+' has been Uploaded Succesfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);*/
        })
    }

  
    showAssignments() {
        debugger;
        console.log('Show Assignment Method');
        console.log(this.accList);
        this.assView = true;
        this.areDetailsVisible = false;
        this.showMainPage = false;
        this.showAss = false;
        
    }

    callRowAction( event ) {  
        var button = event.detail.action.name;
       if(button == 'Apply'){
        debugger;
       //this.assView = false;
        const recId =  event.detail.row.Id;  
        this.assId = recId;
        this.assView = false;
        this.isCreatingApp = true;
       }else{
        debugger;
        const recId =  event.detail.row.Id;  
        this.assId = recId;
        getDocsForAss({ assID:recId})
        .then(result => {
            this.JobDescId = result.jobDescId;
            this.ResStratId = result.ResstrtgyId
            this.EmpPrfId = result.intQueId;
            this.ExecSummId = result.execSumId;
        });
       // this.isModalDocsViewOpen = true;
        this.modalWithAssDocs = true;
       }
        
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalDocsOpen = false;
        this.modalWithAssDocs = false;
    }
    
    closeiframe() {
        this.showSelfAssTemp = false;
    }

    handleSuccessApp(event) {
        debugger;
        this.appId = event.detail.id;
        this.isCreatingApp = false;
        this.isModalDocsOpen = true;
        swal("Congrats", "Application Has Been Created sucessfully", "success");
        confetti({
            particleCount: 100,
            spread: 70,
            origin: {
              y: 0.6
            }
          });
        //alert(event.detail.id);
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        debugger;
        this.selectedAppId;
        if(event.target.name == 'selfAssUploader'){
            event.detail.files[0].name = 'Self Assesment.pdf';
        } else{
            event.detail.files[0].name = 'One Pager.pdf';
        }           
        const uploadedFiles = event.detail.files;

        swal("Congrats", event.detail.files[0].name+" Succesfully Uploaded", "success");
        /*this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Files uploaded Successfully: ' + event.detail.files[0].name,
                variant: 'success',
            }),
        );*/
    }

    openSelfAss(){
        debugger;
        this.isSelfAssOpen = true;
        this.assId;
        SelfAssesmentValues({ mandateRecId:this.assId})
        .then(result => {
            this.selfasslist = result;
            console.log('hi::'+result);
            // this.error = undefined;
        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
    }

    submitApp(){
        this.isModalOpen = false;
        this.isSelfAssOpen = false;
       
        swal("Congrats", " Your Have Succesfully Applied for the Assignment!! ", "success");
        confetti({
            particleCount: 100,
            spread: 70,
            origin: {
              y: 0.6
            }
          });
       
      /*  this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Your Have Succesfully Applied for the Assignment!!',
                variant: 'success',
            }),
        ) */
    }

    updateResponseSelf(event){
        debugger;
        let tempAllRecords = Object.assign([], this.selfasslist);
        let tempRec = Object.assign({}, tempAllRecords[event.target.name]);
        tempRec.Response__c = event.target.value;
        tempRec.Related_Assignment__c = this.appId;
        tempAllRecords[event.target.name] = tempRec;
        this.selfasslist = tempAllRecords;
    }

    updateResponseOne(event){
        debugger;
        let tempAllRecords = Object.assign([], this.onePagerlist);
        let tempRec = Object.assign({}, tempAllRecords[event.target.name]);
        tempRec.Response__c = event.target.value;
        tempRec.Related_Assignment__c = this.appId;
        tempAllRecords[event.target.name] = tempRec;
        this.onePagerlist = tempAllRecords;
    }

    closeselfAss() {
        this.isSelfAssOpen = false;
    }

    submitSar(){
        debugger;
        let selfAssData = this.selfasslist;
        SelfAssesmentResCreation({ selfAssRes:selfAssData})
        .then(result => {
            swal("Congrats", "Your Self Assesment Has Been Submitted Succesfully!!", "success");
            
            /*this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Your Self Assesment Has Been Submitted Succesfully!!',
                    variant: 'success',
                }),
            );*/
         });
         this.isSelfAssOpen = false;
         this.isCreatingOP = true;
    }

    submitOP(){
        debugger;
        let onePagerData = this.onePagerlist;
        OnePagerResCreation({ onePagerRes:onePagerData})
        .then(result => {
           
            swal("Congrats", "Your One Pager Has Been Submitted Succesfully!!", "success");   
            /*this.dispatchEvent( 
            new ShowToastEvent({
                    title: 'Success',
                    message: 'You One Pager Has Been Submitted Succesfully!!',
                    variant: 'success',
                }),
            );*/
         });
         this.showDataOfNewCon();
         this.showWarning = false;
         this.showTable = true;
         this.isSelfAssOpen = false;
         this.isCreatingOP = false;
         this.areAppsAvailable = true;
         this.showSpinner = false;
    }
}