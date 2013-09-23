class PlayerDot {
  PVector position;
  PlayerDot(float x, float y) {
    this.position = new PVector(x, y);
  }
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    ellipseMode(CENTER);
    fill(255,0,0,150);
    ellipse(0,0,10,10);
    popMatrix();
  }
}
