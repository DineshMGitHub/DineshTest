public with sharing class demoLeadController {
    public string lastName{
        get;set;
    }
    public string company{
        get;set;
    }
    public string leadStatus{
        get;set;
    }
    public demoLeadController (){
    
    }
    public PageReference saveForm(){
    
        Lead leadObject = new Lead();
        leadObject.LastName= lastName;
        leadObject.Company= company;
        leadObject.Status= leadStatus;       
       
        insert leadObject;
        PageReference pr = new PageReference('/'+leadObject .id);
        pr.setRedirect(true);
        return pr;
        
    }
}