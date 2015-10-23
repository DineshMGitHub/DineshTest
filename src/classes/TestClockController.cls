@isTest 
private class TestClockController{
    static testMethod void positiveTest() {
        ClockController c = new ClockController();
        c.currentTime();
    }
}