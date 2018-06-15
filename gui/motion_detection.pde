import processing.video.*;
Capture video;

boolean motion_detection =false;
int videoHeight = 90;
int videoWidth = 320 ; 
PImage prevFrame;
float threshold = 30;
float targetX; 
float targetY; 
float destX = 0;
float destY = 0;
float trackX = 0;
float trackY = 0;


void motionSetup() {
//INITALISE WEB-CAM CAPTURE AND PIMAGE//
  video = new Capture(this, 320, 90, 15);
  video.start();
  prevFrame = createImage(video.width, video.height, RGB);
  Capture.list();
}

float distSq(float xl1, float yl1, float zl1, float xl2, float yl2, float zl2) {
  float d = (xl2 - xl1)*(xl2 - xl1) - (yl2 - yl1)*(yl2 - yl1) - (zl2 - zl1)*(zl2 - zl1);
  return (d);
}

void motionDet() {
  //image(video, 0, 0, 160,90);
  float avgX2 = 0;
  float avgY2 =0;
  int count=0;

  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

//LOAD PIXEL ARRAY FOR CAPTURE AND PIMAGE//
  for (int i = 0; i < video.width; i ++ ) {
    for (int j = 0; j < video.height; j ++ ) {
      int loc = i + j*video.width;           
      color current = video.pixels[loc];      
      color previous = prevFrame.pixels[loc]; 
//STORE RGB VALUES OF CAPTURE AND PIMAGE FOR ANALYSIS//
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);

//CALCULATE THE DISTANCE (DIFFERENCE) BETWEEN PIXELS//
      
      float diff = distSq(r1, g1, b1, r2, g2, b2);

      if (diff > threshold*threshold) { 
        avgX += i;
        avgY += j;
        count++;
      }
    }

    video.updatePixels();
    //prevFrame.updatePixels();
    updatePixels();
  }

  if (count>0) {
    avgX = avgX2/count;
    avgY = avgY2/count;
    trackX = avgX2;
    trackY = avgY2;
  }
//MAPPING AND INTERPOLATION//  
  targetX = map(trackX, 0, videoWidth, 0, width);
  targetY = map(trackY, 0, videoHeight, 0, height);
  destX = lerp(destX, targetX, 0.5); 
  destY = lerp(destY, targetY, 0.5);
}

//SAVE THE PREVIOUS FRAME//
void captureEvent(Capture video) {

  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
  prevFrame.updatePixels(); 
  video.read();
}