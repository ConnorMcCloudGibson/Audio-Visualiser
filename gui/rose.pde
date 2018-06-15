float r = 120;
float n;
float m;
float d2;
float step;
float increment2;
float scl; 
float algo=0;
float count=0;
float zoom = 0;
float m1;
float n1;
float snares = 0;
float shaper =2;

Rose[] roses = new Rose[3000];
PVector[] points = new PVector[roses.length];
PVector[] points2 = new PVector[roses.length];
float avgX;
float avgY;

void roseSetup() {
  
  n = 25;
  m = 50;
  d2 = -2;

//INITALISE ROSE OBJECTS OF THE ROSES ARRAY AND POINTS PVECTOR ARRAYS//

  for (int i = 0; i<roses.length; i++) {
    roses[i] = new Rose();
    points[i] = new PVector();
    points2[i] = new PVector();
  }
}

void drawRoses() {

//CALL FUNCTIONS FOR MAPPING AUDIO EVENTS TO PARAMETERS//  
  
  audioReact();

//CALL FUNCTIONS OF THE ROSE CLASS//
  for (int i = 0; i<roses.length; i++) {

    roses[i].update(i); 
    roses[i].drawRose(colour, i);

//CACULATES THE AVERAGE OF ALL COORDINATES TO USE FOR TRANSLATION AND CENRETING//   
    points[i] = roses[i].point1; 
    points2[i] = roses[i].point2; 
    avgX = points[i].x + points2[i].x;
    avgY = points[i].y + points2[i].y;
    
  }

  avgX = avgX/points.length;
  avgX = avgY/points.length;

}
void audioReact() { 

//INCREMENTS THE ROSE FUNCTION AND SCALES THE COORDINATES OF THE POINTS//  
  if (load == true) {
    step += 3;
    scl = lerp(scl, constrain(fftLin.getAvg(1)/3, 0, 4), 0.5); //band 0 or 1?

    if (snare == 1) {
      snares +=1;
    }
//INCREMENTS M VARIABLE USING ONSET DETECTION AND ADDS VALUES FROM FFT ANALYSIS//
    if (snares%2==0 && snare==1) {
      m1+=1.7;
      m1=(m+(map(fftLin.getAvg(5), 0, 1, 0, 0.25)))%100;     
      m=lerp(m, m1+10, 0.3);
    }

//INCREMENTS N AND R (ZOOM) VARIABLES USING ONSET DETECTION//
    if (kick == 1) {
      float increment_target =0;
      increment_target+=2;
      increment2 =lerp(increment, increment_target, 0.1);

      n1+=2.12;
      n=lerp(n, n1+10, 0.3);
      n=n%50;

      count+=1;
      zoom+=2;
    }
//CHANGES THE RADIUS OF THE FUNCTION BASED UPON THE "zoom" INCREMENTOR//
    r = 180+(30*sin(radians(zoom)));
  }

  d2 = step+increment;
//IF 25 ONSETS OF THE "KICK" FREQUENCY BANDS HAVE OCCURED CHANGE THE FUNCTION AND SHAPE//
  count = count%25;
  if (count== 1 && kick==1) {
    algo = int(random(7));

    shaper = random(4)+1;
    if (shaper == 3) {
      shaper = 4;
    }
  }
}  

class Rose {
  
  float x, y, x2, y2;
  float z = 0;
  PVector point1 = new PVector();
  PVector point2 = new PVector();
  float offset_x;
  float offset_y;

  Rose() {
    
  }
  

  void update(float i) { 
//GEOMETRIC FUNCTIONS//
    i = i/shaper;
    
    if (algo == 0) {     
      x = r*sin(radians(i*n/m))*tan(radians(i));
      y =  r*cos(radians(i*n/m))*sin(radians(i));
      x2 = r*sin(radians((i+d2)*n/m))*tan(radians(i+d2));
      y2 =  r*cos(radians((i+d2)*n/m))*sin(radians(i+d2));
      
    } else if (algo == 1) {
      x = r*tan(radians(i*n/m))*cos(radians(i));
      y =  r*sin(radians(i*n/m))*tan(radians(i));
      x2 = r*tan(radians((i+d2)*n/m))*sin(radians(i+d2));
      y2 =  r*sin(radians((i+d2)*n/m))*tan(radians(i+d2));
      
    } else if (algo == 2) {
      x = r*tan(radians(i*n/m))*cos(radians(i));
      y =  r*tan(radians(i*n/m))*tan(radians(i));
      x2 = r*tan(radians((i+d2)*n/m))*cos(radians(i+d2));
      y2 =  r*tan(radians((i+d2)*n/m))*tan(radians(i+d2));
      
    } else if (algo == 3) {
      x = r*tan(radians(i*n/m))*tan(radians(i));
      y =  r*cos(radians(i*n/m))*cos(radians(i));
      x2 = r*tan(radians((i+d2)*n/m))*tan(radians(i+d2));
      y2 =  r*cos(radians((i+d2)*n/m))*sin(radians(i+d2));
      
    } else if (algo == 4) {
      x = r*sin(radians(i*n/m))*tan(radians(i));
      y =  r*cos(radians(i*n/m))*cos(radians(i));
      x2 = r*sin(radians((i+d2)*n/m))*tan(radians(i+d2));
      y2 =  r*sin(radians((i+d2)*n/m))*sin(radians(i+d2));
      
    } else if (algo == 5) {
      x = r*sin(radians(i*n/m))*tan(radians(i));
      y =  r*cos(radians(i*n/m))*cos(radians(i));
      x2 = r*sin(radians((i+d2)*n/m))*tan(radians(i+d2));
      y2 =  r*sin(radians((i+d2)*n/m))*cos(radians(i+d2));
    } else if (algo == 6) {
      x = r*sin(radians(i*n/m))*tan(radians(i));
      y =  r*tan(radians(i*n/m))*cos(radians(i));
      x2 = r*sin(radians((i+d2)*n/m))*tan(radians(i+d2));
      y2 =  r*tan(radians((i+d2)*n/m))*cos(radians(i+d2));
    }

    point1  = new PVector(x, y);
    point2  = new PVector(x2, y2); 
    offset_x = (width/2)-avgX;
    offset_y = (height/2)-avgY;
    
  }
  
  void drawRose(float c, float i ) {
    
    float cd= i/roses.length;
    int[] rgb = hslToRgb(0.5, 1-pow(cd, 0.1), 1);
    int[] rgb2 = hslToRgb(1, 1-pow(cd, 0.1), 1);

    colorMode(RGB);
    noFill();

    if (i != 0) {
      stroke(rgb[0], rgb[1], rgb[2], 12.75);
//VERTEX SHAPE (LINES)//      
      beginShape(LINES);
      vertex(x+offset_x, y+offset_y, 0);
      vertex(x2+offset_x, y2+offset_y, 0);
      endShape();

      strokeWeight(2);
      stroke(rgb2[0], rgb2[1]*0.8, rgb2[2]*0.6, 62.75);
//POINTS OF THE SAME COORDINATES AS THE VERTEX SHAPE, BUT SCALED IN RESPONSE TO LOW-FREQUENCY ENERGY// 

      point(x*scl+offset_x, y*scl+offset_y, 0);
      point(x2*scl+offset_x, y2*scl+offset_y, 0);
    }
  }
}