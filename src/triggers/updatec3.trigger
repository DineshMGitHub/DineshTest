trigger updatec3 on Account (after update) {
    C3__c getsinglerecord = [Select Name from C3__c Limit 1];
    getsinglerecord.Name = 'Test' + String.valueOf(System.Now());
    update getsinglerecord;
}