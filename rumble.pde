//handles rumbling

void watchffb() {
  Serial.print("ffbpd: ");
  Serial.print(ffbpd);
  Serial.print(", ffbcstep: ");
  Serial.print(ffbcstep);
  Serial.print(", cra: ");
  Serial.print(cra);
  Serial.println(" ");
}

void handlerumble() {  
  if((millis() > ffbsdd) && !ffbfirstpass) {
    //cra = cra - ffbstep;
    cra = cra - ffbcstep;
    if(ffbcstep > ffbmincstep) {
      ffbcstep = ffbcstep - ffbxstep;
    } else if (ffbcstep < ffbmincstep) {
      ffbcstep = ffbmincstep;
    }

    if(ffbpd > ffbstepmindelay) {
      ffbpd = ffbpd - ffbstepdr;
    } else if (ffbpd < ffbstepmindelay) {
      ffbpd = ffbstepmindelay;
    }
    
    ffbsdd = millis() + ffbpd;

    if(cra < 0){cra = 0;}

    //watchffb();
  }
}

void setrumble(String cmd, int cmdval) {
  //if(cmdval > affbnum) {affbnum = cmdval;}
  int ra = (float)rma * ((float)cmdval / (float)affbnum);
  if(ra > rma) {ra = rma;}
  if(ra > cra) {
    ffbfirstpass = true;
    cra = ra;
    ffbcstep = ffbstep;
    ffbpd = ffbstepmaxdelay;
  }
}

/*
void updateaccelinfo() {
  //minAccelFFamplitude
  int accelXaverage = 0;
  int accelYaverage = 0;
  int accelZaverage = 0;
  accel1avgXarray[accel1counter] = accelX; //put X reading into array
  accel1avgYarray[accel1counter] = accelY; //put Y reading into array
  accel1avgZarray[accel1counter] = accelZ; //put Z reading into array
  accel1counter++;
  if(accel1counter > accelAVGarraySize) {
     accel1counter = 0;
  }
  for(int a = 0; a<accelAVGarraySize; a++) {
       //add together, to update average...
       accelXaverage = accelXaverage + accel1avgXarray[a];
       accelYaverage = accelYaverage + accel1avgYarray[a];
       accelZaverage = accelZaverage + accel1avgZarray[a];
  }
  accelXaverage = accelXaverage / accelAVGarraySize;
  accelYaverage = accelYaverage / accelAVGarraySize;
  accelZaverage = accelZaverage / accelAVGarraySize;
   
  //now find out if there's enough of a disturbance to report...
  int aXdifference = 0;
  int aYdifference = 0;
  int aZdifference = 0;
  //determine if X reading is out of range
  int accelUnder = accelXaverage - minAccelFFamplitudeX;
  int accelOver = accelXaverage + minAccelFFamplitudeX;
  if(accelX <= accelUnder) {
    aXdifference = accelXaverage - accelX;
  } else if (accelX >= accelOver) {
     aXdifference = accelX - accelXaverage;
  }
  //determine if Y reading is out of range
  accelUnder = accelYaverage - minAccelFFamplitudeY;
  accelOver = accelYaverage + minAccelFFamplitudeY;
  if(accelY <= accelUnder) {
     aYdifference = accelYaverage - accelY;
  } else if (accelY >= accelOver) {
     aYdifference = accelY - accelYaverage;
  }
  //determine if Z reading is out of range
  accelUnder = accelZaverage - minAccelFFamplitudeZ;
  accelOver = accelZaverage + minAccelFFamplitudeZ;
  if(accelZ <= accelUnder) {
     aZdifference = accelZaverage - accelZ;
  } else if (accelZ >= accelOver) {
     aZdifference = accelZ - accelZaverage;
  }
   
  boolean hc = false;
  //X
  if(aXdifference != lastAXdifference) {
     //the affXresult has changed, send to host.
     //loadsendstring("<", aXdifference); //ptb(0x3C); //print "<" to spi uart, for X
     loadsendstring("<", accelX);
     lastAXdifference = aXdifference;
     hc = true;
  }
  //Y
  if(aYdifference != lastAYdifference) {
     //the affZresult has changed, send to host.
     //loadsendstring(">", aYdifference); //ptb(0x3E); //print ">", for Y
     loadsendstring(">", accelY);
     lastAYdifference = aYdifference;
     hc = true;
  }
  //Z
  if(aZdifference != lastAZdifference) {
     //the affZresult has changed, send to host.
     //loadsendstring("^", aZdifference); //ptb(0x5E); //print "^", for Z.
     loadsendstring("^", accelZ);
     lastAZdifference = aZdifference;
     hc = true;
  }
  accelCheckTime = theTime + accelCheckDelay;
  if(hc) {
     sendsendstring();
  }
}*/