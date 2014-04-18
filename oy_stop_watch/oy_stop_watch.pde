// stop_watch
// apr 2014
  int s_timer;
  int e_timer;
  boolean s_setted = false;
  boolean e_setted = false;
  boolean key_released;
void draw() {
  int timer = millis();


  if (keyPressed){
 
      if (s_setted){
        if (key_released){
          e_timer = timer;
          e_setted = true;
        }
      } else {
        s_timer = timer;
        s_setted = true;
        key_released = false;
      } 
  } else {
  key_released=true;
  }
  if (s_setted && !e_setted){
    println(timer-s_timer);
  } else if (s_setted && e_setted){
    println(e_timer-s_timer);
  } else {
    println(0);
  }


}


