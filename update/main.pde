Wall topWall, btmWall;
Pillar topPillar, btmPillar;

ArrayList<Person> persons;
ArrayList<Pillar> pillars;
ArrayList<Wall> walls;

void setup() {
  persons = new ArrayList<Person>();
  pillars = new ArrayList<Pillar>();
  walls = new ArrayList<Wall>();
  
  size(700, 500);
  
  topWall = new Wall(0, 0, 600, 216);
  btmWall = new Wall(600, 284, 0, 500);
  
  walls.add(topWall);
  walls.add(btmWall);

  topPillar = new Pillar(200, 200, 50);
  btmPillar = new Pillar(380, 280, 30);
  
  pillars.add(topPillar);
  pillars.add(btmPillar);
  for (int i = 0; i < 10; i++) {
    float y = random(10, 500);
    persons.add(new Person()
      .setInitialPosition(25, y)
      .setInitialVelocity(0, 0)
    );
  }
}

void draw () { // randomGaussian() * (height - 15)
  background(255);
    
  for(Wall w : walls) {
    w.render();
  }
 
  for(Pillar p : pillars) {
    p.render();
  }
  
  for(Person p : persons) {
    p.target();
    p.wallsForceAgainstPerson(walls);
    p.pillarsForceAgainstPerson(pillars);
    p.personsForce(persons);
    
    p.update();
    p.display();
  }

}
