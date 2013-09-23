float half_width, half_height;
Player player;
Platform the_platform;
void setup() {
  size(700,700, P2D);
  smooth();
  half_width = width / 2;
  half_height = height / 2;
  player = new Player();
  the_platform = new Platform(0, half_height + 100, half_width + 20, 20);
}
void draw() {
  background(0);
  player.update();
  player.draw();
  the_platform.draw();
}

void keyPressed() {
  if(key == 'a')
    player.acceleration.x -= 0.1;
  if(key == 'd')
    player.acceleration.x += 0.1;
  
}
void keyReleased() {
  if(key == 'a' || key == 'd')
    player.acceleration.x = 0;
  if(key == ' ')
    player.velocity.y += -5;
}
