class Player {
  PVector acceleration, velocity, position;
  PImage img;
  float drag, r;
  Player() {
   this.acceleration = new PVector(0, 0);
   this.velocity = new PVector(0, 0);
   this.position = new PVector(half_width, half_height);
   this.drag = 0.7f;
   this.r = 20.0f;
   this.img = loadImage("character_dev.png");
  } 
  void update() {
    this.velocity.y += 0.1;
    this.velocity.add(acceleration);
    velocity.x = constrain(velocity.x, -5, 5);
    velocity.y = constrain(velocity.y, -10, 10);
    if(abs(acceleration.x) == 0) {
      velocity.x *= drag;
    }
    if(position.y + velocity.y + r / 2 > the_platform.position.y  && position.x - velocity.x - r / 2 < the_platform.position.x + the_platform.w) {
      this.velocity.y = 0;
      this.position.y = the_platform.position.y - r / 2; 
    }
    this.position.add(velocity);
  }
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    ellipseMode(CENTER);
    ellipse(0,0,r,r);
    popMatrix();
  }
  
  
}
