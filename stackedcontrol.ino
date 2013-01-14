#include <XBOXUSB.h>
USB Usb;
XBOXUSB Xbox(&Usb);

//variables
int lcd = 44; //live control delay. Milliseconds.
unsigned long lcdd = millis() + lcd; //live control delay deadline
boolean myflag = false;
String ctype = "xbee"; //controller type
unsigned long theTime = millis();
int afterStartupTime = 1366; //after this duration, run runOnceAfterStartupTime stuff.
boolean roast = false;
String usbInstructionDataString = "";
int usbCommandVal = 0;
boolean USBcommandExecuted = true;
String usbCommand = "";

int WHEEL = 0;
int THROTTLE;
int REVERSE = 0;
int FORWARD = 0;

//wheel
int wheelPWMctrDefault = 1500;
int wheelPWMmin = 1085;  //fd 1085
int wheelPWMmax = 1890;  //fd 1890
int wheelPWMctr = wheelPWMctrDefault; //set below !!TEMP equal to default
//throttle
int thrPWMminDefault = 974;
int thrPWMmaxDefault = 1969;
int thrPWMctr = 1473;
int thrPWMmin = thrPWMminDefault; //set below  !!TEMP equal to default min
int thrPWMmax = thrPWMmaxDefault; //set below  !!TEMP equal to default max

int Wheel_uS = wheelPWMctrDefault;     // channel 1.  Ana In Ch.0 uS var - wheel
int Throttle_uS = thrPWMctr;    // channel 2 Ana In Ch.1 uS var - throttle

int xbst = 7500; //xbox stick tolerance number. Lauszus' default was 7500.
int xbminmax = 32200; //xbox guideMin/Max value.
int asmin = xbminmax * -1;  //analog stick minimum (to send to mapToPwm function)
int asmax = xbminmax;       //analog stick maximum (to send to mapToPwm function)
int xbpedalminmax = 255;
int apmin = xbpedalminmax * -1;
int apmax = xbpedalminmax;
int xboxrma = 255; //xbox rumble max amplitude
int rma = xboxrma; //rumble max amplitude
int arbitraryffbnum = 244; //what's the largest amplitude I would see from the adxl335 accelerometer, on the analog spectrum -> 0-1023 ?
int highestravalue = 3; 

void setup() {
  Serial.begin(57600);
  Serial1.begin(57600);
  if (Usb.Init() == -1) {
    Serial.print(F("\r\nOSC did not start"));
    while(1); //halt
  }  
  Serial.print(F("\r\nXBOX USB Library Started. Thanks Kristian Lauszus!"));
}

int mapToPWM(int guideReading, int guideCentre, int guideMin, int guideMax, int deadZoneWidth, int pwmCentre, int pwmMin, int pwmMax)
{
  //expected case: guideMin < guideCentre < guideMax & pwmMin < pwmCentre < pwmMax

  int thePWM; //the PWM value that will be returned.
  float floatPWM;
  float theNumerator;
  float thePercentage;

  //this function accounts for a stick-center deadzone.
  int negDZwidth = deadZoneWidth * -1;
  int ctrThresh = guideReading - guideCentre;
  if((ctrThresh < negDZwidth) && (guideReading > guideMin)) {
    float pwmRangeBelowCtr = float(pwmCentre - pwmMin);
    float guideRangeBelowCtr = float(guideCentre - guideMin - deadZoneWidth);
    theNumerator = guideRangeBelowCtr - float(guideReading - guideMin);
    thePercentage = theNumerator / guideRangeBelowCtr;
    floatPWM = float(pwmCentre) - (pwmRangeBelowCtr * thePercentage);
    thePWM = floatPWM;
  } 
  else if ((ctrThresh > deadZoneWidth) && (guideReading < guideMax)) {
    float guideRangeAboveCtr = float(guideMax - guideCentre - deadZoneWidth);
    float pwmRangeAboveCtr = float(pwmMax - pwmCentre);
    theNumerator = guideRangeAboveCtr - float(guideMax - guideReading);
    thePercentage = theNumerator / guideRangeAboveCtr;
    floatPWM = float(pwmCentre) + (pwmRangeAboveCtr * thePercentage);
    thePWM = floatPWM;
  } 
  else if (guideReading <= guideMin) {
    thePWM = pwmMin;
  } 
  else if (guideReading >= guideMax) {
    thePWM = pwmMax;
  } 
  else {
    thePWM = pwmCentre;
  }
//  Serial.print("guideReading: ");
//  Serial.print(guideReading);
//  Serial.print(", thePWM: ");
//  Serial.print(thePWM);
//  Serial.println(" ");
//  delay(666);
  return(thePWM);
}

