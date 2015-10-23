/**
 *   08 JAN 2014:    Dinesh Moundekar:   Created This Test Class
 *	 07 Mar 2014:	 Dinesh M:			 Modified Test class for custom setting
**/

@isTest
private class TestScheduleAllBatches {
	static String CLASSNAME = 'TestScheduleClass';
	static String CRON_EXPRESSION = '0 30 * * * ?';
	
	/* Schedule All Jobs */
	
	static testMethod void testScheduleAllJobs() {
		insertCustomSetting();
		
		Test.startTest();
		ScheduleAllBatches scheduler = new ScheduleAllBatches();
		scheduler.getAllScheduledBatchJobs();
		scheduler.DeleteAllBatches();
		scheduler.jobName = 'All Job';
		scheduler.Schedule();
		scheduler.getAllScheduledBatchJobs();
		scheduler.DeleteAllBatches();
		Test.stopTest();	
			
	}
	
	/* Test scheduler with empty custom setting */
	
	static testMethod void testSchedulerWithCustomsetting() {
		ScheduleAllBatches scheduler = new ScheduleAllBatches();
		scheduler.getAllScheduledBatchJobs();
		scheduler.DeleteAllBatches();
		scheduler.Schedule();
		scheduler.getAllScheduledBatchJobs();
		scheduler.DeleteAllBatches();
	}
	
	/* Test class to increase code coverage */
	
	static testMethod void testIncreaseCodeCoverage() {
		insertCustomSetting();
		
        ScheduleAllBatches scheduler = new ScheduleAllBatches();
        scheduler.reloadBatchStatus();
        scheduler.reloadBatchStatusPolar();
        
        if(scheduler.getAllScheduledBatchJobs() != null && scheduler.getAllScheduledBatchJobs().size() > 0){
        	scheduler.getAllScheduledBatchJobs()[0].getClassName();
	        scheduler.getAllScheduledBatchJobs()[0].getstatus();
	        scheduler.getAllScheduledBatchJobs()[0].getcronExpression();
	        scheduler.getAllScheduledBatchJobs()[0].getId();
	        scheduler.getAllScheduledBatchJobs()[0].getcronId();
        }        
	}
	
	
	/* Insert Job details in custom setting */
	
	static void insertCustomSetting(){
		Schedule_All_Batches_Setting__c schedulerSetting = Schedule_All_Batches_Setting__c.getInstance();
		List<ApexClass> classList = [SELECT id FROM ApexClass WHERE Name =: CLASSNAME];
		 
		if(schedulerSetting == null || schedulerSetting.id == null){
			schedulerSetting.Name = CLASSNAME;
			schedulerSetting.SetupOwnerId = Userinfo.getOrganizationId();
			schedulerSetting.Apex_Class_Id__c = classList[0].id;
			schedulerSetting.Apex_Class_Name__c = CLASSNAME;
			schedulerSetting.Cronn_Expression__c = CRON_EXPRESSION;
			schedulerSetting.IsActive__c = true;
			
			insert schedulerSetting; 
		}
	}
}