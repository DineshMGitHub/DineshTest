public with sharing class InterviewerExtensionController {
    Interviewer__c interviewerRecord {get;set;}

    public InterviewerExtensionController(ApexPages.StandardController controller) {
        interviewerRecord = (Interviewer__c ) controller.getRecord();
    }
    
    public List<Candidate__c> getCandidates(){
        return [Select NAME,LASTMODIFIEDDATE      
         From Candidate__c ];
    }
    
    public List<Position__c> getPositions(){
        return[Select NAME
        From Position__c];
    }
    
    public List<Book__c> getBookDetails(){
    	return null;
    }

}