void delegate(String cmd, int cmdval) {
  if (cmd.equals("<") || cmd.equals(">") || cmd.equals("^")) {
      if(cmdval > arbitraryffbnum) { arbitraryffbnum = cmdval; digitalWrite(13, HIGH); }
      int ra = (float(cmdval) / float(arbitraryffbnum)) * float(rma);
      //if(ra < 3) { ra = 3; };
      //if(ra > highestravalue) { highestravalue = ra; };
      //Serial.println(highestravalue);
      //Xbox.setRumbleOn(highestravalue,highestravalue);
      
      
      
      //if (cmd.equals("<")) {
        //rumble x
      //} else if (cmd.equals(">")) {
        //rumble y
      //} else if (cmd.equals("^")) {
        //rumble z
      //}
  }
  
  if(cmd.equals("S")) {
    if(cmdval == 0) {
      //Xbox.setLedOn(LED1);
      //digitalWrite(13, LOW);
    } else if (cmdval == 1) {
      //Xbox.setLedOn(LED2);
      //digitalWrite(13, HIGH);
    }
  }
}

void serialListen()
{
  char arduinoSerialData; //FOR CONVERTING BYTE TO CHAR. here is stored information coming from the arduino.
  String currentChar = "";
  if(Serial1.available() > 0) {
    arduinoSerialData = char(Serial1.read());   //BYTE TO CHAR.
    currentChar = (String)arduinoSerialData; //incoming data equated to c.
    if(!currentChar.equals("1") && !currentChar.equals("2") && !currentChar.equals("3") && !currentChar.equals("4") && !currentChar.equals("5") && !currentChar.equals("6") && !currentChar.equals("7") && !currentChar.equals("8") && !currentChar.equals("9") && !currentChar.equals("0") && !currentChar.equals(".")) { 
      //the character is not a number, not a value to go along with a command,
      //so it is probably a command.
      if(!usbInstructionDataString.equals("")) {
        //usbCommandVal = Integer.parseInt(usbInstructionDataString);
        char charBuf[30];
        usbInstructionDataString.toCharArray(charBuf, 30);
        usbCommandVal = atoi(charBuf);
      }
      if((USBcommandExecuted == false) && (arduinoSerialData == 13)) {
        delegate(usbCommand, usbCommandVal);
        USBcommandExecuted = true;
        //Serial.print(usbCommand);
        //Serial.println(usbCommandVal);
      }
      if((arduinoSerialData != 13) && (arduinoSerialData != 10)) {
        usbCommand = currentChar;
      }
      usbInstructionDataString = "";
    } else {
      //in this case, we're probably receiving a command value.
      //store it
      usbInstructionDataString = usbInstructionDataString + currentChar;
      USBcommandExecuted = false;
    }
  }
}

