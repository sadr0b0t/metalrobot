// Робот Машинка едет по линии

/**
 * Сенсор линии: сенсор подключен к входной ножке и 
 * подает на нее сигнал:
 * 1, если сенсор обнаружил линию (черный цвет),
 * 0, если сенсор линию не видит (белый цвет).
 */
#define LINE_SENSOR_L 27
#define LINE_SENSOR_R 28

// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

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

    pinMode(MOTOR_LEFT_1, OUTPUT);
    pinMode(MOTOR_LEFT_2, OUTPUT);
    pinMode(MOTOR_LEFT_EN, OUTPUT);
    
    pinMode(MOTOR_RIGHT_1, OUTPUT);
    pinMode(MOTOR_RIGHT_2, OUTPUT);
    pinMode(MOTOR_RIGHT_EN, OUTPUT);
    
    // пин сенсора в режим ввода
    pinMode(LINE_SENSOR_L, INPUT);
    pinMode(LINE_SENSOR_R, INPUT);
    
    // остановить моторы при старте
    mleft_stop();
    mright_stop();
}


void loop() {
    if( digitalRead(LINE_SENSOR_L) == 0 && digitalRead(LINE_SENSOR_R) == 0 ) {
      // линии нет на обоих датчиках
      //Serial.println("Proverka linii: linii net na 2x datchikah");
      
      // едем вперед
      mleft_forward();
      mright_forward();
    } else {
      // линия есть хотябы на одном из датчиков
      Serial.println("linia na odnom is datchikov");
      
      if( digitalRead(LINE_SENSOR_R) == 1 ) {
        // линия под правым датчиком
        Serial.println("praviy datchik -> povorot napravo");
        
        // ненадолго остановимся, чтобы собраться с мыслями
        //mleft_stop();
        //mright_stop();
        //delay(1000);
        
        // поворачиваем направо
        mleft_forward();
        mright_backward();
        
        // поворачиваемся 350 миллисекунд, время получено эмпирически
        delay(350);
      } else {
        // линии нет под правым датчиком, значит она под левым датчиком        
        Serial.println("leviy datchik -> povorot nalevo");
        
        // ненадолго остановимся, чтобы собраться с мыслями
        //mleft_stop();
        //mright_stop();
        //delay(1000);
        
        // повернуть налево
        mleft_backward();
        mright_forward();
        
        // поворачиваемся 350 миллисекунд, время получено эмпирически
        delay(350);
      }
    }
}

