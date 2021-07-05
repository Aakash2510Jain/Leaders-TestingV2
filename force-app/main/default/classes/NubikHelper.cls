public with sharing class NubikHelper {

    /* 
      * @author Karyn Cuenca
      * @date 09/18/2014
      * @description This method loads html for edit page and generates string representation of field ids
      * @param String obj - API Name of object labels to get
      * @return Map<String, String> - Map of fields to their respective field Ids.
      */
     public static Map<String, String> getFieldsForObject(String obj){  
          //Objects  
          PageReference p = null;  
          List<SObjectField> objFields = null;  
            
          //get describe instance for object  
          Schema.DescribeSObjectResult[] results = Schema.describeSObjects(new String[]{obj});  
          Schema.DescribeSObjectResult r = results[0];  
            
          //Determine the fields and html content from describe object  
          objFields = r.getSObjectType().getDescribe().fields.getMap().values();  
          p = new PageReference('/' + r.getSObjectType().getDescribe().getKeyPrefix() + '/e?nooverride=1');  
          String html = (!Test.isRunningTest()) ? p.getContent().toString() : '<label for=\'test\'></label><input type=\'text\' id=\'test\' name=\'test\'/>';  
            
          Map<String, String> labelToId = new Map<String, String>();  
          Matcher m = Pattern.compile('<label for="(.*?)">(<span class="requiredMark">\\*</span>)?(.*?)</label>').matcher(html);  
          while (m.find()) {  
               String label = m.group(3);  
               
               if (label.contains('</span>')){
               		String[] parts = label.split('</span>');
               		if(parts.size()>0){
               			label = parts[1];
               		}              		
               }
               String id = m.group(1);  
               labelToId.put(label, id);  
          }  
          
                      
          Map<String, String> params = new Map<String, String>();  
          for (SObjectField field : objFields) {  
               DescribeFieldResult f = field.getDescribe();  
               String label = f.getLabel(); 
               if (labelToId.containsKey(label)) {  
                    params.put(f.getName().toLowerCase(), labelToId.get(label));  
               }  
          }
          system.debug(':: params :: '+params);  
          return params;  
     }
     
     
     static public boolean validateId(String Idparam) {
        
            boolean validId = false;
            
            String id = String.escapeSingleQuotes(Idparam);
            
            if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
                
                validId = true;
            }
            
            return validId;
        
     }

}