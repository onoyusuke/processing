/* 3sep2015. 
int hen = 2;  // 取得する領域の辺(hen)の長さ
リアルタイムグラフの修正：更新のタイミング。
*/
// 20May2015 三点への拡張
/* 
28Nov2014. Fri.
＊時系列データをとる。
フレームレートの決定。その時間ごとにデータ取得し、記録。
最大長の長さも決める。例えば、1分間とか。

タイマーによるミリ秒を単位とする割り込みでデータを取得しようとしても、取得できない可能性がある。

*/
// 24Nov2014. Sat.
// 点を２個に拡張。
// TABを押すことでそこが基準になる。
// 矢印で基準の幅を調整。

// 3Nov2013. Sun
//
// [ 実装 ]
// * RGB画面上の円(sono1)の中心(sono1.x, sono1.y)の距離(skyori)を追う。
// * 距離を示す円が前後に動く。
// * キーを押すとそこが基準になり、基準値が設定される。
// [ 今後 ]
// * 軌跡をリアルタイムに表示するようにするか。つなぐ。やや太く。
// * 前後の範囲の調整をうまくやりたい。
// * 目盛りの表示。
//

// 記録ファイル名
String fname = "../kokyu_data/test2";

// 円の数
int Kazu = 7;

// Kinect
import SimpleOpenNI.*;
SimpleOpenNI kinect;
// Font
PFont font;

// 一秒あたり何枚記録するか
int kiroku_rate = 20;

// 時間単位
int chosei = 1000/kiroku_rate;
// 記録時間は秒で指定.
int kiroku_byo = 60;
int kirokuzikan = kiroku_byo*1000/chosei;

// 記録する周期を計算
int kiroku_shuki = (1000/kiroku_rate)/chosei;
// 記録用の配列準備
String[][] rec_kyori = new String[Kazu][ceil(kirokuzikan/kiroku_shuki)];
/* debug
  int test_kazu=1000;
  String[] test_rec = new String[test_kazu];
  int counter=0;
*/

// OyEnという円を描くクラスの設定
OyEn[] sono1 = new OyEn[Kazu];
int sx = 160;
int sy = 100;
int hankei = 10;
// 
int haba = 280;
int takasa =100;
int hankei2 = 10;
OyEn[] sono2 = new OyEn[Kazu];

int mado = 70;
int bairitsu = 4;
int futosa = 2;
int hyoziKazu = 600;

float[][] gra = new float[Kazu][hyoziKazu];


int haikei = 180;

int hen = 2;  // 取得する領域の辺(hen)の長さ

//
  int[] kizyun = new int[Kazu]; // とりあえずの基準値。
  float zengo = 50; // 前後の移動の範囲の合計はこの範囲に収める。
  int vertab = 25;
//
int[] iro = new int[Kazu];


//
int kaishi = 0;
//
  int[] zahyo = new int[Kazu];
  int[] skyori = new int[Kazu];


void setup() {
  size (640 + haba, 480 + mado*2);
  for(int i=0; i<Kazu; i++){
sono2[i] = new OyEn (650+i*int(haba/Kazu), takasa, hankei2);
  }

iro[0] = #FC29CB;// ピンク
iro[1] = #29FCA6;// 水色
iro[2] = #D5E810;// 緑色
iro[3] = #FF0000;// 赤色
iro[4] = #FF00D5;// シアン
iro[5] = #6900FF;// 紫色
iro[6] = #0017FF;// 青

// Kinect
kinect=new SimpleOpenNI(this);
kinect.enableDepth();
kinect.enableRGB();
kinect.alternativeViewPointDepthToImage();
// 円
for(int i=0; i<Kazu; i++){
  sono1[i] = new OyEn (sx+10*i, sy+20*i, hankei);   
} 
//
for (int i=0; i<Kazu; i++){
  for (int j=1; j<hyoziKazu; j++){
  gra[i][j] = 0; // 番号ずらす
}
}
}

