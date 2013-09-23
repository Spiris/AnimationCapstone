class FlowEditor {
  ArrayList<FlowFieldObject> flows;
  ArrayList<MenuElement> elements;
  int mode;
  FlowFieldObject flow;
  Brush brush;
  FlowEditor() {
    flows = new ArrayList<FlowFieldObject>();
    elements = new ArrayList<MenuElement>();
    elements.add(new MenuElement(220, 78, 100, 26, "Brush"));
    elements.add(new MenuElement(220, 106, 100, 26, "Point"));
    mode = 0;
    flow = null;
    brush = new Brush();
  }
  void edit() {
    for (int i = 0; i < elements.size(); i++) {
      MenuElement e = elements.get(i);
      if (i == mode)
        e.drawSelected();
      else {
        e.mouseInside(mouseX, mouseY);
        e.drawNormal();
      }
    }
    if (flow != null) {
      flow.position.set(mouseX, mouseY);
      flow.draw();
    }
    if (mode == 0)
      brush.draw();
  }
  void render() {
    for ( FlowFieldObject f : flows )
      f.draw();
  }

  void mouseDragged() {
    if (mode == 0)
      paint();
  }
  void mouseClicked() {
    for (int i = 0; i < elements.size(); i++) {
      MenuElement e = elements.get(i);
      if (e.highlighted) {
        mode = i;
        e.highlighted = false;
        flow = null;
        return;
      }
    }
    if (mode != 0) {
      if (shift)
        setAndCreateFlowObj();
      else if (ctrl)
        grabFlowObj();
      else
        addOrCreateFlowObj();
    }
  }
  void keyReleased() {
    if (key == DELETE || key == BACKSPACE)
      removeFlowObj();
  }
  void keyPressed() {
  }


  void setAndCreateFlowObj() {
    if (flow != null) {
      flows.add(flow);
      flow = null;
    }
    if (mode == 1)
      flow = new FlowPoint(mouseX, mouseY);
  }

  void addOrCreateFlowObj() {
    if (flow != null) {
      flows.add(flow);
      flow = null;
      return;
    }
    if (mode == 1) 
      flow = new FlowPoint(mouseX, mouseY);
  }

  void grabFlowObj() {
    if (flow != null) {
      return;
    }
    for (int i = 0; i < flows.size(); i++) {
      FlowFieldObject f = flows.get(i);
      if (f.pointInside(mouseX, mouseY)) {
        flow = flows.remove(i);
      }
    }
  }

  void removeFlowObj() {
    if (flow != null)
      flow = null;
  }

  void paint() { 
    for (int i = 0; i < flows.size(); i++) {
      FlowFieldObject f = flows.get(i);
      float d = dist( mouseX, mouseY, f.position.x, f.position.y );
      if (d < brush.size) {
        float strength = map( d, 0, brush.size, 0.01, 0 ) * brush.strength;
        PVector v = new PVector( mouseX - pmouseX, mouseY - pmouseY );
        v.normalize();
        v.mult( strength );
        f.force.add( v );
        f.force.limit(1); // make sure those vectors dont get TOO big.
      }
    }
  }
}

class Brush {
  float strength;
  float size;
  MenuElement str_elem;
  MenuElement size_elem;

  Brush() {
    strength = 5.0f;
    size = 50.0f;
    str_elem = new MenuElement(10, height - 36, 150, 26, "Str- " + strength);
    size_elem = new MenuElement(10, height - 64, 150, 26, "Size- " + size);
  }
  void draw() {
    str_elem.text = "Str- " + strength;
    size_elem.text = "Size- " + size;
    str_elem.drawNormal();
    size_elem.drawNormal(); 
    pushMatrix();
    translate(mouseX, mouseY);
    stroke(255);
    strokeWeight(1);
    fill(255, 70);
    ellipseMode(CENTER);
    ellipse(0, 0, size * 2, size * 2);
    popMatrix();
  }
}
class FlowFieldObject {
  PVector position;
  PVector force;
  float radius;

  FlowFieldObject(float x, float y) {
    this.position = new PVector(x, y);
    this.force = new PVector(0.1, 0);
  }
  boolean pointInside(float x, float y) { 
    return false;
  }
  void draw() {
  }
}

class FlowPoint extends FlowFieldObject {

  FlowPoint(float x, float y) {
    super(x, y);
    radius = 20;
  }
  boolean pointInside(float x, float y) { 
    return dist(x, y, position.x, position.y) < radius;
  }
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    fill(0, 200, 255, 80);
    ellipse(0, 0, radius, radius);
    ellipse(0, 0, 2, 2);
    stroke(255);
    strokeWeight(2);
    line(0, 0, force.x * 20, force.y * 20);
    popMatrix();
  }
}

