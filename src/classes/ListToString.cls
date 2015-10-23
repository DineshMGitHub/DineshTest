public class ListToString {

    public String sessionID { get; set; }
public String listInString{get; set;}
//public String sessionID(get; set;)
    public ListToString(){
        List<Contact> contactList = [select ID from Contact];
        //listInString = String.valueOf(contactList);
        Map<ID,Set<ID>> trialMap = new Map<ID,Set<ID>>();
        trialMap.put(null, null);
        //system.debug(trialMap.values());
        for(string s : trialMap.keySet()){
            
        }
        system.debug('contactList : '+contactList);
        listInString = String.valueOf(Limits.getLimitFutureCalls());
        
        sessionID = UserInfo.getSessionId();

    }
    
    public static Integer GetNumFutureCallsInLast24Hours() {
        return [select count() from AsyncApexJob where CreatedDate >= :Datetime.now().addHours(-24) and JobType = 'Future'];
    }
}