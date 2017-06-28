import java.util.*;

ArrayList<PVector> points=new ArrayList<PVector>();
ArrayList<PVector> pruned=new ArrayList<PVector>();
ArrayList<PVector> convexHull=new ArrayList<PVector>();

int LU_num=-1;
int RU_num=-1;
int RD_num=-1;
int LD_num=-1;

PVector LUVec;// = points.get(LU_num);
PVector RUVec;// = points.get(RU_num);
PVector RDVec;// = points.get(RD_num);
PVector LDVec;// = points.get(LD_num);


float x1, x2, y1, y2;

void mousePressed() {
  align_add(points, new PVector(mouseX, mouseY));
}

void align_add(ArrayList<PVector> points, PVector point) {
  Iterator<PVector> itr = points.iterator();

  int i=0;

  while (itr.hasNext()) {
    PVector vec = itr.next();
    if (vec.x > point.x) {
      break;
    } else if (vec.x == point.x && vec.y > point.y) {
      break;
    } else {
      i++;
    }
  }

  points.add(i, point);
}

void align() {//if points' vector coord can be changing, you have to use this method at every frame


  for (int i=0; i<points.size()-1; ) {
    PVector p1=points.get(i);
    PVector p2=points.get(i+1);

    if ((p1.x<p2.x) || (p1.x==p2.x && p1.y<p2.y)) {
      ++i;
      continue;
    } else {
      PVector temp = points.get(i+1);
      points.remove(i+1);
      for (int j=0; j<=i; j++) {
        PVector p3 = points.get(j);

        if ((p2.x<p3.x) || (p2.x==p3.x && p2.y<=p3.y)) {
          points.add(j, temp);
          ++i;
          break;
        }
      }
    }
  }
}

void pruning(ArrayList<PVector> points) {
  int LU=50000;
  int RU=-100;
  int RD=-100;
  int LD=50000;

  LU_num=0;
  RU_num=0;
  RD_num=0;
  LD_num=0;

  int i=0;
  for (PVector vec : points) {

    if (vec.x + vec.y < LU) {
      LU_num=i;
      LU=int(vec.x + vec.y);
    }
    if (vec.x-vec.y > RU) {
      RU_num=i;
      RU=int(vec.x - vec.y);
    }
    if (vec.x+vec.y > RD) {
      RD_num=i;
      RD=int(vec.x + vec.y);
    }
    if (vec.x-vec.y < LD) {
      LD_num=i;
      LD=int(vec.x - vec.y);
    }

    i++;
  }

  pruned.clear();

  LUVec = points.get(LU_num);
  RUVec = points.get(RU_num);
  RDVec = points.get(RD_num);
  LDVec = points.get(LD_num);

  x1=max(LUVec.x, LDVec.x);
  x2=min(RUVec.x, RDVec.x);
  y1=min(RDVec.y, LDVec.y);
  y2=max(LUVec.y, RUVec.y);

  for (PVector vec : points) {
    if (checkInside(vec)) {
    } else {
      pruned.add(vec);
    }
  }
}

boolean checkInside(PVector vec) {
  if ((vec.x>x1 && vec.x<x2)&&(vec.y<y1&&vec.y>y2)) {
    return true;
  } else
    return false;
}

float graph_getY(PVector v1, PVector v2, float x) {

  float angle = (v2.y-v1.y)/(v2.x-v1.x);
  float y_intercept=v1.y-(angle*v1.x);

  return angle*x+y_intercept;
}

float graph_getX(PVector v1, PVector v2, float y) {
  float angle = (v2.x-v1.x)/(v2.y-v1.y);  
  float x_intercept=v1.x-(angle*v1.y);

  return angle*y+x_intercept;
}

void draw_convexHull() {
  beginShape();

  if (convexHull.size()>0) {
    for (PVector vec : convexHull) {
      vertex(vec.x, vec.y);
    }
  } else {
    for (PVector vec : points) {
      vertex(vec.x, vec.y);
    }
  }

  endShape();
}

void get_convexHull() {
  float angleRecord=360;
  float angle;

  convexHull.clear();

  int from=0;

  convexHull.add(pruned.get(from));

  for (int i=from; i<pruned.size()-1; ) {
    for (int j=from+1; j<pruned.size(); j++) {
      angle = PVector.sub(pruned.get(j), pruned.get(i)).heading();
      if (angle<=angleRecord) {
        angleRecord=angle;
        from=j;
      }
    }
    i=from;
    convexHull.add(pruned.get(i));

    angleRecord=360;
  }

  for (int i=from; i>0; ) {
    for (int j=from-1; j>-1; j--) {
      angle = PVector.sub(pruned.get(i), pruned.get(j)).heading();
      if (angle<=angleRecord) {
        angleRecord=angle;
        from=j;
      }
    }
    i=from;
    convexHull.add(pruned.get(i));
    angleRecord=360;
  }
}