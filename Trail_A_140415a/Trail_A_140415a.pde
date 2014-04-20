/*
Trail A.
15 April 2014.
oy.
*/

// 設定(ここから) -------------------------------------------

// ファイル名
String fname = "OnoYusuke";
// テストの実施回数
int KAISU = 3;
// 半径
int HANKEI = 10;
// 円の個数
int KOSU = 3;
// 円の最低限度の間隔
float KANKAKU  = HANKEI * 2.5;

// 設定(ここまで) -------------------------------------------

//　円の色
color IRO1 = #C4969F;
color IRO2 = #FFFFFF;
// 円の位置
int[] en_x = new int[KOSU];
int[] en_y = new int[KOSU];

// 現在正しく選択されている円の番号
int sentaku = -1;

// 始まりかどうか
boolean saishokara = true;

// タイマー
int timer;
boolean s_setted;
boolean e_setted;
int s_timer;

// 実施回数管理
int nankaime = 1;

// ファイルへの記録
String[] kiroku = new String[KAISU];

void setup(){

size (640,400);


// 文字設定
textSize(12);
textAlign(CENTER, CENTER);

// filename
String sy = str ( year() );
String sm; 
if ( month()<10 ) sm = "0"+str( month() ); else sm = str( month() );
String sd;
if ( day()<10 ) sd = "0"+str( day() ); else sd = str( day() );
String sh;
if ( hour()<10 ) sh = "0"+str( hour() ); else sh = str( hour() );
String smi;
if ( minute()<10 ) smi = "0"+str( minute() ); else smi = str( minute() );
String ss;
if ( second()<10 ) ss = "0"+str( second() ); else ss = str( second() );
fname = "./data/" + fname + "_" + sy + sm + sd + "_" + sh + smi + ss;
}

void draw(){
//時間取得
timer = millis();

// 初期化する場合  
  if (saishokara){
    background(230);
    shokika();
    sentaku = -1;
    saishokara = false;
    e_setted = false;
    s_setted = true; // この時点でタイマースタート
    s_timer = timer; // この時点でタイマースタート

  }
  
  // 線でつなぐ
for (int i=0; i<sentaku; i++){
    line(en_x[i], en_y[i], en_x[i+1], en_y[i+1]);
}
  // 円と番号を描く
for (int i=0; i<=sentaku; i++){
    fill(IRO1);
    draw_en(i);
}
for (int i=sentaku+1; i<KOSU; i++){
    fill(IRO2);
draw_en(i);
}

// クリックされた場合. 次の円の内部を正しく選択しているかどうかを調べる。
if (mousePressed && (sentaku < KOSU-1)){
  if (sq(mouseX-en_x[sentaku+1])+sq(mouseY-en_y[sentaku+1])<=sq(HANKEI)){
    sentaku++;
  }
}  

// 0が選ばれた瞬間をとらえる場合
if (sentaku >=0 && !s_setted){
  s_timer = timer;
  s_setted = true;
}

// 最後の円まで到達 
if ( sentaku == KOSU-1 ){
// 到達した瞬間の検知
if ( e_setted==false ){
int keika = timer - s_timer;
println("所要時間："+ keika);
kiroku[nankaime-1] = str(keika);
e_setted = true;
}
// 最終回か否かを調べ、メッセージ表示。
// その後、最終回ならファイル保存。次のゲームがあるならキー入力を待つ。
if (nankaime == KAISU){  
// 最終回：メッセージ表示
  text("Completed.", en_x[sentaku],en_y[sentaku]+30);
// 最終回：ファイル保存
  saveStrings(fname+".txt", kiroku);
} else {
// 次のゲームあり：メッセージ表示
  text("Press any key.", en_x[sentaku],en_y[sentaku]+30);
// 次のゲームあり：次のゲーム開始のためのキー入力を待つ
if ( keyPressed ){
  saishokara = true;
  nankaime++;
  }
}
}  

}

//
void shokika(){
// 座標設定
for (int i=0; i<KOSU; i++){
  boolean kasanari = true;
  while(kasanari){
  en_x[i] = (int)random(KANKAKU, width-KANKAKU);
  en_y[i] = (int)random(KANKAKU, height-KANKAKU);
  
  if (i==0){
   break; // whileループ抜け。次の円へ。
   }
  // これまでの円と重なるか調べる 
  kasanari = false;
  for (int j=0; j<i; j++){
      if (sq(en_x[i] - en_x[j])+sq(en_y[i] - en_y[j])<=sq(KANKAKU)){
      kasanari = true;
      break; // 重なりを調べるループから抜け。
      } 
   }
  // 重なりを調べるループを抜けている。kasanariはtrueかfalseかになっているはず。
  // kasanariがtrueならwhileのループを抜けられず、再び乱数を得る。falseなら抜けられ、次の円へ。 
  }
  // whileループ抜け。次の円へ。
  }

}
 
 
 
// 円と番号を描く関数  
void draw_en(int i){
  ellipse(en_x[i], en_y[i], HANKEI*2, HANKEI*2);
  fill(0);
  text(i, en_x[i], en_y[i]);
}
