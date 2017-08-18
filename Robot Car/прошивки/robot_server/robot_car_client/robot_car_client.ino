#include <WiFiShieldOrPmodWiFi_G.h>

#include <DNETcK.h>
#include <DWIFIcK.h>

// Протокол общения с Robot Server (Сервер Роботов)

// Команды, принимаемые от Сервера Роботов
const char* CMD_FORWARD = "forward";
const char* CMD_BACKWARD = "backward";
const char* CMD_LEFT = "left";
const char* CMD_RIGHT = "right";
const char* CMD_STOP = "stop";
const char* CMD_PING = "ping";

// Ответы для Сервера Роботов
const char* REPLY_OK = "ok";
const char* REPLY_DONTUNDERSTAND = "dontunderstand";

// Ножки для моторов
#define MOTOR_LEFT_1 8
#define MOTOR_LEFT_2 9
#define MOTOR_LEFT_EN 11
#define MOTOR_RIGHT_1 4
#define MOTOR_RIGHT_2 3
#define MOTOR_RIGHT_EN 6

// Значения для подключений

// Точка доступа ВайФай
const char* wifi_ssid = "lasto4ka";
const char* wifi_wpa2_passphrase = "robotguest";


// Сервер Роботов
const char* robot_server_host = "robotc.lasto4ka.su";
//const char* robot_server_host = "192.168.1.3";
const int robot_server_port = 1116;

// Подключение к WiFi
int conectionId = DWIFIcK::INVALID_CONNECTION_ID;
// TCP-клиент - подключение к серверу
TcpClient tcpClient;

// Буферы для обмена данными с сервером
char read_buffer[128];
char write_buffer[128];
int write_size;

/**
 * Вывести произвольный IP-адрес
 */
void printIPAddress(IPv4 *ipAddress) {
    Serial.print(ipAddress->rgbIP[0], DEC);
    Serial.print(".");
    Serial.print(ipAddress->rgbIP[1], DEC);
    Serial.print(".");
    Serial.print(ipAddress->rgbIP[2], DEC);
    Serial.print(".");
    Serial.print(ipAddress->rgbIP[3], DEC);
}

/**
 * Вывести текущий статус сетевого подключения.
 */
void printNetworkStatus() {
    IPv4 ipAddress;
    
    if( DNETcK::getMyIP(&ipAddress) ) { 
        Serial.print("IPv4 Address: ");
        printIPAddress(&ipAddress);
        Serial.println();
    } else {
        Serial.println("IP not assigned");
    }
    
    if( DNETcK::getDns1(&ipAddress) ) { 
        Serial.print("DNS1: ");
        printIPAddress(&ipAddress);
        Serial.println();
    } else {
        Serial.println("DNS1 not assigned");
    }
    
    if( DNETcK::getDns2(&ipAddress) ) { 
        Serial.print("DNS2: ");
        printIPAddress(&ipAddress);
        Serial.println();
    } else {
        Serial.println("DNS2 not assigned");
    }
    
    if( DNETcK::getGateway(&ipAddress) ) { 
        Serial.print("Gateway: ");
        printIPAddress(&ipAddress);
        Serial.println();
    } else {
        Serial.println("Gateway not assigned");
    }
        
    if( DNETcK::getSubnetMask(&ipAddress) ) { 
        Serial.print("Subnet mask: ");
        printIPAddress(&ipAddress);
        Serial.println();
    } else {
        Serial.println("Subnet mask not assigned");
    }
}

/**
 * Вывести текущий статус подключения к Серверу Роботов.
 */
void printTcpClientStatus() {
    IPEndPoint remoteEndPoint;
    if(tcpClient.getRemoteEndPoint(&remoteEndPoint)) {
        Serial.print("Remote host: ");
        printIPAddress(&remoteEndPoint.ip);
        Serial.print(":");
        Serial.println(remoteEndPoint.port);
    } else {
        Serial.println("TCP client not connected");
    }
}

/**
 * Вывести значение статуса сетевой операции.
 */
