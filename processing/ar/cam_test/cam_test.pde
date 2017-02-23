// Coded by Mitsuteru Kokubun

import processing.video.*;               // video ライブラリを使う
 
Capture cam;                             // Capture オブジェクトの宣言
 
// 一度だけ実行される setup() 関数
void setup() {
  size(640, 480);                        // ウィンドウのサイズ設定
  String[] cameras = Capture.list();     // 利用可能なカメラデバイスを取得
  printArray(cameras);                   // 利用可能なカメラデバイスをコンソールに表示
  cam = new Capture(this, cameras[0]);   // ★ [0]の部分はあとから書き換える
  cam.start();                           // カメラをスタート
}
 
// 繰り返し実行される draw() 関数
void draw() {
  if(cam.available() == false) {         // カメラが利用可能な状態でなければ
    return;                              // 何もせず処理を終える
  }
  cam.read();                            // 映像をキャプチャする
  image(cam, 0, 0);                      // キャプチャした画像を表示する
}