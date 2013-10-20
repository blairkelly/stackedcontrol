
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
        //mapToPWM(guideReading, guideCentre, guideMin, guideMax, deadZoneWidth, pwmCentre, pwmMin, pwmMax, kapow, cap);
        Wheel_uS = mTP.mtp(WHEEL, 0, asmin, asmax, xbst, wheelPWMctr, wheelPWMmin, wheelPWMmax, 0, 0);
        
        REVERSE = Xbox.getButtonPress(0, L2) * -1;
        FORWARD = Xbox.getButtonPress(0, R2);
        if(REVERSE < 0) {
          THROTTLE = REVERSE;
          Throttle_uS = mTP.mtp(REVERSE, 0, -apmax, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax, 0, 0);
        } else {
          THROTTLE = FORWARD;
          Throttle_uS = mTP.mtp(FORWARD, 0, apmin, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax, 0, 0);
        }
        if(THROTTLE != lastthrottle) {
          sbuffer = "T" + (String)THROTTLE + "&" + sbuffer;
          lastthrottle = THROTTLE;
          nts = true;
        }
        if(Xbox.getButtonClick(0, B)) {
          //Serial.print(F(" - B"));
          wheelPWMctr = wheelPWMctr + 2;
        }
        if(Xbox.getButtonClick(0, X)) {
          //Serial.print(F(" - X"));
          wheelPWMctr = wheelPWMctr - 2;
        }
        if(Xbox.getButtonClick(0, Y)) {
          sbuffer = "Y1&" + sbuffer;
          nts = true;
        }
        if(Xbox.getButtonClick(0, A)) {
          sbuffer = "A1&" + sbuffer;
          nts = true;
        }
        boolean printme = false;
        if(printme && (printtime < millis())) {
          Serial.print("THROTTLE: ");
          Serial.print(THROTTLE);
          Serial.print(", Throttle_uS: ");
          Serial.print(Throttle_uS);
          Serial.println(" ");
          printtime = millis() + printdelay;
        }
      } else if (cstate == 3) {
        //quadcopter

        int cxboxrp = Xbox.getButtonPress(0, R2);
        if(cxboxrp > THROTTLE) {
          THROTTLE = cxboxrp;
        }
        int cxboxlp = Xbox.getButtonPress(0, L2);
        if(cxboxlp > apmin) {
          if((apmax - cxboxlp) < THROTTLE) {
            THROTTLE = apmax - cxboxlp;
          }
        }
        //THROTTLE = (Xbox.getButtonPress(0, L2) + Xbox.getButtonPress(0, R2)) / 2.0;
        RUDDER = Xbox.getAnalogHat(0, LeftHatX);
        ELEVATOR = Xbox.getAnalogHat(0, RightHatY);
        AILERON = Xbox.getAnalogHat(0, RightHatX);

        Throttle_uS = mTP.mtp(THROTTLE, 0, apmin, apmax, 0, stickLow, stickLow, stickHigh, 0, 0);
        Rudder_uS = mTP.mtp(RUDDER, 0, asmin, asmax, xbst, rudCentre, stickHigh, stickLow, quadpow, 0);
        Elevator_uS = mTP.mtp(ELEVATOR, 0, asmin, asmax, xbst, eleCentre, stickLow, stickHigh, quadpow, 0.80);
        Aileron_uS = mTP.mtp(AILERON, 0, asmin, asmax, xbst, ailCentre, stickHigh, stickLow, quadpow, 0.80);

        if(!ppmadjust) {
          if(Xbox.getButtonClick(0, B)) {
            ailCentre = ailCentre - 5;
            Serial.print("Aileron Centre: ");
            Serial.println(ailCentre);
          }
          if(Xbox.getButtonClick(0, X)) {
            ailCentre = ailCentre + 5;
            Serial.print("Aileron Centre: ");
            Serial.println(ailCentre);
          }
          if(Xbox.getButtonClick(0, Y)) {
            eleCentre = eleCentre + 5;
            Serial.print("Elevator Centre: ");
            Serial.println(eleCentre);
          }
          if(Xbox.getButtonClick(0, A)) {
            eleCentre = eleCentre - 5;
            Serial.print("Elevator Centre: ");
            Serial.println(eleCentre);
          }
          if(Xbox.getButtonClick(0,RIGHT)) {
            rudCentre = rudCentre - 5;
            Serial.print("Rudder Centre: ");
            Serial.println(rudCentre);
          }
          if(Xbox.getButtonClick(0,LEFT)) {
            rudCentre = rudCentre + 5;
            Serial.print("Rudder Centre: ");
            Serial.println(rudCentre);
          }
        } else {
          if(Xbox.getButtonClick(0, B)) {
            ailCentre = ailCentre - 5;
            Serial.println(ailCentre);
          }
          if(Xbox.getButtonClick(0, X)) {
            if(phase1 == LOW) {
              phase1 = HIGH;
              phase2 = LOW;
              Serial.println("Phase 1 = HIGH, Phase2 = LOW");
            } else {
              phase1 = LOW;
              phase2 = HIGH;
              Serial.println("Phase 1 = LOW, Phase2 = HIGH");
            }
          }
          if(Xbox.getButtonClick(0, Y)) {
            FixedDX_uS++;
            Serial.print("FixedDX_uS = ");
            Serial.println(FixedDX_uS);
          }
          if(Xbox.getButtonClick(0, A)) {
            FixedDX_uS--;
            Serial.print("FixedDX_uS = ");
            Serial.println(FixedDX_uS);
          }
        }

        if(Xbox.getButtonClick(0,BACK)) {
          if(ppmadjust) {
            ppmadjust = false;
            Serial.println("ppmadjust == false");
          } else {
            ppmadjust = true;
            Serial.println("ppmadjust == true");
          }
        }

      }
        
      if(Xbox.getButtonClick(0,XBOX)) {


        boolean doCstate = false;
        if(doCstate) {
          if(cstate == 1){
            cstate = 2;
            ppmgo = true;
            //Xbox.setLedOn(0, LED2);
            Serial.println("cstate == 2");
          } else if (cstate == 2) {
            cstate = 3;
            ppmgo = true;
            //Xbox.setLedOn(0, LED3);
            Serial.println("cstate == 3");
          } else if (cstate == 3) {
            cstate = 1;
            ppmgo = false;
            //Xbox.setLedOn(0, LED1);
            Serial.println("cstate == 1");
          }
        }
      }

    }
  }
}