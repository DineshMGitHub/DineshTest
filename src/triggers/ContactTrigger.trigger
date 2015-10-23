trigger ContactTrigger on Contact (After Insert, After Update, Before Delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        ContactTriggerHandler.afterInsert(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        ContactTriggerHandler.afterUpdate(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        ContactTriggerHandler.afterdelete(Trigger.old);
    }
}