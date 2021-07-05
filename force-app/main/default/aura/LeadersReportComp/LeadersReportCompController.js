({
    myAction : function(component, event, helper) {},
    
    doInit : function(component,event,helper){
        debugger;
        component.set("v.spinner", true); 
        debugger;
        helper.getPartnerName(component,event,helper);
        
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.param1;
            debugger;
            console.log(param1);
        }        
        var testMId = component.get("v.mandateRecId");
        var abc = component.get("v.recordId");
        
        console.log('recorid is:'+abc);
        
        console.log('mandate id :'+testMId);
        
        var potentialcan  = component.get("v.potentialCandidateIds");
        
        console.log('pot cand are :' +potentialcan);
        
        var testSelC = component.get("v.selectedCount");
        console.log(testSelC);
        
        var Selcan = component.get("v.selectedcandidateIds");
        console.log(Selcan);
        helper.getcandidatesData(component,event,helper);
        helper.getCandidatesByNameandId(component,event,helper);
        
        var testcanData = component.get("v.candidatesData");
        console.log(testcanData);
        
        var testcanData1 = component.get("v.candidateNameMapById");
        console.log(testcanData1); 
        
        component.set("v.wrapperData",{candidateByStatus:false,
                                       allCompitencies:false,
                                       Candidatetodiscuss:false,
                                       candidateByStatusTitle:'',
                                       candidateByStatusNotes:'',
                                       allCompitenciesTitle:'',
                                       allCompitenciesNotes:'',
                                       CandidatetodiscussTitle:'',
                                       CandidatetodiscussNotes:'',
                                       
                                      });
        
        helper.getDates(component,event,helper);
    },
    
    handleSectionToggle: function (component, event) {
        var openSections = event.getParam('openSections');
    },
    
    closeModel : function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayLeadersReportModal",false);
        
    },
    handleChangeReportType: function (component, event) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.reportType",selectedOptionValue);
    },
    
    selectCoverPage : function(component,event,helper){
        var valCoverPage = event.getSource().get("v.value");
        component.set("v.coverPage",valCoverPage);
    },
    
    selectCanCoverPage : function(component,event,helper){
        var valCanCoverPage = event.getSource().get("v.value");
        component.set("v.candidateCoverPage", valCanCoverPage);      
    },
    
    handleChangeModule : function(component,event,helper){
        var selectedOptionValue = event.getParam("value");
        component.set("v.module", selectedOptionValue);
    },
    
    selectNextDate : function (component,event,helper){
        var selectND = component.find("NDate");
        
        component.set("v.nextFollowupDate",selectND);
    },
   
    selectJobDescription : function(component,event,helper){
        var valJD = event.getSource().get("v.value");
        component.set("v.jobDescription", valJD);
        
    },
    selectCandidatestoDiscussByTeam : function(component,event,helper){
        debugger;
        var valRS = event.getSource().get("v.value");
        component.set("v.candidatestoDiscussByTeam", valRS);
    },
     selectToDiscuss : function(component,event,helper){
        debugger;
        var valRS = event.getSource().get("v.value");
        component.set("v.selectToDiscuss", valRS);
    },
    selectResearchStrategy : function(component,event,helper){
        var valRS = event.getSource().get("v.value");
        component.set("v.researchStrategy", valRS);
    },
    selectExecutiveSummary : function(component,event,helper){
        var valES = event.getSource().get("v.value");
        component.set("v.executiveSummary", valES);
    },
    selectExecutiveSummary_1 : function(component,event,helper){
        debugger;
        var valES_1 = event.getSource().get("v.value");
        component.set("v.executiveSummary_1", valES_1);
    },
    selectCandidatestoDiscuss : function(component,event,helper){
        var valCantoDis = event.getSource().get("v.value");
        component.set("v.candidatestoDiscuss",valCantoDis);
    },
    
    selectBiography : function(component,event,helper){
        var valBio = event.getSource().get("v.value");
        component.set("v.biography",valBio); 
        
    },
    selectAgenda : function(component,event,helper){
        var agenda = event.getSource().get("v.value");
        component.set("v.SelAgenda",agenda); 
        
    },
    
    selectCV : function(component,event,helper){
        var valCV = event.getSource().get("v.value");
        component.set("v.CV",valCV);
    },
    
    selectOnePager : function(component,event,helper){
        var valOP = event.getSource().get("v.value");
        component.set("v.onePager",valOP);
        
    },
    
    selectPsyTest : function(component,event,helper){
        var valPsyTest = event.getSource().get("v.value");
        component.set("v.PsyTest",valPsyTest);
    },
    selectCandidateIntro : function(component,event,helper){
        var valCanIntro = event.getSource().get("v.value");
        component.set("v.CandIntr",valCanIntro);
    },
    selectSelfAss : function(component,event,helper){
        var selfAss = event.getSource().get("v.value");
        component.set("v.SelfAss",selfAss);
    },
    selectReferences : function(component,event,helper){
        debugger;
        var Reference = event.getSource().get("v.value");
        component.set("v.selectRef",Reference);
    },
    selectRadar : function(component,event,helper){
        var RadGraph = event.getSource().get("v.value");
        component.set("v.RadarGraph",RadGraph);
    },
    selectCompetency: function(component,event,helper){
        debugger;
        var selectedcomp = [];
        var boolean = event.getSource().get("v.value");
        if(boolean == true){
            var comp = event.getSource().get("v.label");
            selectedcomp = component.get("v.selectedComp");
            selectedcomp.push(comp);
        }else{
            selectedcomp = component.get("v.selectedComp");   
            var comp = event.getSource().get("v.label");
            if(selectedcomp.includes(comp))
            {
                const index = selectedcomp.indexOf(comp);
                selectedcomp.splice(index, 1);
            }
        }
        component.set("v.selectedComp",selectedcomp);
    },
    selectSubCompetency: function(component,event,helper){
        debugger;
        var selectedsubcomp = [];
        var boolean = event.getSource().get("v.value");
        if(boolean == true){
            selectedsubcomp = component.get("v.selectedsubComp");
            var comp = event.getSource().get("v.label");
            
            selectedsubcomp.push(comp);
        }else{
            selectedsubcomp = component.get("v.selectedsubComp");   
            var comp = event.getSource().get("v.label");
            if(selectedsubcomp.includes(comp))
            {
                const index = selectedsubcomp.indexOf(comp);
                selectedsubcomp.splice(index, 1);
            }
        }
        component.set("v.selectedsubComp",selectedsubcomp);
    },
    
    selectInterviewQuestionnaire : function(component,event,helper){
        
        var valIQ= event.getSource().get("v.value");
        component.set("v.InterviewQuestionnaire", valIQ);
    },
    selectBoardCV : function(component,event,helper){
        var valIQ= event.getSource().get("v.value");
        component.set("v.BoardCv", valIQ);
    },
    selectOnboarding : function(component,event,helper){
        var valIQ= event.getSource().get("v.value");
        component.set("v.OnBoarding", valIQ);
    },
    
    selectHumanCapitalStudy : function(component,event,helper){
        debugger;
        var val = component.get("v.selectHumanCapitalStudy");
        var valHCS = event.getSource().get("v.value");
        component.set("v.hcs", valHCS);
    },
    
    selectPartnerList : function(component,event,helper){
        var valPartner = event.getSource().get("v.value");
        component.set("v.partner", valPartner);
    },
    
    handleChangeHCS : function(component,event,helper){
        var selectedOptionValue = event.getParam("value");
        component.set("v.hcsSortBy", selectedOptionValue); 
    },
    
    generate : function(component,event,helper){
        helper.generateReport(component,event,helper);
    },
    updatePartner: function(component,event,helper){
        helper.UpdatePartner(component,event,helper);
    }
})