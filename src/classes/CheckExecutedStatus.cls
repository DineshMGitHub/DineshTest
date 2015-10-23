public class CheckExecutedStatus
{
    private static Boolean isExecuted;{isExecuted = false;}
    
    
    public static Boolean getIsExecuted()
    {
        return isExecuted;
    }
    
    public static void setIsExecuted(Boolean val)
    {
        isExecuted = val;
    }
}