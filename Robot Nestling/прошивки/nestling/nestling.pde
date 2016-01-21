// legs
#include <Servo.h>

// номера сверху вниз
const int SERVO_L1_PIN = 11; // поворот
const int SERVO_L2_PIN = 10;
const int SERVO_L3_PIN = 9;
const int SERVO_L4_PIN = 8;
const int SERVO_R1_PIN = 4; // поворот
const int SERVO_R2_PIN = 5;
const int SERVO_R3_PIN = 6;
const int SERVO_R4_PIN = 7;

Servo servol1;
Servo servol2;
Servo servol3;
Servo servol4;
Servo servor1;
Servo servor2;
Servo servor3;
Servo servor4;

// начальное положение
void start() {
  servol1.write(0);
  servol2.write(0);
  servol3.write(0);
  servol4.write(0);
  servor1.write(0);
  servor2.write(0);
  servor3.write(0);
  servor4.write(0);
}

void fwd() {
  servol1.write(90);
  servor1.write(90);
}

void left_stand() {
  servol2.write(90);
  servol3.write(90);
  servol4.write(90);
}

void right_stand() {
  servor2.write(90);
  servor3.write(90);
  servor4.write(90);
}

void left_sit() {
  servol2.write(55);
  servol3.write(135);
  servol4.write(115);
}

void right_sit() {
  servor2.write(125);
  servor3.write(45);
  servor4.write(65);
}


void stand() {
  left_stand();
  right_stand();
}

void sit() {
  left_sit();
  right_sit();
}

void setup() {
    servol1.attach(SERVO_L1_PIN);
    servol2.attach(SERVO_L2_PIN);
    servol3.attach(SERVO_L3_PIN);
    servol4.attach(SERVO_L4_PIN);
    servor1.attach(SERVO_R1_PIN);
    servor2.attach(SERVO_R2_PIN);
    servor3.attach(SERVO_R3_PIN);
    servor4.attach(SERVO_R4_PIN);
    
    start();
    fwd();
}

void loop() {
    // сесть
    stand();
    delay(6000);
    
    // встать
    sit();
    delay(3000);
    
    // ходить
    // ...
}

