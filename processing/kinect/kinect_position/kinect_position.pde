// Coded by Mitsuteru Kokubun

import kinect4WinSDK.*;                       // kinect4WinSDK ライブラリを使う
 
Kinect kine = new Kinect(this);               // Kinect オブジェクト "kine" の宣言
SkeletonData user;                            // SkeletonData オブジェクト "user" の宣言
PImage backImage;                             // 背景画像用の PImage "backImage" の宣言
 
void setup() {
  size(640, 480);                             // ウィンドウのサイズ設定
  backImage = loadImage("back.jpg");          // 背景画像の読み込み
  user = new SkeletonData();                  // SkeletonData のインスタンス化
}
 
void draw() {
  background(0);                              // 背景を黒く塗りつぶす
  image(backImage, 0, 0, 640, 480);           // 背景画像を描画
  image(kine.GetMask(), 0, 0, 640, 480);      // Kinect の人物マスク画像を描画
  drawPosition();                             // 関数 drawPosition() を実行
}
 
// 人物が検出された時に実行される appearEvent 関数
void appearEvent(SkeletonData sd) {
  user = sd;                                  // 検出された人物をuserに入れる
}
 
// 人物がいなくなった時に実行される disappearEvent 関数
void disappearEvent(SkeletonData sd) {
  user = null;                                // userを空（null）にする
}
 
// 人物の位置を描画する drawPosition 関数
void drawPosition() {
  if(user == null) {                          // userが空なら
    return;                                   // 何もしないで関数を抜ける
  }
  // 人物の位置に円を描く
  colorMode(RGB);                             // 色の指定を RGB 形式にする
  noStroke();                                 // 線は描かない
  fill(255, 127, 0);                          // 塗りつぶす色の指定 (Red, Green, Blue)
  ellipse(user.position.x * width,            // 円の中心のx座標（userのx座標は0～1で得られる）
          user.position.y * height,           // 円の中心のy座標（userのy座標は0～1で得られる）
          30, 30);                            // 円の幅, 高さ
  // 人物の位置情報をテキストで描く
  textSize(48);                               // 文字サイズの設定
  text("ID:" + user.dwTrackingID    + "/ " +  // userのID
       nf(user.position.x, 1, 2)    + ", " +  // userのx座標（nfで小数第二位まで表示）
       nf(user.position.y, 1, 2)    + ", " +  // userのy座標（nfで小数第二位まで表示）
       round(user.position.z / 100) + "cm",   // userのz座標（距離：x100cmで得られるので100で割り四捨五入）
       20, 450);                              // 文字列の表示位置 (x, y)
}