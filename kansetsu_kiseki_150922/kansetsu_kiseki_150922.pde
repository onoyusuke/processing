/*
2015/9/22
関節運動の軌跡を図示する。
3次元空間上に点を打ってつなげる。

操作：
まず、右ドラッグでzoom out.
カーソルキー上下

*/

 import peasy.*;
 PeasyCam camera;

String basho = "../data_kansetsu/";
String[] kansetsu = {
  "LeftShoulder_test", "LeftElbow_test", "LeftHand_test", 
  "Head_test", "Neck_test", "Torso_test", 
  "rightShoulder_test", "rightElbow_test", "rightHand_test"};

int[] sen1 = {0,1,2};
int[] sen2 = {3,4,5};
int[] sen3 = {6,7,8};

color[] iro = {
  #F20F98, #F20F98,#F20F98,
  #FFF300, #0FF2E5, #0FF2E5,
  #0F3EF2, #0F3EF2, #0F3EF2};
// #F20F98 赤風
// #0F3EF2 青風
// #0FF2E5 水色
int bgColor = 250; // 背景色

int zikanKosu = 101; // 同時に表示する軌跡の個数. 記録時間に対応.
int kansetsuKazu = kansetsu.length;  // 同時に表示する関節の数
String[] fname = new String[kansetsuKazu];

JSONArray values;
PVector[][] kansetsuPoints = new PVector[kansetsuKazu][zikanKosu];
int[] msecZikan = new int[zikanKosu];

int zikan = 0;

void setup() {
size(512, 768, P3D);
  camera = new PeasyCam(this, 0, 0, 0, 0);  

//
// ファイル名設定
// ファイルは関節ごとになっている。
//

for (int i=0; i<kansetsuKazu; i++){
fname[i] = basho + kansetsu[i] +".json";
println(fname[i]);
}

//
//　読み込み
// 

for (int j = 0 ; j<kansetsuKazu; j++){
    values = loadJSONArray(fname[j]);
  for (int i = 0; i < zikanKosu; i+=1){
    JSONObject json = values.getJSONObject(i);
    kansetsuPoints[j][i] = new PVector ( json.getFloat("x"), json.getFloat ( "y" ),json.getFloat ( "z" ));
    msecZikan[i] = json.getInt("msec");
  }
}


}


void draw() {

  background(bgColor);

int chikuseki = 0; // 点を蓄積して軌跡を表示する場合は0よりも大きくする。
for (int i=max(0, zikan-chikuseki); i<=zikan; i++){ 

  println(msecZikan[i]+" msec");
  
  for(int j=0; j<kansetsuKazu; j++){
  pushMatrix();
  noStroke();  

fill(iro[j]); 
lights();
  translate(kansetsuPoints[j][i].x, kansetsuPoints[j][i].y, kansetsuPoints[j][i].z);
  sphere(12);
  popMatrix();  

//  stroke(iro[j]); sen_hiku_all(j);

}

   
    stroke(100); 
   sen_hiku(i,sen1);
   sen_hiku(i,sen2);
   sen_hiku(i,sen3);
}

}

void sen_hiku(int i, int[] sen){
                 for (int j = 1; j < sen.length; j+=1) {
   PVector v1 = kansetsuPoints[sen[j-1]][i]; 
   PVector v2 = kansetsuPoints[sen[j]][i];     
   line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
                 }
}

void sen_hiku_all(int j){
               for (int i = 0; i < zikan; i+=1) {
     PVector v1 = kansetsuPoints[j][i]; 
     PVector v2 = kansetsuPoints[j][i+1]; 
     
      line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);

    }
}
 
void keyPressed(){
  if (key == CODED){
    if (keyCode == UP){
if(zikan<zikanKosu-1){
  zikan++; }
  else{
  zikan = 0;
  background(bgColor);
}
}else if (keyCode == DOWN) {
if(zikan>0){
  zikan--;}
  else{
zikan = 0;
  }
}
}
}


