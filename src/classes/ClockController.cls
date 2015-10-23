public class ClockController {

    public String stringTime { get; set; }

    public ClockController(){
        stringTime = String.valueOf(System.now());             
    }
    
    public PageReference currentTime() {   
        return null;
    }

}