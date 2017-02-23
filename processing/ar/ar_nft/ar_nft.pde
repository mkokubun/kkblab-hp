import processing.video.*;               // using "video" library
import jp.nyatla.nyar4psg.*;             // using "nyar4psg" library

Capture cam;                             // declaration of Capture object
MultiNft nft;                            // declaration of MultiNft object
PShape obj;                              // declaration of PShape array object
int pz;                                  // variable for rotation of 3DCG model

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
  nft.addNftTarget("launchpad", 145);    // adding NFT target[0] (name, target_width[mm])
  // PShape setting
  obj = loadShape("rocket.obj");         // loading a 3DCG model named "drop.obj"
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
  if(nft.isExist(0) == false) {          // if target[0] is not exist within the image
    return;                              // do nothing and find next target
  }
  nft.beginTransform(0);                 // starting coordinate projection based on target[i]
    lights();                            // adding lights in the 3D scene
    scale(0.15);                         // adjusting the size of the 3DCG model
    translate(-500, 300, pz);            // adjusting the position of the 3DCG model
    rotateX(PI/4);                       // rotating the 3DCG model 45 degrees around the X axis
    shape(obj);                          // displaying the 3DCG model
  nft.endTransform();                    // ending coordinate projection
  // End of AR process
  pz += 20;                              // changing rotation angle
  if(pz > 1000) {                        // 
    pz = 0;                              // 
  }
}