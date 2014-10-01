// Робот Машинка с сонаром: едет вперёд до тех пор, пока не встретит
// препятствие (10 см). При встрече препятствия отъезжает назад,
// поворачивает в сторону и едет вперед до следующего препятствия.


// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

/**
 * Сонар.
 */
#define SONAR_TRIG 31
#define SONAR_ECHO 30

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

/**
 * Измерить дистанцию, возвращает результат в сантиметрах.
 */
int measureDistanceCm() {
    // Отправить на ножку TRIG прямоугольный сигнал 
    // шириной 10 микросекунд
    digitalWrite(SONAR_TRIG, LOW);
    delayMicroseconds(5);
    digitalWrite(SONAR_TRIG, HIGH);
    delayMicroseconds(5);
    digitalWrite(SONAR_TRIG, LOW);
    delayMicroseconds(2);
    
    // Получить ответ HIGH на ножке ECHO и замерить время 
    // в микросекундах
    long duration = pulseIn(SONAR_ECHO, HIGH);
    
    // Вычислить расстояние до препятствия в сантиметрах
    // время мкс/скорость ультразвука 1/29 см/мкс /2 (туда-обратно)
    return (duration / 29 / 2);
}

void setup() {
    Serial.begin(9600);
    Serial.println("Start Robot Car - sonar basic");
    
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
    
    // пины сонара
    pinMode(SONAR_TRIG, OUTPUT);
    pinMode(SONAR_ECHO, INPUT);
    
    // остановить моторы при старте
    mleft_stop();
    mright_stop();
}

void loop() {
    if(measureDistanceCm() < 10) {
        Serial.print("Met obstruction, distance=");
        Serial.print(measureDistance());
        Serial.println("cm");
        
        // встретили препятствие, остановить моторы
        mleft_stop();
        mright_stop();
        
        // подождём долю секунды просто так
        delay(500);
        
        // отъезжаем назад 2 секунды
        mleft_backward();
        mright_backward();
        delay(2000);
        
        // секунду поворачиваем (~45 градусов)
        if(random(0, 2)) {
            // поворачиваем влево
            mleft_backward();
            mright_forward();
        } else {
            // поворачиваем вправо
            mleft_forward();
            mright_backward();
        }
        delay(500);
        //delay(random(300, 2000));
        
        // едем вперёд до линии
        mleft_forward();
        mright_forward();
    }
}

