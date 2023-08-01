class Wall {
  PVector position;
  PVector startPoint, endPoint;
  
  int leftX, leftY, rightX, rightY;
  
  Wall(int xl0, int yl0, int xr0, int yr0) {
    
    leftX = xl0;
    leftY = yl0;
    
    rightX = xr0; 
    rightY = yr0;
    
    startPoint = new PVector(leftX, leftY);
    endPoint = new PVector(rightX, rightY);
  }
  
  PVector getStartPoint() {
    return startPoint;
  }
  
  
  PVector getEndPoint() {
    return endPoint;
  }
   
  void render() {
    fill(0);
    line(
      leftX, leftY, 
      rightX, rightY
    );
  }
}
