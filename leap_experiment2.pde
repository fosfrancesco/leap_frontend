import themidibus.*;
import de.voidplus.leapmotion.*;

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

    println(handPosition.x);
    println(handPosition.y);
    println();
    if ( (handPosition.x < width - 2*offset) & (handPosition.x > 2*offset)) {
      x_position = handPosition.x;
    }
    if ( (handPosition.y < height - 2*offset) & (handPosition.y > 2*offset)) {
      y_position = handPosition.y;
    }
   
    // sending midi messages
    bus.sendControllerChange(0, 20, round(handPosition.x*127/width));
    bus.sendControllerChange(0, 21, round((500-handPosition.y)*127/height));


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
  println(x_position);
  println(y_position);
  fill(204, 102, 0);
  ellipse(x_position, y_position, 20, 20);
}

void keyPressed() {
  if (key == 'p' || key =='P') {
    if (is_playing){
      bus.sendControllerChange(0, 25, 127);
      is_playing = false;
      println("Sending stop message");
    }
    else{
      bus.sendControllerChange(0, 24, 127);
      println("Sending play message");
      is_playing = true;
    }
    
  }
}
