//variables

String usbInstructionDataString = "";
int usbCommandVal = 0;
boolean USBcommandExecuted = true;
String usbCommand = "";

int lcd = 22; //live control delay. Milliseconds.
unsigned long lcdd = millis() + lcd; //live control delay deadline
boolean myflag = false;
String ctype = "xbee"; //controller type
unsigned long theTime = millis();
int afterStartupTime = 1366; //after this duration, run runOnceAfterStartupTime stuff.
boolean roast = false;

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
int affbnum = 140; //what's the largest amplitude I would see from the adxl335 accelerometer, on the analog spectrum -> 0-1023 ?
int cra = 0; //current rumble amplitude.
unsigned long ffbsdd = millis(); //ffb step down deadline
int ffbstepmaxdelay = 39; //milliseconds to let current rumble setting play before reducing amplitude
int ffbstepmindelay = 3; //milliseconds to let current rumble setting play before reducing amplitude
int ffbstepdr = 6;  //how much to reduce the step delay
int ffbpd = ffbstepmaxdelay;  //force feedback present step delay
int ffbstep = 6; //how much to reduce rumbling at step interval.
float ffbcstep = ffbstep;  //ffb current step size
int ffbmincstep = 4; //smallest allowed step.
float ffbxstep = 0.5; //each time ffb steps, the size of the step is reduced.
boolean ffbfirstpass = false;

mapToPWM mTP;
//inSerialCmd sCmd;