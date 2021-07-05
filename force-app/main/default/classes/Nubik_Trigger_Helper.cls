public  class Nubik_Trigger_Helper {

  private static Nubik_Trigger_Helper instance;
  private Map<Id,set<string>> m_ProcessPerName = new Map<Id,set<string>>();

  public static Nubik_Trigger_Helper getInstance()
  {
    if(instance==null)
    {
      instance= new Nubik_Trigger_Helper();
    }
    return instance;
  }
  private Nubik_Trigger_Helper()
  {
    
  }
  public boolean DidProcessRan(string processName, Id parentObject)
  {
    boolean retVal = false;
    if(m_ProcessPerName.containsKey(parentObject))
    {
      if(m_ProcessPerName.get(parentObject).contains(processName))
      {
        retVal= true;
      }
    }
    return retVal;
  }
  public void AddProcessRun(string processName, Id parentObject)
  {
    if(!m_ProcessPerName.containsKey(parentObject))
    {
      m_ProcessPerName.put(parentObject,new set<string>());
    }
    m_ProcessPerName.get(parentObject).add(processName);
  }

}