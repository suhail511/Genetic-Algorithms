class Rocket {

  // All of our physics stuff
  PVector position;
  PVector velocity;
  PVector acceleration;

  // Size
  float r;

  // Fitness and DNA
  float fitness;
  DNA dna;
  // To count which force we're on in the genes
  int geneCounter = 0;

  boolean hitTarget = false;   // Did I reach the target
  
  //constructor
  Rocket(PVector l, DNA dna_) {
    acceleration = new PVector();
    velocity = new PVector();
    position = l;
    r = 4;
    dna = dna_;
  }

  // Fitness function
  // fitness = one divided by distance squared
  void fitness() {
    float d = dist(position.x, position.y, target.x, target.y);
    fitness = pow(1/d, 3);
    //fitness = map(fitness,0,0.1,0,10000);
  }

  // Run in relation to all the obstacles
  // If I'm stuck, don't bother updating or checking for intersection
  void run() {
    checkTarget(); // Check to see if we've reached the target
    if (!hitTarget) {
      applyForce(dna.genes[geneCounter]);
      geneCounter = (geneCounter + 1) % dna.genes.length;
      update();
    }
    display();
  }

  // Did I make it to the target?
  void checkTarget() {
    float d = dist(position.x, position.y, target.x, target.y);
    if (d < 12) {
      hitTarget = true;
    } 
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    float theta = velocity.heading2D() + PI/2;
    fill(200, 100);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);

    // Thrusters
    rectMode(CENTER);
    fill(0);
    rect(-r/2, r*2, r/2, r);
    rect(r/2, r*2, r/2, r);

    // Rocket body
    fill(175);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();

    popMatrix();
  }

  float getFitness() {
    return fitness;
  }

  DNA getDNA() {
    return dna;
  }

}