public with sharing class ManageQuestions {
    public List<Question__c> questions{get; set;}
    
    public ManageQuestions(){
        questions = [SELECT QUESTION__C, TYPE__C, Schedule_Question__c, ACTIVE__C, ID FROM QUESTION__C];
    }
}