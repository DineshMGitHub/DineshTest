global class ActivatePollingBatchClass implements Database.Batchable<sObject>, Database.Stateful{
    private Question__c question;
    global Database.QueryLocator start(Database.BatchableContext bc){
    
        return database.getQuerylocator('SELECT ID,ACTIVE__C FROM QUESTION__C WHERE ACTIVE__C=:TRUE');
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        
            List<Question__c> activatedQuestionList = (List<Question__c>)scope;     
            for(Question__c activatedQuestion : activatedQuestionList){
                activatedQuestion .ACTIVE__C=False;        
            }                    
            update activatedQuestionList;  
            
            question = [SELECT ID,ACTIVE__C FROM QUESTION__C WHERE SCHEDULE_QUESTION__C=: datetime.now().Date()];        
            question.ACTIVE__C=True;        
            update question;  
    }
    
    global void finish(Database.BatchableContext bc){
            
    
    }

}