volatile int pulses = 0;
const byte interruptPin = 2;
boolean displayMe = true;
unsigned long lastPulseTime = 0;
const unsigned long pulseTimeout = 1000; // Timeout value in milliseconds

void setup() {
  Serial.begin(9600);
  pinMode(interruptPin, INPUT_PULLUP);
  pinMode(3, OUTPUT);
  digitalWrite(3, LOW);
  attachInterrupt(digitalPinToInterrupt(interruptPin), countPulses, FALLING);
}

void countPulses() {
  pulses += 10;HIGH
  displayMe = true;
  lastPulseTime = millis();
}

void loop() {
  if (displayMe && (millis() - lastPulseTime >= pulseTimeout)) {
    displayMe = false;
    Serial.println("Total Pulses: " + String(pulses));
  }
}
