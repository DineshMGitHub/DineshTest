public class ContactTriggerHandler{
    static Map<String, Integer> accountCountMap = new Map<String, Integer>();
    
    public static void afterInsert(List<Contact> insertedContacts){
        List<String> accountIds = new List<String>();
        List<Account> accounts= new List<Account>();
        
        // Get account information from contact records
        for(Contact currentContact : [Select ID, Account.ID, Account.hellooo__Contact_Count__c FROM Contact WHERE ID IN: insertedContacts]){
            // Seperate out Account having null OR zero count
            if(currentContact.Account.hellooo__Contact_Count__c == null || currentContact.Account.hellooo__Contact_Count__c <= 0){
                accountIds.add(currentContact.Account.ID);
            
            // Increament count for acount having nn zero count
            }else{
                Integer count = (Integer)currentContact.Account.hellooo__Contact_Count__c;
                count ++;
                accounts.add(new Account(ID = currentContact.Account.ID, hellooo__Contact_Count__c = count));
            }
        }
        
        // Refresh Count of contact on Account with proper value
        if(accountIds.size() > 0){
            accounts.addAll(loadInitalCount(accountIds));
        }
        
        update accounts;        
    }
    
    public static void afterUpdate(List<Contact> updatedContacts){
        List<String> accountIds = new List<String>();
        List<Account> accounts= new List<Account>();
        
        // Get account information from contact records
        for(Contact currentContact : [Select ID, Account.ID, Account.hellooo__Contact_Count__c FROM Contact WHERE ID IN: updatedContacts AND (Account.hellooo__Contact_Count__c = null OR Account.hellooo__Contact_Count__c = 0)]){
            // Seperate out Account having null OR zero count
            if(currentContact.Account.hellooo__Contact_Count__c == null || currentContact.Account.hellooo__Contact_Count__c <= 0){
                accountIds.add(currentContact.Account.ID);
            }
        }
        
        // Refresh Count of contact on Account with proper value
        if(accountIds.size() > 0){
            accounts.addAll(loadInitalCount(accountIds));
        }
        
        update accounts; 
    }
    
    public static void afterdelete(List<Contact> deletedContacts){
        List<String> accountIds = new List<String>();
        List<Account> accounts= new List<Account>();
        
        // Get account information from contact records
        for(Contact currentContact : [Select ID, Account.ID, Account.hellooo__Contact_Count__c FROM Contact WHERE ID IN: deletedContacts]){
            // Seperate out Account having null OR zero count
            if(currentContact.Account.hellooo__Contact_Count__c == null || currentContact.Account.hellooo__Contact_Count__c <= 0){
                accountIds.add(currentContact.Account.ID);
            
            // Decrement count for acount having non zero count
            }else{
                Integer count = (Integer)currentContact.Account.hellooo__Contact_Count__c;
                count --;
                accounts.add(new Account(ID = currentContact.Account.ID, hellooo__Contact_Count__c = count));
            }
        }
        
        // Refresh Count of contact on Account with proper value
        if(accountIds.size() > 0){
            accounts.addAll(loadInitalCount(accountIds));
        }
        
        update accounts;
    }
    
    private static List<Account> loadInitalCount(List<String> accountIds){
        List<Account> accounts = new List<Account>();
        
        for(Account currentAccount : [SELECT ID, hellooo__Contact_Count__c , (SELECT ID FROM Contacts) FROM Account WHERE ID IN: accountIds]){
            if(currentAccount.Contacts != null){
                currentAccount.hellooo__Contact_Count__c = currentAccount.Contacts.size();
                accounts.add(currentAccount);
                accountCountMap.put(currentAccount.ID, currentAccount.Contacts.size());
            }else{
                accountCountMap.put(currentAccount.ID, 0);
                accounts.add(currentAccount);
            }
        }
        
        return accounts;
    }
}