@RestResource(urlMapping='/feed-items/*')

global class ConnextApiDemo1 {

    global ConnextApiDemo1(ApexPages.StandardController controller) {
        //ConnectApi.FeedItemPage testPage = new ConnectApi.FeedItemPage();
        //ConnectApi.ChatterFeeds.getFeedPoll('','');
    }
    global ConnextApiDemo1(){

    }
    
    @HttpGet
    global static String doGet() {
    
        return 'Working??';
        /*RestRequest req = RestContext.request;
        Map<String,String> paramsMap = new Map<String,String>();
        system.debug('Request:'+req );
        if(req !=null){
            paramsMap = req.params;    
            String totalVoteCount= paramsMap.get('totalVoteCount');
            return 'Total count ='+totalVoteCount;
        }else{
            return 'In Else' +String.valueOf(req);
        }*/
        
    }

}