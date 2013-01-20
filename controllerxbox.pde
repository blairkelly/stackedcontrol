
void scancontroller() {
  Usb.Task();
  // if(Xbox.Xbox360Connected) {
  if(Xbox.XboxReceiverConnected) {
    if(Xbox.Xbox360Connected[0]) {
      Xbox.setRumbleOn(0, ra, ra);
        
      WHEEL = Xbox.getAnalogHat(0, RightHatX);
      //mapToPWM(guideReading, guideCentre, guideMin, guideMax, deadZoneWidth, pwmCentre, pwmMin, pwmMax);
      Wheel_uS = mTP.mtp(WHEEL, 0, asmin, asmax, xbst, wheelPWMctr, wheelPWMmin, wheelPWMmax);
      
      REVERSE = Xbox.getButtonPress(0, L2) * -1;
      FORWARD = Xbox.getButtonPress(0, R2);
      if(REVERSE < 0) {
        Throttle_uS = mTP.mtp(REVERSE, 0, apmin, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax);
      } else {
        Throttle_uS = mTP.mtp(FORWARD, 0, apmin, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax);
      }
      /*Serial.print("Wheel_uS: ");
      Serial.print(Wheel_uS);
      Serial.print(", Throttle_uS: ");
      Serial.print(Throttle_uS);
      Serial.println(" ");
      delay(100);*/

      //if(Xbox.buttonPressed) {
        if(Xbox.getButtonClick(0, UP)) {
        }      
        if(Xbox.getButtonClick(0, DOWN)) {
        }
        if(Xbox.getButtonClick(0, LEFT)) {
        }
        if(Xbox.getButtonClick(0, RIGHT)) {
        }

        if(Xbox.getButtonClick(0, START)) {
        }
        if(Xbox.getButtonClick(0, BACK)) {
        }
        if(Xbox.getButtonClick(0, L3)) {
        }
        if(Xbox.getButtonClick(0, R3)) {
        }
        
        if(Xbox.getButtonClick(0, L1)) {
        }
        if(Xbox.getButtonClick(0, R1)) {
        }
        if(Xbox.getButtonClick(0, XBOX)) {
          pc("S", 5485);
          if(!myflag) {
            if(Xbox.Xbox360Connected) {
              //Xbox.setLedOn(LED2);
              myflag = true;
            }
          } else {
            if(Xbox.Xbox360Connected) {
              //Xbox.setLedOn(LED1);
              myflag = false;
            }
          }       
        }

        if(Xbox.getButtonClick(0, A)) {
          //Serial.print(F(" - A"));
        }
        if(Xbox.getButtonClick(0, B)) {
          //Serial.print(F(" - B"));
          wheelPWMctr = wheelPWMctr + 5;
        }
        if(Xbox.getButtonClick(0, X)) {
          //Serial.print(F(" - X"));
          wheelPWMctr = wheelPWMctr - 5;
        }
        if(Xbox.getButtonClick(0, Y)) {
          //Serial.print(F(" - Y"));
        }

        
        //Serial.println();  
    }
  }
}