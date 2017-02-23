// Coded by Mitsuteru Kokubun

import processing.video.*;               // video ライブラリを使う
import jp.nyatla.nyar4psg.*;             // nyar4psg ライブラリを使う
 
Capture cam;                             // Capture オブジェクトの宣言
MultiMarker mm;                          // MultiMarker オブジェクトの宣言
PShape obj;                              // CG を扱う PShape オブジェクトの宣言
float ry;                                // CG モデルを回転させるための変数 ry の宣言
 
void setup() {
  // ウィンドウとカメラの設定
  size(640, 480, P3D);                   // ウィンドウのサイズ設定（P3Dモード）
  String[] cameras = Capture.list();     // 利用可能なカメラデバイスを取得
  printArray(cameras);                   // 利用可能なカメラデバイスをコンソールに表示
  cam = new Capture(this, cameras[0]);   // ★ cameras[ ] 内にカメラのテストで控えた数字を入れる
  cam.start();                           // カメラをスタート
  // NyARToolkit の設定
  mm = new MultiMarker(this,             // NyARToolkit の初期設定
             width,                      // カメラ画像の幅（ウィンドウの幅と同じ 640）
             height,                     // カメラ画像の高さ（ウィンドウの高さと同じ 480）
             "camera_para.dat",          // カメラの校正ファイル
             NyAR4PsgConfig.CONFIG_PSG); // nyar4psg を Processing 用に設定する決まり文句
  mm.addNyIdMarker(0, 80);               // 認識するマーカを登録する (ID, マーカの幅[mm])
  // PShape の設定
  obj = loadShape("rocket.obj");         // "rocket.obj" という名前の CG モデルを読み込む
}
 
void draw() {
  // ビデオキャプチャ
  if(cam.available() == false) {         // カメラが利用可能な状態でなければ
    return;                              // 何もせず処理を終える
  }
  cam.read();                            // 映像をキャプチャする
  // AR 処理の開始
  mm.detect(cam);                        // キャプチャした画像内でマーカを探す
  mm.drawBackground(cam);                // ウィンドウの背景にキャプチャした画像を設定
  if(mm.isExist(0) == false) {           // マーカ[0] が存在しなければ
    return;                              // 何もせず処理を終える
  }
  mm.beginTransform(0);                  // マーカ[0] の位置にもとづいて座標の投射（変換）を始める
    lights();                            // 3D シーンに照明を追加
    scale(0.3);                          // CG モデルのサイズを調整
    translate(0, 0, 80);                 // 原点の位置の調整（原点をZ軸方向に 80mm 移動）
    rotateX(PI/2);                       // CG モデルを X軸まわりに 90度（π/2）回転させる
    rotateY(ry);                         // CG モデルを Y軸まわりに ry ぶん回転させる
    shape(obj);                          // CG モデルを表示
  mm.endTransform();                     // 座標の投射（変換）を終了
  // AR 処理の終了
  ry += 0.1;                             // rotateY(ry); で回転させる角度 ry を少し増やす
}