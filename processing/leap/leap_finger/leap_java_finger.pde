// Coded by Mitsuteru Kokubun, 2017.02.26

import com.leapmotion.leap.*;               // LeapJava ライブラリを使う

Controller leap = new Controller();         // leap という名前で Controller オブジェクトを宣言
InteractionBox iBox;                        // InteractionBox オブジェクト（座標変換などをする）を宣言

void setup() {
  size(800, 600, P3D);                      // P3D モードでウィンドウを作る
}

void draw() {
  background(0);                            // 背景を黒に
  Frame frame = leap.frame();               // Frame オブジェクトを宣言し、leap のフレームを入れる
  HandList hands = frame.hands();           // HandList オブジェクトを宣言し、frame 内の手（複数）の情報を取得
  iBox = frame.interactionBox();            // InteractionBox を初期化
  for(int i = 0; i < hands.count(); i++) {  // 見つかった全ての手について
    Hand hand = hands.get(i);               // Hand オブジェクトを宣言し、i 番目の手を取得
    drawPalm(hand);                         // drawPalm 関数を呼ぶ
    drawFingerTip(hand);                    // ★ drawFingerTip 関数を呼ぶ
  }
}

// 手のひらを描画する drawPalm 関数（Hand オブジェクトを引数に取る）
void drawPalm(Hand hand) {
  Vector palmPos = hand.palmPosition();     // 手のひらの位置を取得
  Vector palmPosNorm = iBox.normalizePoint(palmPos, false); // 標準化された座標値に変換
  pushMatrix();                             // 描画座標の変換開始
    translate(palmPosNorm.getX() * width,   // 標準化された座標値にウィンドウの幅を掛けて画面内の座標に変換
              (1 - palmPosNorm.getY()) * height,  // ウィンドウの高さを掛けて画面内の座標に変換
              palmPosNorm.getZ() * 50);     // Z軸（奥行方向）は適当に 50 を掛けた
    rotateX(-1 * hand.direction().pitch()); // X軸まわりに座標を回転（手の pitch 角度ぶん）
    rotateY(-1 * hand.direction().yaw());   // Y軸まわりに座標を回転（手の yaw 角度ぶん）
    rotateZ(-1 * hand.palmNormal().roll()); // Z軸まわりに座標を回転（手の roll 角度ぶん）
    noStroke();                             // 線は描かない
    fill(255);                              // 白く塗りつぶす
    lights();                               // 3D シーン内に照明を置く
    box(80, 10, 100);                       // 手のひらを示す箱を描く
    stroke(255);                            // 線を描く（白）
    line(0, 0, 0, 50);                      // 箱の中心から Y 軸方向に 50ピクセル
  popMatrix();                              // 描画座標の変換終了
}

// ★ 指先を描画する drawFingerTip 関数（Hand オブジェクトを引数に取る）
void drawFingerTip(Hand hand) {
  FingerList fingers = hand.fingers();        // FingerList オブジェクトに見つかった指の情報（複数）を入れる
  for(int i = 0; i < fingers.count(); i++) {  // 見つかった全ての指について
    Finger finger = fingers.get(i);           // 指 i を取得（0:親指, 1:人差し指, 2:中指, 3:薬指, 4:小指）
    Vector tipPos = finger.tipPosition();     // その指の指先（tip）の位置を取得
    Vector tipPosNorm = iBox.normalizePoint(tipPos, false);   // 標準化された座標値に変換
    if(finger.isExtended() == true) {         // その指が伸びて（isExtended）いたら
      fill(255, 0, 0);                        // 塗りつぶし色を赤に
    } else {                                  // そうでなければ（伸びていなければ）
      fill(255, 255, 255);                    // 塗りつぶし色を白に
    }
    pushMatrix();                           // 描画座標の変換開始
      translate(tipPosNorm.getX() * width,  // 標準化された座標値にウィンドウの幅を掛けて画面内の座標に変換
                (1 - tipPosNorm.getY()) * height,   // ウィンドウの高さを掛けて画面内の座標に変換
                tipPosNorm.getZ() * 50);    // Z軸（奥行方向）は適当に 50 を掛けた
      noStroke();                           // 線は描かない
      lights();                             // 3D シーン内に照明を置く
      sphere(20);                           // 球を描く
    popMatrix();                            // 描画座標の変換終了
  }
}