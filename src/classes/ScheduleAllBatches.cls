/**
 *  Summary: This class is created as POC to schedule or delete all Job Batches in Organisation. 
 *      07 Mar 2014:    Dinesh M:       Moved Batch/Scheduler class details into custom setting
**/

global class ScheduleAllBatches {

    public String message { get; set; }
    private boolean schedule = False ;
    private boolean doNotSendEmail = False ;
    public map<Id,string> batchJobsToMonitor { get; set; }
    public map<Id,AsyncApexJob > asyncApexScheduledJobs {get; set ;}
    public map<Id,CronTrigger > cronJobsMap {get; set ;}
    public String jobName {get; set;}
    Map<String, Schedule_All_Batches_Setting__c> jobSettingMap;    
    public String JobID {get; set;}
    
    /* Create object of class ScheduleJobDetail define below*/
    
    public list<ScheduleJobDetail> getAllScheduledBatchJobs(){  
        list<ScheduleJobDetail> ScheduleJobDetaillist = null;
          
        try{                     
            jobSettingMap = new Map<String, Schedule_All_Batches_Setting__c>();
            jobSettingMap = Schedule_All_Batches_Setting__c.getAll();
            
            insertBatchJobDetailsToMonitor();
            collectBatchStatus();
            
            ScheduleJobDetaillist= new list<ScheduleJobDetail>();        
            
            for(ID currentID : batchJobsToMonitor.keySet()){
                string className = asyncApexScheduledJobs.get(currentID) == null ? batchJobsToMonitor.get(currentID) : asyncApexScheduledJobs.get(currentID).ApexClass.Name ;
                string Id = asyncApexScheduledJobs.get(currentID) == null ? currentID  : asyncApexScheduledJobs.get(currentID).ApexClassId ;            
                string status = asyncApexScheduledJobs.get(currentID) == null ? 'Aborted' : asyncApexScheduledJobs.get(currentID).Status;
                string cronExpression = cronJobsMap.get(currentID) == null ? '' : cronJobsMap.get(currentID).CronExpression ; 
                String cronId = cronJobsMap.get(currentID) == null ? '' : cronJobsMap.get(currentID).ID;                       
                ScheduleJobDetail currentScheduleJobDetail= new ScheduleJobDetail(className ,status ,cronExpression ,Id, cronId);
                ScheduleJobDetaillist.add(currentScheduleJobDetail);
            }
            
            System.debug('ScheduleAllBatches: getAllScheduledBatchJobs - Success');
        }catch(Exception e){
            System.debug('ScheduleAllBatches: getAllScheduledBatchJobs - Error: ' + e.getMessage());
            message=e.getmessage();
        }   
        return ScheduleJobDetaillist;       
    }
    
    /* Reload status of all batch Job frequently */
    
    public Pagereference reloadBatchStatus(){
        try{
            getAllScheduledBatchJobs();                       
            pageReference pg = new pageReference('/apex/RescheduleAllBatches');
            pg.setRedirect(true);
            System.debug('ScheduleAllBatches: reloadBatchStatus - Success');
            message='';
            return pg;
        }catch(Exception e){
            System.debug('ScheduleAllBatches: reloadBatchStatus - Error:' + e.getMessage());
            message=e.getmessage();
            return null;
        }    
    }

    /* Reload status of all batch Job frequently */
    
    public Pagereference reloadBatchStatusPolar(){
        try{
            getAllScheduledBatchJobs();
            System.debug('ScheduleAllBatches: reloadBatchStatusPolar - Success'); 
            message='';
        }catch(Exception e){
            System.debug('ScheduleAllBatches: reloadBatchStatusPolar - Error:' + e.getMessage());
            message=e.getmessage();
        }
        return null;            
    }
    
     /* Delete all Jobs */
    
    public void DeleteAllBatches() {
        try{
            for(CronTrigger currentJob: [SELECT ID FROM CronTrigger]){
                system.abortjob(currentJob.ID);
            }
            
            System.debug('ScheduleAllBatches: DeleteAllBatches - Success');            
            schedule = False ;            
            sendEmail('All Jobs');    
            message='';    
        }catch(exception e){
            System.debug('ScheduleAllBatches: DeleteAllBatches - Error:' + e.getMessage());
            message=e.getmessage();
        }
    }

    /* Schedule all Job */
    
    public void Schedule(){
        Boolean isJobSchedule = false;
        for(Schedule_All_Batches_Setting__c currentSetting : jobSettingMap.values()){
            try{
                if(jobName == 'All Job' && currentSetting.IsActive__c){
                    scheduleThisJob(currentSetting);                
                }else if(jobName == currentSetting.Apex_Class_Name__c && currentSetting.IsActive__c){
                    scheduleThisJob(currentSetting);
                }
                
                System.debug('ScheduleAllBatches: Schedule - Success');   
                message='';            
		        isJobSchedule = true;         
            }catch(exception e){
                System.debug('ScheduleAllBatches: Schedule - Error:' + e.getMessage());
                message=e.getmessage();
                isJobSchedule = false;
            } 
            
            if(jobName == currentSetting.Apex_Class_Name__c && currentSetting.IsActive__c){
            	break;
            }    
        } 
        
        if(isJobSchedule){
	        schedule = true;
	        sendEmail(jobName);
        } 
    }           
    
    /*Delete Current Job*/
    
    public void DeleteCurrentJob(){     
        for(CronTrigger aaj : [SELECT Id FROM CronTrigger WHERE Id =: JobID ]){        
            system.abortjob(aaj.ID);        
        }
        
        schedule = False ;
        sendEmail(jobName);  
    }
    
    /*Schedule Per job at a time */
    private void scheduleThisJob(Schedule_All_Batches_Setting__c currentSetting){       
        System.Type t;
        Schedulable cls;
    
        if(currentSetting.Cronn_Expression__c != null){
	        String name = currentSetting.Apex_Class_Name__c;                
	        t = System.Type.forName(name);
	                
	        if ((t == null) && (!name.contains('.'))) {
	            t = System.Type.forName(null,name);
	        }  
	          
	        //For managed package classes use nameSpace to instantiate class.       
	        if ((t == null) && (name.indexOf('.')!=-1)){
	            String className = name.substring(name.indexOf('.')+1);
	            String nameSpace= name.substring(0,name.indexOf('.'));
	                      
	            t = System.Type.forName(nameSpace,className);
	        }               
	        
	        cls=(Schedulable)t.newinstance();               
	        System.schedule(name, currentSetting.Cronn_Expression__c, cls);
	    }   
    }
    
    /* Collect Status of all Scheduled Batch */
    
    private void collectBatchStatus(){
        asyncApexScheduledJobs = new map<Id,AsyncApexJob >();
        cronJobsMap  = new map<Id,CronTrigger >();
        Map<Integer, ID> apexclassMapSequence = new Map<Integer, ID>();
        Integer index = 0;
        
        for(AsyncApexJob aaj : [SELECT Id, CreatedDate, CreatedById, JobType, ApexClass.Name, ApexClassID, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, CompletedDate, MethodName, ExtendedStatus, ParentJobId, LastProcessed, LastProcessedOffset FROM AsyncApexJob WHERE JobType = 'ScheduledApex' and Status != 'Aborted' ORDER BY CreatedDate DESC]){            
            If(!asyncApexScheduledJobs.containsKey(aaj.ApexClassID))
            asyncApexScheduledJobs.put(aaj.ApexClassID, aaj);
            apexclassMapSequence.put(index, aaj.ApexClassID);
            index ++;
        }
        
        index = 0;
        
        for(CronTrigger currentCronTrigger : [SELECT ID, CronExpression FROM CronTrigger ORDER BY CreatedDate DESC]){
            if(apexclassMapSequence.get(index) != null)
            cronJobsMap.put(apexclassMapSequence.get(index), currentCronTrigger);
            index ++;
        }
        
        System.debug('ScheduleAllBatches: collectBatchStatus - Success'); 
    }
    
    /* Collect details of all batch job from custom setting */
    
    private void insertBatchJobDetailsToMonitor(){
        batchJobsToMonitor = new map<Id,string>();
        
        for(Schedule_All_Batches_Setting__c currentSetting : jobSettingMap.values()){
            if(currentSetting.IsActive__c){batchJobsToMonitor.put(currentSetting.Apex_Class_Id__c, currentSetting.Apex_Class_Name__c) ;}
        }        
        
        System.debug('ScheduleAllBatches: insertBatchJobDetailsToMonitor - Success');
    }
    
    /* Send Email to all member about user who deleted or schedule Jobs */ 
    
    private void sendEmail(String ScheduledJobName){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            List<String> toAddresses = new List<String>();
            
            for(Email_Setting__c currentEmail : Email_Setting__c.getAll().values()){
                if(currentEmail.IsActive__c){toAddresses.add(currentEmail.Email__c);}                   
            }

            mail.setToAddresses(toAddresses);
    
            if(schedule){
                mail.setSubject(userinfo.getName()+' has scheduled ' + ScheduledJobName);
        
                mail.setPlainTextBody(userinfo.getName()+' has scheduled ' + ScheduledJobName + ' on' + system.now()+'Local IP Address: '+GetUserIPAddress());
                mail.setHtmlBody(userinfo.getName()+' has scheduled ' + ScheduledJobName + ' on ' + system.now()+'<br /> <b>Local IP Address:</b> '+GetUserIPAddress());        
            }else{
                mail.setSubject(userinfo.getName()+' has deleted ' + ScheduledJobName);
        
                mail.setPlainTextBody(userinfo.getName()+' has deleted ' + ScheduledJobName + ' on ' + system.now()+'Local IP Address: '+GetUserIPAddress());
                mail.setHtmlBody(userinfo.getName()+' has deleted ' + ScheduledJobName + ' on ' + system.now()+'<br /> <b>Local IP Address:</b> '+GetUserIPAddress());
            }
                
            if(toAddresses.size() > 0){
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            System.debug('ScheduleAllBatches: sendEmail - Success'); 
            message='';       
        }catch(Exception e){
            System.debug('ScheduleAllBatches: sendEmail - Error:' + e.getMessage());
            message=e.getmessage();
        }
    }
    
    /* Get Ip of User */
    
    private String GetUserIPAddress() {
        string ReturnValue = '';    
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
                
        if (String.isEmpty(ReturnValue)) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }else if(String.isEmpty(ReturnValue)){
            ReturnValue = ApexPages.currentPage().getHeaders().get('User-Agent');
        }  
                  
        System.debug('ScheduleAllBatches: GetUserIPAddress - Success');
        return ReturnValue;            
    } 

         
    /* Class used to display the Job Status */
    
    class ScheduleJobDetail{
        public string className;
        public string status;
        public string cronExpression;
        public string Id;
        public string cronId;
                
        public ScheduleJobDetail(string className,string status,string cronExpression,string Id, String cronId){
            this.className = className;
            this.status = status;
            this.cronExpression = cronExpression;
            This.Id = Id;  
            this.cronId = cronId;                   
        }
        
        public string getClassName(){
            return className;
        }
        
        public string getstatus(){
            return status;
        }
        
        public string getcronExpression(){
            return cronExpression;
        }
         
        public string getId(){
            return Id;
        } 
         
        public string getcronId(){
            return cronId;
        }                  
    }    
}