void printDNETcKStatus(DNETcK::STATUS status) {
    switch(status) {
        case DNETcK::None:                           // = 0,
            Serial.print("None");
            break;
        case DNETcK::Success:                        // = 1,
            Serial.print("Success");
            break;
        case DNETcK::UDPCacheToSmall:                // = 2,
            Serial.print("UDPCacheToSmall");
            break;
        // Initialization status
        case DNETcK::NetworkNotInitialized:          // = 10,
            Serial.print("NetworkNotInitialized");
            break;
        case DNETcK::NetworkInitialized:             // = 11,
            Serial.print("NetworkInitialized");
            break;
        case DNETcK::DHCPNotBound:                   // = 12,
            Serial.print("DHCPNotBound");
            break;
        // Epoch status
        case DNETcK::TimeSincePowerUp:               // = 20,
            Serial.print("TimeSincePowerUp");
            break;
        case DNETcK::TimeSinceEpoch:                 // = 21,
            Serial.print("TimeSinceEpoch");
            break;
        // DNS status
        case DNETcK::DNSIsBusy:                      // = 30,
            Serial.print("DNSIsBusy");
            break;
        case DNETcK::DNSResolving:                   // = 31,
            Serial.print("DNSResolving");
            break;
        case DNETcK::DNSLookupSuccess:               // = 32,
            Serial.print("DNSLookupSuccess");
            break;
        case DNETcK::DNSUninitialized:               // = 33,
            Serial.print("DNSUninitialized");
            break;
        case DNETcK::DNSResolutionFailed:            // = 34,
            Serial.print("DNSResolutionFailed");
            break;
        case DNETcK::DNSHostNameIsNULL:              // = 35,
            Serial.print("DNSHostNameIsNULL");
            break;
        case DNETcK::DNSRecursiveExit:               // = 36,
            Serial.print("DNSRecursiveExit");
            break;
        // TCP connect state machine states
        case DNETcK::NotConnected:                   // = 40,
            Serial.print("NotConnected");
            break;
        case DNETcK::WaitingConnect:                 // = 41,
            Serial.print("WaitingConnect");
            break;
        case DNETcK::WaitingReConnect:               // = 42,
            Serial.print("WaitingReConnect");
            break;
        case DNETcK::Connected:                      // = 43,
            Serial.print("Connected");
            break;
        // other connection status
        case DNETcK::LostConnect:                    // = 50,
            Serial.print("LostConnect");
            break;
        case DNETcK::ConnectionAlreadyDefined:       // = 51,
            Serial.print("ConnectionAlreadyDefined");
            break;
        case DNETcK::SocketError:                    // = 52,
            Serial.print("SocketError");
            break;
        case DNETcK::WaitingMACLinkage:              // = 53,
            Serial.print("WaitingMACLinkage");
            break;
        case DNETcK::LostMACLinkage:                 // = 54,
            Serial.print("LostMACLinkage");
            break;
        // write status
        case DNETcK::WriteTimeout:                   // = 60,
            Serial.print("WriteTimeout");
            break;
        // read status
        case DNETcK::NoDataToRead:                   // = 70,
            Serial.print("NoDataToRead");
            break;
        // Listening status
        case DNETcK::NeedToCallStartListening:       // = 80,
            Serial.print("NeedToCallStartListening");
            break;
        case DNETcK::NeedToResumeListening:          // = 81,
            Serial.print("NeedToResumeListening");
            break;
        case DNETcK::AlreadyStarted:                 // = 82,
            Serial.print("AlreadyStarted");
            break;
        case DNETcK::AlreadyListening:               // = 83,
            Serial.print("AlreadyListening");
            break;
        case DNETcK::Listening:                      // = 84,
            Serial.print("Listening");
            break;
        case DNETcK::ExceededMaxPendingAllowed:      // = 85,
            Serial.print("ExceededMaxPendingAllowed");
            break;
        case DNETcK::MoreCurrentlyPendingThanAllowed: // = 86,
            Serial.print("MoreCurrentlyPendingThanAllowed");
            break;
        case DNETcK::ClientPointerIsNULL:            // = 87,
            Serial.print("ClientPointerIsNULL");
            break;
        case DNETcK::SocketAlreadyAssignedToClient:  // = 88,
            Serial.print("SocketAlreadyAssignedToClient");
            break;
        case DNETcK::NoPendingClients:               // = 89,
            Serial.print("NoPendingClients");
            break;
        case DNETcK::IndexOutOfBounds:               // = 90,
            Serial.print("IndexOutOfBounds");
            break;
        // UDP endpoint resolve state machine
        case DNETcK::EndPointNotSet:                 // = 100,
            Serial.print("EndPointNotSet");
            break;
        // DNSResolving
        case DNETcK::ARPResolving:                   // = 110,
            Serial.print("ARPResolving");
            break;
        case DNETcK::AcquiringSocket:                // = 111,
            Serial.print("AcquiringSocket");
            break;
        case DNETcK::Finalizing:                     // = 112,
            Serial.print("Finalizing");
            break;
        case DNETcK::EndPointResolved:               // = 113,
            Serial.print("EndPointResolved");
            break;
        // DNSResolutionFailed
        case DNETcK::ARPResolutionFailed:            // = 120,
            Serial.print("ARPResolutionFailed");
            break;
        // SocketError
        // WiFi Stuff below here
        case DNETcK::WFStillScanning:                // = 130,
            Serial.print("WFStillScanning");
            break;
        case DNETcK::WFUnableToGetConnectionID:      // = 131,
            Serial.print("WFUnableToGetConnectionID");
            break;
        case DNETcK::WFInvalideConnectionID:         // = 132,
            Serial.print("WFInvalideConnectionID");
            break;
        case DNETcK::WFAssertHit:                    // = 133,
            Serial.print("WFAssertHit");
            break;
        default:
            Serial.print("Status unknown");
            break;
    }
}

