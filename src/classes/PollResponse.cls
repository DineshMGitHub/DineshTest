public class PollResponse 
{
    public Question__c question{get;set;}
    
    public ID radioValue{get;set;}{radioValue = null;}
    
    public List<ID> checkBoxesValue{get;set;}{checkBoxesValue = new List<String>();}
    
    public List<SelectOption> options{get; set;}
    
    public Boolean isSubmitButtonActive{
    get
    {
        if(question != null)
        {
            generateAnswerOption();
            Integer checkUserResponse= [SELECT count() FROM Polling_Response__c WHERE USER__C=:UserInfo.getUserId() AND QUESTION__C=:question.ID];
            
            if(checkUserResponse == 0)
            {
                isSubmitButtonActive = True;
            }
            else
            {
                isSubmitButtonActive = False;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'You have already Answer This Question');
                ApexPages.addMessage(myMsg);
            }            
        }
        return isSubmitButtonActive;
    }    
    set;}
    
    public Integer correctAnswerCount{get; set;}
    
    public List<Answer__c> answerList{
    get{
        
        return question.Answers__r;
    }
    set;}
    
    
    public PollResponse()
    {
        
    }
    
    public void generateAnswerOption()
    {
        options = new List<SelectOption>();
        Integer answerCount=0;
        if(question != null)
        {
            for(ANSWER__c a : question.ANSWERS__r)
            {
                if(a.ANSWER_STATUS__C=='Correct'){
                answerCount++;
                } 
                options.add(new SelectOption(a.ID, a.ANSWER__C));
            }
        }        
        correctAnswerCount=answerCount;
        
    }
    
    public void submit()
    {
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
        
    }
    
    
}