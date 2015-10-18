// 2015年
// 2015/10/18改訂

String sname = "../kokyu_graph"; // グラフの出力先
String dirname="../kokyu_data";
String fname="test2";

int Kazu = 7;
int tkazu = 1200;

int moziSpace = 15;
int yohaku = 10;

int[] iro = new int[Kazu];

iro[0] = #FC29CB;// ピンク
iro[1] = #29FCA6;// 水色
iro[2] = #D5E810;// 緑色
iro[3] = #FF0000;// 赤色
iro[4] = #FF00D5;// シアン
iro[5] = #6900FF;// 紫色
iro[6] = #0017FF;// 青

int haikei = 120; // 背景色
int mozicol = 255; //　文字色

String[][] mune = new String[Kazu][tkazu];

int yoko = 1300;
int tate = 400;
int t_bairitsu = 4;
int x_bairitsu = 1;
int futosa = 2;

background(haikei);
size(yoko, tate + moziSpace);
strokeWeight(futosa);


for (int i=0; i<Kazu; i++){
mune[i] = loadStrings(dirname+"/"+fname+"_"+str(i)+".txt");
}



//int y_bairitsu = int(yoko/kazu);
for (int j=0; j<Kazu; j++){
stroke(iro[j]);
for (int i=0; i<tkazu; i++){
point(yohaku+x_bairitsu*i, t_bairitsu*float(mune[j][i])+0.5*tate );
}
}

fill(mozicol);
textSize(moziSpace);
text(dirname, 10, (tate+moziSpace)*1+tate);


save(sname+".tif");
