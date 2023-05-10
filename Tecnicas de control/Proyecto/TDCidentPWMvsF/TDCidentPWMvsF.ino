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


float Ref = 0; // System Reference - Temperature [°C]
float directCmd = 50.0; // Direct Control Output - FOR OPENLOOP or FEEDFORWARD - Transistor Collector Current [mA]
float Cmd = 0.0; // Control Output

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
 
   
    pwmDuty = int((Ref/100)*pwmMax);

    analogWriteADJ(OutputPWM_GPIO, pwmDuty); 
    
    Serial.print("PWM:");
    Serial.println(Ref); 
 
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
  digitalWrite(7, LOW);
  digitalWrite(8, HIGH);
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
