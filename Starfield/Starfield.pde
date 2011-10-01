/*
 Bract Starfield
 09072011
 alacenski@gmail.com
 
 Add points to collection. Attempt to polygonalize from triangulation.  
 */

import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;

int canvasSize = 500;
int pointCount = 0;
List <Triangle2D> delaunayTriangles = new ArrayList<Triangle2D>();

// Helper object for rendering
ToxiclibsSupport gfx;
PolygonClipper2D clip;

// Empty container for Voronoi diagram (inverse of DT)
// Waiting on full DT implementation in toxiclibs
Voronoi voronoi = new Voronoi();

void setup() {
  size(canvasSize, canvasSize);
  smooth();

  // Initialize gfx! That'll help...
  gfx = new ToxiclibsSupport(this);

  // surface defines vertices of the tileable shape
  // this could be read from a file...
  ArrayList<Vec2D> vertices = new ArrayList<Vec2D>();
  vertices.add(new Vec2D(0, 0));
  vertices.add(new Vec2D(0, canvasSize));
  vertices.add(new Vec2D(canvasSize, canvasSize));
  vertices.add(new Vec2D(canvasSize, 0));

  // Make the graph the edges at first
  voronoi = defineSurface(vertices);

  // Throw down remaining points that are inside the shape
  Polygon2D surface = new Polygon2D(vertices);
  ArrayList<Vec2D> newPoints = new ArrayList<Vec2D>();
  int containedPoints = 1000;

  while (newPoints.size () < containedPoints) {
    Vec2D newPoint = new Vec2D((int) random(0, canvasSize), (int) random(0, canvasSize));
    if (surface.containsPoint(newPoint)) {
      newPoints.add(newPoint);
    }
  } 

  for (Vec2D pt : newPoints) {
    voronoi.addPoint(pt);
  }

  setTriangles();
}

void draw() {
  background(0);
  fill(128);
  strokeWeight(1);
  stroke(255);

/*
  // Show DT of points
  beginShape(TRIANGLES);
  for (Triangle2D t : delaunayTriangles) {
    // if the triangle is wholly inside the container
    if (t.containsPoint(new Vec2D(mouseX, mouseY))) {
      fill(255, 0, 0);
    } 
    else {
      fill(128);
    }
    gfx.triangle(t, false);
  }
  endShape();
*/
  stroke(#671295);
  fill(#D7B9E8);
  for (Polygon2D r : voronoi.getRegions()) {
    gfx.polygon2D(r);
  }  
  
  // Show original clicked points
  for (Vec2D c : voronoi.getSites()) {
    ellipse(c.x, c.y, 3, 3);
  }
}  

void mouseClicked() {
  //  allPoints.add(new PVector(mouseX, mouseY));

  voronoi.addPoint(new Vec2D(mouseX, mouseY));
  setTriangles();
}

void keyPressed() {
  if (key == 'x') {
    voronoi = new Voronoi();
  }
}

/* 
 Test whether the triangle of interest is in the bounds of the display field.
 Don't care about 'fake' triangles whose bounds are offscreen ( > 10000).
 */
boolean isTriangle(Triangle2D tri2d) {
  int ext = 9999;
  /*
    Convert Triangle2D to Polygon2D to get at vertices
   because for some reason a Tri is not a Poly
   */
  Polygon2D tri = tri2d.toPolygon2D();  

  for (Vec2D vtx : tri.vertices) {
    if (abs(vtx.x) > ext || abs(vtx.y) > ext ) {
      return false;
    }
  } 
  return true;
}

void setTriangles() {
  // Do DT, populate initial list of PolyTriangles
  for (Triangle2D t : voronoi.getTriangles()) {
    if (isTriangle(t)) {
      delaunayTriangles.add(t);
    }
  }
}

/**
 * Add the vertices of the desired shape
 * to the Voronoi object, along with
 * random points along the edges.
 * 
 * Star power: make number of edge points proportional to edge length
 */
Voronoi defineSurface(ArrayList<Vec2D> vertices) {
  Voronoi graph = new Voronoi();
  int pointsPerSide = 20;

  for (int i = 0; i < vertices.size(); i++) {
    Vec2D a = (Vec2D)vertices.get(i);
    // Loop around to find b to ensure closed (though not necessarily convex!) polygon 
    Vec2D b = (Vec2D)vertices.get((i == (vertices.size() - 1)) ? 0 : i+1);
    // Add vertices to graph
    graph.addPoint((Vec2D)vertices.get(i));

    // Define a line to put points on
    // Special case for lines with vertical slope...
    if (a.x == b.x) {
      for (int j = 0; j < pointsPerSide; j++) {
        graph.addPoint(new Vec2D((int)a.x, (int)random(a.y, b.y)));
      }
    } 
    else { // Non-undefined slope
      float m = (b.y - a.y) / (b.x - a.x);
      float y_int = a.y - (m * a.x);
      for (int k = 0; k < pointsPerSide; k++) {
        int x = (int) (a.x < b.x ? random(a.x, b.x) : random(b.x, a.x));
        int y = (int) ((m * x) + y_int);
        graph.addPoint(new Vec2D(x, y));
      }
    } // End point-adding
  }

  return graph;
}

