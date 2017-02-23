// Coded by Mitsuteru Kokubun

import kinect4WinSDK.*;                      // kinect4WinSDK ライブラリを使う
 
Kinect kine = new Kinect(this);              // Kinect オブジェクト "kine" の宣言
PImage backImage;                            // 背景画像用の PImage "backImage" の宣言
 
void setup() {
  size(640, 480);                            // ウィンドウのサイズ設定
  backImage = loadImage("back.jpg");         // 背景画像の読み込み
}
 
void draw() {
  background(0);                             // 背景を黒く塗りつぶす
  image(backImage, 0, 0, 640, 480);          // 背景画像を描画
  // image(kine.GetImage(), 0, 0, 640, 480);    // Kinect のカラー画像を描画
  image(kine.GetMask(), 0, 0, 640, 480);     // Kinect の人物マスク画像を描画
}