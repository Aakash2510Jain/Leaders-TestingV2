({
	init: function (cmp, event, helper)
    {
        debugger;
        cmp.set("v.checkSpinner", true);
        var getQuestionsData = cmp.get("c.getAllTestQuestions");
        getQuestionsData.setParams({
            "applicationTestAssociationId" : cmp.get("v.recordId")
        });
        getQuestionsData.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.quesAnswerWrapper", response.getReturnValue());
                cmp.set("v.checkSpinner", false);
            }
        });
        $A.enqueueAction(getQuestionsData);
    },
    handleAnswer : function (cmp, event, helper)
    {
        debugger;
         cmp.set("v.checkSpinner", true);
        var dataForApex = cmp.get("v.quesAnswerWrapper"); 
        var insertApplicationTestResponse = cmp.get("c.insertResponse");
        insertApplicationTestResponse.setParams({
            "responseListToBeInserted" : JSON.stringify(dataForApex)
        });
        insertApplicationTestResponse.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                alert("Success");
                 for (var i = 0; i < dataForApex.length; i++) {
                  dataForApex[i].studentResult = response.getReturnValue()[i];        
                }
                cmp.set("v.quesAnswerWrapper",dataForApex);
                cmp.set("v.checkSpinner", false);
            }
        });
        $A.enqueueAction(insertApplicationTestResponse);
    },
})