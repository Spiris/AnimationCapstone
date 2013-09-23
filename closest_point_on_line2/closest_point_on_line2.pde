// closest_point_on_line
//
// How to find the closest point on a line segment to a point
//

// The line segment is defined by two points, p1 & p2
PVector q1;
PVector q2;
// a is the point we know. we want to find a point on the line
// segment p1->p2 that is closest to a. 
PVector a1;
PVector b1;


void setup() {
  size( 512, 512 );
  smooth();
  
  q1 = new PVector( 100, 200 );
  q2 = new PVector( 400, 300 );
  a1 = new PVector( 300, 100 );
  b1 = new PVector( 500, 500 );
}


void draw() {
  background( 255 );
  
  // draw p1 & p2
  stroke( 128, 0, 0 );
  ellipse( q1.x, q1.y, 6, 6 );
  stroke( 0, 0, 128 );
  ellipse( q2.x, q2.y, 6, 6 );
  // draw the line segment
  stroke( 0 );
  line( q1.x, q1.y, q2.x, q2.y );
  // draw point a
  ellipse( a1.x, a1.y, 10, 10 );
  
  float t = closest_point_on_line( a1, q1, q2, b1 );
  
  // draw a line from a to b (blue)
  stroke( 0, 0, 255 );
  line( a1.x, a1.y, b1.x, b1.y );
  // draw point b
  stroke( 0 );
  ellipse( b1.x, b1.y, 10, 10 );
}


float closest_point_on_line( PVector a, PVector p1, PVector p2, PVector b ) {
  // vector from p1 to p2
  PVector line_seg = PVector.sub( p1, p2 );
  // vector perpendicular to the line
  PVector line_perp = new PVector( line_seg.y, -line_seg.x );
  
  // vector r is a vector from a to the line
  PVector r = PVector.sub ( p1, a );
  
  // project r onto line_perp
  float d1 = line_seg.x * r.y - r.x * line_seg.y;
  float d = abs(d1) / line_seg.mag();
  
  // if d1 is positive, reverse d, so that line_perp flips 
  // to point towards the line.
  if (d1 > 0)
    d = d * -1;
  
  // make line_perp vector be length d
  line_perp.normalize();
  line_perp.mult( d );
  
  // b is the new point, on the line, closest to the point a.
  // however, this point may not be on the *line segment*
  b.x = a.x + line_perp.x;
  b.y = a.y + line_perp.y;
  
  // t is where b is parametericly on this line.
  // if t is between 0-1, then it is on the line segment.
  float t = (b.x / (p2.x - p1.x)) - (p1.x / (p2.x - p1.x));
  
  if (t < 0) {
    // if t < 0, then b was on the line before p1
    b.x = p1.x;
    b.y = p1.y;
  }
  else if (t > 1) {
    // if t > 1, then b was on the line after p2
    b.x = p2.x;
    b.y = p2.y;
  }
  
  return t;
}


void mouseDragged() {
  a1.x = mouseX;
  a1.y = mouseY;
}


