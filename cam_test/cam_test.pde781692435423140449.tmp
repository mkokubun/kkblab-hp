// cam_test.pde
// Install "video" library via "Add Library" tool of Processing IDE.
// Connect a Web camera to your PC.
// Run this sketch once.
// Find a camera device number with "size=640x480,fps=30" from the list.
// * Rewrite "x" with the device number you use.
// Run this sketch again, and confirm the video is shown.
// Coded by Mitsuteru Kokubun, 2017/02/20

import processing.video.*;               // using "video" library

Capture cam;                             // declaration of Capture object

// setup() function is executed once
void setup() {
  size(640, 480);                        // setting size of window
  String[] cameras = Capture.list();     // getting available camera devices
  printArray(cameras);                   // listing available camera devices
  cam = new Capture(this, cameras[12]);  // * Rewrite [x] with the device number you use.
  cam.start();                           // starting capture
}

// draw() function is exectuted repeatedly
void draw() {
  if(cam.available() == false) {         // if camera is not available
    return;                              // do nothing and return
  }
  cam.read();                            // capturing image
  image(cam, 0, 0);                      // displaying captured image
}