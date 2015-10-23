public class RegexMatcher {

    Public String isWorking{get; set;}
    Public String matchingValue{get; set;}
    
    public RegexMatcher(){
        isWorking = 'false';
        isWorking = String.valueOf(Pattern.matches('a(.*?)b', 'a aaaaab b'));
        
        // First, instantiate a new Pattern object "MyPattern"
        Pattern MyPattern = Pattern.compile('public(.*?)\\)');
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher('public static void testregex(string me){hjhjhjh;   } \npublic static void testregex2(string me2){hjhjhjh;   }');
        
        // You can use the system static method assert to verify the match
        //System.assert(MyMatcher.matches());
        
        matchingValue = String.valueOf(MyMatcher.groupCount());
        
        while(MyMatcher.find()) {
            matchingValue += (MyMatcher.group(0)); //"aaaaab"
        }
    }
}