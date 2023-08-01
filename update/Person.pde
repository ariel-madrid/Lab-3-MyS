float MAX_SPEED = 3;
float MAX_FORCE = 1;

class Person {
  float size = 15;
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  Person () {
    acceleration = new PVector(0, 0);
  }
  
  float getSize() {
    return size;
  }
   
  Person setInitialPosition(float x0, float y0) {
    position = new PVector(x0, y0);
    return this;
  }
   
  Person setInitialVelocity(float x0, float y0) {
    velocity = new PVector(x0, y0);
    return this;
  }
  
  void update() {
    velocity
      .add(acceleration)
      .limit(MAX_SPEED);
      
    position.add(velocity);
    acceleration.mult(0);
  }
 
  void display() {
    stroke(0);
    fill(0);
    circle(position.x, position.y, size);
  }
  
  // Calcular f_ij -> fuerza ejercida por persona j sobre persona i.
  void personsForce(ArrayList<Person> persons) {
    float desiredSeparation = 30;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every Person in the system, check if it's too close
    for (Person other : persons) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredSeparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(MAX_SPEED);
      steer.sub(velocity);
      steer.limit(MAX_FORCE);
    }
    
    steer.mult(1.5);
    applyForce(steer);
  }
  

  void checkCollision(PVector pilar, float radio) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(pilar, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float r = size / 2;
    float minDistance = r + radio;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      //other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      //bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      //bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      //vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      //vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      //vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      //vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      //other.position.x = position.x + bFinal[1].x;
      //other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);
    }
  }
  
  void pillarsForceAgainstPerson(ArrayList<Pillar> pillars) {
    PVector fip = new PVector(0, 0);
    for(Pillar p : pillars) {
      checkCollision(new PVector(p.xStart, p.yStart), p.r);
    }
  }
  
  
  void wallsForceAgainstPerson(ArrayList<Wall> walls) {
    PVector fiw = new PVector(0, 0);
    float AGENT_TO_WALL_DISTANCE_TOLERANCE = 25;
    
    for(Wall w : walls) {
      // Calcular el vector normal a la pared.
      PVector wallPosition = PVector.sub(w.getEndPoint(), w.getStartPoint());
      PVector wallNormal = new PVector(-1 * wallPosition.y, wallPosition.x);
      
      PVector distance = PVector.sub(w.getStartPoint(), position);
      
      // Calculate the perpendicular distance from the agent to the line
      float perpendicularDistance = distance.cross(wallPosition).mag() / wallPosition.mag();
      if (perpendicularDistance < AGENT_TO_WALL_DISTANCE_TOLERANCE) {
        // Calculate the direction of the repulsive force
        PVector repulsiveDirection = new PVector(-1 * wallPosition.y, wallPosition.x).normalize();
        
        // Calculate the magnitude of the repulsive force
        float repulsiveMagnitude = wallNormal.mag() / (perpendicularDistance*perpendicularDistance + 1);
        
        // Calculate the repulsive force
        fiw.add(repulsiveDirection.mult(repulsiveMagnitude));
      }
    }
    applyForce(fiw);
  }
  
  void target() {
    float targetX = 700;
    float targetY = 0;
    
    if (position.y < 216) { // Parte superior.
      targetY = 224;
    } else if (position.y > 284) { // Parte inferior.
      targetY = 276;
    } else {
      targetY = position.y;
    }
   
    PVector desired = new PVector(targetX, targetY)
      .sub(position)
      .setMag(MAX_SPEED);
    
    applyForce(desired);
  }
  
  void applyForce(PVector f) { // F = M*A
    acceleration.add(f);
  }
}
