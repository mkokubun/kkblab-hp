// ar_nft.pde
// An NFT(Natural Feature Tracking) AR demo using NyARToolkit and Proceccing 3.
// Install "video" library via "Add Library" tool of the Processing IDE.
// Install "nyar4psg" library according to the URL below.
// Connect a Web camera to your PC.
// * Rewrite "x" with the device number you use.
// Place "camera_para.dat" in "data" folder of this sketch.
//   - "camera_para.dat" is included within ./libraries/nyar4psg/data
// Place "drop.{obj, mtl}" and "time.{obj, mtl}" in "data" folder of this sketch.
//   - These obj models are made by using some modeling software, e.g. Blender.
// Place "faucet.{fset,fset3, iset}" and "time.{fset,fset3, iset}" in "data" folder of this sketch.
// Print "faucet.jpg" and "clock.jpg" on paper.
// Run this sketch, and check that the 3DCGs are superimposed on the marker.
// Coded by Mitsuteru Kokubun, 2017/02/20

import processing.video.*;               // using "video" library
import jp.nyatla.nyar4psg.*;             // using "nyar4psg" library

Capture cam;                             // declaration of Capture object
MultiNft nft;                            // declaration of MultiNft object
PShape[] obj;                            // declaration of PShape array object

void setup() {
  // window and camera settings
  size(640, 480, P3D);                   // setting size of window with P3D mode
  String[] cameras = Capture.list();     // getting available camera devices
  printArray(cameras);                   // listing available camera devices
  cam = new Capture(this, cameras[0]);   // * Rewrite [x] with the device number you use.
  cam.start();                           // starting capture
  // NyARToolkit settings
  nft = new MultiNft(this,               // initial settings of NyARToolkit
             width,                      // width of the input image
             height,                     // height of the input image
             "camera_para.dat",          // camera calibration parameter file
             NyAR4PsgConfig.CONFIG_PSG); // configuration for Processing
  nft.addNftTarget("faucet", 160);       // adding NFT target[0] (name, target_width[mm])
  nft.addNftTarget("clock", 160);        // adding NFT target[1] (name, target_width[mm])
  // PShape setting
  obj = new PShape[2];
  obj[0] = loadShape("drop.obj");        // loading a 3DCG model named "drop.obj"
  obj[1] = loadShape("time.obj");        // loading a 3DCG model named "time.obj"
}

void draw() {
  // video capture
  if(cam.available() == false) {         // if camera is not available
    return;                              // do nothing and return
  }
  cam.read();                            // capturing image
  // Start of AR process
  nft.detect(cam);                       // detecting marker within captured image
  nft.drawBackground(cam);               // drawing captured image on background
  for (int i=0; i<2; i++) {              // repeating for two NFT targets
    if(nft.isExist(i) == false) {        // if target[i] is not exist within the image
      continue;                          // do nothing and find next target
    }
    nft.beginTransform(i);               // starting coordinate projection based on target[i]
      lights();                          // adding lights in the 3D scene
      translate(-80, 40, 0);             // adjusting the position of the 3DCG model
      rotateY(PI);                       // rotating the 3DCG model 180 degrees around the Y axis 
      shape(obj[i]);                     // displaying the 3DCG model
    nft.endTransform();                  // ending coordinate projection
  }
  // End of AR process
}