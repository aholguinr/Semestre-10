#define pwmRes 12   
#define pwmMax 4095 
//#define pwmMax 255 
#define OutputPWM_GPIO 9    
#define OutputM 8   

int sensorPin = A0;    // select the input pin for the potentiometer
int sensorValue = 0;  // variable to store the value coming from the sensor
double angulo=-12;
double amplitudMaxAnalogo=753;
double valorAn0=70+amplitudMaxAnalogo;
double valorPiso=650;
double valorTecho=289+amplitudMaxAnalogo;
//double amplitudMaxAnalogo=1023;

long Ts = 2; // Sample time in ms
long previousMillis = 0;  // For main loop function


float Ref = -70; // System Reference - Temperature [°C]
float directCmd = 50.0; // Direct Control Output - FOR OPENLOOP or FEEDFORWARD - Transistor Collector Current [mA]
float Cmd = 0.0; // Control Output
float CmdRed = 0.0; // Control Output
float CmdPID = 0.0;
float CmdRedp = 0.0;
float E = 0;
float Ep = 0;
float Up = 0;
float Epp = 0;
float Upp = 0;
float Eppp = 0;
float Uppp = 0;
unsigned int pwmDuty = 0; // Control Output (Converted to PWM Duty Cycle)


double pwm=0.5;

// Advanced Serial Input Variables
const byte numChars = 32;
char receivedChars[numChars];
boolean newData = false;



void control(void){
  // Measurement, Control, Output Command Signal, Serial Data Communication

  unsigned long currentMillis = millis(); // Update current time from the beginning

  if (currentMillis - previousMillis >= Ts ) {
    previousMillis = currentMillis;
    angulo=analogRead(sensorPin);
    if (angulo<valorPiso*0.9){angulo=angulo+amplitudMaxAnalogo;}
    angulo=(angulo-valorAn0)*90;
    if(angulo>=0){angulo=angulo/(valorTecho-valorAn0);}else{
      angulo=angulo/(valorAn0-valorPiso);
    }
    
    
    float CmdLim = min(max(CmdRed, -50), 50); // Saturated Control Output
    float Cmd = CmdLim + directCmd;  

    pwmDuty = int((Cmd/100)*pwmMax);
    //analogWrite(OutputPWM_GPIO, pwmDuty);
    analogWriteADJ(OutputPWM_GPIO, pwmDuty); 
    
    if (currentMillis >= 500) {
      E = Ref - angulo;
      //ley de control

      //CmdRed=6.580782192615031*E-18.891748968281533*Ep+18.051769213192244*Epp-5.740768357921944*Eppp+2.751239739291020*Up-2.514650765653094*Upp+0.763411026362074*Uppp;

      //CmdRed=12.79*E+1*Ep- 1.42e-15*Epp+8.725*Eppp+Upp;

      //CmdRed=(306.6*E-604.9*Ep+298.3*Epp)+(0.4051*Up+0.5949*Upp);  //Intento PID TUNER    Se satura
      //CmdRed=8.215*E-16.2*Ep+7.989*Epp+1.006*Up-0.005624*Upp; //Intento 2 PID TUNER TF*2  Llega a unos 35, pero es lento, con sobrepico, y no soporta perturbaciones
      //CmdRed=25.87*E-50.95*Ep+25.08*Epp+0.8011*Up+0.1989*Upp;  //Error estacionario
      CmdRed=16.23*E-31.98*Ep+15.76*Epp+0.8909*Up+0.1091*Upp; //El mejor hasta el momento

/*
 * C_c =
 
             1            s    
  Kp + Ki * --- + Kd * --------
             s          Tf*s+1 

  with Kp = 0.42, Ki = 1.54, Kd = 0.0285, Tf = 0.000803
 
Continuous-time PIDF controller in parallel form.

 */


      Eppp=Epp;
      Epp = Ep;
      Ep = E;
      Uppp=Upp;
      Upp=Up;
      Up = CmdRed;

    }
    Serial.print("Ref:");
    Serial.print(Ref); 
    Serial.print("    Angulo:");
    Serial.print(angulo); 
    Serial.print("    PWM:");
    Serial.print(Cmd); 
    Serial.print("  Error:");
    Serial.println(E); 

  }



// Advanced Serial Input Functions
  recvWithStartEndMarkers();  
  if (newData == true) {
    parseData();
    newData = false;
  }
  
}


void setup() {
  Serial.begin(115200);

  pinMode(OutputPWM_GPIO, OUTPUT);  //In1
  pinMode(OutputM, OUTPUT);
  digitalWrite(OutputM, LOW);
  setupPWMadj();
  analogWriteADJ(OutputPWM_GPIO, pwmDuty);
    
 
  delay(2000); // Wait 2.5 [s] to open Serial Monitor/Plotter
  
}

void loop() {
  // read the value from the sensor:
  control();
}


void setupPWMadj() {
  DDRB |= _BV(PB1) | _BV(PB2);        /* set pins as outputs */
  TCCR1A = _BV(COM1A1) | _BV(COM1B1)  /* non-inverting PWM */
      | _BV(WGM11);                   /* mode 14: fast PWM, TOP=ICR1 */
  TCCR1B = _BV(WGM13) | _BV(WGM12)
      | _BV(CS10);                    /* no prescaling */
  ICR1 = 0x0fff;                      /* TOP counter value - SETS RESOLUTION/FREQUENCY */
}



void analogWriteADJ(uint8_t pin, uint16_t val){
  switch (pin) {
    case  9: OCR1A = val; break;
    case 10: OCR1B = val; break;
    }
}

void recvWithStartEndMarkers() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<'; // Serial input must start with this character
    char endMarker = '>'; // Serial input must end with this character
    char rc;

    while (Serial.available() > 0 && newData == false) {
        rc = Serial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}



void parseData() {      // split the data into its parts
    Ref = atof(receivedChars);     // convert serial input to a float and update System Reference value with that value
}
