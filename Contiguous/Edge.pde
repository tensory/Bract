class Edge {
  boolean isExtensible;
  PVector a, b;
  
  public Edge() {
    isExtensible = false;
    a = new PVector(0, 0);
    b = new PVector(0, 0);
  }
  
  public Edge(PVector begin, PVector end) {
    a = new PVector(begin.x, begin.y);
    b = new PVector(end.x, end.y);
    isExtensible = true;
  }
}

