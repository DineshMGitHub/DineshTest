trigger ResetPollingQuestionActiveStatus  on Question__c (before insert, before update) 
{
    List<Question__c> questionsToUpdate =  new List<Question__c>();
    
    for(Question__c question : Trigger.New)
    {
        if(question.SCHEDULE_QUESTION__C == Date.Today() && question.Active__c)
        {
            question.Active__c = True;
            inActivePreviousQuestion();
        }     
        //if(!CheckExecutedStatus.getIsExecuted())
        //{
            update questionsToUpdate;  
            //CheckExecutedStatus.setIsExecuted(true);
        //}        
    }
    public void inActivePreviousQuestion()
    {     
        for(Question__c q: [SELECT ACTIVE__C,ID FROM QUESTION__C WHERE ACTIVE__C=:True and SCHEDULE_QUESTION__C < TODAY])
        {
            q.ACTIVE__C = False;
            questionsToUpdate.add(q);
        }             
    }
}