import kinect4WinSDK.*;                      // using kinect4WinSDK library

Kinect kine = new Kinect(this);              // declaring "kine" as Kinect object
PImage backImage;                            // declaring "backImage" as PImage

void setup() {
  size(640, 480);                            // setting size of window
  backImage = loadImage("back.jpg");         // loading jpg file onto backImage
}

void draw() {
  background(0);                             // setting background to black
  image(kine.GetImage(), 0, 0, 640, 480);    // drawing Kinect RGB image
  // image(backImage, 0, 0, 640, 480);          // drawing backImage
  image(kine.GetMask(), 0, 0, 640, 480);     // drawing Kinect Mask image
}