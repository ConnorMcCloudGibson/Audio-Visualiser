PVector[] attractors = new PVector[2];
int particle_max;
Swarm[] swarms = new Swarm[15000];

PVector position_L;
PVector position_Pn;
float xtime = 0.0;  
float ytime = 100.0;
float increment = 0.0;  
float repel; 
PVector prev_position_Pn;
float dir_x;
float dir_y;
float mass = 2000;//4000
float vL = 25; //50
float  G = 1;
float inertia = 1;
float invert=0;
float t_mass=1000;
float t_velocity;
float fill = 0;
boolean reset = false;
float reset_count; 
boolean part_line = true;
float movement=0;
float colour = random(1);

void SwarmSetup() {

  position_L = new PVector();
  position_Pn = new PVector();
  prev_position_Pn = new PVector(); 

  //INITALISE SWARM OBJECTS IN THE SWARMS ARRAY//

  for (int i = 0; i< swarms.length; i++) {
    swarms[i] = new Swarm(random((width/2)-50, (width/2)+50), random((height/2)-50, (height/2)+50));
  }
}
void drawSwarm() {

  //CALL THE MOVEMENT FUNCTION//

  movement();

  //CALL THE FUNCTIONS OF THE SWARM CLASS
  for (int i = 0; i<particle_max; i++) { 
    swarms[i].call(position_Pn, i, colour);
  }
  //CALCULATE RANDOM COLOUR//
  colour+=random(0.01);
  if ( colour > 1 ) { 
    colour = colour%1;
  }
  //INCREMENT USING ONSET DETECTION//
  if (kick == 1) {
    invert = invert+1;
    reset_count += 1;
  }
  //INVERT THE BACKGROUND AFTER 15 ONSET DETECTIONS//
  if (invert%16==15 && kick == 1) {
    fill = 255;
  } else {
    fill = 0;
  }
  //RESET ALL THE PARTICLES TO RANDOM LOCATIONS AFTER 300 ONSET DETECTIONS//
  if (reset_count%300==299 && kick == 1) {
    reset = true;
  } else { 
    reset = false;
  }
}
void movement() {

//IF AN AUDIOFILE HAS BEEN LOADED, APPLY MAPPINGS TO VARIABLES//
  
  if (load == true) {
    increment = 1;
    vL = constrain(fftLin.getAvg(2)*t_velocity, 2, t_velocity*2);
    mass = constrain(fftLin.getAvg(0)*1000, 2, t_mass); 
    inertia = 0.8+constrain(fftLin.getAvg(5)*0.2, 0, 5);
  }

//STORE PREVIOUS POSITION// 
  prev_position_Pn.x = position_Pn.x; 
  prev_position_Pn.y = position_Pn.y; 

  //MOVEMENT USING SIN/COSINE/PERLIN NOISE AND BEAT ANALYSIS//
  float move_x_Pn = noise(0.5, xtime)*width;
  float move_y_Pn = noise(0.5, ytime+100)*height;
  float move_xc =(width/2) + cos(xtime)*(-100+width/2);
  float move_ys = (height/2) + sin(ytime)*(-100+height/2);
  position_Pn.x = lerp(position_Pn.x, (move_xc+move_x_Pn)/2, 0.2);
  position_Pn.y = lerp(position_Pn.y, (move_ys+move_y_Pn)/2, 0.2);

  float move_x =0; 
  move_x+= (kick*movement); 
  float move_y =0; 
  move_y+= (snare*movement);
  increment+=increment;
  xtime = increment+move_x;  
  ytime = increment+move_y;
}
class Swarm {

  PVector pos;
  PVector vel = new PVector();
  PVector prev = new PVector();
  PVector acc = new PVector();
  float scale = 1;
  PVector t_pos = new PVector();
  int[] rgb;

  Swarm(float xn, float yn) {

    float x = xn;
    float y = yn;
    pos = new PVector(x, y);
    vel.setMag(random(2, 5));
  }
  void update() {

//RESET PARTICLE LOCATIONS//
    
    if (reset == true) {
      pos = new PVector((width/2)+random(-50, 50), (height/2)+random(-50, 50));
    }
//CALCULATE POSITION BASED UPON VELOCITY AND ACCELERATION//
    pos.add(vel);
    vel.add(acc);
    vel.limit(vL);
    acc.mult(0);
  }

  void show(float i, float c) {

//PLACE ATTRACTOR AT THE CENTER OF THE SCREEN//    

    t_pos.x = pos.x - position_Pn.x+width/2;
    t_pos.y = pos.y - position_Pn.y+height/2;

    float cd= i/particle_max;
    rgb = hslToRgb(c, pow(cd, 0.1), 1-cd);

    colorMode(RGB);

//POINT AND LINE DRAWING//
    if (part_line == true) {

      stroke(300-rgb[0], 300-rgb[1], 300-rgb[2], 30.5);
      strokeWeight(2);  
      line(t_pos.x*scale, t_pos.y*scale, prev.x*scale, prev.y*scale);
    } else {
      strokeWeight(2);  
      stroke(400-rgb[0], 400-rgb[1], 400-rgb[2], 80);
      point(t_pos.x*scale, t_pos.y*scale);
    }


    prev.x = t_pos.x;
    prev.y = t_pos.y;

//APPLY BOUNDARIES TO THE PARTICLES//

    if (t_pos.x<2) {
      t_pos.x = 4;
      vel.x *= -1;
    }
    if (t_pos.x>width-2) {
      t_pos.x = width-4;
      vel.x *= -1;
    }
    if (t_pos.y<2) {
      t_pos.y = 4;
      vel.y *= -1;
    }
    if (t_pos.y>height-2) {
      t_pos.y = height-4;
      vel.y *= -1;
    }
  }

  void forces(PVector target) {
    //CALCULATING THE GRAVITATIONAL FORCES, VARYING PARARAMETERS WITH SPECTRAL DATA//
    repel = 0;
    PVector dir = PVector.sub(target, pos);  
    dir.normalize();
    float strength = (mass*mass)/sqrt(sq( pos.x - target.x ) + sq( pos.y - target.y));
    dir.setMag(strength);

    //USING FREQUENCY ENERGY DETECTION TO TRIGGER ATTRACTION/REPULSION//
    if (snare == 1) {
      repel += 1;
    }
    if (repel%2 == 1) {
      dir.mult(-10);
    } else {
      dir.mult(1);
    }

    dir.div(mass/inertia);
    acc.add(dir);
  }

  void call(PVector init, float c1, float c2) {

//CALL ALL FUNCTIONS OF THE SWARM CLASS//    
    
    forces(init); 
    show(c1, c2); 
    update();
  }
}