void draw() {

  int keikazikan = millis()/chosei;
    
//
background(haikei);
stroke(255);
  
// Kinectより画像を取得し表示
kinect.update();
PImage img = kinect.rgbImage();
int[] depthValues = kinect.depthMap();
image(img,0,0);
// 標的を示す円を描く
for(int i=0; i<Kazu; i++){
  fill(iro[i]);
  stroke(0);
  strokeWeight(0);
  sono1[i].display();
}
  
  
// 円の中心の距離情報の取得
for(int i=0; i<Kazu; i++){
  skyori[i] =0;
  for(int j=0; j<hen; j++){
    for(int k=0; k<hen; k++){
      zahyo[i] = 640 * (sono1[i].y + k) + sono1[i].x + j;
      skyori[i] =  depthValues[ zahyo[i] ] + skyori[i];
    }
  }
  skyori[i] = skyori[i]/(hen*hen);
}

for(int i=0; i<Kazu; i++){
print(i+": "+skyori[i]+"     ");
}

/* debug
test_rec[counter]=str(skyori[0]);
counter++;
if (test_kazu<=counter) 
{
  saveStrings("debug.txt", test_rec);
  exit();
}
*/


// 時間管理とそれに伴う距離情報の蓄積
println(float((keikazikan-kaishi)*chosei/1000)+"秒"); 
 
if ((( (keikazikan-kaishi) % kiroku_shuki ) == 0) && 
    ((keikazikan-kaishi) < kirokuzikan)){
      // 記録時間(kirokuzikan)の範囲だけ、記録する
int bango = int((keikazikan-kaishi)/kiroku_shuki);
//println(bango);  

for(int i=0; i<Kazu; i++){
  rec_kyori[i][bango] = str(skyori[i] - kizyun[i]);
}
    }

// 距離を表す円を描く
for(int i=0; i<Kazu; i++){
  fill(iro[i]);
sono2[i].y = int(map(skyori[i], kizyun[i]-int(zengo/2), kizyun[i]+int(zengo/2), vertab, 480-vertab));
sono2[i].display();
}


fill(128);
textSize(20);
textAlign(LEFT, CENTER);
//textAlign(CENTER);
//textAlign(RIGHT);
text(" +"+str(int(zengo/2))+"mm", 640, vertab);
text("  0mm", 640,240);
text(" -"+str(int(zengo/2))+"mm", 640, 480-vertab);

//println ( "前後の長さ: "+ zengo );

// グラフを描く
for (int i=0; i<Kazu; i++){
    stroke(iro[i]);
    strokeWeight(futosa);
for (int j=0; j<hyoziKazu-1; j++){
gra[i][j] = gra[i][j+1]; // 番号ずらす
}
  gra[i][hyoziKazu-1] = skyori[i] - kizyun[i];
//
//// 描く
for (int j=0; j<hyoziKazu; j++){

point(j,480+mado+bairitsu*gra[i][j]);
//point(hyoziKazu-1, 480+mado+gra[i][hyoziKazu-1]);
}
}
//
if ( mousePressed ) {
 for(int i=0; i<Kazu; i++){
  if (sono1[i].inp(mouseX, mouseY)){
    sono1[i].x = mouseX;
    sono1[i].y = mouseY;
  }
  }
}



if (keyPressed){
  if (key == TAB) {
 for(int i=0; i<Kazu; i++){
    zahyo[i] = 640 * sono1[i].y + sono1[i].x;
    kizyun[i] = depthValues[ zahyo[i] ];
 }
    //　開始時間再設定
    kaishi = keikazikan;
  }
  if (key == ENTER) {
  // 記録
 // println(rec_kyori[0]);
  println("Saved");
  exit();
   for(int i=0; i<Kazu; i++){
  saveStrings(fname+"_"+i+".txt", rec_kyori[i]);
   }
  save(fname+".tif");
  }




  
  if (key == CODED) {
    if (keyCode == UP) {
      zengo ++;
    }
    if (keyCode == DOWN) {
      zengo --;
    }    
  }
} 
}



