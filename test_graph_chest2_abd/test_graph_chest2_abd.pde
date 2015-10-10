// 2015年
// 2015/10/10改訂


String sname = "../kokyu_graph"; // グラフの出力先
String[] fname={
"../kokyu_data"
  }; // データ読み込み先。複数設定可能。

int fkazu = fname.length;

int moziSpace = 15;


int color1 = #FC29CB; //ピンク
int color2 = #29FCA6; //水色
int color3 = #D5E810; //緑色
//int color1 = 10;
//int color2 = 200;
//int color3 = 255;

int haikei = 120; // 背景色
int mozicol = 255; //　文字色

String[] muneR;
String[] muneL;
String[] hara;

int yoko = 1300;
int tate = 150;
int t_bairitsu = 4;
int y_bairitsu = 1;
int futosa = 2;

background(haikei);
size(yoko, (tate + moziSpace)*fkazu);
strokeWeight(futosa);

for (int j=0; j<fkazu; j++){

muneR = loadStrings(fname[j]+"/test_0.txt");
muneL = loadStrings(fname[j]+"/test_1.txt");
hara = loadStrings(fname[j]+"/test_2.txt");

int kazu = muneR.length;

//int y_bairitsu = int(yoko/kazu);

stroke(color1);
for (int i=0; i<kazu; i++){
point(y_bairitsu*i, (tate+moziSpace)*j+t_bairitsu*float(muneR[i])+0.5*tate );
}
stroke(color2);
for (int i=0; i<kazu; i++){
point(y_bairitsu*i, (tate+moziSpace)*j+t_bairitsu*float(muneL[i])+0.5*tate );
}
stroke(color3);
for (int i=0; i<kazu; i++){
point(y_bairitsu*i, (tate+moziSpace)*j+t_bairitsu*float(hara[i])+0.5*tate );
}

fill(mozicol);
textSize(moziSpace);
text(fname[j], 10, (tate+moziSpace)*j+tate);

}

save(sname+".tif");
