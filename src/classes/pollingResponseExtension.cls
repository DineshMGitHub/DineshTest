public with sharing class pollingResponseExtension {

    public List<Answer__c> pollingAnswer{get; set;}
    public List<ID> checkBoxesValue {get; set;}
    public ID radioValue{get; set;}
    public Boolean isSubmitButtonActive{get; set;}
    public Question__c question{get; set;}
    public List<Question__c> questionList{get; set;}
    public List<SelectOption> options{get; set;}
    public Integer correctAnswerCount{get; set;}
    

    public pollingResponseExtension() {
        clearAnswers();
        questionList = [SELECT ID,QUESTION__C,TYPE__C,(SELECT ID,ANSWER__C,ANSWER_STATUS__C FROM ANSWERS__r) FROM QUESTION__C WHERE ACTIVE__C=:True];          
        question = questionList[0];
        
        //question = [SELECT ID,QUESTION__C,TYPE__C FROM QUESTION__C WHERE ACTIVE__C=:True];
        
        generateAnswerOption();
        
        Integer checkUserResponse= [SELECT count() FROM Polling_Response__c WHERE USER__C=:UserInfo.getUserId() AND QUESTION__C=:question.ID];
        if(checkUserResponse == 0){
            isSubmitButtonActive=True;
        }else{
            isSubmitButtonActive=False;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'You have already Answer This Question');
            ApexPages.addMessage(myMsg);
        }
    }

        
    public PageReference submit(){        
        List<Polling_Response__c> getUserResponse = new List<Polling_Response__c>();
        Polling_Response__c userResponse;
                
        if(!checkBoxesValue.isEmpty()){
            if(checkBoxesValue.size() == correctAnswerCount){
                for(ID answerID:checkBoxesValue){
                        userResponse = new Polling_Response__c();
                        userResponse.Answer__c=answerID;
                        userResponse.Question__c=question.ID;
                        userResponse.User__c=UserInfo.getUserId();
                        
                        getUserResponse.add(userResponse);
                }                
                insert getUserResponse;
                isSubmitButtonActive=False;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'Thanks For your response');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'Pleae Select '+correctAnswerCount+' answer');
                ApexPages.addMessage(myMsg);
            }                                
        }else if(radioValue !=null){                
                    userResponse = new Polling_Response__c();
                    userResponse.Answer__c=radioValue;
                    userResponse.Question__c=question.ID;
                    userResponse.User__c=UserInfo.getUserId();                   
                    
                    insert userResponse;   
                    isSubmitButtonActive=False; 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'Thanks For your response');
                    ApexPages.addMessage(myMsg);               
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select Answer');
            ApexPages.addMessage(myMsg);
        }               
        return null;
    }
    
    private void clearAnswers(){
        checkBoxesValue = new List<ID>(); 
        checkBoxesValue.clear();
        radioValue=null;
    }
    
    private void generateAnswerOption()
    {
        //pollingAnswer = [SELECT ID,ANSWER__C,ANSWER_STATUS__C FROM ANSWER__C WHERE QUESTION__C =:question.ID];      
        Integer answerCount=0;
        options= new List<SelectOption>();
        
        for(Answer__c answer : question.Answers__r){
            if(answer.ANSWER_STATUS__C=='Correct'){
                answerCount++;
            }  
            options.add(new SelectOption(answer.ID,answer.Answer__c));                  
        }
        correctAnswerCount=answerCount;
    }

}