/**
 * Подключиться к открытой сети WiFi.
 */
int connectWifiOpen(const char* ssid, DNETcK::STATUS *netStatus) {
    Serial.print("SSID: ");
    Serial.println(ssid);
  
    return DWIFIcK::connect(ssid, netStatus);   
}

/**
 * Подключиться к сети WiFi, защищенной WPA2 с паролем.
 */
int connectWifiWPA2Passphrase(const char* ssid, const char* passphrase, DNETcK::STATUS *netStatus) {
    Serial.print("SSID: ");
    Serial.print(ssid);
    Serial.print(", WPA2 passphrase: ");
    Serial.println(passphrase);
    
    return DWIFIcK::connect(ssid, passphrase, netStatus);
}

/**
 * Подлключиться к сети WiFi.
 */
int connectWifi(DNETcK::STATUS *netStatus) {
    int conId = DWIFIcK::INVALID_CONNECTION_ID;
    // Выбрать способ подключения - раскомментировать нужную строку.    
//    conId = connectWifiOpen(wifi_ssid, netStatus);
    conId = connectWifiWPA2Passphrase(wifi_ssid, wifi_wpa2_passphrase, netStatus);
    return conId;
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
    } else if (strcmp(buffer, CMD_PING) == 0) {
        Serial.println("Command 'ping': reply ok");
                
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_OK);
        replySize = strlen(reply_buffer);
    } else {      
        Serial.print("Unknown command: ");
        Serial.println(buffer);
        
        // Подготовить ответ
        strcpy(reply_buffer, REPLY_DONTUNDERSTAND);
        replySize = strlen(reply_buffer);
    }
    
    return replySize;
}

