
void pc(String cmd, int cmdval) {
  Serial1.print(cmd);
  Serial1.println(cmdval);
}

void sendcoms() {
  //enumerates which method to use to send instructions to the vehicle
  if(!ppmgo) {
    if(millis() > lcdd) { //lcdd = live control delay deadline
      pc("W", Wheel_uS);
      pc("T", Throttle_uS);
      lcdd = millis() + lcd;
    }
  }
}

void delegate(String cmd, int cmdval) {
  
  if (cmd.equals("<") || cmd.equals(">") || cmd.equals("^")) {
      //setrumble(cmd, cmdval);
  }
  
  if(cmd.equals("S")) {
    if(cmdval == 0) {
      //digitalWrite(13, LOW);
    } else if (cmdval == 1) {
      //digitalWrite(13, HIGH);
    }
  }
}

void serialListen()
{
  char arduinoSerialData; //FOR CONVERTING BYTE TO CHAR. here is stored information coming from the arduino.
  String currentChar = "";
  if(Serial1.available() > 0) {
    Serial.println("high");
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
        //String newt = usbCommand + usbCommandVal;
        //Serial.println(newt);
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