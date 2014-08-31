// Робот Машинка в роли Таракана: убегает и прибегает на звук


// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

/**
 * Сенсор звука: сенсор подключен к входной ножке и 
 * подает на нее сигнал:
 * 0, если сенсор обнаружил звук,
 * 1, если сенсор звук не слышит.
 */
#define SOUND_SENSOR_PIN 28

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
    pinMode(MOTOR_LEFT_1, OUTPUT);
    pinMode(MOTOR_LEFT_2, OUTPUT);
    pinMode(MOTOR_LEFT_EN, OUTPUT);
    
    pinMode(MOTOR_RIGHT_1, OUTPUT);
    pinMode(MOTOR_RIGHT_2, OUTPUT);
    pinMode(MOTOR_RIGHT_EN, OUTPUT);
    
    // пин сенсора в режим ввода
    pinMode(SOUND_SENSOR_PIN, INPUT);
    
    // остановить моторы при старте
    mleft_stop();
    mright_stop();
}

void loop() {
    // Слышим звук - 2 секунды "бежим" назад, потом встаём;
    // на следующий звук бежим вперед, потом встаём и тп.
   
    // проверяем значение сенсора
    if(digitalRead(SOUND_SENSOR_PIN) == 0) {
        // сенсор сработал - бежим 2 секунды
        if(run_forward) {
            // вперед
            mleft_forward();
            mright_forward();
        } else {
            // назад
            mleft_backward();
            mright_backward();
        }
        // в следующий раз побежим обратно
        run_forward = !run_forward;
        
        // бежим 2 секунды
        delay(2000);
        
        // остановились       
        mleft_stop();
        mright_stop();
    
        // подождем секунду стоя, чтобы сенсор не сработал
        // от звука моторов
        delay(1000);
    }
}

