global class Person{
    public String name;
    public Integer weight;
    public Decimal height;
    
    public Person(String name, Integer weight, Decimal height){
        this.name = name;
        this.weight = weight;
        this.height = height;
    } 
    
    public String getName(){
        return name;
    }
    
    public Integer getWeight(){
        return weight;
    }
    
    public Decimal getHeight(){
        return height;
    }
}