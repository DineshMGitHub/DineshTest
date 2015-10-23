public with sharing class answerManagement {
    public QUESTION__C questionObject{get; set;}
    public string answer{get; set;}
    public string answerStatus{get; set;}
    private ID questionID;
    public List<Answer__c> answerObjectList{get; set;}
    
    public answerManagement (){
        try{
            if(ApexPages.currentPage().getParameters().get('questionID')!=null){
                questionID=ApexPages.currentPage().getParameters().get('questionID');
                questionObject = new QUESTION__C();
                questionObject = [SELECT QUESTION__C,TYPE__C,ACTIVE__C,SCHEDULE_QUESTION__C FROM QUESTION__C WHERE ID=:questionID];
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Didn\'t find Question');
                ApexPages.addMessage(myMsg);
            }   
        
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Didn\'t find Question'+e);
            ApexPages.addMessage(myMsg);
        }
        
        answerObjectList = getAvailableAnswer();   
    }
    
    public void saveAnswer(){
        try{           
            insertNewAnswer();
            answerObjectList = getAvailableAnswer(); 
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error:'+e);
            ApexPages.addMessage(myMsg);
        }        
    }
    
    private List<Answer__c> getAvailableAnswer(){
        return [SELECT ANSWER__C,ANSWER_STATUS__C FROM Answer__c WHERE QUESTION__C=:questionID];
    }
    
    private void insertNewAnswer(){
         Answer__c newAnswer = new Answer__c();
            newAnswer.ANSWER__C=answer;
            newAnswer.ANSWER_STATUS__C=answerStatus;
            newAnswer.QUESTION__C=questionID;
            insert newAnswer;
    }
}