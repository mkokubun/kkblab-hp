// ar_obj.pde
// A 3DCG (*.obj) AR demo using NyARToolkit and Proceccing 3.
// Install "video" library via "Add Library" tool of the Processing IDE.
// Install "nyar4psg" library according to the URL below.
// Connect a Web camera to your PC.
// * Rewrite "x" with the camera device number you use.
// Place "camera_para.dat" in "data" folder of this sketch.
//   - "camera_para.dat" is included within ./libraries/nyar4psg/data
// Place "rocket.obj", "rocket.mtl", and "rocket.png" in "data" folder of this sketch.
//   - "rocket.*" are included within ./Processing_3.x.x/
//       modes/java/exmples/Basics/Shape/LoadDisplayOBJ/data
// Print NyID markers on paper. ("NyId_000-005.pdf")
// Run this sketch, and check that a rocket of 3DCG is superimposed on the marker.
// Coded by Mitsuteru Kokubun, 2017/02/20

import processing.video.*;               // using "video" library
import jp.nyatla.nyar4psg.*;             // using "nyar4psg" library

Capture cam;                             // declaration of Capture object
MultiMarker mm;                          // declaration of MultiMarker object
PShape obj;                              // declaration of PShape object
float ry;                                // variable for rotation of 3DCG model

void setup() {
  // window and camera settings
  size(640, 480, P3D);                   // setting size of window with P3D mode
  String[] cameras = Capture.list();     // getting available camera devices
  printArray(cameras);                   // listing available camera devices
  cam = new Capture(this, cameras[12]);  // * Rewrite [x] with the device number you use.
  cam.start();                           // starting capture
  // NyARToolkit settings
  mm = new MultiMarker(this,             // initial settings of NyARToolkit
             width,                      // width of the input image
             height,                     // height of the input image
             "camera_para.dat",          // camera calibration parameter file
             NyAR4PsgConfig.CONFIG_PSG); // configuration for Processing
  mm.addNyIdMarker(0, 80);               // adding NyId marker(ID, marker_width[mm])
  // PShape setting
  obj = loadShape("rocket.obj");         // loading a 3DCG model named "rocket.obj"
}

void draw() {
  // video capture
  if(cam.available() == false) {         // if camera is not available
    return;                              // do nothing and return
  }
  cam.read();                            // capturing image
  // Start of AR process
  mm.detect(cam);                        // detecting marker within captured image
  mm.drawBackground(cam);                // drawing captured image on background
  if(mm.isExist(0) == false) {           // if marker[0] is not exist within the image
    return;                              // do nothing and return
  }
  mm.beginTransform(0);                  // starting coordinate projection based on marker[0]
    lights();                            // adding lights in the 3D scene
    scale(0.3);                          // adjusting the size of the 3DCG model
    translate(0, 0, 80);                 // adjusting the position of the 3DCG model
    rotateX(PI/2);                       // rotating the 3DCG model 90 degrees around the X axis
    rotateY(ry);                         // rotating the 3DCG model ry radians around the Y axis
    shape(obj);                          // displaying the 3DCG model
  mm.endTransform();                     // ending coordinate projection
  // End of AR process
  ry += 0.1;                             // changing rotation angle
}