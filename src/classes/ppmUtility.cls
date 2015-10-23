public class ppmUtility{ 
    static hellooo__PPM_Setting__c currentPPMSetting;
    
    static{
        currentPPMSetting = [SELECT hellooo__Admin_Email__c, hellooo__Confirm_URL__c, hellooo__Downtime_PPM_Error__c, hellooo__Error_Message__c, hellooo__PPM_Manager_Email__c, hellooo__PPM_Reminder_Email_Body__c, hellooo__PPM_Reminder_Email_Subject__c, hellooo__PPM_Status_Email_Body__c, hellooo__PPM_Status_Email_Subject__c, hellooo__Success_Message__c FROM hellooo__PPM_Setting__c WHERE hellooo__Is_Active__c = true Limit 1];
    }
    
    public static Boolean sendEmailToDefaulters(String ppmDate){
        string emailBody = currentPPMSetting.hellooo__PPM_Reminder_Email_Body__c; 
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = TRUE LIMIT 1];
        
        for(Contact currentContact : [SELECT ID, Email, Name, (SELECT ID FROM PPM_Entries__r WHERE Name =: ppmDate) FROM Contact WHERE hellooo__isEnrolledForPPM__c = true ]){
            if(currentContact.PPM_Entries__r != null && currentContact.PPM_Entries__r.size() == 0){
                String confirmUrl = currentPPMSetting.hellooo__Confirm_URL__c + currentContact.ID ;
                String updatedEmailBody = emailBody.replace('{DisplayName}', currentContact.Name).replace('{confirmURL}', confirmUrl );
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setHtmlBody(updatedEmailBody);
                mail.setPlainTextBody('You are defaulter \n' + confirmUrl );
                mail.setToAddresses(new List<String>{currentContact.Email});
                mail.setSubject(currentPPMSetting.hellooo__PPM_Reminder_Email_Subject__c);
                mail.setOrgWideEmailAddressId(owe.ID);
                //mail.setSenderDisplayName(owe.DisplayName);
                
                emails.add(mail);  
            }          
        }
        
        if(emails.size() > 0){
            Messaging.SendEmailResult [] r = Messaging.sendEmail(emails);            
            return true;
        }else{
            return false;
        }
    }
    
    public static Boolean updatePPMEntries(String contactID, String ppmDate){
        List<hellooo__PPM_Entry__c> entryDetails = new List<hellooo__PPM_Entry__c>();
        entryDetails = [SELECT hellooo__Contact__c, hellooo__Contact__r.Email FROM hellooo__PPM_Entry__c WHERE Name =: ppmDate and hellooo__Contact__c =: contactID];
        
        if(entryDetails.isEmpty()){
            entryDetails.add(new hellooo__PPM_Entry__c(Name = ppmDate, hellooo__Contact__c = contactID, hellooo__Entry_Date__c = System.Now().format('dd-MMM-YYYY hh:mm:ss')));
            Database.Insert(entryDetails, false);
            
            return true;
        }else{
            return false;
        }       
    }   
    
    public static Boolean sendEmailToAdmin(String ppmDate){
        String mainEmailBody = currentPPMSetting.hellooo__PPM_Status_Email_Body__c; 
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
               
        String status = 'Completed';
        String defaulterHTML = '';
        Integer defaulterCount = 1;
        
        List<String> toAddress = new List<String>();
        toAddress.add(currentPPMSetting.hellooo__PPM_Manager_Email__c);
        
        List<String> bccAddress = new List<String>();
        bccAddress.add(currentPPMSetting.hellooo__Admin_Email__c);
        
        List<String> ccAddress = new List<String>();
        
        for(Contact currentContact : [SELECT ID, Email, Name, (SELECT ID FROM PPM_Entries__r WHERE Name =: ppmDate) FROM Contact WHERE hellooo__isEnrolledForPPM__c = true ]){
            if(currentContact.PPM_Entries__r.size() == 0){
                status = 'Partially Completed';
                defaulterHTML += '<tr><td>' + defaulterCount + '</td><td>' + currentContact.Name +'</td><td>Pending</td><td>On Leave</td></tr>';
                defaulterCount ++;
                ccAddress.add(currentContact.Email);
            }
        }
        
        OrgWideEmailAddress owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = TRUE LIMIT 1];
        
        String updatedEmailBody = mainEmailBody.replace('{THISWEEKPPMSTATUS}', status).replace('{DEFAULTERSTIMESHEET}', defaulterHTML );
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setHtmlBody(updatedEmailBody );
        mail.setPlainTextBody(currentPPMSetting.hellooo__PPM_Status_Email_Subject__c);
        mail.setToAddresses(toAddress);
        mail.setCcAddresses(ccAddress);
        mail.setBccAddresses(bccAddress);
        //mail.setToAddresses(new List<String>{'dinesh.moundekar@morganstanley.com'});
        mail.setSubject(currentPPMSetting.hellooo__PPM_Status_Email_Subject__c);
        mail.setOrgWideEmailAddressId(owe.ID);
        
        emails.add(mail);        
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(emails);
        
        return true;
    }
    
    public static String getThisWeekDate(){
        DateTime weekStartDate = System.today().toStartOfWeek().addDays(1);
        DateTime weekEndDate = System.today().toStartOfWeek().addDays(7);
        
        return '(' + weekStartDate.format('dd-MMM-YYYY') + ')-To-(' + weekEndDate .format('dd-MMM-YYYY') + ')';
    }
    
}