boolean shift, ctrl, editing;

Player player;
Editor editor;

PFont font;
PImage bg;

void setup() {
  size(1000, 700, P2D);
  smooth();
  font = createFont("Helvetica", 20);
  textFont(font);
  
  player = new Player(100, 100, 20, 30);
  bg = loadImage("platforms.png");
  editor = new Editor();
  editing = true;
  shift = false;
  ctrl = false;
}

void draw() {
  background(160);
  image(bg, 0, 0);
  player.draw();
  if (editing) {
    editor.edit();
  }
}

void keyPressed() {
  if (key == 'd')
    player.right = true;
  if (key == 'a')
    player.left = true;
  if (key == ' ' && !player.jumping)
    player.jump();
  if (key == CODED) {
    if (keyCode == SHIFT)
      shift = true;
    if (keyCode == CONTROL || keyCode == ALT)
      ctrl = true;
  }
}
void keyReleased() {
  if (key == 'd')
    player.right = false;
  if (key == 'a')
    player.left = false;
  if (key == ' ')
    player.jump = false;
  if (key == 'q')
    editing = !editing;
  if (key == CODED) {
    if (keyCode == SHIFT)
      shift = false;
    if (keyCode == CONTROL || keyCode == ALT)
      ctrl = false;
  }
  if(editing) {
    editor.keyReleased();
  }
}
void mouseDragged() {
  if (editing) {
    editor.mouseDragged();
  }
}
void mouseClicked() {
  if (editing) {
    editor.mouseClicked();
  }
}

