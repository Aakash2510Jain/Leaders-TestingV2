({  
    getSelfAssResponse :function(component,event,helper){
        debugger;
        component.set("v.showSpinner", true);
        console.log('recordId==>'+component.get("v.recordId"));
        var action=component.get("c.genSelfAssResp");
        action.setParams({
            "appId" : component.get("v.recordId")
        });
        var language = component.get("v.language");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selfAssResp=response.getReturnValue();
                component.set("v.self_assesment_resp",selfAssResp);
                console.log(component.get("v.self_assesment_resp"));
                component.set("v.showSpinner", false);
            }
            else{
                component.set("v.showSpinner", false);
                alert('Some Error');
            }
        });
        $A.enqueueAction(action);
    },
    getassgnname :function(component,event,helper){
        debugger;
        component.set("v.showSpinner", true);
        console.log('recordId==>'+component.get("v.recordId"));
        var action=component.get("c.GetAssignDetails");
        action.setParams({
            "appId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selfAssResp=response.getReturnValue();
                component.set("v.AssgnName",selfAssResp.rec[0].Current_Company_French__c);
                component.set("v.Assgntitle",selfAssResp.rec[0].Mandate__r.Name);
                component.set("v.language",selfAssResp.rec[0].Mandate__r.Language__c);
                component.set("v.Self_Ass_Response_length",selfAssResp.lenght_Of_self_Ass);
                component.set("v.showSpinner", false);
            }
            else{
                alert('Some Error');
            }
        });
        $A.enqueueAction(action);
    },
    update : function(component,event) {
        debugger;
        component.set("v.showSpinner", true);
        var updated_response = component.get("v.self_assesment_resp");
        
        var action=component.get("c.updateSelfAssessmentOfCandidate");
        action.setParams({
            "UpdatedResponse" : updated_response,
            "appid" : component.get("v.recordId"),
            "isSave" : component.get("v.isSave")
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                // component.set("v.checkSpinner", true);
                if(component.get("v.isSave") == false)
                {
                    Swal.fire({
                        title: "Success",
                        text: "Your self-Asseement has been sent to Leaders International",
                        type: "success",
                        timer: 3000,
                        showConfirmButton: false
                    }).then((result) => {
                        window.self.close();
                    });
                        
                    }else{
                        
                    Swal.fire({
                        title: "Success",
                        text: "Your self-Asseement has been Saved",
                        type: "success",
                        timer: 3000,
                        showConfirmButton: false
                    });
                    component.set("v.self_assesment_resp",response.getReturnValue());  
                }
                component.set("v.showSpinner", false);
            }else{
                alert("Some Error Occured");
            }
        });
        $A.enqueueAction(action);
    },
    gen_self_ass : function(component,event) {
        debugger;
        component.set("v.showSpinner", true);
        var action = component.get("c.Generate_Self_Ass");
        
        action.setParams({
            "appid" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var genid = response.getReturnValue();
                console.log('generated id'+genid);
                component.set("v.checkSpinner", false);
                
            }
            else{
                alert('Some Error');
            }
        });
        $A.enqueueAction(action);
    },
    previewSelfAssessmentHelper : function(component,event) {
        debugger;
        
        component.set("v.isOpen",true);   
    }
})