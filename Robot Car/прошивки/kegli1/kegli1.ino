// Робот Машинка с сонаром: едет вперёд до тех пор, пока не встретит
// препятствие (10 см). При встрече препятствия отъезжает назад,
// поворачивает в сторону и едет вперед до следующего препятствия.

#define LINE_SENSOR_L 27
#define LINE_SENSOR_R 28
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
    // выключить мотор
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
    // выключить мотор
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
    
    // время на подготовку отправки импульса
    delayMicroseconds(2);
    
    // Получить ответ HIGH на ножке ECHO и замерить время 
    // в микросекундах
    long duration = pulseIn(SONAR_ECHO, HIGH);
    
    // Вычислить расстояние до препятствия в сантиметрах:
    // duration - время, мкс
    // 29 ~ 30 ~ 1/0.033; 0.033 см/мкс - скорость звука в воздухе
    // 2 - делим расстояние туда+обратно пополам
    return (duration / 29 / 2);
}

void setup() {
    Serial.begin(9600);
    Serial.println("Start Robot Car - kegli");
    
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
    
    pinMode(LINE_SENSOR_L, INPUT);
    pinMode(LINE_SENSOR_R, INPUT);
    
    // пины сонара
    pinMode(SONAR_TRIG, OUTPUT);
    pinMode(SONAR_ECHO, INPUT);
    
    // остановить моторы при старте
    mleft_stop();
    mright_stop();
}

int count = 0;

void loop() {
        mleft_stop();
        mright_stop();
        
        if(count < 150) {
        
      
    if(measureDistanceCm() < 90) {
        Serial.print("Met obstruction, distance=");
        Serial.print(measureDistanceCm());
        Serial.println("cm");
        
        count = 0;
        
        // встретили препятствие, остановить моторы
        mleft_stop();
        mright_stop();
        
        // отъедем назад
         mleft_forward();
        mright_backward();
        delay(400);
        
         while( digitalRead(LINE_SENSOR_L) == 0 && digitalRead(LINE_SENSOR_R) == 0 ) {
      Serial.println("Proverka linii: linii net na 2x datchikah");
      
      // линии нет на обоих датчиках
      // едем вперед
      mleft_forward();
      mright_forward();
      
    } 
      // линия есть хотябы на одном из датчиков
      
      Serial.println("linia na odnom is datchikov");
      
      // ненадолго остановимся, чтобы собраться с мыслями
      mleft_stop();
      mright_stop();
      
      if( digitalRead(LINE_SENSOR_R) == 1 ) {
        // линия под правым датчиком
        
        Serial.println("praviy datchik -> povorot napravo");
        //delay(1000);
        mleft_backward();
        mright_backward();
        delay(500);
        // поворачиваем направо
        mleft_forward();
        mright_backward();
        
        // поворачиваемся 400 миллисекунд, время получено эмпирически
        delay(100);
      } else {
        // линии нет под правым датчиком, значит она под левым датчиком
        
        Serial.println("leviy datchik -> povorot nalevo");
        //delay(1000);
        mleft_backward();
        mright_backward();
        delay(500);
        // повернуть налево
        mleft_backward();
        mright_forward();
        
        // поворачиваемся 400 миллисекунд, время получено эмпирически
        delay(100);
      }
      } else{
        
        mleft_forward();
        mright_backward();
        
        // поворачиваемся 400 миллисекунд, время получено эмпирически
        delay(50);
        
        count = count + 1;
        
    }
        }
}