void scancontroller() {
  Usb.Task();
  if(Xbox.Xbox360Connected) {
    WHEEL = Xbox.getAnalogHat(RightHatX);
    //mapToPWM(guideReading, guideCentre, guideMin, guideMax, deadZoneWidth, pwmCentre, pwmMin, pwmMax);
    Wheel_uS = mapToPWM(WHEEL, 0, asmin, asmax, xbst, wheelPWMctr, wheelPWMmin, wheelPWMmax);
    
    REVERSE = Xbox.getButton(L2) * -1;
    FORWARD = Xbox.getButton(R2);
    if(REVERSE < 0) {
      Throttle_uS = mapToPWM(REVERSE, 0, apmin, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax);
    } else {
      Throttle_uS = mapToPWM(FORWARD, 0, apmin, apmax, 0, thrPWMctr, thrPWMmin, thrPWMmax);
    }
    
    //Xbox.setRumbleOn(Xbox.getButton(L2),Xbox.getButton(R2)); //to rumble!
    //if(Xbox.getAnalogHat(LeftHatX) > xbst || Xbox.getAnalogHat(LeftHatX) < -xbst || Xbox.getAnalogHat(LeftHatY) > xbst || Xbox.getAnalogHat(LeftHatY) < -xbst || Xbox.getAnalogHat(RightHatX) > xbst || Xbox.getAnalogHat(RightHatX) < -xbst || Xbox.getAnalogHat(RightHatY) > xbst || Xbox.getAnalogHat(RightHatY) < -xbst) {
      //if(Xbox.getAnalogHat(LeftHatX) > xbst || Xbox.getAnalogHat(LeftHatX) < -xbst) {
        //Serial.print(F("LeftHatX: ")); 
        //Serial.print(Xbox.getAnalogHat(LeftHatX));
        //Serial.print("\t");
      //} 
      //if(Xbox.getAnalogHat(LeftHatY) > xbst || Xbox.getAnalogHat(LeftHatY) < -xbst) {
        //Serial.print(F("LeftHatY: ")); 
        //Serial.print(Xbox.getAnalogHat(LeftHatY));
        //Serial.print("\t");
      //} 
      //if(Xbox.getAnalogHat(RightHatX) > xbst || Xbox.getAnalogHat(RightHatX) < -xbst) {
        //Serial.print(F("RightHatX: ")); 
        //Serial.print(Xbox.getAnalogHat(RightHatX));
        //Serial.print("\t");
      //}
      //if(Xbox.getAnalogHat(RightHatY) > xbst || Xbox.getAnalogHat(RightHatY) < -xbst) {
        //Serial.print(F("RightHatY: ")); 
        //Serial.print(Xbox.getAnalogHat(RightHatY));  
      //}
      //Serial.println("");
    //}

    if(Xbox.buttonPressed) {
      //Serial.print(F("Xbox 360 Controller"));
      if(Xbox.getButton(UP)) {
        //Xbox.setLedOn(LED1);
        //Serial.print(F(" - UP"));
      }      
      if(Xbox.getButton(DOWN)) {
        //Xbox.setLedOn(LED4);
        //Serial.print(F(" - DOWN"));
      }
      if(Xbox.getButton(LEFT)) {
        //Xbox.setLedOn(LED3);
        //Serial.print(F(" - LEFT"));
      }
      if(Xbox.getButton(RIGHT)) {
        //Xbox.setLedOn(LED2);
        //Serial.print(F(" - RIGHT"));
      }

      if(Xbox.getButton(START)) {
        //Xbox.setLedMode(ALTERNATING);
        //Serial.print(F(" - START"));
      }
      if(Xbox.getButton(BACK)) {
        //Xbox.setLedBlink(ALL);
        //Serial.print(F(" - BACK"));
      }
      if(Xbox.getButton(L3)) {
        //Serial.print(F(" - L3"));
      }
      if(Xbox.getButton(R3)) {
        //Serial.print(F(" - R3"));
      }
      
      if(Xbox.getButton(L1)) {
        //Serial.print(F(" - L1"));
      }
      if(Xbox.getButton(R1)) {
        //Serial.print(F(" - R1"));
      }
      if(Xbox.getButton(XBOX)) {
        //Xbox.setLedMode(ROTATING);
        //Serial.print(F("Wings Up"));
        pc("S", 5485);
        if(!myflag) {
          Xbox.setLedOn(LED2);
          myflag = true;
          Xbox.setRumbleOn(50,50);
        } else {
          Xbox.setLedOn(LED1);
          myflag = false;
          Xbox.setRumbleOn(0,0);
        }       
      }

      if(Xbox.getButton(A)) {
        //Serial.print(F(" - A"));
      }
      if(Xbox.getButton(B)) {
        //Serial.print(F(" - B"));
        wheelPWMctr = wheelPWMctr + 5;
      }
      if(Xbox.getButton(X)) {
        //Serial.print(F(" - X"));
        wheelPWMctr = wheelPWMctr - 5;
      }
      if(Xbox.getButton(Y)) {
        //Serial.print(F(" - Y"));
      }

      if(Xbox.getButton(L2)) {
        //Serial.print(F(" - L2:"));
        //Serial.print(Xbox.getButton(L2));
      }
      if(Xbox.getButton(R2)) {
        //Serial.print(F(" - R2:"));
        //Serial.print(Xbox.getButton(R2));
      }
      //Serial.println();        
    } 
  }
}

void pc(String cmd, int cmdval) {
  Serial1.print(cmd);
  Serial1.println(cmdval);
}
void sendcoms() {
  //enumerates which method to use to send instructions to the vehicle
  //depends on value of ctype
  if(ctype == "xbee") {
    if(millis() > lcdd) { //lcdd = live control delay deadline
      pc("W", Wheel_uS);
      pc("T", Throttle_uS);
      lcdd = millis() + lcd;
    }
  }
}

void loop() {
  serialListen();
  scancontroller();
  sendcoms();
  if(!roast) {
    if(millis() > afterStartupTime) {
      Xbox.setLedOn(LED1);
      roast = true;
    }
  }
}
