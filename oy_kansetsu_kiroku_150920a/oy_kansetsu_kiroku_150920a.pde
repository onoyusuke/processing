/* 2015/9/19 
1秒あたりの取得データ数を決める。int kiroku_rate
そこから周期がきまる。int kiroku_shuki
計測時間を決める。int kiroku_byo
すると記録数がきまる。int kiroku_su = kiroku_byo * kiroku_shuki
プログラムが開始してからの経過時間をミリ秒で測る。keika
tabが押された時間を記録。kaishi
keika - kaishiをkiroku_shukiで割る。その余りがゼロで、商が記録数よりも少ないとき、商を配列番号として配列に格納。
各関節のデータは別ファイルに保存。ファイル名の表を配列として用意しておく。
*/


import SimpleOpenNI.*;
SimpleOpenNI  kinect;

// 記録ファイル名
String fname = "test";

// 関節のリスト
String[] k_namae = {"rightHand", "rightElbow", "rightShoulder", "LeftHand", "LeftElbow", "LeftShoulder","Torso","Neck","Head"};
int Kazu=k_namae.length;
// 保存用の変数
int kiroku_rate = 10;// 1秒あたりの取得データ数
int kiroku_shuki = 1000/kiroku_rate; // 周期
int kiroku_byo = 10;// 計測時間
int kiroku_su = kiroku_byo * kiroku_rate; // 記録数
int keika; //プログラムが開始してからの経過時間をミリ秒で測る。
int kaishi; // tabが押された時間を記録
boolean s_zikan=false;

int s_bango;

PVector[][] k_zahyo = new PVector[Kazu][kiroku_su+1];
// JSON
JSONObject json;
JSONArray values;
void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(false);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser();

  size(640, 480);
    fill(255, 0, 0);
}

void draw() {

  background(200);
  kinect.update();
  image(kinect.rgbImage(),0,0);



  int[] userList = kinect.getUsers();
  if (userList.length > 0) {
    int userId = userList[0];
    if ( kinect.isTrackingSkeleton(userId)) {
      keika = millis();
      if(s_zikan){println(keika-kaishi);}

      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

      PVector rightElbow = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);

      PVector rightShoulder = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);

      PVector leftHand = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);

      PVector leftElbow = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, leftElbow);

      PVector leftShoulder = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);

      PVector Torso = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, Torso);

      PVector Neck = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, Neck);
      
      PVector Head = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, Head);


      stroke(255,0,0);
        strokeWeight(5);
 
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_RIGHT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HAND, SimpleOpenNI.SKEL_LEFT_ELBOW);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_TORSO);
      
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_HEAD);

 int bango = int((keika-kaishi)/kiroku_shuki);

  if (!s_zikan){
  bango=0;
  s_bango=-1;
  }

  if (s_bango!=bango){

  k_zahyo[0][bango] = rightHand;  // 右手
  k_zahyo[1][bango] = rightElbow;  // 右肘
  k_zahyo[2][bango] = rightShoulder;  // 右肩
  k_zahyo[3][bango] = leftHand;  
  k_zahyo[4][bango] = leftElbow;  
  k_zahyo[5][bango] = leftShoulder;  
  k_zahyo[6][bango] = Torso;  
  k_zahyo[7][bango] = Neck;  
  k_zahyo[8][bango] = Head;  
 
  s_bango=bango;
  }
  // 記録
  if((bango>=kiroku_su) && s_zikan){
    println("Saved");
    for(int j=0; j<Kazu; j++){
      values = new JSONArray();
  for (int i = 0; i < kiroku_su+1; i++){
      json = new JSONObject();
    
    json.setInt ( "msec", i*kiroku_shuki );

    json.setFloat ( "x", k_zahyo[j][i].x );
    json.setFloat ( "y", k_zahyo[j][i].y );
    json.setFloat ( "z", k_zahyo[j][i].z );
   
    values.setJSONObject(i, json);
  }
    saveJSONArray (values, "../data_kansetsu/"+k_namae[j]+"_"+fname+".json");
   }
  exit();
    
  }
  
if (keyPressed){
  if (key == TAB) {
    //　開始時間再設定
    kaishi = millis();
    s_zikan = true;
    
   
  }
}
  
  }
  else{      // 座標が取得できないときはtimer 初期化
    kaishi = millis(); 
  s_zikan = false;}
  }
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
  println("onVisibleUser - userId: " + userId);
}

