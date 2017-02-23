// Coded by Mitsuteru Kokubun

import processing.video.*;               // video ライブラリを使う
import jp.nyatla.nyar4psg.*;             // nyar4psg ライブラリを使う
 
Capture cam;                             // Capture オブジェクトの宣言
MultiNft nft;                            // ★ MultiNft オブジェクトの宣言
PShape obj;                              // CG を扱う PShape オブジェクトの宣言
int pz;                                  // ★ CG モデルを動かすための変数 pz の宣言
 
void setup() {
  // ウィンドウとカメラの設定
  size(640, 480, P3D);                   // ウィンドウのサイズ設定（P3Dモード）
  String[] cameras = Capture.list();     // 利用可能なカメラデバイスを取得
  printArray(cameras);                   // 利用可能なカメラデバイスをコンソールに表示
  cam = new Capture(this, cameras[0]);   // ★ cameras[ ] 内にカメラのテストで控えた数字を入れる
  cam.start();                           // カメラをスタート
  // NyARToolkit の設定
  nft = new MultiNft(this,               // ★ NyARToolkit の初期設定
             width,                      // カメラ画像の幅（ウィンドウの幅と同じ 640）
             height,                     // カメラ画像の高さ（ウィンドウの高さと同じ 480）
             "camera_para.dat",          // カメラの校正ファイル
             NyAR4PsgConfig.CONFIG_PSG); // cnyar4psg を Processing 用に設定する決まり文句
  nft.addNftTarget("launchpad", 145);    // ★ 認識するターゲット画像を登録 (ファイル名, 画像の幅[mm])
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
  nft.detect(cam);                       // ★ キャプチャした画像内でマーカを探す
  nft.drawBackground(cam);               // ★ ウィンドウの背景にキャプチャした画像を設定
  if(nft.isExist(0) == false) {          // ★ ターゲット[0] が存在しなければ
    return;                              // 何もせず処理を終える
  }
  nft.beginTransform(0);                 // ★ ターゲット[0] の位置にもとづいて座標の投射（変換）を始める
    lights();                            // 3D シーンに照明を追加
    scale(0.15);                         // ★ CG モデルのサイズを調整
    translate(-500, 300, pz);            // ★ 原点の位置の調整
    rotateX(PI/4);                       // ★ CG モデルを X軸まわりに 45度（π/4）回転させる
    shape(obj);                          // CG モデルを表示
  nft.endTransform();                    // ★ 座標の投射（変換）を終了
  // AR 処理の終了
  pz += 20;                              // ★ CG を動かす値を増やす
  if(pz > 1000) {                        // ★ もし pz が 一定値以上なら
    pz = 0;                              // ★ 元の位置に戻す
  }
}