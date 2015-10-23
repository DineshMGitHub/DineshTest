public with sharing class positionextension {
    transient public string title{get; set;}
    public string newMethods {get; set;}
    
    transient public POSITION__C postions{get; set;}
    
    private String positionId{get; set;}
    
    public void setNewMethod(){
        newMethods = 'hell new method';
    }

    public positionextension(ApexPages.StandardController controller) {
        positionId= Apexpages.currentPage().getParameters().get('id');
        title='I am Here';
    }
    
    public PageReference showAllPositions(){
        postions=[SELECT NAME FROM Position__c WHERE id=:positionId];
        return null;
    }

}