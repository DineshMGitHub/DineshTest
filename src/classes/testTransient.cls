public class testTransient{
    public DateTime date1 = System.now();
    transient DateTime date2 = System.now();

    public testTransient() {
        System.debug('Date operations:'+addSubDates(true));
    }
    public Integer addSubDates(Boolean operation) {
        Integer myvar=0;
        if (date1!=null && date2 != null) {
            if(operation){
                myvar = date1.day()+date2.day();
            } else {
                myvar= date2.day()-date1.day();
            }
        }
        return myvar;
    }

    public Datetime getT2() {
        if (date2 == null)
            date2 = System.now();
            return date2;
    }
    public Datetime getT1() {
        if (date1 == null) 
            date1 = System.now();
            return date1;
    }
    
    public void go(){
        system.debug('----Constructor Go Method----');
    }
}