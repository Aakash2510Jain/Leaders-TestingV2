({
	 addRecord: function(component, event) {
        debugger;
        var role = component.get("v.role");
         
        if(role == 'experienceList'){
			var recordList = component.get("v.experienceList");    
            
            recordList.push({"record":{
            Add_company_description__c: false,
            Company_Name_French__c: "",
            Company_Name__c: "",
            Company__c: "",
            Contact__c: "",
            Current_del__c: false,
            End_Year__c: "",
            Id: "",
            Location__c: "",
            Name: "",
            Start_Year__c: "",
            Title_FR__c: "",
            Title__c: "",
            Verified__c: false,
            RecordTypeId:component.get("v.recordTypeIds")
            },"lookupObj":{}});            
            component.set("v.experienceList", recordList);
        }else if(role == 'educationList'){
            var recordList = component.get("v.educationList");    
            
            recordList.push({"record":{
            'sobjectType': 'Work_Experience__c',
            'Company__c': '',
            'Title__c': '',
            'Title_FR__c': '',
            'Start_Year__c': '',
            'End_Year__c': '',
            'Current_del__c': '',
                'RecordTypeId':component.get("v.recordTypeIds")
            },"lookupObj":{}}); 
            component.set("v.educationList", recordList);
              
        }else if(role == 'professionalList'){
            var recordList = component.get("v.professionalList");    
            
            recordList.push({"record":{
            'sobjectType': 'Work_Experience__c',
            'Company__c': '',
            'Title__c': '',
            'Title_FR__c': '',
            'Start_Year__c': '',
            'End_Year__c': '',
            'Current_del__c': '',
                'RecordTypeId':component.get("v.recordTypeIds")
            },"lookupObj":{}}); 
            component.set("v.professionalList", recordList);
        }else if(role == 'boardList'){
            var recordList = component.get("v.boardList");    
            
            recordList.push({"record":{
            'sobjectType': 'Work_Experience__c',
            'Company__c': '',
            'Title__c': '',
            'Title_FR__c': '',
            'Start_Year__c': '',
            'End_Year__c': '',
            'Current_del__c': '',
                'RecordTypeId':component.get("v.recordTypeIds")
            },"lookupObj":{}}); 
            component.set("v.boardList", recordList);
            var boardList= component.get("v.boardList"); 
            debugger;
        }else if(role == 'commentList'){
            var AddcmntList = component.get("v.AddCmntList");    
            
            AddcmntList.push({"record":{
            'sobjectType': 'Work_Experience__c',
            'Biography_Comments__c':'',
                'RecordTypeId':component.get("v.recordTypeIds")}
            }); 
            component.set("v.AddCmntList", AddcmntList);
           // var boardList= component.get("v.AddCmntList"); 
            debugger;
        }
         
         
    }
})