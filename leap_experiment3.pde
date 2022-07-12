import themidibus.*;
import de.voidplus.leapmotion.*;
import java.util.Arrays;

MidiBus virtual_bus ;
MidiBus piano_bus ;
MidiBus nanok_bus ;
LeapMotion leap ;

boolean is_playing = false;
int offset = 20;
float x_position;
float y_position ;
int blur_dim = 10;
float [] old_x = new float[blur_dim];
float [] old_y = new float[blur_dim];
int tempo= 50;
int loudness = 50;
int microt = 50;
int dynamic= 50;
int articulation= 50;
float y_division = 0.6;

float bar_starting_pos;
float bar_end_pos;
float bar_height;
int bar_n = 5;
float[] bar_pos = new float[bar_n];
float[] bar_width = new float[bar_n];

void setup() {
  size(800, 800);
  //background(255);
  // ...
  println("Available MIDI devices");
  MidiBus.list();
  virtual_bus = new MidiBus(this, "con_espressione" , "con_espressione");
  piano_bus = new MidiBus(this, -1, "Clavinova");
  nanok_bus = new MidiBus(this, "nanoKONTROL2", -1);
  leap = new LeapMotion(this);
  
  // update ball position based on the size
  x_position = width/2;
  y_position = height/2;
  
  Arrays.fill(old_x, width/2);
  Arrays.fill(old_y, height/2);
  
  bar_starting_pos = height*y_division + 4*offset;
  bar_end_pos = height - 2*offset;
  bar_height = -(bar_starting_pos - bar_end_pos)/bar_n - offset;
  println(bar_height);
  println();
  for (int i = 0; i < bar_n; i++) {
    bar_pos[i] = bar_starting_pos + bar_height*i + i*offset;
    bar_width[i] = 0;
  }
  
}

void shift_array() {
  for (int i = 0; i < blur_dim-1; i++) {
    old_x[blur_dim-1-i] = old_x[blur_dim-2-i];
    old_y[blur_dim-1-i] = old_y[blur_dim-2-i];
  }
}


void draw() {
  //background(255);
  fill(200);
  rect(0,0,width,height);
  fill(255);
  stroke(0);
  rect(2*offset, 2*offset, width - 4*offset, height*y_division-2*offset);
  
  stroke(255); 
 
  for (Hand hand : leap.getHands ()) {
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();

    //println(handPosition.x);
    //println(handPosition.y);
    //println();
    if ( (handStabilized.x < width - 2*offset) & (handStabilized.x > 2*offset)) {
      x_position = handStabilized.x;
    }
    if ( (handStabilized.y < y_division*height) & (handStabilized.y > 2*offset)) {
      y_position = handStabilized.y;
    }
   
    // sending midi messages
    virtual_bus.sendControllerChange(0, 20, round(x_position*127/width));
    virtual_bus.sendControllerChange(0, 21, round(127-(y_position*127/height)));


    // ==================================================
    // Arm

    if (hand.hasArm()) {
      Arm     arm              = hand.getArm();
      arm.draw();
    }
    
    // ==================================================
    // Finger
    Finger  fingerIndex        = hand.getIndexFinger();
    PVector fingerPosition   = fingerIndex.getPosition();
    // or                        hand.getFinger("index");
    // or                        hand.getFinger(1);

    for (Finger finger : hand.getFingers()) {     
      // Drawing:
       finger.drawBones();
       finger.drawJoints();
    }
  }
  
  // draw ellipses
  //println(x_position);
  //println(y_position);
  fill(204, 102, 0);
  ellipse(x_position, y_position, 20, 20);
  
  shift_array();
  old_x[0] = x_position;
  old_y[0] = y_position;
  for (int i = 0; i < 9; i++) {
    fill(204, 102, 0);
    ellipse(old_x[i], old_y[i], 20-i, 20-i);
  }
  
  // write text
  fill(200);
  stroke(255,0);
  rect(0,width*y_division+2*offset,width,height*(1-y_division)-2*offset);
  textSize(20);
  fill(100);
  textAlign(CENTER, CENTER);
  text("quiet", width/2 ,  height- offset);
  text("loud", width/2, offset);
  text("slow", offset,  height/2);
  text("fast", width - offset,  height/2);
  
  // basis mixer settings
  fill(0);
  for (int i = 0; i < bar_n; i++) {
    rect(2*offset,bar_pos[i],bar_width[i], bar_height);
    //print("printing rectangle i with, start_x, start-Y, width, height ");
    //println(i, 2*offset, bar_pos[i], bar_width[i], bar_height);
  }
  println(tempo, loudness, microt, dynamic, articulation);
}

void keyPressed() {
  switch(key) {
    case 'p':
    case 'P':
      if (is_playing){
        virtual_bus.sendControllerChange(0, 25, 127);
        is_playing = false;
        println("Sending stop message");
      }
      else{
        virtual_bus.sendControllerChange(0, 24, 127);
        is_playing = true;
        println("Sending play message");
      }
      break;
    case '1':
      println("Sending song selection message to song 1");
      virtual_bus.sendMessage(0xF3, 0);
      is_playing = false;
      break;
    case '2':
      println("Sending song selection message to song 2");
      virtual_bus.sendMessage(0xF3, 1);
      is_playing = false;
      break;
   case '3':
      println("Sending song selection message to song 3");
      virtual_bus.sendMessage(0xF3, 2);
      is_playing = false;
      break;
    case '4':
      println("Sending song selection message to song 4");
      virtual_bus.sendMessage(0xF3, 3);
      is_playing = false;
      break;
  }
}

void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
  switch (number) {
  // nano controls
    case 0:
      virtual_bus.sendControllerChange(0, 22, value);
      print("Send ML scaler with value ");
      println(value);
      break;
    case 41:
      if (value == 127) {
        virtual_bus.sendControllerChange(0, 24, 127);
        is_playing = true;
        println("Sending play message");
      }
      break;
    case 42:
      if (value == 127) {
        virtual_bus.sendControllerChange(0, 25, 127);
        is_playing = false;
        println("Sending stop message");
      }
      break;
    // pedal control
    case 64:
      piano_bus.sendControllerChange(0, 64, value);
      break;
    case 110:
      if (value > 10) {
        tempo= value;
        bar_width[0] = value * (width - 4*offset) /127;
        //println("Setting tempo to", bar_width[0], tempo );
      }
      break;
    case 111:
      if (value > 10) {
        loudness = value;
        bar_width[1] = value * (width - 4*offset) /127;
      }
      break;
    case 112:
      if (value > 10) {
        microt = value;
        bar_width[2] = value * (width - 4*offset) /127;
        //println("Setting microt to", bar_width[2] );
      }
      break;
    case 113:
      if (value > 10) {
        dynamic= value;
        bar_width[3] = value * (width - 4*offset)/127;
      }
      break;
    case 114:
      if (value > 10) {
        articulation= value;
        bar_width[4] = value * (width - 4*offset)/127;
      }
      break;
    }
}

void noteOn(int channel, int pitch, int velocity, long timestamp, String bus_name) {
  // Receive a noteOn
  piano_bus.sendNoteOn(channel, pitch, velocity);
}

void noteOff(int channel, int pitch, int velocity, long timestamp, String bus_name) {
  // Receive a noteOff
  piano_bus.sendNoteOff(channel, pitch, velocity); 
}

void stop() {
  virtual_bus.sendControllerChange(0, 25, 127);
  is_playing = false;
  println("Sending stop message");
  println("Goodbye");
} 
