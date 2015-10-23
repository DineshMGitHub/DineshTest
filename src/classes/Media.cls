public class Media {

    public PageReference redirect() {
    PageReference p = new PageReference ('/apex/useStandardController');
    //p.setRedirect(true);
        return p;
      //return null;
    }
    
    public Media(){
        currentMedia = new Media__c ();
    }

    public Media__c currentMedia { get; set; }
    public String getValue(){
        system.debug('currentMedia: ' + currentMedia);
        return String.valueOf(currentMedia);
    }
}