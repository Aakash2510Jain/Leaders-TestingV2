({
    init: function (cmp, event, helper)
    {
        debugger;
        var getData = cmp.get("c.getMandatesRelatedAssignment");
        getData.setParams({
            "mandateId" : cmp.get("v.recordId")  
        });
        var pageSize = cmp.get("v.pageSize");
        getData.setCallback(this, function(response){
            
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set("v.application", response.getReturnValue());
                cmp.set("v.totalSize", cmp.get("v.application").length);
                cmp.set("v.end",pageSize-1);
                var paginationList = [];
                
                for(var i=0; i< pageSize; i++)
                    
                {
                    
                    paginationList.push(response.getReturnValue()[i]);
                    
                }
                
                cmp.set("v.paginationList", paginationList);
            }
        });
        $A.enqueueAction(getData);
    },
    
    next : function(component, event, helper)
    {
        debugger;
        var applist = component.get("v.application");
        
        var end = component.get("v.end");
        
        var start = component.get("v.start");
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        var counter = 0;
        
        for(var i=end+1; i<end+pageSize+1; i++)
            
        {
            
            if(applist.length > end)
                
            {
                
                paginationList.push(applist[i]);
                
                counter ++ ;
                
            }
            
        }
        
        start = start + counter;
        
        end = end + counter;
        
        component.set("v.start",start);
        
        component.set("v.end",end);
        
        component.set("v.paginationList", paginationList);
        
    },
    
    previous : function(component, event, helper)
    
    {debugger;
     
     var applist = component.get("v.application");
     
     var end = component.get("v.end");
     
     var start = component.get("v.start");
     
     var pageSize = component.get("v.pageSize");
     
     var paginationList = [];
     
     var counter = 0;
     
     for(var i= start-pageSize; i < start ; i++)
         
     {
         
         if(i > -1)
             
         {
             
             paginationList.push(applist[i]);
             
             counter ++;
             
         }
         
         else {
             
             start++;
             
         }
         
     }
     
     start = (start)-(counter);
     
     end = (end)-(counter);
     
     component.set("v.start",start);
     
     component.set("v.end",end);
     
     component.set("v.paginationList", paginationList);
     
    },
    first : function(component, event, helper)
    
    { debugger;
        
        var applist = component.get("v.application");
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        for(var i=0; i< pageSize; i++)
            
        {
            
            paginationList.push(applist[i]);
            
        }
        
        component.set("v.paginationList", paginationList);
        component.set("v.start", 0);
        component.set("v.end", 9);
    },
    
    last : function(component, event, helper)
    
    {
        debugger;
        
        var applist = component.get("v.application");
        
        var pageSize = component.get("v.pageSize");
        
        var totalSize = component.get("v.totalSize");
        
        var paginationList = [];
        
        for(var i=totalSize-pageSize+1; i< totalSize; i++)
            
        {
            
            paginationList.push(applist[i]);
            
        }
        
        component.set("v.paginationList", paginationList);
        component.set("v.start", totalSize-pageSize+1);
        component.set("v.end", totalSize+1);
        
    },
    
    
})