import themidibus.*;
import de.voidplus.leapmotion.*;
import java.util.Arrays;

// ======================================================
// Table of Contents:
// ├─ 1. Callbacks
// ├─ 2. Hand
// ├─ 3. Arms
// ├─ 4. Fingers
// ├─ 5. Bones
// ├─ 6. Tools
// └─ 7. Devices
// ======================================================

MidiBus bus ;
LeapMotion leap;

boolean is_playing = false;
int offset = 20;
float x_position;
float y_position ;
int blur_dim = 10;
float [] old_x = new float[blur_dim];
float [] old_y = new float[blur_dim];

void setup() {
  size(800, 800);
  //background(255);
  // ...
  println("Available MIDI devices");
  MidiBus.list();
  bus = new MidiBus(this, -1, "con_espressione");
  leap = new LeapMotion(this);
  
  // update ball position based on the size
  x_position = width/2;
  y_position = height/2;
  
  Arrays.fill(old_x, width/2);
  Arrays.fill(old_y, height/2);
  //old_x = {width/2, width/2, width/2, width/2, width/2, width/2, width/2, width/2, width/2, width/2};
  //old y = {height/2, height/2,height/2,height/2,height/2,height/2,height/2,height/2,height/2,height/2};

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
  rect(2*offset, 2*offset, width - 4*offset, height-4*offset);
  
  stroke(255);
  
  //fill(255,200);
  // ...
  
  textSize(20);
  fill(100);
  textAlign(CENTER, CENTER);
  text("quiet", width/2 ,  height- offset);
  text("loud", width/2, offset);
  text("slow", offset,  height/2);
  text("fast", width - offset,  height/2);
  
 
  for (Hand hand : leap.getHands ()) {
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();

    //println(handPosition.x);
    //println(handPosition.y);
    //println();
    if ( (handStabilized.x < width - 2*offset) & (handStabilized.x > 2*offset)) {
      x_position = handStabilized.x;
    }
    if ( (handStabilized.y < height - 2*offset) & (handStabilized.y > 2*offset)) {
      y_position = handStabilized.y;
    }
   
    // sending midi messages
    bus.sendControllerChange(0, 20, round(x_position*127/width));
    bus.sendControllerChange(0, 21, round(127-(y_position*127/height)));


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
}

void keyPressed() {
  switch(key) {
    case 'p':
    case 'P':
      if (is_playing){
        bus.sendControllerChange(0, 25, 127);
        is_playing = false;
        println("Sending stop message");
      }
      else{
        bus.sendControllerChange(0, 24, 127);
        is_playing = true;
        println("Sending play message");
      }
      break;
  case '1':
    println("Sending song selection message to song 1");
    bus.sendMessage(0xF3, 0);
    is_playing = false;
    break;
  case '2':
    println("Sending song selection message to song 2");
    bus.sendMessage(0xF3, 1);
    is_playing = false;
    break;
 case '3':
    println("Sending song selection message to song 3");
    bus.sendMessage(0xF3, 2);
    is_playing = false;
    break;
  case '4':
    println("Sending song selection message to song 4");
    bus.sendMessage(0xF3, 3);
    is_playing = false;
    break;
  }
}



void stop() {
  bus.sendControllerChange(0, 25, 127);
  is_playing = false;
  println("Sending stop message");
  println("Goodbye");
} 
