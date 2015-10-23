/**
 * 24 June 2014:        Dinesh M:       Created 
 */
@isTest(SeeAllData=true)
private class TestGetAllLimits {

    static testMethod void myUnitTest() {
        LimitController lc = new LimitController();
        lc.updateObjectMetadata();
        Database.executeBatch(new Batch_GenerateApexClassMetadata(), 2000);
    }
}