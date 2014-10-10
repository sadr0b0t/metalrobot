#include <chipKITUSBHost.h>
#include <chipKITUSBAndroidHost.h>

// Информация о текущем устройстве
static char manufacturer[] = "NNTU";
static char model[] = "Robot Car Android accessory";
static char description[] = "Robot Car Android accessory: control your Robot Car";
static char version[] = "1.0";
static char uri[] = "https://github.com/1i7/lessons";
static char serial[] = "N/A";

ANDROID_ACCESSORY_INFORMATION myDeviceInfo = {
    manufacturer, sizeof(manufacturer),
    model, sizeof(model),
    description, sizeof(description),
    version, sizeof(version),
    uri, sizeof(uri),
    serial, sizeof(serial)
};

// Команды, принимаемые от Android-устройства
const char* CMD_FORWARD = "forward";
const char* CMD_BACKWARD = "backward";
const char* CMD_LEFT = "left";
const char* CMD_RIGHT = "right";
const char* CMD_STOP = "stop";
const char* CMD_LETMEGO = "letmego";

// Ответы для Android-устройства
const char* REPLY_OK = "ok";
const char* REPLY_GETOUT = "getout";
const char* REPLY_UNKNOWN_CMD = "dontunderstand";

// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

// Локальные переменные
BOOL deviceAttached = FALSE;
void* deviceHandle = NULL;

BOOL readInProgress = FALSE;
BOOL writeInProgress = FALSE;

char read_buffer[128];
char write_buffer[128];
int write_size;

BOOL USBEventHandlerApplication( uint8_t address, USB_EVENT event, void *data, DWORD size ) {
    BOOL fRet = FALSE;

    // Вызываем обработчик событий для базового хост-контроллера
    // (это важно сделать, т.к. он также включает и выключает питание на ножках контроллера
    // по событиям EVENT_VBUS_REQUEST_POWER и EVENT_VBUS_RELEASE_POWER)
    fRet = USBHost.DefaultEventHandler(address, event, data, size);
  
    switch( event ) {
        // События от драйвера Android
        case EVENT_ANDROID_DETACH:
            Serial.println("Device NOT attached");
            deviceAttached = FALSE;
            return TRUE;
            break;

        case EVENT_ANDROID_ATTACH:
            Serial.println("Device attached");
            deviceAttached = TRUE;
            deviceHandle = data;
            return TRUE;

        default :
            break;
    }
    return fRet;
}

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


void cmd_forward() {
    mleft_forward();
    mright_forward();
}

void cmd_backward() {
    mleft_backward();
    mright_backward();
}

void cmd_left() {
    mleft_backward();
    mright_forward();
}

void cmd_right() {
    mleft_forward();
    mright_backward();
}

void cmd_stop() {
    mleft_stop();
    mright_stop();
}

/**
 * Обработать входные данные - разобрать строку, выполнить команду.
 * @return размер ответа в байтах (0, чтобы не отправлять ответ).
 */
