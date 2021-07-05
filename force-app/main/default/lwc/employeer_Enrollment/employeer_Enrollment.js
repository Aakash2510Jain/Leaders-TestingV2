import { LightningElement , api ,track , wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from "lightning/platformResourceLoader";
import Email__c  from '@salesforce/schema/Account.Email__c';
import Name  from '@salesforce/schema/Account.Name';
import getCandidateList from '@salesforce/apex/AssSelectionLwcHelper.getCandidateList';
import addCandidateToAss from '@salesforce/apex/AssSelectionLwcHelper.addCandidateToAss';
import Industry_Types__c  from '@salesforce/schema/Account.Industry_Types__c';
import LinkedIn_URL__c  from '@salesforce/schema/Account.LinkedIn_URL__c';
import Location__c  from '@salesforce/schema/Account.Location__c';
import State__c  from '@salesforce/schema/Account.State__c';
import Status__c  from '@salesforce/schema/Account.Status__c';
import Type   from '@salesforce/schema/Account.Type';
import Description  from '@salesforce/schema/Account.Description';
import NameofAss  from '@salesforce/schema/Mandate__c.Name';
import Module__c  from '@salesforce/schema/Mandate__c.Module__c';
import Company__c  from '@salesforce/schema/Mandate__c.Company__c';
import Mandate_Start_Date__c  from '@salesforce/schema/Mandate__c.Mandate_Start_Date__c';
import Mandate_End_Date__c  from '@salesforce/schema/Mandate__c.Mandate_End_Date__c';
import Language__c  from '@salesforce/schema/Mandate__c.Module__c';
import Assignment_Status__c  from '@salesforce/schema/Mandate__c.Assignment_Status__c';
import Job_Function__c  from '@salesforce/schema/Mandate__c.Job_Function__c';
import Industry__c  from '@salesforce/schema/Mandate__c.Industry__c';
import Summary_Description__c  from '@salesforce/schema/Mandate__c.Summary_Description__c';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';
import getAssignmentList from '@salesforce/apex/AssSelectionLwcHelper.getAssignmentList';
//import getNewAssignmentList from '@salesforce/apex/AssSelectionLwcHelper.getNewAssignmentList';
import insertSelfAssQues from '@salesforce/apex/AssSelectionLwcHelper.insertSelfAssQues';
import insertOnePagerQues from '@salesforce/apex/AssSelectionLwcHelper.insertOnePagerQues';
import getDocsForAss from '@salesforce/apex/AssSelectionLwcHelper.getDocsForAss';
import CONFETTI from "@salesforce/resourceUrl/confetti";
import SWEETALERT from "@salesforce/resourceUrl/sweetalert";


export default class TemplateIFTrueExampleLWC extends NavigationMixin(LightningElement)  {


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
    
      
    @api recordId ;//Company-Id
    @api assId ;//Assignment-Id
    @api objectApiName = 'Account';
    @api objectName = 'Mandate__c';
    assName;
    field = [Name,Email__c,Industry_Types__c,LinkedIn_URL__c,Location__c,Status__c,Type,Description];
    assfields = [Name,Company__c,Language__c,Assignment_Status__c,Job_Function__c,Module__c,Mandate_Start_Date__c,Mandate_End_Date__c,Industry__c,Summary_Description__c];
    initalData = false;
    isCandidatesAvail = false;
    areDetailsVisible = false;
    isCreatingAss = false;
    candidateAvail = false;
    showSecondPage = true;
    existUserData = false;
    attFound = false;
    noAttFound = false;
    showSelfAssTemp = false;
    isModalDocsOpen = false;
    assView = false;
    createNewAss = false;
    isCreatingSelf = false;
    showWarning = true;
    showTable = false; 
    isModalDocsViewOpen = false;
    isShowAtt = false;
    showProgress = true;
    companyId;
    selectedAssId;
    jobDescId;
    ResstrtgyId;
    intQueId;
    execSumId;
    frameURLSelf;
    assList;
    regid;
    newassList;
    @track columns = [
        {  
            label: "Candidate Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'text',
            sortable: true
        },
        {
            label: 'Phone',
            fieldName: 'Phone',
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
            label: 'Status Summary Line',
            fieldName: 'Status_Summary_Line__c',
            type: 'text',
            sortable: true
        }
    ];
    
  

    @track columnForAss = [
        {  
            label: "Assignment Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Start Date',
            fieldName: 'Start_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: ' End Date',
            fieldName: 'End_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'TOTAL REQUIREMENT',
            fieldName: 'Total_Candidates_Required__c',
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
    @track columnForNewAss = [
        {  
            label: "Assignment Name",  
            fieldName: "recordLink",  
            type: "url",  
            sortable: true,
            typeAttributes: { label: { fieldName: "Name" }, tooltip:"Name", target: "_blank" }  
        },
        {
            label: 'Start Date',
            fieldName: 'Start_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: ' End Date',
            fieldName: 'End_Date__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'TOTAL REQUIREMENT',
            fieldName: 'Total_Candidates_Required__c',
            type: 'text',
            sortable: true
        }
    ];


    regNew() {
        this.showSecondPage = false;
        this.initalData = true;
    }

    regExisting(){
        debugger;
        this.showSecondPage = false;
        this.existUserData = true;
    }

    closeiframe() {
        this.isShowAtt = false;
    }

    handleClick(){
        debugger;
        const {base64, filename, recordId} = this.fileData
        uploadFile({ base64, filename, recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} `

            swal("Congrats", title+" Succesfully Uploaded", "success");
            /*const evt = new ShowToastEvent({
                title: 'Succesfully Uploaded',
                message: title+' has been Uploaded Succesfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);*/
        })
    }
    
    showData(){
        debugger;
        const conId = this.regid;
        getAssignmentList({ compId:conId})
        .then(result => {
              this.assList = result;

              if (result) {
                debugger;
                console.log('result'+result);
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]); //cloning object  
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.assList = tempOppList;
            }
         });
        this.existUserData =false;
        this.assView = true; 
    }

    closeModal() {
        this.isModalOpen = false;
        this.isModalDocsViewOpen = false;
    }

    openDocsModal(event){
        debugger;
        this.selectedAssId =  event.detail.row.Id;
        //this.assView = false;  
         getDocsForAss({ assID:this.selectedAssId})
        .then(result => {
            this.jobDescId = result.jobDescId;
            this.ResstrtgyId = result.ResstrtgyId; 
            this.intQueId = result.intQueId;
            this.execSumId = result.execSumId;
         });
        this.isModalDocsViewOpen = true;
        this.assView = false;
    }

    viewAtt(event){
        debugger;

        if(
            event.currentTarget.title == 'JOB'){
        if(this.jobDescId != undefined){
        this.noAttFound = false;
        this.heading = 'JOB - DESCRIPTION';//
        this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.jobDescId;
        this.attFound = true;
        }else{
            this.heading = 'JOB - DESCRIPTION';
            this.attFound = false;
            this.noAttFound = true;
            }
        }else if(
            event.currentTarget.title == 'RESEARCH'){
        if(this.ResstrtgyId != undefined){
        this.noAttFound = false;
        this.heading = 'RESEARCH-STRATEGY';
        this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.ResstrtgyId;
        this.attFound = true;
        }else{
            this.heading = 'RESEARCH-STRATEGY';
                this.attFound = false;
                this.noAttFound = true;
            }
        }
        else if(
            event.currentTarget.title == 'INTERVIEW'){
        if(this.intQueId != undefined){
        this.noAttFound = false;
        this.heading = 'EMPLOYEE - PROFILEE';
        this.frameURLSelf = 'https://leadersinternational--testingv2--c.documentforce.com/servlet/servlet.FileDownload?file='+this.intQueId;
        this.attFound = true;
        }else{
            this.heading = 'EMPLOYEE - PROFILEE';
            this.attFound = false;
            this.noAttFound = true;
               
            }
        }
        else if(
            event.currentTarget.title == 'EXECUTIVE'){
        if(this.execSumId != undefined){
        this.noAttFound = false;
        this.heading = 'EXECUTIVE-SUMMARY';
        this.frameURLSelf = 'https://leadersinternational--test--c.cs78.content.force.com/servlet/servlet.FileDownload?file='+this.execSumId;
        this.attFound = true;
        }else{
            this.heading = 'EXECUTIVE-SUMMARY';
            this.attFound = false;
            this.noAttFound = true
         }
        }
        this.isShowAtt = true;
    }

    updateRegId(event){
        debugger;
       this.regid = event.target.value;
    }

    @track error;
    @track conList ;
    @wire(getCandidateList)
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            debugger;
            var tempOppList = [];  
            for (var i = 0; i < data.length; i++) {  
             let tempRecord = Object.assign({}, data[i]); //cloning object  
             tempRecord.recordLink = "/" + tempRecord.Id;  
             tempOppList.push(tempRecord);  
            }
            this.conList = tempOppList;
        } else if (error) {
            this.error = error;
        }
    }

    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }

    
    handleclickcan(){
        debugger;
        var el = this.template.querySelector('lightning-datatable');
        console.log(el);
        var selected = el.getSelectedRows();
        console.log(selected);
        var canIds = [];  
        for (var i = 0; i < selected.length; i++) {  
            canIds.push(selected[i].Id);  
           }

        addCandidateToAss({ canIds:canIds ,assId:this.assId})
        .then(result => {
            
            const evt = new ShowToastEvent({
                title: 'Candidates Added Succesfully',
                message: 'Selected Candidate Has Been Added To the Assignment Succesfully!!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);

        })
        .catch(error => {
            this.resultsum = undefined;
            //this.error = error;
        });
    }
    
    handleSubmit(event){
        debugger;
        console.log('Account detail : ',event.detail.fields);
        console.log('Account name : ',event.detail.fields.Name); 
    }
//

    openSelfAssModel(){
    debugger;
    this.isModalDocsOpen = false;
    this.isCreatingSelf = true;
    }
    backToAssPage(){
        debugger;
        this.isModalDocsViewOpen = false;
        this.assView = true;
    }

    selectCandidates(){
        this.candidateAvail = true;
        this.isCandidatesAvail = false;
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
        let parseData = JSON.parse(JSON.stringify(this.newassList));

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
        this.newassList = parseData;

    }


    createAss(event) {
        debugger;
        this.isCreatingAss = true;
        this.assView = false;
        this.isModalDocsViewOpen = false;
        this.recordId = this.regid;
        this.showProgress = false;
    }

    attId;
    fileData
    openfileUpload(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.assId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file);
    }
    //
    openfileUploadAss(event){
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.selectedAssId 
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }

    openAssModel(){
        this.areDetailsVisible = false;
        this.isCreatingAss = true;
    }
    
    closeAss(){
        this.isCreatingAss = false;
    }
    handleSuccess(event) {
        debugger;
        this.recordId = event.detail.id;
        this.initalData = false;
        swal("Congrats", "Company Has Been Created sucessfully", "success");
        
        /*
        const evt = new ShowToastEvent({
            title: 'Succesfully Registered',
            message: 'Company Has Been Created sucessfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);*/
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.areDetailsVisible = true;
    }

    handleSuccessOfAss(event) {
        debugger;

        swal("Congrats", "Assignment Has been Created sucessfully!!", "success");
        confetti({
            particleCount: 100,
            spread: 70,
            origin: {
              y: 0.6
            }
          });
        /*const evt = new ShowToastEvent({
            title: 'Succesfully Created',
            message: 'Assignment Has been Created sucessfully',
            variant: 'success',
            mode: 'dismissable'
        });*/
        //this.dispatchEvent(evt);
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.assName  = event.detail.name;
        this.assId = event.detail.id;
        this.areDetailsVisible = false;
        this.isCreatingAss = false;
        this.initalData = false;
        this.isModalDocsOpen = true;
    }  

    keyIndex = 0;
    itemList = [{id: 0,Question: ""}];

   
    handleChange(event) {
        debugger;
        var oplist = this.itemList;
        var ind = event.target.name;
        oplist[ind].Question = event.target.value;
        this.itemList = oplist;
    }
    addRow() {
        debugger;
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
        console.log(this.itemList);
    }

    removeRow(event) {
        debugger;
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
              
            });
        }
        event.label;
    }
    
    createSelfAssQues(){
        debugger;
        this.isCreatingSelf = false;
        this.isCreatingOP = true;
        let selfAssData = this.itemList;
        var self_Ass_que = [];
        var tempOppList = [];  
        for (var i = 0; i < selfAssData.length; i++) {  
            tempOppList.push(selfAssData[i].Question);  
        }
   

        insertSelfAssQues({ Questions:tempOppList,assId:this.assId})
        .then(result => {

            swal("Congrats", "You Self Assesment Quesrions Have Been Submitted Succesfully!!", "success");
          /* this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'You Self Assesment Has Been Submitted Succesfully!!',
                    variant: 'success',
                }),
            );*/
         });

         this.itemList = [{id: 0,Question: ""}];
    }

    createOnePagerQues() {
        debugger;
        this.isCreatingOP = false;
        this.islastPager = true;
        let selfAssData = this.itemList;
        var self_Ass_que = [];
        var tempOppList = [];  
        for (var i = 0; i < selfAssData.length; i++) {  
            tempOppList.push(selfAssData[i].Question);  
        }
   

        insertOnePagerQues({ Questions:tempOppList,assId:this.assId})
        .then(result => {

            swal("Congrats", "You One Pager Questions Have Been Submitted Succesfully!!", "success");
           /*this.dispatchEvent(
 new ShowToastEvent({
                    title: 'Success',
                    message: 'You Self Assesment Has Been Submitted Succesfully!!',
                    variant: 'success',
                }),
            );*/
         });

         this.itemList = [{id: 0,Question: ""}];
    }
    showCreatedAss(){
        debugger;
        const newAssId = this.recordId;
        getAssignmentList({ compId:newAssId})
        .then(result => {
              this.newassList = result;

              if (result) {
                debugger;
                console.log('result'+result);
                var tempOppList = [];  
                for (var i = 0; i < result.length; i++) {  
                 let tempRecord = Object.assign({}, result[i]); //cloning object  
                 tempRecord.recordLink = "/" + tempRecord.Id;  
                 tempOppList.push(tempRecord);  
                }
                this.newassList = tempOppList;
                this.showTable = true;
            }
         });
        this.islastPager =false;
        this.areDetailsVisible = true; 
        this.showWarning = false;
       
    }

}