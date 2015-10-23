@isTest(SeeAllData=false)
public class Test_PPMReminder {
    static testmethod void test1(){
        createTestData();
        
        String ppmDate = ppmUtility.getThisWeekDate();
        
        ppmUtility.sendEmailToDefaulters(ppmDate);  
        
        String contactID = [SELECT ID FROM Contact WHERE hellooo__isEnrolledForPPM__c = true limit 1].ID;
        PageReference myVfPage = Page.angularPOC;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference, 
       
        ApexPages.currentPage().getParameters().put('contactId',contactID );
        PPMReminder ac = new PPMReminder();  
               
        //ppmUtility.updatePPMEntries(contactID ,ppmDate);  
        ac.updatePPMEntry();
        ac.getPpmData();         
        
        ppmUtility.sendEmailToAdmin(ppmDate);
        
        ac.updatePPMEntry();
        ac.getPpmData(); 
        
        weeklyPPMReminder w = new weeklyPPMReminder();
        w.execute(null);      
    }
    
    static void createTestData(){
        Account testAccount = new Account(name = 'testAccount');
        insert testAccount;
        
        // insert Contact
        Contact con = new Contact(); 
        con.firstName = 'testfirstName';
        con.lastName = 'testlastName';
        con.AccountId = testAccount.id;
        con.hellooo__isEnrolledForPPM__c = true;
        con.Email = 'test@test.com';
        insert con;
        
        hellooo__PPM_Setting__c ppmSetting = new hellooo__PPM_Setting__c();
        ppmSetting.hellooo__Admin_Email__c = 'dinesh.moundekar@morganstanley.com';
        ppmSetting.hellooo__Confirm_URL__c = 'https://dineshmoundekar-developer-edition.ap1.force.com/PPMReminder?contactId=';
        ppmSetting.hellooo__Downtime_PPM_Error__c = 'You can update the PPM Status only on Thursday and Friday';
        ppmSetting.hellooo__Error_Message__c = 'You have already filled the PPM for this week';
        ppmSetting.hellooo__Is_Active__c = true;
        ppmSetting.hellooo__PPM_Manager_Email__c = 'himanshu.bhatt@morganstanley.com';
        ppmSetting.hellooo__PPM_Reminder_Email_Body__c = '<html><head><style> #contactName{font-weight: bold;color: rgb(8, 150, 168); }#emailBody{color: rgb(8, 150, 168);font-family: serif; }</style></head><body><label id="contactName">Hi {DisplayName}</label><p id="emailBody">Gentle PPM Reminder !!! <br><br> Kindly fill <a href="http://ppm/">This Week PPM</a> by EOD <br>And Confirm by clicking following link after completion of <a href="http://ppm/">PPM</a><br><br><a href="{confirmURL}">Done, I have completed my PPM</a><br><br> Thanks &amp; Regards<br></p><p class="MsoNormal"><span style="font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">Dinesh Moundekar&nbsp;&nbsp;&nbsp;<br></span><b><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">Morgan Stanley | Institutional &amp; Corporate Tech&nbsp;&nbsp;&nbsp;<br></span></b><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">A-2 &amp; A-3 | Software Technology Park | MIDC&nbsp;&nbsp;&nbsp;<br>Pune, 412114&nbsp;&nbsp;&nbsp;<br>Phone: +91 20 6735-1731 ext. 1731&nbsp;&nbsp;&nbsp;<br><a href="mailto:Dinesh.Moundekar@morganstanley.com">Dinesh.Moundekar@morganstanley.com</a>&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;<br></span><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:seagreen;mso-fareast-language:EN-GB">Be carbon conscious. Please consider our environment before printing this email. </span><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;</span><span style="color:#1F497D"><o:p></o:p></span></p><p></p></body></html>';
        ppmSetting.hellooo__PPM_Reminder_Email_Subject__c = 'CONFIRM ONCE DONE WITH PPM TODAY !!!';
        ppmSetting.hellooo__PPM_Status_Email_Body__c = '<html><head><style>#displayName{font-weight: bold;color: rgb(8, 150, 168);}#emailBody{color: rgb(8, 150, 168);font-family: serif;}table {border-collapse: collapse;Width:100%;text-align: left;color: rgb(8, 107, 119);}table, td, th {border: 1px solid silver;text-align: left;}</style></head><body><label id="displayName">Hi Himanshu</label>  <p id="emailBody">  Following is the status of our team <br><br>  <table><tr><th>SR. No.</th><th>Team</th><th>Compliance champ</th><th>This week Timesheet Status</th></tr><tr><td>1</td><td>CI CAM</td><td>Dinesh Moundekar</td><td>{THISWEEKPPMSTATUS}</td></tr></table>Timesheet Pending<table><tr><th>SR. No.</th><th>Associate Name</th><th>Timesheet Status</th><th>Reason</th></tr>{DEFAULTERSTIMESHEET}</table></br>Kindly reply to Himanshu if any information is incorrect.</br></br>Thanks &amp; Regards<p class="MsoNormal"><span style="font-size:10.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">Dinesh Moundekar&nbsp;&nbsp;&nbsp;<br></span><b><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">Morgan Stanley | Institutional &amp; Corporate Tech&nbsp;&nbsp;&nbsp;<br></span></b><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">A-2 &amp; A-3 | Software Technology Park | MIDC&nbsp;&nbsp;&nbsp;<br>Pune, 412114&nbsp;&nbsp;&nbsp;<br>Phone: +91 20 6735-1731 ext. 1731&nbsp;&nbsp;&nbsp;<br><a href="mailto:Dinesh.Moundekar@morganstanley.com">Dinesh.Moundekar@morganstanley.com</a>&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;<br></span><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:seagreen;mso-fareast-language:EN-GB">Be carbon conscious. Please consider our environment before printing this email. </span><span style="font-size:7.5pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;;color:black;mso-fareast-language:EN-GB">&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;</span><span style="color:#1F497D"><o:p></o:p></span></p>  </p></body></html>';
        ppmSetting.hellooo__PPM_Status_Email_Subject__c = 'This Week PPM Status';
        ppmSetting.hellooo__Send_Report_Time_In_HR__c = 16;
        ppmSetting.hellooo__Success_Message__c = 'Thanks for your Time';
        
        insert ppmSetting;
        
        
    }
}