float opacity = 255;

void settings() {  
  fullScreen(P3D);
  smooth();
}
void setup() { 
//INITIALISING FUNCTIONS FOR EACH ELEMENT//  
  roseSetup();

  SwarmSetup();

  guiSetup();

  motionSetup();
}
void draw() {

  noStroke();
  fill(fill, opacity);
  rect(0, 0, width, height);

//ROSES DRAW CALL//
  if (rose ==true) {
    drawRoses();
    opacity = 200;
  }

//SWARM DRAW CALL//
  if (swarm == true) {
    opacity =100;
    drawSwarm();
  }
  
  beatDetection();
//MOTION DETECTION CALL//
  if (motion_detection == true) {
    motionDet();
    position_Pn.x=destX;
    position_Pn.y=destY;
  }  

//GUI DRAW//
  translate(0, 0, 2);
  control.draw();
}

//CONVERTS HSB TO RGB//

int[] hslToRgb(float h, float s, float l) {
  float r, g, b;

  if (s == 0f) {
    r = g = b = l; // achromatic
  } else {
    float q = l < 0.5f ? l * (1 + s) : l + s - l * s;
    float p = 2 * l - q;
    r = hueToRgb(p, q, h + 1f/3f);
    g = hueToRgb(p, q, h);
    b = hueToRgb(p, q, h - 1f/3f);
  }
  int[] rgb = {(int) (r * 255), (int) (g * 255), (int) (b * 255)};
  return rgb;
}
float hueToRgb(float p, float q, float t) {
  if (t < 0f)
    t += 1f;
  if (t > 1f)
    t -= 1f;
  if (t < 1f/6f)
    return p + (q - p) * 6f * t;
  if (t < 1f/2f)
    return q;
  if (t < 2f/3f)
    return p + (q - p) * (2f/3f - t) * 6f;
  return p;
}