void setup() {
    Serial.begin(9600);
    Serial.println("Start Robot Car as Robot Server client");

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
    DNETcK::STATUS networkStatus;
    int readSize;
    int writeSize;
    
    // Держим Tcp-стек в живом состоянии
    DNETcK::periodicTasks();
        
    if(!DWIFIcK::isConnected(conectionId)) {
        // Подключимся к сети WiFi
        
        bool connectedToWifi = false;
        
        Serial.println("Connecting wifi...");
        conectionId = connectWifi(&networkStatus);
  
        if(conectionId != DWIFIcK::INVALID_CONNECTION_ID) {
            // На этом этапе подключение будет создано, даже если указанная 
            // сеть Wifi недоступна или для нее задан неправильный пароль
            Serial.print("Connection created, connection id=");
            Serial.println(conectionId, DEC);

            Serial.print("Initializing IP stack...");
            
            // Получим IP и сетевые адреса по DHCP
            DNETcK::begin();
            
            // К открытой сети может подключиться с первой попытки, к сети с паролем
            // может потребоваться несколько циклов (если пароль для сети неправильный,
            // то ошибка вылезет тоже на этом этапе).
            bool initializing = true;
            while(initializing) {
                Serial.print(".");
                // Вызов isInitialized заблокируется до тех пор, пока стек не будет 
                // инициализирован или не истечет время ожидания (по умолчанию 15 секунд). 
                // Если сеть не подключится до истечения таймаута и при этом не произойдет
                // ошибка, isInitialized просто вернет FALSE без кода ошибки, при необходимости
                // можно вызвать его повторно до успеха или ошибки.
                if(DNETcK::isInitialized(&networkStatus)) {
                    // Стек IP инициализирован
                    connectedToWifi = true;
                    
                    initializing = false;
                } else if(DNETcK::isStatusAnError(networkStatus)) {
                    // Стек IP не инициализирован из-за ошибки,
                    // в этом месте больше не пробуем                  
                    initializing = false;
                }
            }
            Serial.println();
        }
        
        if(connectedToWifi) {
            // Подключились к Wifi
            Serial.println("Connected to wifi");
            printNetworkStatus();
        } else {
            // Так и не получилось подключиться
            Serial.print("Failed to connect wifi, status: ");
            //Serial.print(networkStatus, DEC);
            printDNETcKStatus(networkStatus);
            Serial.println();
            
            // Нужно корректно завершить весь стек IP и Wifi, чтобы
            // иметь возможность переподключиться на следующей итерации
            DNETcK::end();
            DWIFIcK::disconnect(conectionId);
            conectionId = DWIFIcK::INVALID_CONNECTION_ID;
            
            // Немного подождем и попробуем переподключиться на следующей итерации
            Serial.println("Retry after 4 seconds...");
            delay(4000);
        }
    } else if(!tcpClient.isConnected()) {
        // Подключимся к Серверу Роботов
        
        bool connectedToServer = false;
        
        Serial.print("Connecting to Robot Server...");
        tcpClient.connect(robot_server_host, robot_server_port);
        // Сокет для подключения назначен, подождем, чем завершится процесс подключения
        bool connecting = true;
        while(connecting) {
            Serial.print(".");
            if(tcpClient.isConnected(&networkStatus)) {
                // Подключились к сереверу
                connectedToServer = true;
                                    
                connecting = false;
            } else if(DNETcK::isStatusAnError(networkStatus)) {
                // Не смогли подключиться к серверу из-за ошибки,
                // в этом месте больше не пробуем
                connecting = false;                    
            }
        }
        Serial.println();
        
        if(connectedToServer) {
            // Подключились к Серверу Роботов
            Serial.println("Connected to Robot Server");
            
            printTcpClientStatus();
        } else {
            // Так и не получилось подключиться
            Serial.print("Failed to connect Robot Server, status: ");
            //Serial.print(networkStatus, DEC);
            printDNETcKStatus(networkStatus);
            Serial.println();
            
            // Вернем TCP-клиента в исходное состояние
            tcpClient.close();
            
            // Немного подождем и попробуем переподключиться на следующей итерации
            Serial.println("Retry after 4 seconds...");
            delay(4000);
        }
    } else {
        // Подключены к серверу - читаем команды, отправляем ответы
        
        // есть чо почитать?
        if((readSize = tcpClient.available()) > 0) {
            readSize = readSize < sizeof(read_buffer) ? readSize : sizeof(read_buffer);
            readSize = tcpClient.readStream((byte*)read_buffer, readSize);
            
            // Считали порцию данных;
            // добавим к входным данным завершающий ноль,
            // чтобы рассматривать их как корректную строку
            read_buffer[readSize] = 0;
            
            Serial.print("Read: ");
            Serial.println(read_buffer);
 
            // и можно выполнить команду, ответ попадет в write_buffer
            writeSize = handleInput(read_buffer, readSize, write_buffer);
            write_size = writeSize;
        }
            
        if(write_size > 0) {
            Serial.print("Write: ");
            Serial.print(write_buffer);
            Serial.println();
            
            tcpClient.writeStream((const byte*)write_buffer, write_size);
            write_size = 0;
        }
    }
}

