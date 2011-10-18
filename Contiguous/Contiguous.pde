/*
 Bract Contiguous
 an ongoing experiment in Bract-world
 alacenski@gmail.com 
 20110728
 */

int canvasSize = 500;
PVector one, two, three, four, five;
ArrayList <PVector> allPoints = new ArrayList();
ArrayList <PVector> supergon = new ArrayList();
//ArrayList <Edge> supergonEdge = new ArrayList();
int numPoints = 3; //pentagooooons

// How far away from points should you look 
int proxRadius = 30;

//Edge nearestEdgeToNewRegion = new Edge();

void setup() {
  size(canvasSize, canvasSize);
  allPoints.add(new PVector(50, 50));
  allPoints.add(new PVector(20, 90));
  allPoints.add(new PVector(80, 180));
  allPoints.add(new PVector(120, 100));
  allPoints.add(new PVector(90, 60));

  numPoints = allPoints.size(); 
 
  for (int pointIndex = 0; pointIndex < numPoints; pointIndex++) {
    PVector a = (PVector)allPoints.get(pointIndex);
    PVector b;
    if (pointIndex == (numPoints - 1)) {
      b = (PVector)allPoints.get(0);
    } else {
      b = (PVector)allPoints.get(pointIndex+1);
    }

    supergonEdge.add(new Edge(a, b));
  }
}

