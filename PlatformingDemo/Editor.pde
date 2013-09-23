class Editor {
  EdgeEditor edge_editor;
  PolygonEditor polygon_editor;
  FlowEditor flow_editor;
  ArrayList<MenuElement> elements;
  int mode;
  boolean holding_player;
  Editor() {
    mode = 0;
    edge_editor = new EdgeEditor();
    polygon_editor = new PolygonEditor();
    flow_editor = new FlowEditor();
    holding_player = false;
    elements = new ArrayList<MenuElement>();
    elements.add(new MenuElement(10, 10, 200, 26, "Place Player"));
    elements.add(new MenuElement(10, 38, 200, 26, "Platforming Edge"));
    elements.add(new MenuElement(10, 66, 200, 26, "Obstacle Polygon"));
    elements.add(new MenuElement(10, 94, 200, 26, "Flow Field"));
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
    switch(mode) {
    case 0:
      if (holding_player)
        player.position.set(mouseX, mouseY);
      break;
    case 1:
      edge_editor.edit();
      break;
    case 2:
      polygon_editor.edit();
      break;
    case 3:
      flow_editor.edit();
      break;
    case 4:
      break;
    default:
      break;
    }
    render();
  }
  void render() {
    polygon_editor.render();
    edge_editor.render();
    flow_editor.render();
  }

  void keyReleased() {
    if (key == CODED) {
      if (keyCode == DOWN) 
        mode = min(mode + 1, elements.size() - 1);
      if (keyCode == UP)
        mode = max(mode - 1, 0);
    }
    switch(mode) {
    case 0:

      break;
    case 1:
      edge_editor.keyReleased();
      break;
    case 2:
      polygon_editor.keyReleased();
      break;
    case 3:
      flow_editor.keyReleased();
    break;
    case 4:
      break;
    default:
      break;
    }
  }

  void mouseClicked() {
    for (int i = 0; i < elements.size(); i++) {
      MenuElement e = elements.get(i);
      if (e.highlighted) {
        mode = i;
        e.highlighted = false;
        return;
      }
    }

    switch(mode) {
    case 0:
      holding_player = !holding_player;
      break;
    case 1:
      edge_editor.mouseClicked();
      break;
    case 2:
      polygon_editor.mouseClicked();
      break;
      case 3:
      flow_editor.mouseClicked();
      break;
    case 4:
      break;
    default:
      break;
    }
  }
  void mouseDragged() {
    switch(mode) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
      case 3:
      flow_editor.mouseDragged();
      break;
    case 4:
      break;
    default:
      break;
    }
  }
}

class MenuElement {
  PVector position;
  float w, h;
  String text;
  boolean highlighted;
  MenuElement(float x, float y, float w, float h, String text) {
    this.position = new PVector(x, y);
    this.w = w;
    this.h = h;
    this.text = text;
    this.highlighted = false;
  }
  void mouseInside(float x, float y) {
    highlighted = (x > position.x && x < position.x + w && y > position.y && y < position.y + h);
  }
  void drawHighlighted() {
    pushMatrix();
    rectMode(CORNER);
    translate(position.x, position.y);
    stroke(0);
    strokeWeight(1);
    fill(0, 0, 200);
    rect(5, 0, w, h);
    fill(255);
    textAlign(CENTER, CENTER);
    text(text, w / 2, h / 2 - 3);
    popMatrix();
  }
  void drawNormal() {
    if (highlighted) {
      drawHighlighted();
      return;
    }
    pushMatrix();
    rectMode(CORNER);
    translate(position.x, position.y);
    stroke(0);
    strokeWeight(1);
    fill(100);
    rect(0, 0, w, h);
    fill(255);
    textAlign(CENTER, CENTER);
    text(text, w / 2, h / 2 - 3);
    popMatrix();
  }
  void drawSelected() {
    pushMatrix();
    rectMode(CORNER);
    translate(position.x, position.y);
    stroke(255);
    strokeWeight(1);
    fill(255, 0, 0);
    rect(5, 0, w, h);
    fill(255);
    textAlign(CENTER, CENTER);
    text(text, w / 2, h / 2 - 3);
    popMatrix();
  }
}

