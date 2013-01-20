//Stacked Controller

#include <XBOXRECV.h>
USB Usb;
XBOXRECV Xbox(&Usb);


#include "mapToPWM.h"
//#include "rcBaseDelegate.h"
//#include "inSerialCmd.h"
#include "variables.h"


void setup() {
  Serial.begin(57600);
  Serial1.begin(57600);
  if (Usb.Init() == -1) {
    Serial.print(F("\r\nOSC did not start"));
    while(1); //halt
  }  
  //Serial.print(F("\r\nXBOX USB Library Started. Thanks Kristian Lauszus!"));
  Serial.print(F("\r\nXbox Wireless Receiver Library Started. Thanks Kristian Lauszus!"));
}

void loop() {
  serialListen();
  scancontroller();
  sendcoms();
  if(cra > 0) {
    handlerumble();
  }
  if(!roast) {
    if(millis() > afterStartupTime) {
      Xbox.setLedOn(0, LED1);
      roast = true;
    }
  }
  delay(1); //recommended by Lauszus.
}
