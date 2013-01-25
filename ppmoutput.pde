void ppmoutput() { // PPM output sub
  if(cstate < 3) {
    //Land based vehicle AWM, Mini Summit, Summit.

    // Channel 1 - Wheel
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(Wheel_uS);

    // Channel 2 - High/Low Gear 
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    //delayMicroseconds(highLow_uS);
    delayMicroseconds(Wheel_uS);  
    
    // Channel 3 - Differential, Front
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(1500);
    
    // Channel 4 - Throttle 
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(Throttle_uS);
    
    // Channel 5 - Differential, Back
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(1500);   

    // Channel 6 - cameraX
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(1500);  //unused presently

     // Synchro pulse
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(Fixed_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);  // Start Synchro pulse
  } else if (cstate == 3) {
    //quadcopter

    // Channel 1
    // Throttle
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(Throttle_uS);

    // Channel 2 - Aileron
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    //delayMicroseconds(highLow_uS);
    delayMicroseconds(Aileron_uS);  
    
    // Channel 3 - Elevator
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(Elevator_uS);
    
    // Channel 4 - Rudder 
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(Rudder_uS);
    
    // Channel 5 - NoneSoFar
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(stickCentre);   

    // Channel 6 - NoneSoFar
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);
    delayMicroseconds(stickCentre);  //unused presently

    // Synchro pulse
    digitalWrite(outPinPPM, LOW);
    delayMicroseconds(FixedDX_uS);    // Hold
    digitalWrite(outPinPPM, HIGH);  // Start Synchro pulse
  }

  //// Channel 7 - 
  //digitalWrite(outPinPPM, LOW);
  //delayMicroseconds(Fixed_uS);    // Hold
  //digitalWrite(outPinPPM, HIGH);
  //delayMicroseconds(CameraX_uS); 
  
  // Channel 8 - cameraY
  //digitalWrite(outPinPPM, LOW);
  //delayMicroseconds(Fixed_uS);    // Hold
  //digitalWrite(outPinPPM, HIGH);
  //delayMicroseconds(CameraY_uS);

 

}