
void scancontroller() {
  Usb.Task();
  // if(Xbox.Xbox360Connected) {
  if(Xbox.XboxReceiverConnected) {
    if(Xbox.Xbox360Connected[0]) {
      
      Xbox.setRumbleOn(0, cra, cra);
      if(ffbfirstpass) {
        ffbsdd = millis() + ffbpd;
        ffbfirstpass = false;
      }
      
      if(cstate < 3) {
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
        if(Xbox.getButtonClick(0, B)) {
          //Serial.print(F(" - B"));
          wheelPWMctr = wheelPWMctr + 2;
        }
        if(Xbox.getButtonClick(0, X)) {
          //Serial.print(F(" - X"));
          wheelPWMctr = wheelPWMctr - 2;
        }
      } else if (cstate == 3) {
        //quadcopter

        THROTTLE = (Xbox.getButtonPress(0, L2) + Xbox.getButtonPress(0, R2)) / 2;
        RUDDER = Xbox.getAnalogHat(0, LeftHatX);
        ELEVATOR = Xbox.getAnalogHat(0, RightHatY);
        AILERON = Xbox.getAnalogHat(0, RightHatX);

        Throttle_uS = mTP.mtp(THROTTLE, 0, apmin, apmax, 0, stickLow, stickLow, stickHigh);
        Rudder_uS = mTP.mtp(RUDDER, 0, asmin, asmax, xbst, rudCentre, stickHigh, stickLow);
        Elevator_uS = mTP.mtp(ELEVATOR, 0, asmin, asmax, xbst, eleCentre, stickLow, stickHigh);
        Aileron_uS = mTP.mtp(AILERON, 0, asmin, asmax, xbst, ailCentre, stickHigh, stickLow);

        if(Xbox.getButtonClick(0, B)) {
          ailCentre = ailCentre - 2;
          Serial.println(ailCentre);
        }
        if(Xbox.getButtonClick(0, X)) {
          ailCentre = ailCentre + 2;
          Serial.println(ailCentre);
        }
        if(Xbox.getButtonClick(0, Y)) {
          eleCentre = eleCentre + 2;
          Serial.println(eleCentre);
        }
        if(Xbox.getButtonClick(0, A)) {
          eleCentre = eleCentre - 2;
          Serial.println(eleCentre);
        }
        if(Xbox.getButtonClick(0,RIGHT)) {
          rudCentre = rudCentre - 2;
          Serial.println(rudCentre);
        }
        if(Xbox.getButtonClick(0,LEFT)) {
          rudCentre = rudCentre + 2;
          Serial.println(rudCentre);
        }
      }
        

        if(Xbox.getButtonClick(0,XBOX)) {
          if(cstate == 1){
            cstate = 2;
            ppmgo = true;
            //Xbox.setLedOn(0, LED2);
            Serial.println("cstate = 2");
          } else if (cstate == 2) {
            cstate = 3;
            ppmgo = true;
            //Xbox.setLedOn(0, LED3);
            Serial.println("cstate = 3");
          } else if (cstate == 3) {
            cstate = 1;
            ppmgo = false;
            //Xbox.setLedOn(0, LED1);
            Serial.println("cstate = 1");
          }
        }

    }
  }
}