// Робот Машинка в роли сюмоиста: едет вперёд до тех пор, пока не встретит
// границу круга (черная линия) - в этом случае отъезжает назад на заданное
// расстояние, поворачивается в сторону и едет вперед до границы круга и тп.


// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

/**
 * Сенсор линии: сенсор подключен к входной ножке и 
 * подает на нее сигнал:
 * 1, если сенсор обнаружил линию (черный цвет),
 * 0, если сенсор линию не видит (белый цвет).
 */
#define LINE_SENSOR_PIN 28

boolean run_forward = false;

void mleft_forward() {
    // задать направление
    digitalWrite(MOTOR_LEFT_1, HIGH);
    digitalWrite(MOTOR_LEFT_2, LOW);
    
    // включить моторы
    digitalWrite(MOTOR_LEFT_EN, HIGH);
}

void mleft_backward() {
    // задать направление
    digitalWrite(MOTOR_LEFT_1, LOW);
    digitalWrite(MOTOR_LEFT_2, HIGH);
    
    // включить моторы
    digitalWrite(MOTOR_LEFT_EN, HIGH);
}

void mleft_stop() {
    // выключить моторы
    digitalWrite(MOTOR_LEFT_EN, LOW);
}

void mright_forward() {
    // задать направление
    digitalWrite(MOTOR_RIGHT_1, HIGH);
    digitalWrite(MOTOR_RIGHT_2, LOW);
    
    // включить моторы
    digitalWrite(MOTOR_RIGHT_EN, HIGH);
}

void mright_backward() {
    // задать направление
    digitalWrite(MOTOR_RIGHT_1, LOW);
    digitalWrite(MOTOR_RIGHT_2, HIGH);
    
    // включить моторы
    digitalWrite(MOTOR_RIGHT_EN, HIGH);
}

void mright_stop() {
    // выключить моторы
    digitalWrite(MOTOR_RIGHT_EN, LOW);
}

void setup() {
    Serial.begin(9600);
    Serial.println("Start Robot Car - the line follower!");
    
    // if analog input pin 0 is unconnected, random analog
    // noise will cause the call to randomSeed() to generate
    // different seed numbers each time the sketch runs.
    // randomSeed() will then shuffle the random function.
    randomSeed(analogRead(0));

    pinMode(MOTOR_LEFT_1, OUTPUT);
    pinMode(MOTOR_LEFT_2, OUTPUT);
    pinMode(MOTOR_LEFT_EN, OUTPUT);
    
    pinMode(MOTOR_RIGHT_1, OUTPUT);
    pinMode(MOTOR_RIGHT_2, OUTPUT);
    pinMode(MOTOR_RIGHT_EN, OUTPUT);
    
    // пин сенсора в режим ввода
    pinMode(LINE_SENSOR_PIN, INPUT);
    
    // остановить моторы при старте
    mleft_stop();
    mright_stop();
}

void loop() {
    if(digitalRead(LINE_SENSOR_PIN)) {
        Serial.println("Found line");
        
        // наткнулись на линию, остановить моторы
        mleft_stop();
        mright_stop();
        
        // подождём долю секунды просто так
        delay(500);
        
        // отъезжаем назад 2 секунды
        mleft_backward();
        mright_backward();
        delay(2000);
        
        // секунду поворачиваем (~90 градусов)
        if(random(0, 2)) {
            // поворачиваем влево
            mleft_backward();
            mright_forward();
        } else {
            // поворачиваем вправо
            mleft_forward();
            mright_backward();
        }
        delay(1000);
        //delay(random(300, 2000));
        
        // едем вперёд до линии
        mleft_forward();
        mright_forward();
    }
}

