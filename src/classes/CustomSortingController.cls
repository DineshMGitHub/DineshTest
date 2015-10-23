public class CustomSortingController {
    public List<Person> personList {get; set;}
    public List<Person> sortedPersonList {get; set;}
    public List<String> sortedPersonName{get; set;}
    public List<Integer> sortedPersonWeight{get; set;}
    public List<PersonWrapper> personWrapperList {get; set;}
    
    public CustomSortingController(){
        personList = new List<Person>();
        personWrapperList = new List<PersonWrapper>();
        
        
        
        personList.add(new Person('Aditya', 30, 122.4));
        personWrapperList.add(new PersonWrapper(new Person('Aditya', 30, 122.4)));
        
        personList.add(new Person('Aditya', 20, 122.4));
        personWrapperList.add(new PersonWrapper(new Person('Aditya', 20, 122.4)));
        
        personList.add(new Person('Dinesh', 60, 150));
        personWrapperList.add(new PersonWrapper(new Person('Dinesh', 60, 150)));
        
        
        
        personList.add(new Person('Dinesh', 60, 150.56));
        personWrapperList.add(new PersonWrapper(new Person('Dinesh', 60, 150.56)));
        
        personList.add(new Person('Dinesh', 30, 150.56));
        personWrapperList.add(new PersonWrapper(new Person('Dinesh', 30, 150.56)));
        
        personList.add(new Person('Aditya', 30, 122.5));
        personWrapperList.add(new PersonWrapper(new Person('Aditya', 20, 122.5)));
        
        personList.add(new Person('Mangesh', 80, 120.2));
        personWrapperList.add(new PersonWrapper(new Person('Mangesh', 80, 120.2)));
        
        personList.add(new Person('Mangesh', 80, 120.6));
        personWrapperList.add(new PersonWrapper(new Person('Mangesh', 80, 120.6)));
        
        personList.add(new Person('Mangesh', 50, 120.3));
        personWrapperList.add(new PersonWrapper(new Person('Mangesh', 50, 120.3)));
        
        personList.add(new Person('Dinesh', 60, 150.1));
        personWrapperList.add(new PersonWrapper(new Person('Dinesh', 60, 150.1)));
        
        /*for(Integer i = 0; i < 10; i++){
            personList.add(new Person('Name-' + i + ' ', i*10));
            personWrapperList.add(new PersonWrapper(new Person('Name-' + i + ' ', i*10)));
        }*/
        
        personWrapperList.sort();
        
        sortedPersonList = new List<Person>();
        for(PersonWrapper currentWrapper : personWrapperList){
            sortedPersonList.add(currentWrapper.p);
        }
    }   
}