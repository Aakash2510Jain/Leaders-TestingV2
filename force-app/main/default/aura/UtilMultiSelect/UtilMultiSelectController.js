({

    init: function(component, event, helper) {
		debugger;
        var values = helper.getSelectedValues(component);

        helper.setInfoText(component, values);
        
        var allOptions= component.get("v.options_");
        var options_=[];
        for(var i=0;i<allOptions.length;i++){
            options_.push({'Name':allOptions[i]});
        }
        component.set("v.options_",options_);

    },

 

    handleClick: function(component, event, helper) {

        var mainDiv = component.find('main-div');

        $A.util.addClass(mainDiv, 'slds-is-open');

    },

 

    handleSelection: function(component, event, helper) {

        var item = event.currentTarget;
        console.log("item==>"+item);
        if (item && item.dataset) {

            var value = item.dataset.value;
		    console.log("value==>"+value);
            var selected = item.dataset.selected;
		    console.log("selected==>"+selected);
            var options = component.get("v.options_");
            console.log("options==>"+options);
 

            //contro(ctrl) key ADDS to the list (unless clicking on a previously selected item)

            //also, ctrl key does not close the dropdown (uses mouse out to do that)

            if (event.ctrlKey) {

                options.forEach(function(element) {

 

                    if (element.Name === value) {

                        element.selected = selected === "true" ? false : true;

                    }

                });

            } else {

                options.forEach(function(element) {

                    if (element.Name === value) {

                        element.selected = selected === "true" ? false : true;

                    } else {

                        element.selected = false;

                    }

                });

                var mainDiv = component.find('main-div');

                $A.util.removeClass(mainDiv, 'slds-is-open');

            }

            component.set("v.options_", options);

 

            var values = helper.getSelectedValues(component);

            var labels = helper.getSelectedLabels(component);

 

            helper.setInfoText(component, labels);

            helper.despatchSelectChangeEvent(component, values);
			component.set("v.selectedItems",values);
 

        }
		var cmpTarget = component.find('wfsSurvey.Top_1_to_3_Categories__c');
        $A.util.removeClass(cmpTarget, 'displayNone');

    },

 

    handleMouseLeave: function(component, event, helper) {

        component.set("v.dropdownOver", false);

        var mainDiv = component.find('main-div');

        $A.util.removeClass(mainDiv, 'slds-is-open');

    },

 

    handleMouseEnter: function(component, event, helper) {

        component.set("v.dropdownOver", true);

    },

 

    handleMouseOutButton: function(component, event, helper) {

        window.setTimeout(

            $A.getCallback(function() {

                if (component.isValid()) {

                    //if dropdown over, user has hovered over the dropdown, so don't close.

                    if (component.get("v.dropdownOver")) {

                        return;

                    }

                    var mainDiv = component.find('main-div');

                    $A.util.removeClass(mainDiv, 'slds-is-open');

                }

            }), 200

        );

    }

})