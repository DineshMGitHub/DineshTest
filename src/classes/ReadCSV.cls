public with sharing class ReadCSV {

    private Integer numberOfColumns = 48;
    public List<string> sampleCheck1{get; set;}
    public List<string> sampleCheck{get; set;}
    public string records{get; set;}
    public Map<Integer,List<string>> sampleCheck2 {get; set;}
    private List<Account> newAccounts {get; set;}
    public Blob contentFile { get; set; }
    public String nameFile { get; set; }
    public List<Account> sampleAcc{get; set;}

    public PageReference ReadFile() {
        
        Map<Integer,List<string>> csvDataInMap = getCSVDataInMap();
        //List<string> newAccountSchema= getNewAccountSchema(csvDataInMap); 
        //List<Account> newAccountList =  getNewAccountList(newAccountSchema);
        List<Account> newAccountList =  getNewAccountList(csvDataInMap);  
        //insert newAccountList ;
        return null;
    }
    
    private Map<Integer,List<string>> getCSVDataInMap(){
        string csvInString = contentFile.toString().remove('"');
        nameFile=csvInString ;
        integer numberOfRecord=0;
        Map<Integer,List<string>> csvInMap = new Map<Integer,List<string>>();
        Integer count =0;
        List<string> csvInList = csvInString.split('\n');
        for(string accountRow: csvInList ){            
            csvInMap.put(count,accountRow.split(','));
            count++;
        }
        
        //sampleCheck = csvInList;
        records = csvInMap.get(0).size().format();
        return csvInMap ;
    }
    
    /*private List<string> getNewAccountSchema(Map<Integer,List<string>> csvInMap){
        List<string> newAccountSchema= new List<string>();
        string accountValue = '';
        for(Integer i = 1; i< csvInMap.size();i++){            
            for(Integer j =0; j< csvInMap.get(0).size();j++ ){
                if(s.getDescribe().getName()<> 'Id' && s.getDescribe().getName()<>'IsDeleted' && s.getDescribe().getName()<>'CreatedById' && s.getDescribe().getName()<>'CreatedDate' && s.getDescribe().getName()<>'LastModifiedById' && s.getDescribe().getName()<>'LastModifiedDate' && s.getDescribe().getName()<>'SystemModstamp'){
                    accountValue += s.getDescribe().getName()+'=\''+csvInMap.get(i).get(j)+'\'';
                    if(j<csvInMap.get(0).size()-1){
                        accountValue +=',';
                    }
                }              
            }
            newAccountSchema.add(accountValue);  
            accountValue ='';            
        }
        sampleCheck1 = newAccountSchema;
        return newAccountSchema;
    }*/
    
    /*private List<Account> getNewAccountList(List<string> newAccountSchema){
        List<Account> newAccountList = new List<Account>();
        for(string accountSchema : newAccountSchema){
            newAccountList .add(new Account(accountSchema.format()));        
        }
        return newAccountList;
    }*/
    
    private List<Account> getNewAccountList (Map<Integer,List<string>> csvInMap){
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.Account.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        List<Account> newAccountList = new List<Account>();
        List<string> sampleType = new List<string>();
        List<string> sampleName = new List<string>();
        for(Integer i = 1; i< csvInMap.size();i++){
            //Integer j =0;
            Account acc = new Account();   
            
            for(Schema.SObjectField s : fldObjMapValues){
                
                if(s.getDescribe().getName()<> 'MasterRecordId' && s.getDescribe().getName()<> 'Id' && s.getDescribe().getName()<>'IsDeleted' && s.getDescribe().getName()<>'CreatedById' && s.getDescribe().getName()<>'CreatedDate' && s.getDescribe().getName()<>'LastModifiedById' && s.getDescribe().getName()<>'LastModifiedDate' && s.getDescribe().getName()<>'SystemModstamp' && s.getDescribe().getName()<>'LastActivityDate'){
                    string fieldValue;
                    integer index = getIndexInList(csvInMap,String.valueOf(s.getDescribe().getName()));
                    system.debug('------------------------------> I= '+i+'------------->Index = '+index);
                    
                    fieldValue = csvInMap.get(i).get(index);
                    
                    //j++;
                    string currentFieldDataType = String.valueOf(s.getDescribe().getType());
                    sampleName .add(s.getDescribe().getName());
                    sampleType .add(string.valueOf(index ));
                    if(fieldValue == NULL || string.isEmpty(fieldValue) || string.isBlank(fieldValue)){
                        continue;
                    }
                    if(currentFieldDataType.equalsIgnoreCase('Blob') ){
                        acc.put(s,Blob.valueOf(fieldValue ));  
                    }else if(currentFieldDataType.equalsIgnoreCase('Boolean')){
                        acc.put(s,Boolean.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Date')){
                        acc.put(s,Date.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Datetime')){
                        acc.put(s,Datetime.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Decimal')){
                        acc.put(s,Decimal.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Double') || currentFieldDataType.equalsIgnoreCase('Percent') || currentFieldDataType.equalsIgnoreCase('Currency')){
                        acc.put(s,Double.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('ID') ||  currentFieldDataType.equalsIgnoreCase('Reference')){
                        acc.put(s,ID.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Integer')){
                        acc.put(s,Integer.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('Long')){
                        acc.put(s,Long.valueOf(fieldValue )); 
                    }else if(currentFieldDataType.equalsIgnoreCase('String') || currentFieldDataType.equalsIgnoreCase('PICKLIST') ||currentFieldDataType.equalsIgnoreCase('TEXTAREA') || currentFieldDataType.equalsIgnoreCase('URL') || currentFieldDataType.equalsIgnoreCase('EMAIL')){
                        acc.put(s,fieldValue); 
                    }
                    //acc.put(s,);                    
                } 
                
                
            }     
            sampleCheck1 = sampleType ;
            sampleCheck = sampleName ;
            newAccountList.add(acc);                         
        }
        return newAccountList ;
    }
    
    private integer getIndexInList(Map<Integer,List<string>> searchCSVInMap,string searchElement){
        integer count=0;
        while(count<searchCSVInMap.get(0).size()){
            if(searchCSVInMap.get(0).get(count)== searchElement){
                return count;
            }
            count++;
        }
        if(searchCSVInMap.get(0).get(searchCSVInMap.get(0).size()-1)== searchElement){
            return searchCSVInMap.get(0).size()-1;
        }
        return null;
    }
}