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