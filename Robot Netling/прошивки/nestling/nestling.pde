// legs
#include <Servo.h>

const int SERVO_LA_PIN = 4;
const int SERVO_LB_PIN = 5;
const int SERVO_LC_PIN = 6;
const int SERVO_RA_PIN = 4;
const int SERVO_RB_PIN = 5;
const int SERVO_RC_PIN = 6;

Servo servola;
Servo servolb;
Servo servolc;
Servo servora;
Servo servorb;
Servo servorc;

// начальное положение
void start() {
  servola.write(0);
  servolb.write(0);
  servolc.write(0);
  servora.write(0);
  servorb.write(0);
  servorc.write(0);
}

void left_stand() {
  servola.write(0);
  servolb.write(0);
  servolc.write(0);
}

void left_sit() {
  servola.write(0);
  servolb.write(0);
  servolc.write(0);
}

void right_stand() {
  servora.write(0);
  servorb.write(0);
  servorc.write(0);
}

void right_sit() {
  servora.write(0);
  servorb.write(0);
  servorc.write(0);
}


void stand() {
  left_stand();
  right_stand();
}

void sit() {
  left_sit();
  right_sit();
}

void left_step1() {
  servola.write(0);
  servolb.write(0);
  servolc.write(0);
}

void left_step2() {
  servola.write(0);
  servolb.write(0);
  servolc.write(0);
}

void right_step1() {
  servora.write(0);
  servorb.write(0);
  servorc.write(0);
}

void right_step2() {
  servora.write(0);
  servorb.write(0);
  servorc.write(0);
}

void setup() {
    servola.attach(SERVO_LA_PIN);
    servolb.attach(SERVO_LB_PIN);
    servolc.attach(SERVO_LC_PIN);
    servora.attach(SERVO_RA_PIN);
    servorb.attach(SERVO_RB_PIN);
    servorc.attach(SERVO_RC_PIN);
    
    start();
}

void loop() {
    // сесть
    stand();
    delay(3000);
    
    // встать
    sit();
    delay(3000);
    
    // ходить
    // ...
}

