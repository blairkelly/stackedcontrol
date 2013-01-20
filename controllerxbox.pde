
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
          wheelPWMctr = wheelPWMctr + 5;
        }
        if(Xbox.getButtonClick(0, X)) {
          //Serial.print(F(" - X"));
          wheelPWMctr = wheelPWMctr - 5;
        }

    }
  }
}