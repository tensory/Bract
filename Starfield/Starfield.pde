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
  ArrayList<Vec2D> surface = new ArrayList<Vec2D>();
  surface.add(new Vec2D(0, 0));
  surface.add(new Vec2D(0, canvasSize));
  surface.add(new Vec2D(canvasSize, canvasSize));
  surface.add(new Vec2D(canvasSize, 0));
  
  // Define the corners since it's a square
  // TODO: make a function to sort out corners and other major vertices
  
  
  voronoi.addPoint(new Vec2D(0, 0));
  voronoi.addPoint(new Vec2D(0, canvasSize));
  voronoi.addPoint(new Vec2D(canvasSize, canvasSize));
  voronoi.addPoint(new Vec2D(canvasSize, 0));
  
  // Put points down randomly along the edges of the containing shape
  // Define it as a segment array
  // This can be reused for more complicated shapes; just reduce them to segments
  ArrayList<Line2D> container = new ArrayList<Line2D>();
  container.add(new Line2D(new Vec2D(0, 0), new Vec2D(canvasSize, 0))); // top
  container.add(new Line2D(new Vec2D(canvasSize, 0), new Vec2D(canvasSize, canvasSize))); // right
  container.add(new Line2D(new Vec2D(0, canvasSize), new Vec2D(canvasSize, canvasSize))); // bottom
  container.add(new Line2D(new Vec2D(0, 0), new Vec2D(0, canvasSize))); // left

  int pointsPerSide = 20;
  for (Line2D segment : container) {
    // Find slope
    // Special case for vertical slope
    if (segment.a.x == segment.b.x) {
      for (int i = 0; i < pointsPerSide; i++) {
        voronoi.addPoint(new Vec2D((int)segment.a.x, (int)random(segment.a.y, segment.b.y)));
      }
    } 
    else { 
      float m = (segment.b.y - segment.a.y) / (segment.b.x - segment.a.x);
      float b = segment.a.y - (m * segment.a.x);
      for (int i = 0; i < pointsPerSide; i++) {
        int x = (int) (segment.a.x < segment.b.x ? random(segment.a.x, segment.b.x) : random(segment.b.x, segment.a.x));
        int y = (int) ((m * x) + b);
        voronoi.addPoint(new Vec2D(x, y));
      }
    }
  }
  
  // Throw down the rest of the points
  for (int i = 0; i < 300; i++) {
     voronoi.addPoint(new Vec2D((int) random(0, canvasSize), (int) random(0, canvasSize)));
   }
  setTriangles();
}

void draw() {
   background(0);
   fill(128);
   strokeWeight(1);
   stroke(255);
   
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
    Vec2D b = new Vec2D();
    if (i == vertices.size() -1) {
      b = (Vec2D)vertices.get(0);
    } else {
      b = (Vec2D)vertices.get
    }
    (1 ? 1 : 0);
    graph.addPoint((Vec2D)vertices.get(i));
    
    // Define a line to put points on
    
    if (segment.a.x == segment.b.x) {
      for (int i = 0; i < pointsPerSide; i++) {
        voronoi.addPoint(new Vec2D((int)segment.a.x, (int)random(segment.a.y, segment.b.y)));
      }
    } else { 
      float m = (segment.b.y - segment.a.y) / (segment.b.x - segment.a.x);
      float b = segment.a.y - (m * segment.a.x);
      for (int i = 0; i < pointsPerSide; i++) {
        int x = (int) (segment.a.x < segment.b.x ? random(segment.a.x, segment.b.x) : random(segment.b.x, segment.a.x));
        int y = (int) ((m * x) + b);
        voronoi.addPoint(new Vec2D(x, y));
      }
    } // End point-adding
  }
  
  
  
  
  
  
  
  
  for (Vec2D vert : vertices) {
  // Add endpoint to graph
    graph.addPoint(vert);
  
  // Define a line 
    
  // Special case for last point: should wrap around (might end up with pinched shape but whatever) 
  }
  return graph;
  
  
}


