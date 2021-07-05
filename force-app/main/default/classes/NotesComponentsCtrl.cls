public class NotesComponentsCtrl {
    
    public string contactId {get;set;}
   
    public list<Note> noteList{get
        
    {
        if(noteList==null)
        {
            noteList = [select id,Title,Body,ParentId,LastModifiedDate,CreatedBy.Name from Note where parentId =: contactId];
        }
        
        return noteList;
    }     
        
        
      set;}
     

}