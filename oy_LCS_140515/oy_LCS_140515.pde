

/*
(1) 3点がある。p1, p2, p3. これらから右ねじ系の基底を作る。
(2) n個の点がある。n個の点を、基底で表現する。変換行列をもとめる。

*/

import peasy.*;
PeasyCam camera;  

int kosu=5;

PVector[] v = new PVector[kosu];
PVector[] kitei = new PVector[3];

void setup(){
// 点を与える
  for (int i=0; i<kosu; i++){
  v[i] = PVector.random3D();
  v[i].mult(100);
  println(v);
 } 
// 基底を作る
kitei[0] = PVector.sub(v[1], v[0]);
kitei[0].normalize();
kitei[1] = kitei[0].cross(PVector.sub(v[2], v[0]));
kitei[1].normalize();
kitei[2] = kitei[0].cross(kitei[1]);
//kitei[2].normalize();

println(kitei);
//　基底の大きさの確認
float[] m = new float[3];
for (int i=0; i<3; i++){
  m[i]=kitei[i].mag();
}
println(m);
/* 基底同士がなす角度の確認
float[] kakudo = new float[3];

  kakudo[0] = degrees(PVector.angleBetween(kitei[0], kitei[1]));
  kakudo[1] = degrees(PVector.angleBetween(kitei[1], kitei[2]));
    kakudo[2] = degrees(PVector.angleBetween(kitei[0], kitei[2]));
println(kakudo);
*/  

size(500,500, P3D);
  camera = new PeasyCam(this, 0, 0, 0, 50);
}

void draw(){
background(0);


stroke(255);
for (int i=0; i<3; i++){
  line(v[0].x,v[0].y,v[0].z,v[0].x+kitei[i].x*100,v[0].y+kitei[i].y*100,v[0].z+kitei[i].z*100);
}

noStroke();
lights();
for (int i=0; i<kosu; i++){
pushMatrix();
translate(v[i].x, v[i].y, v[i].z);
if (i<3){
  fill(0,255,0);
}
else{
  fill(255);
  }
sphere(5);
//text (i, 0,0,0);
popMatrix();

}

applyMatrix( kitei[0].x, kitei[0].y, kitei[0].z,0,
 kitei[1].x, kitei[1].y, kitei[1].z,0,
  kitei[2].x, kitei[2].y, kitei[2].z,0,
  0,0,0,1);
translate(-v[0].x, -v[0].y, -v[0].z);




stroke(255,0,0);
for (int i=0; i<3; i++){
    line(v[0].x,v[0].y,v[0].z,v[0].x+kitei[i].x*100,v[0].y+kitei[i].y*100,v[0].z+kitei[i].z*100);
}
noStroke();

for (int i=0; i<kosu; i++){
pushMatrix();

translate(v[i].x, v[i].y, v[i].z);
fill(255,0,0);
//text (i, 0,0,0);
sphere(5);
popMatrix();

}
/*
for (int i=0; i<3; i++){
pushMatrix();
translate(kitei[i].x, kitei[i].y, kitei[i].z);

sphere(1);
popMatrix();

}
*/


if (keyPressed){
//resetMatrix();
//translate(v[0].x, v[0].y, v[0].z);
//rotateX(PI/3.0);
printMatrix();
//popMatrix();
//translate(-50,-50,-50);
//}
}


}
