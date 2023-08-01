Flock flock;

void setup() {
  size(700, 500);
  flock = new Flock();
  // Crear grupo inicial de personas en ubicaciones aleatorias.
  for (int i = 0; i < 10; i++) {
    float y = random(10,600);
    flock.addPerson(new Person(25,y));
  }
}

void draw() {
  background(0);
  stroke(255);
  line(0,0,600,216);
  stroke(255);
  line(600,284,0,500);
  circle(200,200,50);
  circle(380,280,30);
   
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addPerson(new Person(mouseX,mouseY));
}