int handleInput(char* buffer, int buffer_size, char* reply_buffer) {
    // обнулить ответ
    int replySize = 0;
    reply_buffer[0] = 0;
    
    // выполнить команды для Робота Машинки
    if(strcmp(buffer, CMD_FORWARD) == 0) {
        Serial.println("Command 'forward': go forward");
        
        // Выполнить команду
        cmd_forward();
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else if (strcmp(buffer, CMD_BACKWARD) == 0) {
        Serial.println("Command 'backward': go backward");
        
        // Выполнить команду
        cmd_backward();
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else if (strcmp(buffer, CMD_LEFT) == 0) {
        Serial.println("Command 'left': turn left");
        
        // Выполнить команду
        cmd_left();
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else if (strcmp(buffer, CMD_RIGHT) == 0) {
        Serial.println("Command 'right': turn right");
        
        // Выполнить команду
        cmd_right();
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else if (strcmp(buffer, CMD_STOP) == 0) {
        Serial.println("Command 'stop': stop");
        
        // Выполнить команду
        cmd_stop();
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else if (strcmp(buffer, CMD_LETMEGO) == 0) {
        Serial.println("Command 'letmego': send 'getout' reply");
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_GETOUT);
        replySize = strlen(reply_buffer);
    } else {      
        Serial.print("Unknown command: ");
        Serial.println(buffer);
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_UNKNOWN_CMD);
        replySize = strlen(reply_buffer);
    }
    
    return replySize;
}

void setup() {
    // Отладочные сообщения через последовательный порт:
    Serial.begin(9600);
    Serial.println("Start Robot Car android accessory");
  
    // Инициализируем контроллер USB HOST:
    // Передаем ссылку на обработчик событий
    USBHost.Begin(USBEventHandlerApplication);
    // Передаем информацию об устройстве драйверу Android
    USBAndroidHost.AppStart(&myDeviceInfo);

    // Ножки для моторов
    pinMode(MOTOR_LEFT_1, OUTPUT);
    pinMode(MOTOR_LEFT_2, OUTPUT);
    pinMode(MOTOR_LEFT_EN, OUTPUT);
    
    pinMode(MOTOR_RIGHT_1, OUTPUT);
    pinMode(MOTOR_RIGHT_2, OUTPUT);
    pinMode(MOTOR_RIGHT_EN, OUTPUT);
    
    // остановить колеса, если они будут крутиться
    cmd_stop();
}

void loop() {
    DWORD readSize;
    DWORD writeSize;
    uint8_t errorCode;
    
    // Запускаем периодические задачи для поддержания стека USB в живом и корректном состоянии.
    // Следует выполнять их хотябы один раз внутри цикла или в момент, когда нужно
    // обновить внутреннее состояние контроллера USB хоста.
    USBTasks();

    if(deviceAttached) {      
        // Чтение данных с устройства Android - ждем команду
        if(!readInProgress) {
            // Вызов не блокируется - проверка завершения чтения через AndroidAppIsReadComplete
            errorCode = USBAndroidHost.AppRead(deviceHandle, (uint8_t*)&read_buffer, (DWORD)sizeof(read_buffer));
            if(errorCode == USB_SUCCESS) {
                // Дождались команду - новую читать не будем, пока не придут все данные,
                // проверять завершение операции будем в следующих итерациях цикла
                readInProgress = TRUE;
            } else {
                Serial.print("Error trying to read: errorCode=");
                Serial.println(errorCode, HEX);
            }
        }

        // Проверим, завершилось ли чтение
        if(USBAndroidHost.AppIsReadComplete(deviceHandle, &errorCode, &readSize)) {
            // Разрешим читать следующую команду
            readInProgress = FALSE;
            
            if(errorCode == USB_SUCCESS) {
                // Считали порцию данных;
                // добавим к входным данным завершающий ноль,
                // чтобы рассматривать их как корректную строку
                read_buffer[readSize] = 0;
                
                Serial.print("Read: ");
                Serial.println(read_buffer);
                
                // и можно выполнить команду, ответ попадет в write_buffer
                writeSize = handleInput(read_buffer, readSize, write_buffer);
                                
                // Если writeSize не 0, отправим назад ответ - инициируем 
                // процедуру записи для следующей итерации цикла (данные уже внутри write_buffer)
                write_size = writeSize;
            } else {
                Serial.print("Error trying to complete read: errorCode=");
                Serial.println(errorCode, HEX);
            }
        }
        
        // Отправка данных на устройство Android
        if(write_size > 0 && !writeInProgress) {
            Serial.print("Write: ");
            Serial.print(write_buffer);
            Serial.println();
          
            writeSize = write_size;
            // Нужная команда уже в буфере для отправки
            // Вызов не блокируется - проверка завершения чтения через AndroidAppIsWriteComplete
            errorCode = USBAndroidHost.AppWrite(deviceHandle, (uint8_t*)&write_buffer, writeSize);
                        
            if(errorCode == USB_SUCCESS) {
                writeInProgress = TRUE;
            } else {
                Serial.print("Error trying to write: errorCode=");
                Serial.println(errorCode, HEX);
                
                write_size = 0;
            }
        }
        
        if(writeInProgress) {
            // Проверим, завершена ли запись
            if(USBAndroidHost.AppIsWriteComplete(deviceHandle, &errorCode, &writeSize)) {
                writeInProgress = FALSE;
                write_size = 0;
    
                if(errorCode != USB_SUCCESS) {
                    Serial.print("Error trying to complete write: errorCode=");
                    Serial.println(errorCode, HEX);
                }
            }
        }
    }
}

