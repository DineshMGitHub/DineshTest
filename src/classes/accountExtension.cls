public with sharing class accountExtension {
    public Map<string,Account> accountMap{get;set;}
    public string message{get;set;}

    public accountExtension(ApexPages.StandardController controller) 
    {
        accountMap = new Map<string,Account>([SELECT ID,NAME FROM Account]); 

        if(accountMap.size() < 0)
        {
            message='Map is empty';
            
        }
        else
        {
            message='Map is Not empty';
        }

    }
    public accountExtension(){
         accountMap = new Map<string,Account>([SELECT ID,NAME FROM Account]); 

        if(accountMap.size() < 0)
        {
            message='Map is empty';
            
        }
        else
        {
            message='Map is Not empty';
        }
    }
    
    string uName;
    
    public PageReference setUserName(){
        uName= UserInfo.getName();        
        return null;
    }
    
    public string getUsername(){
        return uName;
    }
    //Action poller
    Integer count=0;
    public PageReference IncreamentCount(){
        count++;
        return null;
    }
    
    public Integer getCount(){
        return count;
    }
}