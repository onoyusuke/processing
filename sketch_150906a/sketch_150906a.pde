/*　2015/9/6
肘と肩の角度を取得し、リアルタイムでグラフに表示。
加速などどの程度とらえられるか。
角度をJSONでとれるように改造したい。
*/

import SimpleOpenNI.*;
SimpleOpenNI  kinect;
/*
int max_counter = 200;
int counter = 0;
float[] series_s3d = new float[max_counter+1];
float[] series_e3d = new float[max_counter+1];
int[] series_timer = new int[max_counter+1];
*/
int[] iro = {#FC29CB, #29FCA6, #D5E810};
//int color1 = #FC29CB; //ピンク
//int color2 = #29FCA6; //水色
//int color3 = #30E00E; //緑色

int Kazu = 2; // 関節の数
int mado = 200;
int bairitsu = 1;
int futosa = 3;
int hyoziKazu = 600;

float[][] gra = new float[Kazu][hyoziKazu];

int[] kakudo = new int[Kazu];

//int timerStart=0;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth();
    kinect.enableRGB();
  kinect.enableUser();

  size(640, 480 + mado + 20);
  //  fill(255, 0, 0);
  
  for (int i=0; i<Kazu; i++){
  for (int j=0; j<hyoziKazu; j++){
  gra[i][j] = 0; // 番号ずらす
  }
  }

}

void draw() {

  background(200);
  kinect.update();
  image(kinect.rgbImage(),0,0);
//  image(kinect.depthImage(), 0, 0);
//  image(kinect.userImage(),0,0);

  // IntVector userList = new IntVector();

  int[] userList = kinect.getUsers();
  if (userList.length > 0) {
    int userId = userList[0];
    //    if (timerStart==0){
    //      timerStart=millis();
    //    }
    if ( kinect.isTrackingSkeleton(userId)) {
      int timer = millis();
      //        println(timer);
      //


      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

      PVector rightElbow = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);

      PVector rightShoulder = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);

      PVector rightHip = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);
      //
      //      PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
      //      PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
      //      PVector rightShoulder2D = new PVector(rightShoulder.x, rightShoulder.y);
      //      PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
      //      //
      //      PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
      //      PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);    
      //      //
      //      float shoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
      //      float elbowAngle = angleOf(rightHand2D, rightElbow2D, upperArmOrientation);
      //
      PVector rightHand3D = rightHand;
      PVector rightElbow3D = rightElbow;
      PVector rightShoulder3D = rightShoulder;
      PVector rightHip3D = rightHip;
      //
      PVector torsoOrientation3D = PVector.sub(rightShoulder3D, rightHip3D);
      PVector upperArmOrientation3D = PVector.sub(rightElbow3D, rightShoulder3D);
      //
      float shoulderAngle3D = angleOf(rightElbow3D, rightShoulder3D, torsoOrientation3D);
      float elbowAngle3D = 180-angleOf(rightHand3D, rightElbow3D, upperArmOrientation3D);
      //
      stroke(255,0,0);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_HIP);
      
      kakudo[0] = int(shoulderAngle3D);
      kakudo[1] = int(elbowAngle3D);
/*      
      fill(255, 0, 0);
      scale(3);
      text("R shoulder: " + kakudo[0] + "\n" + "R elbow: " + kakudo[1], 20, 120);
*/
      
// グラフを描く
    strokeWeight(futosa);
    for (int i=0; i<Kazu; i++){
    stroke(iro[i]);
    for (int j=0; j<hyoziKazu-1; j++){
    gra[i][j] = gra[i][j+1]; 
    }
//
    gra[i][hyoziKazu-1] = kakudo[i];
    
//// 描く
    for (int j=0; j<hyoziKazu; j++){

    point(j,480+mado-bairitsu*gra[i][j]);
      //    point(j,480+mado-gra[i][j]);
//point(hyoziKazu-1, 480+mado+gra[i][hyoziKazu-1]);
    }
}
//
     fill(0);
     text("0", hyoziKazu+5, 480+mado); 
     text("90", hyoziKazu+5, 480+mado-bairitsu*90); 
     text("180", hyoziKazu+5, 480+mado-bairitsu*180); 
/*
      series_s3d[counter] = shoulderAngle3D;
      series_e3d[counter] = elbowAngle3D;
      series_timer[counter] = timer;
*/

/*
      if (counter>=max_counter-1) {
        String[] lines = new String[max_counter+1];
        lines[0]="time \t Shoulder \t Elbow";
        for (int i=0; i<max_counter; i++) {
          lines[i+1] =series_timer[i]-series_timer[0]+"\t"+series_s3d[i]+"\t"+series_e3d[i];         
          //          lines[i+1] =(i+1)+"\t"+series_s3d[i]+"\t"+series_e3d[i];
        }
        saveStrings("angles_UE.csv", lines);
        exit();
      }
      else {
        counter++;

        //        println(counter);
      }
*/      
    }
  }
}

float angleOf(PVector one, PVector two, PVector axis) {
  PVector limb = PVector.sub(two, one);
  return degrees(PVector.angleBetween(limb, axis));
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

/*

 // user-tracking callbacks!
 void onNewUser(int userId) {
 println("start pose detection");
 kinect.startPoseDetection("Psi", userId);
 }
 
 void onEndCalibration(int userId, boolean successful) {
 if (successful) { 
 println("  User calibrated !!!");
 kinect.startTrackingSkeleton(userId);
 } 
 else { 
 println("  Failed to calibrate user !!!");
 kinect.startPoseDetection("Psi", userId);
 }
 }
 
 void onStartPose(String pose, int userId) {
 println("Started pose for user");
 kinect.stopPoseDetection(userId); 
 kinect.requestCalibrationSkeleton(userId, true);
 }
 */
