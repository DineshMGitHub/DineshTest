public class HelloworldOnPosition{
    public static void applyHelloworld(List<Position__c> positions){
        for(Position__c p:positions){
            if(p.Hello__c != 'World'){
                p.Hello__c = 'World';
            }
        }
    }
}