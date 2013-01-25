//Stacked Controller

#include <XBOXRECV.h>
USB Usb;
XBOXRECV Xbox(&Usb);


#include "mapToPWM.h"
//#include "rcBaseDelegate.h"
//#include "inSerialCmd.h"
#include "variables.h"

ISR(TIMER3_COMPA_vect) {
  if(ppmgo) {
    ppmoutput(); // Jump to ppmoutput subroutine
  }
}

void setup() {
  Serial.begin(57600);
  Serial1.begin(57600);
  if (Usb.Init() == -1) {
    Serial.print(F("\r\nOSC did not start"));
    while(1); //halt
  }  
  //Serial.print(F("\r\nXBOX USB Library Started. Thanks Kristian Lauszus!"));
  Serial.print(F("\r\nXbox Wireless Receiver Library Started. Thanks Kristian Lauszus!"));

  pinMode(outPinPPM, OUTPUT);   // sets the digital pin as output

  // Setup timer
  TCCR3A = B00110001; // Compare register B used in mode '3'
  TCCR3B = B00010010; // WGM13 and CS11 set to 1
  TCCR3C = B00000000; // All set to 0
  TIMSK3 = B00000010; // Interrupt on compare B
  TIFR3  = B00000010; // Interrupt on compare B
  OCR3A = 22000; // 22mS PPM output refresh
  OCR3B = 1000;
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
