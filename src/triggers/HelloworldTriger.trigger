trigger HelloworldTriger on Position__c (before insert, before update) {

    system.debug('Oldhellooo__TestFormula__c' + Trigger.Old[0].hellooo__TestFormula__c);
    system.debug('Newhellooo__TestFormula__c' + Trigger.New[0].hellooo__TestFormula__c);
    List<Position__c> positions = Trigger.New;
    HelloworldOnPosition.applyHelloworld(positions);
}