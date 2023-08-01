// The Flock (a list of Person objects)

class Flock {
  ArrayList<Person> persons; // An ArrayList for all the Persons

  Flock() {
    persons = new ArrayList<Person>(); // Initialize the ArrayList
  }
  
  void run() {
    for (Person b : persons) {
      b.run(persons);
      b.checkCollision(new PVector(200,200),32);
      b.checkCollision(new PVector(380,280),22);
    }
  }
  void addPerson(Person b) {
    persons.add(b);
  }

}
