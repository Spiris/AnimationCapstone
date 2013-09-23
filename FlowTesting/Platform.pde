class Platform {
  PVector position;
  float w, h;
  Platform(float x, float y, float w, float h) {
    this.position = new PVector(x, y);
    this.w = w;
    this.h = h;
  }
  void update() {}
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rectMode(CORNER);
    rect(0,0,w,h);
    popMatrix();
  }

}

