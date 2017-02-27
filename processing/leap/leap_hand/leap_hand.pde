// Coded by Mitsuteru Kokubun, 2017.02.26

import com.leapmotion.leap.*;               // LeapJava ライブラリを使う

Controller leap = new Controller();         // leap という名前で Controller オブジェクトを宣言

void setup() {
  size(800, 600);                           // ウィンドウのサイズ設定
}

void draw() {
  background(0);                            // 背景を黒に
  Frame frame = leap.frame();               // Frame オブジェクトを宣言し、leap のフレームを入れる
  HandList hands = frame.hands();           // HandList オブジェクトを宣言し、frame 内の手（複数）の情報を取得
  for(int i = 0; i < hands.count(); i++) {  // 見つかった全ての手について
    Hand hand = hands.get(i);               // Hand オブジェクトを宣言し、i 番目の手を取得
    Vector palmPos = hand.palmPosition();   // Vector オブジェクトを宣言し、その手の手のひらの位置を取得
    textSize(40);                           // 文字サイズ
    text(hand.id() + palmPos.toString(), 0, 40 * (i + 1));  // その手の ID と手のひらの位置をテキストで表示
  }
}