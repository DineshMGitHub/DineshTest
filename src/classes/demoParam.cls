public with sharing class demoParam {
    public string param{get;set;}
        
    public PageReference acceptParam() {
        PageReference pr= new PageReference('/apex/DemoAcceptParm?id='+param);
        pr.setRedirect(false);
        return pr;
    }


}