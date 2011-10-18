/*
 Bract Hull
 Find the exterior of a cluster of points.
 alacenski@gmail.com 
 20110813
 */

int canvasSize = 500;
int numPoints = 6; //pentagooooons

ArrayList <Polygon> polys = new ArrayList();
//ArrayList <PVector> allPoints = new ArrayList();
PVector[] allPoints = new PVector[numPoints];

void setup() {
  size(canvasSize, canvasSize);

  allPoints[0] = new PVector(50, 50);
  allPoints[1] = new PVector(20, 90);
  allPoints[2] = new PVector(80, 180);
  allPoints[3] = new PVector(120, 100);
  allPoints[4] = new PVector(90, 60);
  allPoints[5] = new PVector(30, 180);
}

void draw() {
  PVector lowest = getConvexHull(allPoints);

  for (int t = 0; t < numPoints; t++) {
    PVector thisPoint = (PVector) allPoints[t];
    // grab point from current
    // PVector pointFromCurrent = (PVector) current.polyHull[t];
    // PVector thisPoint = current.polarToCartesian(pointFromCurrent);
    if (thisPoint.x == lowest.x && thisPoint.y == lowest.y) {
      stroke(255, 0, 0);
    } 
    else {
      stroke(0);
    }

    ellipse(thisPoint.x, thisPoint.y, 5, 5);
  }
}



void mousePressed() {
  // create a polygon at the mouse click site
  Polygon addition = new Polygon(new PVector(mouseX, mouseY));
  polys.add(addition);
}

/**
 * Graham scan implementation in progress
 * From http://softsurfer.com/Archive/algorithm_0109/algorithm_0109.htm#GS Pseudo-Code
 */
PVector getConvexHull(PVector[] polyPoints) {
  PVector[] sortedPoints = new PVector[numPoints];

  /* Select the rightmost lowest point P0 in S. */
  PVector lowest = new PVector(0, 0); 
  for (PVector proposedLowest : polyPoints) {
    if (proposedLowest.y > lowest.y &&
      proposedLowest.x > lowest.x) {
      lowest = proposedLowest;
    }
  }
  //return lowest;
  // Sort S angularly about P0 as a center.
  //sortedPoints[0] = lowest;
  Arrays.sort(polyPoints, Comparator)
  }

  // How to use comparator?
  Comparator sortPoints()


    /*
Input: a set of points S = {P = (P.x,P.y)}
     
     Select the rightmost lowest point P0 in S.
     Sort S angularly about P0 as a center.
     For ties, discard the closer points.
     Let P[N] be the sorted array of points.
     
     Push P[0]=P0 and P[1] onto a stack W.
     
     while i < N
     {
     Let PT1 = the top point on W
     Let PT2 = the second top point on W
     if (P[i] is strictly left of the line PT2 to PT1) { 
     Push P[i] onto W
     i++    // increment i
     }
     else
     Pop the top point PT1 off the stack
     
     }
     
     Output: W = the convex hull of S.
     */
