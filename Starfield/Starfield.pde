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

// Canvas size less than 300
int canvasSize = 300;
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
  
  // Put points down randomly along the edges of the canvas
  int halfCanvas = canvasSize / 2;
  translate(halfCanvas, halfCanvas);
  strokeWeight(3);
  stroke(255, 0, 0);
  ellipse(0, 0, 5, 5);
 /*
  for (int i = 0; i < 4; i++) {
    voronoi.addPoint(new Vec2D(0, (int) random(-(halfCanvas), halfCanvas)));
    // Rotate 90 degrees
    rotate(HALF_PI);
  }
 /*
  // Put a whole bunch of points down
  for (int i = 0; i < 300; i++) {
    voronoi.addPoint(new Vec2D((int) random(0, canvasSize), (int) random(0, canvasSize)));
  }
  */
  setTriangles();
}

void draw() {
/*  background(0);
  fill(128);
  strokeWeight(1);
  stroke(255);
*/
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
  */
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

/**/

