@isTest 
private class HelloWorldTestClass {
    static testMethod void accountExtension() {
        List<Account> newAccounts = new List<Account>();
        for(integer i=0; i< 500; i++){
            newAccounts.add(new Account(Name = 'Demo'));
        }
        insert newAccounts;
        
        accountExtension ae = new accountExtension ();
        ae.setUserName();
        ae.IncreamentCount();
        ae.getCount();  
        for(Account newAccount : ae.accountMap.values()){
            System.assertEquals(ae.getUsername(),newAccount.Name);
        }    
        
          
    }
}