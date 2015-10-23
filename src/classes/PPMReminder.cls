public class PPMReminder {

    public String getPpmData() {
        String ppmDate = ppmUtility.getThisWeekDate();
        
        String ppmDataHTML = '';
        String ppmDataJson='[';
        Integer count = 0 ;
        
        for(Contact currentContact : [SELECT Name, (SELECT ID, Name, hellooo__Entry_Date__c FROM PPM_Entries__r WHERE Name=: ppmDate) FROM Contact WHERE hellooo__isEnrolledForPPM__c = true ]){
            if(currentContact.PPM_Entries__r.size() == 0){
                ppmDataJson += '{"id":' + count + ',"name":"' + currentContact.Name + '","ppm":"' + ppmDate + '","status":"Pending","actionTime":"-"},';
                ppmDataHTML += '<tr><td>' + currentContact.Name + '</td><td>' + ppmDate + '</td><td>Pending</td><td>-</td></tr>';
            }else{
                ppmDataJson += '{"id":' + count + ',"name":"' + currentContact.Name + '","ppm":"' + ppmDate + '","status":"Completed","actionTime":" ' + currentContact.PPM_Entries__r[0].hellooo__Entry_Date__c + ' "},';
                ppmDataHTML += '<tr><td>' + currentContact.Name + '</td><td>' + ppmDate + '</td><td>Completed</td><td>' + currentContact.PPM_Entries__r[0].hellooo__Entry_Date__c + '</td></tr>';
            }
            
            count++;
        }
        
        ppmDataJson = ppmDataJson.subString(0, ppmDataJson.length() - 1);
        ppmDataJson += ']';
        
        //return ppmDataHTML ;
        return ppmDataJson ;
    }


    public String url { get; set; }

    public void updatePPMEntry() {        
        String contactID = ApexPages.currentPage().getParameters().get('contactId');
        String ppmDate = ppmUtility.getThisWeekDate();
        
        try{
            hellooo__PPM_Setting__c currentPPMSetting = [SELECT hellooo__Error_Message__c, hellooo__Success_Message__c FROM hellooo__PPM_Setting__c WHERE hellooo__Is_Active__c = true Limit 1];
            Boolean isAlreadyUpdate = ppmUtility.updatePPMEntries(contactID, ppmDate);
            
            if(isAlreadyUpdate){
                url = currentPPMSetting.hellooo__Success_Message__c;
            }else{
                url = currentPPMSetting.hellooo__Error_Message__c;
            }
        }
        catch(Exception ex){
            url = ex.getmessage();
        }
    }

}