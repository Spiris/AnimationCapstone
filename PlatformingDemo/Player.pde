class Player {
  final float mov = 5;
  final float gravity = 0.3;
  PVector position, velocity, acceleration;
  boolean right, left, jump, jumping, jump_ready, on_ground;
  float w, h, drag;
  PlayerDot foot, head, left_dot, right_dot;
  PVector closest;
  Edge current_edge;
  int jump_timer;
  Player(float x, float y, float w, float h) {
    this.foot = new PlayerDot(x, y + h / 2);
    this.head = new PlayerDot(x, y - h / 2);
    this.right_dot = new PlayerDot(x  + w / 2, y); 
    this.left_dot = new PlayerDot(x - w / 2, y);
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);  
    this.right = false;
    this.left = false;  
    this.jump = false;
    this.jumping = false;
    this.on_ground = false; 
    this.jump_ready = true; 
    this.w = w;
    this.h = h;
    this.drag = 0.9;
    this.closest = new PVector(0, 0);
    this.current_edge = new Edge();
  }

  void update() {
    for (FlowFieldObject f : editor.flow_editor.flows)
      if (f.pointInside(position.x, position.y) )
        velocity.add(f.force);

    xAxisMovement();
    yAxisMovement();
    PVector next = PVector.add(foot.position, velocity);

    for (Edge e : editor.edge_editor.edges) {
      PVector p = e.closestPointOnEdge(foot.position);
      if (dist(next.x, next.y, p.x, p.y) < dist(closest.x, closest.y, next.x, next.y)) {
        current_edge = e;
        closest = p;
      }
    }
    if(editing) ellipse(closest.x, closest.y, 10, 10);
    velocity.x = constrain(velocity.x, -6, 6);
    velocity.y = constrain(velocity.y, -12, 12);
    position.add(velocity);
    foot.position.set(position.x, position.y + h / 2);
    head.position.set(position.x, position.y - h / 2);
    left_dot.position.set(position.x - w / 2, position.y);
    right_dot.position.set(position.x + w / 2, position.y);
  }
  boolean collision() {
    PVector v = PVector.sub(closest, foot.position);

    return v.mag() < 30;
  }


  void xAxisMovement() {

    if (on_ground) {
      if (right) {
        velocity = new PVector(current_edge.norm.x * mov, current_edge.norm.y * mov);
      }
      if (left) {
        velocity = new PVector(current_edge.norm.x * -mov, current_edge.norm.y * -mov);
      }
      if (!(right || left)) {
        velocity.mult(drag);
        acceleration.mult(0);
      }
    } 
    else {
      if (right) {
        if (velocity.x < 0)
          velocity.x *= drag;

        velocity.x += mov / 2;
      }
      if (left) {
        if (velocity.x > 0)
          velocity.x *= drag;
        velocity.x -= mov / 2;
      }
      if (!(right || left)) {
        if (abs(velocity.x) > 0.1)
          velocity.x *= drag + 0.05;
        else
          velocity.x = 0;
        acceleration.x = 0;
      }
    }
  }
  void jump() {
    if (on_ground) {
      if (!jump) {
        jump = true;
        jumping = true;
        velocity = new PVector(current_edge.perp.x * 3, -10);
        jump_timer = 15;
        on_ground = false;
      }
    }
  }
  void yAxisMovement() {
    if (on_ground) {
      PVector next = PVector.add(foot.position, velocity);
      if(closest.y < next.y) {
        if(velocity.y > 0)
          velocity.y = 0;
        position.y = closest.y - 20;
      }
    }
    else {
      if (collision()) {
        if (jump_timer < 0 && velocity.y > 0) {
          on_ground = true;
          velocity.y = 0;
          jumping = false;
        }
      } 
      velocity.y += gravity;
      jump_timer--;
    }
    if(!collision())
      on_ground = false;
  }

  void draw() {
    update();
    foot.draw();
    head.draw();
    left_dot.draw();
    right_dot.draw();
    pushMatrix();
    translate(position.x, position.y);
    rectMode(CENTER);
    fill(255);
    rect(0, 0, w, h);
    popMatrix();
  }
}

