global class PersonWrapper implements Comparable {
    public Person p;
    // Constructor
    public PersonWrapper (Person op) {
        p = op;
    }
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        PersonWrapper compareToPerson = (PersonWrapper)compareTo;
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (p.name > compareToPerson.p.name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (p.name < compareToPerson.p.name) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        if(returnValue == 0){
            if (p.weight > compareToPerson.p.weight) {
                // Set return value to a positive value.
                returnValue = -1;
            } else if (p.weight < compareToPerson.p.weight) {
                // Set return value to a negative value.
                returnValue = 1;
            }
        }
        
        if(returnValue == 0){
            if (p.height > compareToPerson.p.height) {
                // Set return value to a positive value.
                returnValue = -1;
            } else if (p.height < compareToPerson.p.height) {
                // Set return value to a negative value.
                returnValue = 1;
            }
        }
        
        return returnValue;
    }
}