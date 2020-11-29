// This code controls the conveyor belt motor through an Arduino board.
// The Arduino is attached to a rotary encoder mounted on a motor, and a motor driver.
// Serial communication is used to get the goal speed, or return the current speed.
// PID control is used to achieve speed control.

// setPWMFrequency is used to match the motor's resonance. Function taken from https://playground.arduino.cc/Code/PwmFrequency/
// parts of the serial communication taken from https://forum.arduino.cc/index.php?topic=396450

#define ENCODERPPR 1024
#define TRANSMISSION_RATIO 60
#define R 24

const int ENC_A = 2;
const int ENC_B = 3;
const int MOTOR1A = 9;
const int MOTOR1DIR = 8;
byte incomingByte1;
int goalSpeed = 0;
volatile long encoderValue = 0;

int interval = 300;
long previousMillis = 0;
long currentMillis = 0;
long elapsedMillis = 1000;

float rps = 0;
boolean measureRpm = false;
int motorPwm = 0;

double currentSpeed = 0;
int output = 0;
boolean reverse = false;

double lastGivenSpeed = 0;


const byte numChars = 32;
char receivedChars[numChars];   // an array to store the received data
boolean newData = false;
int dataNumber = 0;             // new for this version


double errSum = 0;
unsigned long lastTime;
double lastErr;
double Kp = 0.7;
double Ki = 0.001;
double Kd = 0.0001;

void setup() {

  Serial.begin(115200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Native USB only
  }
  Serial.println("Ready");
  EncoderInit();//Initialize the module
  pinMode( MOTOR1A , OUTPUT);
  pinMode( MOTOR1DIR , OUTPUT);
  setPwmFrequency(MOTOR1A, 1);
}



void loop() {
  digitalWrite(LED_BUILTIN, LOW); //turn off LED
  if (Serial.available() > 0) {
    digitalWrite(LED_BUILTIN, HIGH); //flash LED everytime data is available
    delay(50);
    recvWithEndMarker();
    showNewNumber();
    if (dataNumber == 10000) {  //Speed query code
      Serial.println(currentSpeed);
    }
    else
      goalSpeed = dataNumber;
  }

  currentMillis = millis();
  if (currentMillis - previousMillis > interval) {

    elapsedMillis = currentMillis - previousMillis;
    previousMillis = currentMillis;
    // Revolutions per second = (total encoder pulse in 1s / motor encoder output)
    rps = (float)(((float)encoderValue / (float)((float)elapsedMillis / (float)1000)) / (float)ENCODERPPR);
    encoderValue = 0;

    currentSpeed = abs(rps * TRANSMISSION_RATIO);

    //PID speed control
    unsigned long now = millis();
    double timeChange = (double)(now - lastTime);
    double error = abs(goalSpeed) - currentSpeed;
    errSum += error * timeChange;
    double dErr = (error - lastErr) / timeChange;

    lastErr = error;
    lastTime = now;

    double newOutput = (Kp * error + Ki * errSum + Kd * dErr);
    output = round(constrain(newOutput, 0, 255));

    //output = abs(goalSpeed) * 1 + 9; //Uncomment this to use estimated constant output w/o speed control

    if (goalSpeed == 0) {  // stop command ovverides PID
      errSum = 0;
      output = 0;
      dErr = 0;
    }

    delay(30);
    if (reverse) {
      MotorCounterClockwise(output);
    } else {
      MotorClockwise(output);
    }
    delay(2);
  }
}

void EncoderInit()
{
  // Attach interrupt at encoder channel A on each rising signal
  attachInterrupt(digitalPinToInterrupt(ENC_A), updateEncoder, RISING);
  //attachInterrupt(digitalPinToInterrupt(ENC_B), updateEncoder, RISING);

}


void updateEncoder()
{
  // Add encoderValue by 1, each time it detects rising signal
  // from encoder channel A
  encoderValue++;
}

void MotorClockwise(int power) {
  if (power > 0) {
    analogWrite(MOTOR1A, power);
    digitalWrite(MOTOR1DIR, LOW);
  } else {
    digitalWrite(MOTOR1A, LOW);
    digitalWrite(MOTOR1DIR, LOW);
  }
}

void MotorCounterClockwise(int power) {
  if (power > 0) {
    analogWrite(MOTOR1A, power);
    digitalWrite(MOTOR1DIR, HIGH);
  } else {
    digitalWrite(MOTOR1A, LOW);
    digitalWrite(MOTOR1DIR, LOW);
  }
}

void setPwmFrequency(int pin, int divisor) {
  byte mode;
  if (pin == 5 || pin == 6 || pin == 9 || pin == 10) {
    switch (divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 64: mode = 0x03; break;
      case 256: mode = 0x04; break;
      case 1024: mode = 0x05; break;
      default: return;
    }
    if (pin == 5 || pin == 6) {
      TCCR0B = TCCR0B & 0b11111000 | mode;
    } else {
      TCCR1B = TCCR1B & 0b11111000 | mode;
    }
  } else if (pin == 3 || pin == 11) {
    switch (divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 32: mode = 0x03; break;
      case 64: mode = 0x04; break;
      case 128: mode = 0x05; break;
      case 256: mode = 0x06; break;
      case 1024: mode = 0x07; break;
      default: return;
    }
    TCCR2B = TCCR2B & 0b11111000 | mode;
  }
}

void recvWithEndMarker() {
  static byte ndx = 0;
  char endMarker = '\n';
  char rc;

  if (Serial.available() > 0) {
    rc = Serial.read();

    if (rc != endMarker) {
      receivedChars[ndx] = rc;
      ndx++;
      if (ndx >= numChars) {
        ndx = numChars - 1;
      }
    }
    else {
      receivedChars[ndx] = '\0'; // terminate the string
      ndx = 0;
      newData = true;
    }
  }
}

void showNewNumber() {
  if (newData == true) {
    dataNumber = 0;             // new for this version
    dataNumber = atoi(receivedChars);   // new for this version
    Serial.print("Speed set to ");
    //Serial.println(receivedChars);
    //Serial.print("Data as Number ... ");    // new for this version
    Serial.println(dataNumber);     // new for this version
    if (dataNumber < 0)
      reverse = true;
    else
      reverse = false;
    newData = false;
  }
}
