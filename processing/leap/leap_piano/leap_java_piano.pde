// Coded by Mitsuteru Kokubun, 2017.02.26

import com.leapmotion.leap.*;               // LeapJava ライブラリを使う
import processing.sound.*;                  // ★ sound ライブラリを使う

Controller leap = new Controller();         // leap という名前で Controller オブジェクトを宣言
InteractionBox iBox;                        // InteractionBox オブジェクト（座標変換などをする）を宣言
boolean pinched[] = new boolean[2];         // ★ 指がピンチ（親指と人差指でつまむ動作）か否かを入れる変数（二人プレイまで対応）
int noteNum = 8;                            // ★ 音程の数
String[] note = {"C", "D", "E", "F", "G", "A", "B", "C"}; // ★ 音名の文字列
SoundFile[] tone = new SoundFile[noteNum];  // ★ 鳴らす音を入れる SoundFile オブジェクト（配列）

void setup() {
  size(800, 600);                           // ★ このプログラムでは2次元で
  for(int i = 0; i < noteNum; i++) {        // ★ 鳴らす音の読み込み
    tone[i] = new SoundFile(this, i + ".wav");  // ★ 0:ド(C) ～ 7:ド(C) .wav
  }
}

void draw() {
  background(0);                            // 背景を黒に
  Frame frame = leap.frame();               // Frame オブジェクトを宣言し、leap のフレームを入れる
  HandList hands = frame.hands();           // HandList オブジェクトを宣言し、frame 内の手（複数）の情報を取得
  iBox = frame.interactionBox();            // InteractionBox を初期化
  drawKeys();                               // ★ drawKeys 関数で鍵盤を描く
  for(int i = 0; i < hands.count(); i++) {  // 見つかった全ての手について
    Hand hand = hands.get(i);               // Hand オブジェクトを宣言し、i 番目の手を取得
    drawThumb(hand, i);                     // ★ drawThumb 関数で親指の位置を描く
  }
}

// ★ 鍵盤を描く drawKeys 関数
void drawKeys() {
  for(int i = 0; i < noteNum; i++) {        // 音程の数ぶん
    stroke(255);                            // 白い線で
    noFill();                               // 塗りつぶしなし
    rect(0, height / noteNum * i, width, height / noteNum);         // 画面の上から矩形を描く
    textSize(40);                                                   // 文字サイズ
    text(note[(noteNum - 1) - i], 10, height / noteNum * (i + 1));  // 音名を表示
  }
}

// ★ 親指の位置を描く drawThumb 関数（手の情報と、その手のidを引数に取る）
void drawThumb(Hand hand, int id) {
  FingerList fingers = hand.fingers();      // FingerList オブジェクトに見つかった指の情報（複数）を入れる
  Finger thumb = fingers.get(0);            // 親指を取得
  Vector thumbPos = thumb.tipPosition();    // 親指の位置を取得
  Vector thumbPosNorm = iBox.normalizePoint(thumbPos, false);   // 標準化された座標値に変換
  noStroke();                               // 線は描かない
  fill(255);                                // 白く塗りつぶす
  ellipse(thumbPosNorm.getX() * width,      // 親指の位置に円を描く
          (1 - thumbPosNorm.getY()) * height,
          30, 30);
  if(hand.pinchDistance() < 20) {           // ピンチ距離が 20mm 未満なら
    playTone((1 - thumbPosNorm.getY()) * height, id);   // playTone 関数で音を鳴らす
    pinched[id] = true;                     // ピンチ状態を true にする
  } else {                                  // ピンチ距離が 20mm 以上なら
    pinched[id] = false;                    // ピンチ状態を false にする
  }
}

// ★ 音を鳴らす playTone 関数（親指の位置と、その手のidを引数に取る）
void playTone(float thumbPos, int id) {
  if(pinched[id] == true) {                 // そのidの手が既にピンチ状態なら
    return;                                 // 何もしないで抜ける（一度のピンチで何度も音が鳴らないように）
  }
  for(int i = 0; i < noteNum; i++) {        // ピンチされた位置から音程を判定
    if((thumbPos > height / noteNum * i) &&
       (thumbPos < height / noteNum * (i + 1))) {
      tone[(noteNum - 1) - i].play();       // 指定の音程の音を鳴らす
      return;                               // 抜ける
    }
  }
}