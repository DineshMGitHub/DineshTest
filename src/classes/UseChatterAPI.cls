public class UseChatterAPI {


    public String xmlResult { get; set; }
    public string pollCount{get; set;}
    public List<PollChoice> pollChoiceList{get; set;}
    
    public List<Account> accounts{get; set;}
    
    public String totalVoteCount{get; set;}
    public String myChoiceId {get; set;}
    public String type {get; set;}
    
    public String getSessionID(){
        return UserInfo.getSessionId();
    }
    
    public UseChatterAPI (){ 
            //ConnectApi.FeedItemPage testPage = new ConnectApi.FeedItemPage();
        pollChoiceList = new List<PollChoice>();
        String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String url = 'https://ap1.salesforce.com/services/data/v27.0/chatter/feed-items/0D59000000ESRk1CAH/poll';
        req.setEndpoint(url);
        req.setHeader('Content-type', 'application/xml');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        //pollCount = String.valueOf(resp);
        System.debug(resp.getBody());
        pollCount = 'Response : '+resp.getBody();
        JSONParser parser = JSON.createParser(resp.getBody());
        
        xmlResult = String.valueOf(parser) ;
        
        while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    PollChoice choice= (PollChoice)parser.readValueAs(PollChoice.class);
                    system.debug('totalVoteCount number: ' + choice.voteCount);
                    //system.debug('Size of Choice list items: ' + inv.choice.size());
                    // For debugging purposes, serialize again to verify what was parsed.
                    String s = JSON.serialize(choice);
                    system.debug('Serialized invoice: ' + s);
                    pollChoiceList.add(choice);

                    // Skip the child start array and start object markers.
                    parser.skipChildren();
                }else if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    String fieldName = parser.getCurrentName();
                    String fieldValue = parser.getText();
                    System.debug('--->'+fieldName +' = '+ fieldValue );
                    if(fieldName.equals('totalVoteCount')){
                        totalVoteCount = fieldValue;
                    }else if(fieldName.equals('myChoiceId')){
                        myChoiceId = fieldValue;
                    }else if(fieldName.equals('type')){
                        type = fieldValue;
                    }
                }
            }
        }
    }
        
        /* Code to post Feed from Apex
        http://salesforce.stackexchange.com/questions/1545/how-can-i-add-an-mention-when-creating-a-feeditem-via-apex*/
    }
    
    public class PollChoice{
        public String id;
        public String text;
        public String position;
        public String voteCount;
        public String voteCountRatio;
        
        public String getID(){
            return this.id;
        }
        
         public String getText(){
            return this.text;
        }
        
         public String getPosition(){
            return this.position;
        }
        
         public String getVoteCount(){
            return this.voteCount;
        }
        
        public String getVoteCountRatio(){
            return this.voteCountRatio;
        }
    }
}