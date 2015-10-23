global class weeklyPPMReminder implements Schedulable{
    global void execute(SchedulableContext s){
        hellooo__PPM_Setting__c currentPPMSetting = [SELECT hellooo__Send_Report_Time_In_HR__c FROM hellooo__PPM_Setting__c WHERE hellooo__Is_Active__c = true Limit 1];
        DateTime weekStartDate = System.today().toStartOfWeek().addDays(1);
        DateTime weekEndDate = System.today().toStartOfWeek().addDays(7);
        
        String ppmDate = '(' + weekStartDate.format('dd-MMM-YYYY') + ')-To-(' + weekEndDate .format('dd-MMM-YYYY') + ')';        
        
        Date todayDate = System.now().Date();
        Time deadlineTime = Time.newInstance(Integer.valueOf(currentPPMSetting.hellooo__Send_Report_Time_In_HR__c), 0, 0, 0);
        DateTime deadLine = DateTime.newInstance(todayDate , deadlineTime);
        
        if(System.now() > deadLine){
            ppmUtility.sendEmailToAdmin(ppmDate);
        }else{        
            Boolean isEmailSent = ppmUtility.sendEmailToDefaulters(ppmDate);            
            
            
        }
    } 
}