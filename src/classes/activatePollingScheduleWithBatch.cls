global class activatePollingScheduleWithBatch implements Schedulable{
        global void execute(SchedulableContext SC) {
            ActivatePollingBatchClass pollingBatch = new ActivatePollingBatchClass();
            String cronStr = '0 0,59 * * * *';
            database.executebatch(pollingBatch);
        }
}