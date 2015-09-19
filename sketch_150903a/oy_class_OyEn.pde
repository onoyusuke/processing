// 2013. 10/19(Sat)

class OyEn {
  int x;
  int y;
  int hankei;
  
  OyEn ( int tempX, int tempY, int tempHankei ) {
    x = tempX;
    y = tempY;
    hankei = tempHankei;
  }
  
  boolean inp( int tempX, int tempY ) {
    if ( pow ( x - tempX ,2 ) + pow ( y - tempY ,2 ) <= pow ( hankei, 2 ) )
      return true;
      else return false;
  }
  
  void display() {
    ellipse ( x, y, hankei, hankei );
  }
  
}

