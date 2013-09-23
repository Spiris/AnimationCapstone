/*
  Jason Ryan
 Bread and Butter Games - Capstone
 Edge Editor - Sky Breaker
 2013.9.19
 
 A basic editing tool used to manipulate virtual 
 edges used for the vectorial platforming in the game
 
 DONE:
 basic edge editing
 
 TODO:
 improved deletion methods
 */
class EdgeEditor {
  ArrayList<Edge> edges; // the edges that have been added to the game
  Edge e1, e2; // the edges being edited

  EdgeEditor() {
    edges = new ArrayList<Edge>(); 
    edges.add(new Edge(30, 300, 300, 300));

    e1 = null; 
    e2 = null;
  }  
  void edit() {
    if (e1 != null) {  // update the points of the edges currently selected only
      e1.a.set(mouseX, mouseY);
      e1.v = PVector.sub(e1.b, e1.a);
      e1.norm = e1.v.get();
      e1.norm.normalize();
      e1.perp = new PVector(e1.v.y, -e1.v.x);
      e1.perp.normalize();
      e1.draw();
    }
    if (e2 != null) {
      e2.b.set(mouseX, mouseY);
      e2.v = PVector.sub(e2.b, e2.a);
      e2.norm = e2.v.get();
      e2.norm.normalize();
      e2.perp = new PVector(e2.v.y, -e2.v.x);
      e2.perp.normalize();
      e2.draw();
    }      
  }
  void render() {
    for (Edge e : edges) 
      e.draw();
  }

  void keyReleased() {
    if (key == DELETE || key == BACKSPACE)
      removeEdge();
  }

  void mouseClicked() {
    if (shift)
      setAndStartEdge();
    else if (ctrl)
      grabPoints();
    else
      dropPoints();
  }

  void removeEdge() { // removes all edges currently selected
    if (e2 != null) 
      e2 = null;
    if (e1 != null)
      e1 = null;
  }

  // selects a nearby edge point, selecting its edge in the process
  // can select two if stacked, but only if the poles are opposite eachother
  void grabPoints() {  
    if (e1 != null || e2 != null)
      return;
    for (int i = 0; i < edges.size(); i++) {
      Edge e = edges.get(i);
      if (dist(e.b.x, e.b.y, mouseX, mouseY) < 10) {
        e2 = edges.remove(i);
        break;
      }
    }
    for (int i = 0; i < edges.size(); i++) {
      Edge e = edges.get(i);
      if (dist(e.a.x, e.a.y, mouseX, mouseY) < 10) {
        e1 = edges.remove(i);
        break;
      }
    }
  }

  void dropPoints() { // release all current edges and add them to the game
    if (e2 == null && e1 == null) {
      e2 = new Edge(mouseX, mouseY, mouseX, mouseY);
      return;
    }
    if (e2 != null) {
      edges.add(e2);
      e2 = null;
    }
    if (e1 != null) {
      edges.add(e1);
      e1 = null;
    }
  }

  void setAndStartEdge() { // drops any held edges, creating a polyedge with a newly added edge.
    addEdgeToPoly();
    e2 = new Edge(mouseX, mouseY, mouseX, mouseY);
  }
  void addEdgeToPoly() {
    if (e2 == null)
      return;
    edges.add(e2);
    e2 = null;
  }

  void backOffEdge() { // removes he current edge in the list, selected the new last edge in the list (NEEDS IMPROVEMENT)
    if (edges.size() > 0)
      e2 = edges.remove(edges.size() - 1);
  }
}
class PolyEdge {
  ArrayList<Edge> edges;
  PolyEdge() {
    edges = new ArrayList<Edge>();
  }
  void draw() { 
    fill(0);
    for (Edge e : edges)
      e.draw();
  }
}
class Edge {
  PVector a, b, perp, v, norm;
  Edge() {
    a = new PVector();
    b = new PVector();
    v = new PVector();
    norm = new PVector();
    perp = new PVector();
  }
  Edge(float xa, float ya, float xb, float yb) {
    a = new PVector(xa, ya);
    b = new PVector(xb, yb);
    v = PVector.sub(b, a);
    norm = v.get();
    norm.normalize();
    perp = new PVector(v.y, -v.x);
    perp.normalize();
  }

  void draw() {
    stroke(120);
    strokeWeight(2);
    pushMatrix();
    translate(a.x, a.y);
    line(0, 0, v.x, v.y);
    strokeWeight(3);
    stroke(255, 0, 0);
    line(0, 0, norm.x * 10, norm.y * 10);
    stroke(0, 255, 0);
    line(0, 0, perp.x * 10, perp.y * 10);
    fill(255);
    stroke(120);
    strokeWeight(2);
    ellipse(0, 0, 5, 5);
    ellipse(v.x, v.y, 5, 5);
    popMatrix();
  }

  PVector closestPointOnEdge(PVector p) {
    PVector v = PVector.sub(a, b);
    PVector o = PVector.sub(a, p);
    PVector n = v.get(); 
    n.normalize();

    float dp = o.dot(n);
    if (dp < 0)
      return a;
    if (dp > v.mag())
      return b;
    n.mult(-dp);
    n.add(a);
    return n;
  }
}

