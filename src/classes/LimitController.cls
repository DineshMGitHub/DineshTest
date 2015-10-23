public class LimitController {

    public List<LimitClass> limitObjectList {get; set;}
    public List<LimitClass> lastDayLimitObjectList {get; set;}
    public String ApexClassesXML{get; set;}
    public String SystemClassXML{get; set;} 
    public String ObjectXML{get; set;} 
    Public String rawSystemClassXML {get; set;} 
    Public String modifiedSystemClassXML {get; set;}
    Public String objectName {get; set;}
    Public String localFieldXML {get; set;}
    
    public LimitController (){
        getLimitObjectList();
        getLastDayLimitObjectList();
        getApexClassesXML();
    }
    
    public void getLimitObjectList(){
        //SchedulerManagerUtil.getDntSkipJobs();
        
        limitObjectList = new List<LimitClass>();
        
        limitObjectList.add(new LimitClass('Aggregate Queries', limits.getAggregateQueries(), limits.getLimitAggregateQueries()));
        limitObjectList.add(new LimitClass('Callouts', limits.getCallouts(), limits.getLimitCallouts()));
        limitObjectList.add(new LimitClass('Mobile Push Apex Calls', 0/*limits.getMobilePushApexCalls()*/, 0/*limits.getLimitMobilePushApexCalls()*/));
        limitObjectList.add(new LimitClass('Cpu Time', limits.getCpuTime(), limits.getLimitCpuTime()));
        limitObjectList.add(new LimitClass('Dml Rows', limits.getDmlRows(), limits.getLimitDmlRows()));
        limitObjectList.add(new LimitClass('Dml Statements', limits.getDmlStatements(), limits.getLimitDmlStatements()));
        limitObjectList.add(new LimitClass('Email Invocations', limits.getEmailInvocations(), limits.getLimitEmailInvocations()));
        //limitObjectList.add(new LimitClass('Fields Describes', limits.getFieldsDescribes(), limits.getLimitFieldsDescribes()));
        limitObjectList.add(new LimitClass('Find Similar Calls', limits.getFindSimilarCalls(), limits.getLimitFindSimilarCalls()));
        limitObjectList.add(new LimitClass('Future Calls', limits.getFutureCalls(), limits.getLimitFutureCalls()));
        limitObjectList.add(new LimitClass('Heap Size', limits.getHeapSize(), limits.getLimitHeapSize()));
        //limitObjectList.add(new LimitClass('Picklist Describes', limits.getPicklistDescribes(), limits.getLimitPicklistDescribes()));
        limitObjectList.add(new LimitClass('Queries', limits.getQueries(), limits.getLimitQueries()));
        limitObjectList.add(new LimitClass('Query Locator Rows', limits.getQueryLocatorRows(), limits.getLimitQueryLocatorRows()));
        limitObjectList.add(new LimitClass('Query Rows', limits.getQueryRows(), limits.getLimitQueryRows()));
        //limitObjectList.add(new LimitClass('Record Types Describes', limits.getRecordTypesDescribes(), limits.getLimitRecordTypesDescribes()));
        limitObjectList.add(new LimitClass('Run As', limits.getRunAs(), limits.getLimitRunAs()));
        limitObjectList.add(new LimitClass('Savepoint Rollbacks', limits.getSavepointRollbacks(), limits.getLimitSavepointRollbacks()));
        limitObjectList.add(new LimitClass('Savepoints', limits.getSavepoints(), limits.getLimitSavepoints()));
        //limitObjectList.add(new LimitClass('Script Statements', limits.getScriptStatements(), limits.getLimitScriptStatements()));
        limitObjectList.add(new LimitClass('SOSL Queries', limits.getSoslQueries(), limits.getLimitSoslQueries()));
        limitObjectList.add(new LimitClass('Time Elapsed', 0 , 3));
        
        
        //return limitObjectList;         
    }
    
    public void getLastDayLimitObjectList(){
        lastDayLimitObjectList = new List<LimitClass>();
    
        lastDayLimitObjectList .add(new LimitClass('Future Call', getLast24HRFutureCall(), 10));
        lastDayLimitObjectList .add(new LimitClass('Schedule Call', getLast24HRScheduleCall(), 0));
        lastDayLimitObjectList .add(new LimitClass('Batch Call', getLast24HRBatchCall(), 0));
        lastDayLimitObjectList .add(new LimitClass('Async Apex Executions', getLast24HRAsyncApexExecutions(), 10500));
    }
    
    public void getApexClassesXML(){
        //List<Document> d = [Select body from Document where Name ='Ap1'];
        List<Document> d = [Select Name, body from Document where Name IN ('ApexClassXML', 'SystemClassXML', 'ObjectXML')];
        for(Document currentDocument : d){
            if(currentDocument.Name == 'ApexClassXML'){
                Blob b = currentDocument.body;
                ApexClassesXML = b.toString();
            }else if(currentDocument.Name == 'SystemClassXML'){
                Blob b = currentDocument.body;
                SystemClassXML = b.toString();
            }else if(currentDocument.Name == 'ObjectXML'){
                Blob b = currentDocument.body;
                ObjectXML = b.toString();
            }            
        }
    }
    
    public void updateCustomClassMetadata(){
        Database.executeBatch(new Batch_GenerateApexClassMetadata(), 1);
        //updateApexMetadata();
    }
    
    public void insertSystemClassXML(){
        String content = '<?xml version="1.0" encoding="utf-8" ?>\n<ApexClasses>' + modifiedSystemClassXML + '</ApexClasses>';
        
        List<Document> existingDoc = [SELECT ID, Body FROM DOCUMENT WHERE NAME = 'SystemClassXML'];
        if(existingDoc != null && existingDoc.size() > 0){
            delete existingDoc ;
        }
                
        Document d = new Document();
        d.Name = 'SystemClassXML';
        d.Body = Blob.valueOf(content);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        d.FolderId = UserInfo.getUserId();
        
        insert d;     
    }
    
    public void getRawSystemClasses(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.salesforce.com/us/developer/docs/apexcode/Data/Toc.xml');
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        rawSystemClassXML = res.getBody();
    }
    
    public void updateObjectMetadata(){
        String objectXML = getObjectMetadataXML();
        insertObjectMetadataXML(objectXML);
    }
    
    private String getObjectMetadataXML(){
        String objectXML = '<?xml version="1.0" encoding="utf-8" ?>\n<ApexObject>\n';
        
        Map <String, Schema.SObjectType> objectSchema = Schema.getGlobalDescribe();
        List<String> objectList = new List<String>();
        objectList.addAll(objectSchema.keySet());
        objectList.sort();
        
        for(String currentObject : objectList){            
            objectXML += '<' + currentObject + '></' + currentObject + '>\n';
        }
        
        objectXML += '</ApexObject>';
        
        return objectXML ;
    }
    
    public void setObjectFieldXML(){
        String objectFields = '<?xml version="1.0" encoding="utf-8" ?>\n<ObjectFields>\n';
        
        if(Schema.getGlobalDescribe().containsKey(objectName)){
            for(String currentField : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet()){
                objectFields += '<NonStatic>' + currentField  + '</NonStatic>\n';
            }
        }
        
        if(Schema.getGlobalDescribe().containsKey(objectName + '__c')){
            for(String currentField : Schema.getGlobalDescribe().get(objectName + '__c').getDescribe().fields.getMap().keySet()){
                objectFields += '<NonStatic>' + currentField  + '</NonStatic>\n';
            }
        }
        
        objectFields += '</ObjectFields>';
        
        localFieldXML = objectFields;
    }
    
    private void insertObjectMetadataXML(String XML){
        List<Document> existingDoc = [SELECT ID, Body FROM DOCUMENT WHERE NAME = 'ObjectXML'];
        delete existingDoc;
        
        Document d = new Document();
        d.Name = 'ObjectXML';
        d.Body = Blob.valueOf(XML);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        d.FolderId = UserInfo.getUserId();
        insert d;
    }

    private Integer getLast24HRFutureCall(){
        return [select count() from AsyncApexJob where CreatedDate >= :Datetime.now().addHours(-24) and JobType = 'Future'];
    }
    
    private Integer getLast24HRScheduleCall(){
        return [select count() from AsyncApexJob where CreatedDate >= :Datetime.now().addHours(-24) and JobType = 'ScheduledApex'];
    }
    
    private Integer getLast24HRBatchCall(){
        return [select count() from AsyncApexJob where CreatedDate >= :Datetime.now().addHours(-24) and JobType = 'BatchApex'];
    }
    
    private Integer getLast24HRAsyncApexExecutions (){
        return [select count() from AsyncApexJob where CreatedDate >= :Datetime.now().addHours(-24)];
    }

    class LimitClass{
        String name;
        Integer consumed;
        Integer total;
        
        public LimitClass(String name, Integer consumed, Integer total){
            this.name = name;
            this.consumed = consumed;
            this.total = total;
        }
        
        public String Getname(){
            return name;
        }
        
        public Integer getConsumed(){
            return consumed;
        }
        
        public Integer getTotal(){
            return total;
        }
    }
}