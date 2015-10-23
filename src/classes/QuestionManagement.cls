public with sharing class QuestionManagement {

    public string question {get; set;}
    public Boolean isActive {get; set;}
    public date scheduleDate{get; set;}
    public string type {get; set;}
    public ID questionID {get; set;}
    public List<Answer__c> answerObjectList{get; set;}
    public List<string> answers{get; set;}
    public List<string> answerStatus{get; set;}
    public string commaSeperatedAnswer{get; set;}
    public string commaSeperatedAnswerStatus{get; set;}
    public string blankString{get{return '';} set{blankString = '';}}
    public string defaultStatus{get{return 'Correct';} set;}
    
    public QuestionManagement() {
        type='Multi Select';
        //blankString = '';
        //trialAnswer = 'Initial Answer';
        
        
        //answerObjectList = getAvailableAnswer();   
    }
    
    public void saveNewQuestion(){
        try{
            Integer currentDateQuestion = [SELECT COUNT() FROM QUESTION__C WHERE SCHEDULE_QUESTION__C = :scheduleDate]; 
            if(currentDateQuestion == 0 && scheduleDate >= datetime.now().Date()){
                insertNewQuestion(); 
                saveNewAnswers();               
                //answerObjectList = getAvailableAnswer();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You can not add question for Date:'+ scheduleDate+' question already available or you are trying to add question for previous date'+datetime.now().Date());
                ApexPages.addMessage(myMsg);
            }
            
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please check fields again'+e);
            ApexPages.addMessage(myMsg);
        }
        clearForm();
    }
    
    
    public void insertNewQuestion(){
        Question__c newQuestion = new Question__c();
        newQuestion .QUESTION__C=question;
        newQuestion .TYPE__C=type;
        newQuestion .ACTIVE__C=isActive;
        newQuestion .SCHEDULE_QUESTION__C=scheduleDate;
        insert newQuestion;
        questionID = newQuestion.ID;
    }
    
    private void clearForm(){
        question = '';
        isActive = False;
        scheduleDate = null;
    }
    
    /*private void insertNewAnswer(){
         Answer__c newAnswer = new Answer__c();
            newAnswer.ANSWER__C=answer;
            newAnswer.ANSWER_STATUS__C=answerStatus;
            newAnswer.QUESTION__C=questionID;
            insert newAnswer;
    }*/
    
    private List<Answer__c> getAvailableAnswer(){
        try{
            if(questionID != null){
                return [SELECT ANSWER__C,ANSWER_STATUS__C FROM Answer__c WHERE QUESTION__C=:questionID];
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Question is not inserted');
                ApexPages.addMessage(myMsg);
            }            
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please check fields again'+e);
            ApexPages.addMessage(myMsg);
        }
        return null;        
    }  
    
    public PageReference saveNewAnswers() {
        answers = new List<string>();
        answerStatus = new List<string>();
        
        answers = commaSeperatedAnswer.split(',');
        answerStatus = commaSeperatedAnswerStatus.split(',');
        
        
        try{
            if(questionID != null){
                List<Answer__c> answersList = new List<Answer__c>();
                           
                Answer__c answer ;
                for(integer i=0; i<answers.size(); i++){
                    answer = new Answer__c();
                    answer.Answer__c = answers.get(i);
                    answer.ANSWER_STATUS__C = answerStatus.get(i);
                    answer.Question__c = questionID;
                    answersList.add(answer);
                }
                insert answersList;
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'Sucessfully Inserted');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Question is not Inserted');
                ApexPages.addMessage(myMsg);
            }           
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please check fields again'+e);
            ApexPages.addMessage(myMsg);
        }
                
        return null;
    } 
    
    public string getBlankString(){
        return '';
    }
    
    public void setBlankString(string blankString){
        blankString ='';
    }
    
    public List<Question__c> getAllQuestion(){
        return [SELECT ID,Question__c, Type__c, Active__c,Schedule_Question__c FROM Question__c];
    }
}