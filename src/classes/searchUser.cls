public class searchUser {

    public Void getSearchUser() {
        
        String userInput = userName + '%';
        List<SelectOption> options = new List<SelectOption>();
        
        for(User currentUser : [SELECT UserName FROM User where UserName Like :userInput ] ){
            options.add(new SelectOption(currentUser.UserName  ,currentUser.UserName  ));
        }
        
        userResult = options ;
    }


    public List<SelectOption> userResult { get; set; }

    public String userName { get; set; }
}