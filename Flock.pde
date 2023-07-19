// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Person> persons; // An ArrayList for all the boids

  Flock() {
    persons = new ArrayList<Person>(); // Initialize the ArrayList
  }
  
  void run() {
    for (Person b : persons) {
      b.run(persons);  // Passing the entire list of boids to each boid individually
    }
  }

  void addPerson(Person b) {
    persons.add(b);
  }

}
