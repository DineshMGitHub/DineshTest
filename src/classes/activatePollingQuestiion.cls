global class activatePollingQuestiion implements Schedulable{
    private List<Question__c> activatedQuestionList;
    private Question__c question;
    global void execute(SchedulableContext SC) {
        try{
            clearActivatedStatus();
            activeTodayQuestion();           
            
        }catch(Exception e){
            system.debug(e);
        }        
    }
    
    private void clearActivatedStatus(){
        activatedQuestionList = new List<Question__c>();
        activatedQuestionList = [SELECT ID,ACTIVE__C FROM QUESTION__C WHERE ACTIVE__C=:TRUE];
        for(Question__c activatedQuestion : activatedQuestionList){
            activatedQuestion .ACTIVE__C=False;
        }            
        update activatedQuestionList;
    }
    
    private void activeTodayQuestion(){
        question = [SELECT ID,ACTIVE__C FROM QUESTION__C WHERE Active__c= :True AND SCHEDULE_QUESTION__C <=: datetime.now().Date() ORDER BY SCHEDULE_QUESTION__C DESC Limit 1];
        question.ACTIVE__C=True;
        update question;
    }
}