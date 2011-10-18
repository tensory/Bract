/*
  Polar-coordinate polygons (r, theta)
 */

class Polygon {
//  Edge[] edges = new Edge[numPoints];
  PVector origin;
  PVector[] polyHull = new PVector[numPoints];

  Polygon() {
    origin = new PVector(0, 0);
  }

  Polygon(PVector pt) {
    origin = new PVector(pt.x, pt.y);
    this.create();
  }

  void create() {
    int pointCloudSize = 30;
    PVector[] tempPoints = new PVector[pointCloudSize];

    for (int i = 0; i < pointCloudSize; i++) {
      int rad = (int)random(5, 30);
      float angle = random(0, TWO_PI); // generate points from center
      tempPoints[i] = new PVector(rad, angle);
    }
    
    // find the limited hull of these points
    polyHull = hullPoints(tempPoints);
  }

  PVector polarToCartesian(PVector polarPoint) {
    float localX, localY;
    localX = polarPoint.x * cos(polarPoint.y);
    localY = polarPoint.x * sin(polarPoint.y);
    return new PVector(origin.x + localX, origin.y + localY);
  }

  // point list sort to grab just the top N points
  PVector[] hullPoints(PVector[] sortPoints) {
    // sorting point group doesn't actually matter
    PVector[] hull = new PVector[numPoints];
    for (int i = 0; i < numPoints; i++) {
      hull[i] = new PVector(0, 0);
    }

    for (int j = 0; j < sortPoints.length; j++) {
      // do mini-bubble sort in hull
      // hull[i] and sortPoints[j]
      PVector hullPoint = hull[0];
      PVector sortablePoint = sortPoints[j];
      if (sortablePoint.x > hullPoint.x) {
        // bubblesort JUST the hull
        for (int k = 0; k < numPoints-1; k++) {
          PVector holder;
          if (hull[k].x > hull[k+1].x) {
            holder = hull[k+1];
            hull[k+1] = hull[k];
            hull[k] = holder;
          }
        }
        hull[0] = sortablePoint;
      }
    }
    return hull;
  }
}

