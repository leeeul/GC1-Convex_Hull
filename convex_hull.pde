void setup() {
  size(640, 480);
  noFill();
}

void draw() {
  background(255);

  strokeWeight(1);
  stroke(0);

  //align();//if points' vector coord can be changing, you have to use this method at every frame before pruning method!!

  if (points.size()>=3) {
    pruning(points);
    get_convexHull();
    draw_convexHull();
  }

  for (PVector point : points) {
    ellipse(point.x, point.y, 10, 10);
  }

  if (points.size()>=3) {
    strokeWeight(3);
    stroke(255, 0, 0);

    ellipse(LUVec.x, LUVec.y, 10, 10);
    ellipse(RUVec.x, RUVec.y, 10, 10);
    ellipse(LDVec.x, LDVec.y, 10, 10);
    ellipse(RDVec.x, RDVec.y, 10, 10);

    beginShape();

    vertex(LUVec.x, LUVec.y);
    vertex(RUVec.x, RUVec.y);
    vertex(RDVec.x, RDVec.y);
    vertex(LDVec.x, LDVec.y);

    endShape(CLOSE);
  }
}