// ar_box.pde
// A simple AR demo using NyARToolkit and Proceccing 3.
// Install "video" library via "Add Library" tool of Processing IDE.
// Install "nyar4psg" library according to the URL below.
//   -> https://github.com/nyatla/NyARToolkit-for-Processing/
// Connect a Web camera to your PC.
// * Rewrite "x" with the camera device number you use.
// Place "camera_para.dat" in "data" folder of this sketch.
//   - "camera_para.dat" is included within ./libraries/nyar4psg/data
// Print NyID markers on paper. ("NyId_000-005.pdf")
// Run this sketch, and check that an orange transparent box is superimposed on the marker.
// Coded by Mitsuteru Kokubun, 2017/02/20

import processing.video.*;               // using "video" library
import jp.nyatla.nyar4psg.*;             // using "nyar4psg" library

Capture cam;                             // declaration of Capture object
MultiMarker mm;                          // declaration of MultiMarker object

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
    translate(0, 0, 40);                 // move the origin 40 mm in the Z axis direction
    fill(255, 165, 0, 127);              // fill color(R, G, B, opacity)
    box(80);                             // draw a 80 mm square box
  mm.endTransform();                     // ending coordinate projection
  // End of AR process
}