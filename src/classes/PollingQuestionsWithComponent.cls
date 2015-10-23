public with sharing class PollingQuestionsWithComponent {
    public Question__c question{get; set;}  
    public PollingQuestionsWithComponent(){
        List<Question__c> questionList = [SELECT ID,QUESTION__C,TYPE__C,(SELECT ID,ANSWER__C,ANSWER_STATUS__C FROM ANSWERS__r) FROM QUESTION__C WHERE ACTIVE__C=:True];          
        question= questionList[0];
    }    
}