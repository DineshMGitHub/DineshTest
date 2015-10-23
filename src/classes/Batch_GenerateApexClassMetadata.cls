/********************************************************************
    Summary    :     This batch will create Apex Class Metadata File 
    26 Mar 2014:     Dinesh M:    Created
*********************************************************************/

global class Batch_GenerateApexClassMetadata implements Database.Batchable<sObject>, Database.Stateful{
    global String affectedRecords = '';
    global Integer i = 0;
    global Integer j = 0;
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        createNewXMLFile();      
        String query = 'Select Name, Body from ApexClass where Status = \'Active\' order by Name';
        
        if(Test.isRunningTest()){
            query += ' Limit 2';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ApexClass> apexClassList){
        String apexCode = '';
        List<String> methodDefinationList = null;
        String apexClassXML = '';
        String bodyRegex = '(public|global|protected|public static|global static|protected static) +[\\.\\w\\<\\>\\[\\]]+\\s+(\\w+) *\\([^\\)]*\\) *(\\{?|[^;])';
        
        for(ApexClass currentApexClass : apexClassList){
            try{
                String methodDefination = '';
                methodDefinationList = new List<String>();
                
                if(currentApexClass.Body.toLowerCase().contains('@istest')){
                        system.debug('Name: ' + currentApexClass.Name);
                        continue;
                }
                
                Pattern MyPattern = Pattern.compile(bodyRegex );
                
                System.debug('MyMatcher: ' + MyPattern);
                Matcher MyMatcher = MyPattern.matcher(currentApexClass.Body.toLowerCase());
                
                while (MyMatcher.find()) {                  
                    String currentMethod = MyMatcher.group(0);
                    System.debug('MyMatcher: ' + currentMethod);
                    methodDefinationList.add(currentMethod.subString(0, currentMethod.length() - 1));                   
                }
                            
                String apexMethodXML = getApexMethodXML(methodDefinationList);
                
                apexClassXML += '\n<' + currentApexClass.Name + '>' + apexMethodXML + '\n</' + currentApexClass.Name + '>';
                i++;
            }Catch(Exception ex){
                affectedRecords += currentApexClass.Name;
                j++;
            }
        }
        
        addApexClass(apexClassXML);
    }
    
    global void finish(Database.BatchableContext BC){
        endXMLFile();
    }
    
    private void createNewXMLFile(){
        List<Document> existingDoc = [SELECT ID, Body FROM DOCUMENT WHERE NAME = 'ApexClassXML'];
        delete existingDoc;
        
        String content = '<?xml version="1.0" encoding="utf-8" ?>\n<ApexClasses>';
        
        Document d = new Document();
        d.Name = 'ApexClassXML';
        d.Body = Blob.valueOf(content);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        d.FolderId = UserInfo.getUserId();
        insert d;
    }
    
    private void addApexClass(String apexClasses){
        List<Document> existingDoc = [SELECT ID, Body FROM DOCUMENT WHERE NAME = 'ApexClassXML'];
        
        Blob b = existingDoc[0].Body;
        String content  = b.toString() + apexClasses;
        
        Document d = new Document();
        d.Name = 'ApexClassXML';
        d.Body = Blob.valueOf(content);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        d.FolderId = UserInfo.getUserId();
        
        delete existingDoc;
        insert d;        
    }
    
    private void endXMLFile(){
        List<Document> existingDoc = [SELECT ID, Body FROM DOCUMENT WHERE NAME = 'ApexClassXML'];
        
        Blob b = existingDoc[0].Body;
        String content  = b.toString() + '\n</ApexClasses>';
        
        delete existingDoc;
        
        Document d = new Document();
        d.Name = 'ApexClassXML';
        d.Body = Blob.valueOf(content);
        d.ContentType = 'text/plain';
        d.Type = 'txt';
        d.FolderId = UserInfo.getUserId();
        insert d;
    }
    
    private String getApexMethodXML(List<String> methodDefinationList){
        String xmlValue = '';
        String xmlText = '';
        String returnType = '';
        String methodXML = '';
        
        for(String currentMethodDefination : methodDefinationList){
            //System.debug('Current Method: ' + currentMethodDefination );
        
            currentMethodDefination = currentMethodDefination.replaceAll('\R',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('\\r',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('\\n',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('\\t',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('\\s',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('  ',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('/\\s/g',' ');
            currentMethodDefination = currentMethodDefination.replaceAll('\\s+',' ');
            
            if(currentMethodDefination.indexOf('(') != -1 && currentMethodDefination.substring(0, currentMethodDefination.indexOf('(')).split(' ').size() > 4){
                    continue;
            }
                
            xmlText = currentMethodDefination.subString(currentMethodDefination.toLowerCase().indexOf(' ') + 1, currentMethodDefination.length());
            xmlText = xmlText.subString(xmlText.toLowerCase().indexOf(' ') + 1, xmlText.length());            
                
            if(currentMethodDefination.toLowerCase().contains('static')){               
                xmlText = xmlText.subString(xmlText.toLowerCase().indexOf(' ') + 1, xmlText.length());
                xmlValue = 'Static';
                returnType = currentMethodDefination.split(' ')[2];
                //xmlText = 'static - ' + currentMethodDefination;
                
            }else if(currentMethodDefination.toLowerCase().contains('virtual')){               
                xmlText = xmlText.subString(xmlText.toLowerCase().indexOf(' ') + 1, xmlText.length());
                xmlValue = 'NonStatic';
                returnType = currentMethodDefination.split(' ')[2];
                //xmlText = 'static - ' + currentMethodDefination;
                
            }else{              
                xmlValue = 'NonStatic';
                returnType = currentMethodDefination.split(' ')[1];
                //xmlText = 'NonStatic - ' + currentMethodDefination;               
            }
            
            if(xmlText.trim().indexOf('(') == 0 || xmlText.trim().indexOf('(') == -1){
                continue;
            }
            
            methodXML += '\n<' + xmlValue + '>' + xmlText.replaceAll('<', ' Of ').replaceAll('>', '') + ' - ' + returnType.replaceAll('<', ' Of ').replaceAll('>', '') + '</' + xmlValue + '>';
            //methodXML += '\n<' + xmlValue + '>' + xmlText.replace('<', ' Of ').replace('>', '') + '</' + xmlValue + '>';
        }
        
        return methodXML;
    }
}