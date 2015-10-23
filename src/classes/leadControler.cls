public with sharing class leadControler {

    public leadControler(ApexPages.StandardController controller) {

    }

    public Lead getLeadInfo(){
        string leadID= ApexPages.currentPage().getParameters().get('leadID');
        return [Select LastName, Status From Lead Where id=: leadID];
    }
}