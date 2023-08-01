class Pillar {
  int r, xStart, yStart;
  
  Pillar(int x0, int y0, int radius) {
    r = radius;
    xStart = x0;
    yStart = y0;
  }
   
  void render() {
    fill(0);
    circle(xStart, yStart, r);
  }
}
