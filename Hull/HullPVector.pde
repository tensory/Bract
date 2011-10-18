/*
  Bract.HullPVector
  The purpose of this class is to help sort points in the
  Graham scan pattern to derive the convex hull of a point set.
  20110814
*/

class HullPVector implements Comparator<PVector> {
  PVector origin = new PVector(0, 0); 
  
  // Only use this class with an origin point! 
  HullPVector(PVector pOrigin) {
    origin = pOrigin;
  }
  
  int compare(PVector p1, PVector p2) {
    return isLeft(this.origin, p1, p2); 
  }
  
  /* 
   * isLeft implementation from http://softsurfer.com/Archive/algorithm_0109/algorithm_0109.htm#isLeft()
   * Tests if a point is Left, On, or Right of a line
   * Only evaluates to true if P2 is to the left of the line through P0 and P1
   * * >0 for P2 left of the line through P0 and P1
   * * =0 for P2 on the line
   * * <0 for P2 right of the line
   * Whatever calls the comparator must deal with the = case
   * and throw away 
   */
  int isLeft(PVector p0, PVector p1, PVector p2) {
    return (p1.x - p0.x)*(p2.y - p0.y) - (p2.x - p0.x)*(p1.y - p0.y);
  }
}
