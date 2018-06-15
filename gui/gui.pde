import controlP5.*;
ControlP5 control;

boolean swarm;
boolean rose; 
boolean loading;

void guiSetup() {

  control = new ControlP5(this);
  control.setAutoDraw(false);

//GROUPS (DROP-DOWN MENUS)//
  Group group = control.addGroup("group")
    .setPosition(0, 10)
    .setWidth(width/2-5)
    .activateEvent(false)
    .setBackgroundColor(color(255))
    .setBackgroundHeight(30)
    .setLabel("CONTROLS")
    ;
    
  Group group2 = control.addGroup("group2")
    .setPosition(5+width/2, 10)
    .setWidth(-5+width/2)
    .activateEvent(false)
    .setBackgroundColor(color(255))
    .setBackgroundHeight(30)
    .setLabel("SWARM SETTINGS")
    ;
    
//GENERAL FUNCTION CONTROLS//
    
  control.addButton("ROSE")
    .setPosition(5, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ; 
    
  control.addButton("SWARM")
    .setPosition(10+((width/2)-40)/6, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ;  
    
  control.addButton("LOAD")
    .setPosition(15+2*((width/2)-40)/6, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ;
  control.addButton("PLAY")
    .setPosition(20+3*((width/2)-40)/6, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ;

  control.addButton("PAUSE")
    .setPosition(25+4*((width/2)-40)/6, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ;

  control.addButton("REWIND")
    .setPosition(30+5*((width/2)-40)/6, 5)
    .setSize(((width/2)-40)/6, 20)
    .setGroup(group)
    ;


  control.addSlider("MASS")
    .setPosition(5, 5)
    .setSize((width/2)/6, 20)
    .setRange(2, 4000)
    .setGroup(group2)
    .setValue(2000)
    ;

//SWARM VISUALISER CONTROLS//
    
  control.getController("MASS").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  control.getController("MASS").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  control.addSlider("VELOCITY")
    .setPosition(10+(width/2)/6, 5)
    .setSize((width/2)/6, 20)
    .setRange(2, 80)
    .setGroup(group2)
    .setValue(35)
    ;
    
  control.getController("VELOCITY").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  control.getController("VELOCITY").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  control.addSlider("PARTICLES")
    .setPosition(15+2*(width/2)/6, 5)
    .setSize((width/2)/6, 20)
    .setRange(1000, 15000)
    .setGroup(group2)
    .setValue(10000)
    ;
    
  control.getController("PARTICLES").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  control.getController("PARTICLES").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

control.addSlider("MOVEMENT")
    .setPosition(20+3*(width/2)/6, 5)
    .setSize((width/2)/6, 20)
    .setRange(0,50)
    .setGroup(group2)
    .setValue(3)
    ;
    
  control.getController("MOVEMENT").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  control.getController("MOVEMENT").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  control.addButton("MODE")
    .setPosition(25+4*(width/2)/6, 5)
    .setSize((width/2)/12, 20)
    .setGroup(group2)
    ;
    
  control.addButton("MOTION_DETECTION")
    .setPosition(30+9*(width/2)/12, 5)
    .setSize((width/2)/9, 20)
    .setGroup(group2)
    ;
    
}

//EVENTS FROM GUI INTERACTION//

public void SWARM() {
  swarm = true; 
  rose = false;
}
public void ROSE() {
  swarm = false; 
  rose = true;
}
public void LOAD() { 
  selectInput("Select a file to process:", "fileSelected");
  if (load==true) {
    fun.pause();
  }
}
public void PLAY() { 
  if (load == true) {
    //fun.play();
    fun.loop();
  }
}
public void PAUSE() { 
  if (load == true) {
    fun.pause();
  }
}
public void REWIND() { 
  if (load == true) {
    fun.rewind();
  }
}

public void VELOCITY(float vd) {
  t_velocity = vd;
}

public void MASS(float m) {
  t_mass = m;
}
public void PARTICLES(int pm) {
  particle_max = pm;
}
public void MODE() { 
 part_line=!part_line; 
   
}
public void MOVEMENT(float move) { 
 movement = move; 
   
}
public void MOTION_DETECTION() { 
 motion_detection=!motion_detection; 
   
}