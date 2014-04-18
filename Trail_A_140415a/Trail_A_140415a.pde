/*
Trail A.
15 April 2014.
oy.
*/

// 半径
int HANKEI = 10;
// 円の個数
int KOSU = 15;
// 円の最低限度の間隔
float KANKAKU  = HANKEI * 2.5;
//　円の色
color IRO1 = #C4969F;
color IRO2 = #FFFFFF;
// 円の位置
int[] en_x = new int[KOSU];
int[] en_y = new int[KOSU];

// 現在正しく選択されている円の番号
int sentaku = -1;

// フォント
PFont font;

void setup(){

size (640,400);

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

// フォント
font = loadFont("SansSerif-12.vlw");
textFont(font);
textAlign(CENTER, CENTER);
}

void draw(){
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

// 完了. 祝福のメッセージ表示.
if ( sentaku == KOSU-1 ){
  font = loadFont("SansSerif-18.vlw");
  textFont(font);
  text("Completed.", en_x[sentaku],en_y[sentaku]+30);
}

}
 
// 円と番号を描く関数  
void draw_en(int i){
  ellipse(en_x[i], en_y[i], HANKEI*2, HANKEI*2);
  fill(0);
  text(i, en_x[i], en_y[i]);
}
