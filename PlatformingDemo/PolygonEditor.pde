class PolygonEditor {
  ArrayList<Square> polys;
  Square poly;
  PolygonEditor() {
    polys = new ArrayList<Square>();
    poly = null;
  }
  void edit() {
    if (poly != null) {
      poly.position.set(mouseX, mouseY);
      poly.draw();
    }
  }
  void render() {
    for (Square p : polys)
      p.draw();    
  }
  void mouseClicked() {
    if (shift) {
      setAndCreatePoly();
    }
    else if (ctrl) {
      grabPoly();
    }
    else {
      addOrCreatePoly();
    }
  }
  void setAndCreatePoly() {
    if(poly != null) {
      polys.add(poly);
      poly = null;
    }
    poly = new Square(mouseX, mouseY);
  }

  void addOrCreatePoly() {
    if (poly != null) {
      polys.add(poly);
    poly = null;
      return;
    }
    poly = new Square(mouseX, mouseY);
  }
  
  void grabPoly() {
    if (poly != null) {
      return;
    }
    for (int i = 0; i < polys.size(); i++) {
      Square s = polys.get(i);
      if (s.pointInside(mouseX, mouseY)) {
        poly = polys.remove(i);
      }
    }
  }
  
  void removePoly() {
    if(poly != null)
      poly = null;
  }
  void keyReleased() {
    if(key == DELETE || key == BACKSPACE)
      removePoly();
  }
}
class Square {
  PVector position;
  float w, h;
  Square(float x, float y) {
    this.position = new PVector(x, y);
    this.w = 32;
    this.h = 32;
  }
  boolean pointInside(float x, float y) {
    if (x < position.x) return false;
    if (x > position.x  + w) return false;
    if (y < position.y) return false;
    if (y > position.y + h) return false;
    return true;
  }
  void draw() {
    rectMode(CORNER);
    pushMatrix();
    translate(position.x, position.y);
    stroke(100, 0, 0);
    fill(255, 0, 0, 70);
    rect(0, 0, w, h);
    popMatrix();
  }
}

