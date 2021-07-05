({
    doInit : function(component, event, helper) {
        debugger;
        var conid = component.get("v.recordId");
        var mandateRecId = component.get("v.mandateRecId");
        var action = component.get("c.get_Attach_ids");
        action.setParams({
            "mandateId" : mandateRecId,
            "condid" : conid,
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = response.getReturnValue();
                if(respObj != null)
                {
                    component.set("v.Attachemnts",respObj);
                    if(respObj.SelfAssId == null && respObj.SelfAssId == undefined){
                        component.set("v.isselfAssAvailable",true);
                    }else{
                        component.set("v.SelfAssId",respObj.SelfAssId);    
                    }
                    
                    if(respObj.CVId == null && respObj.CVId == undefined){
                        component.set("v.isCvAvailable",true);
                    }else{
                        component.set("v.CVID",respObj.CVId);    
                    }
                    
                    if(respObj.BioId == null && respObj.BioId == undefined){
                        component.set("v.isBioAvailable",true);
                    }else{
                        component.set("v.BioId",respObj.BioId);    
                    }
                    
                    if(respObj.RefId == null && respObj.RefId == undefined){
                        component.set("v.isRefAvailable",true);
                    }else{
                        component.set("v.RefId",respObj.RefId);    
                    }
                    
                    if(respObj.PsyId == null && respObj.PsyId == undefined){
                        component.set("v.isPSYAvailable",true);
                    }else{
                        component.set("v.PsyId",respObj.PsyId);   
                    }
                    
                    if(respObj.OnePagerId == null && respObj.OnePagerId == undefined){
                        component.set("v.isOPAvailable",true);
                    }else{
                        component.set("v.OpId",respObj.OnePagerId);    
                    }
                    
                    if(respObj.LetterId == null && respObj.LetterId == undefined){
                        component.set("v.isILAvailable",true);
                    }else{
                        component.set("v.ILId",respObj.LetterId);
                    }
                    
                    if(respObj.OnboardingId == null && respObj.OnboardingId == undefined){
                        component.set("v.isOnBoardAvailable",true);
                    }else{
                        component.set("v.OnBoardId",respObj.OnboardingId);  
                    }
                    
                    if(respObj.BoardCVId == null && respObj.BoardCVId == undefined){
                        component.set("v.isBoardCvAvailable",true);
                    }else{
                        component.set("v.BoardCvId",respObj.BoardCVId);  
                    }
                    component.set("v.emailBody",respObj.TemplateData);
                    component.set("v.emailSubject",respObj.TemplateSubject)
                }
            }else{
                console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
    },
    closeModal : function(component, event, helper){
        debugger;
        component.set("v.displaySendEmail",false);
    },
    closeModalSecond : function(component, event, helper){
        component.set("v.showModal",false);
    },
    selectSelfAss : function(component,event,helper){
        debugger;
        var valSelfAss = event.getSource().get("v.value");
        
        if(valSelfAss == true){
            component.set("v.SelfAss",valSelfAss);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.SelfAssId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.SelfAssId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray);    
        
        
    },
    selectRef : function(component,event,helper){
        debugger;
        var val = event.getSource().get("v.value");
        if(val == true){
            component.set("v.References",val);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.RefId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.RefId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray);    
    },
    selectPsyTest : function(component,event,helper){
        debugger;
        var valpsy = event.getSource().get("v.value");
        if(valpsy == true){
            component.set("v.PsyTest",valpsy);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.PsyId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.PsyId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray);    
        
    },
    selectIL : function(component,event,helper){
        debugger;
        var valIL = event.getSource().get("v.value");
        
        if(valIL == true){
            component.set("v.CandIntr",valIL);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.ILId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.ILId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
    },
    selectCV : function(component,event,helper){
        debugger;
        var valRS = event.getSource().get("v.value");
        
        if(valRS == true){
            component.set("v.CV",valRS);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.CVID");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.CVID");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
    },
    selectBoardCV : function(component,event,helper){
        debugger;
        var valRS = event.getSource().get("v.value");
        
        
        if(valRS == true){
            component.set("v.BoardCv",valRS);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.BoardCvId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.BoardCvId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
        
        
    },
    selectOP : function(component,event,helper){
        debugger;
        var valES = event.getSource().get("v.value");
        
        if(valES == true){
            component.set("v.onePager",valES);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.OpId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.OpId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
        
    },
    selectOnBoard : function(component,event,helper){
        debugger;
        var valES = event.getSource().get("v.value");
        
        if(valES == true){
            component.set("v.OnBoard",valES);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.OnBoardId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.OnBoardId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
    },
    selectBio : function(component,event,helper){
        debugger;
        var valES = event.getSource().get("v.value");
        
        if(valES == true){
            component.set("v.Bio",valES);
            var Att = component.get("v.SelectedAtt");
            var selAtt = component.get("v.BioId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            Attarray.push(selAtt);
        }else{
            var Att = component.get("v.SelectedAtt"); 
            var selAtt = component.get("v.BioId");
            var Attarray = [];
            Attarray = component.get("v.SelectedAtt");
            if(Attarray.includes(selAtt))
            {
                const index = Att.indexOf(selAtt);
                Attarray.splice(index, 1);
            }
        }
        component.set("v.SelectedAtt",Attarray); 
        
        
    },
    SendEmail : function(component,event,helper){
        debugger;
        var Att = component.get("v.SelectedAtt");
        var MailId = component.get("v.emailId");
        var SUbject = component.get("v.emailSubject");
        var Body = component.get("v.emailBody");
        var action = component.get("c.AddingAttachementsToEmail");
        action.setParams({
            "attachmentIds" : Att,
            "MailId" : MailId,
            "SUbject" : SUbject,
            "Body" : Body,
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                
                swal.fire({
                    title: "Success",
                    text: "Email Sent Succesfully!!",
                    type: "success",
                    timer: 3000,
                    showConfirmButton: false
                });
                component.set("v.displaySendEmail",false);
                
            }else{
                console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
    },
    navigateToRecord : function(component, event, helper){
        debugger;
        helper.hideLoader(component,event,helper);
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: event.currentTarget.getAttribute("name"),
            slideDevName: "detail"
        });
        navEvent.fire();
    },
    showLoader: function(component, event, helper) {
        helper.showLoader(component, event, helper);
    },
    hideLoader : function(component,event,helper){
        helper.hideLoader(component, event, helper);
    }    
})