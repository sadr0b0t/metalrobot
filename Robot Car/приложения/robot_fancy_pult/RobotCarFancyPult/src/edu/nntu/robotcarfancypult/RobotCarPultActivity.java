package edu.nntu.robotcarfancypult;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

public class RobotCarPultActivity extends Activity {

    /**
     * Обратный вызов для получения результата выполения команды, добавленной в
     * очередь на выполнение в фоновом потоке.
     */
    private interface CommandListener {
        /**
         * Команды была выполнена на устройстве, получен ответ.
         * 
         * @param cmd
         *            выполненная команда
         * @param reply
         *            ответ от устройства
         */
        void onCommandExecuted(final String cmd, final String reply);
    }

    private enum ConnectionStatus {
        DISCONNECTED, CONNECTING, CONNECTED, ERROR
    }

    public static final String CMD_FORWARD = "forward";
    public static final String CMD_BACKWARD = "backward";
    public static final String CMD_LEFT = "left";
    public static final String CMD_RIGHT = "right";
    public static final String CMD_STOP = "stop";
    public static final String CMD_PING = "ping";

    public static final String DEFAULT_SERVER_HOST = "192.168.43.117";
    public static final int DEFAULT_SERVER_PORT = 44114;

    /**
     * Таймаут для чтения ответа на команды - сервер должет прислать ответ на
     * запрос за 5 секунд, иначе он будет считаться отключенным.
     */
    private static final int SERVER_SO_TIMEOUT = 5000;

    /**
     * Максимальное время неактивности пользователя, если пользователь не
     * отправлял команды на сервер роботу 5 секунд, приложение само отправит
     * команду ping, чтобы держать подключение открытым.
     */
    private final long MAX_IDLE_TIMEOUT = 5000;

    private TextView txtStatus;
    private Button btnConnect;
    private ImageButton btnCmdForward;
    private ImageButton btnCmdBackward;
    private ImageButton btnCmdLeft;
    private ImageButton btnCmdRight;
    private Button btnCmdStop;
    private TextView txtDebug;

    private final Handler handler = new Handler();

    private Socket socket;
    private OutputStream serverOut;
    private InputStream serverIn;

    private ConnectionStatus connectionStatus = ConnectionStatus.DISCONNECTED;
    private String connectionInfo;
    private String connectionErrorMessage;

    /**
     * "Очередь" команд для выполнения на сервере, состоящая из одного элемента.
     */
    private String nextCommand;
    private CommandListener nextCommandListener;

    /**
     * Подлключиться к серверу и запустить процесс чтения данных.
     */
    private void connectToServer(final String serverHost, final int serverPort) {
        // Все сетевые операции нужно делать в фоновом потоке, чтобы не
        // блокировать интерфейс
        new Thread() {
            @Override
            public void run() {
                try {
                    debug("Connecting to server: " + serverHost + ":"
                            + serverPort + "...");
                    setConnectionStatus(ConnectionStatus.CONNECTING);

                    socket = new Socket(serverHost, serverPort);

                    // Подключились к серверу:
                    // Установим таймаут для чтения ответа на команды -
                    // сервер должет прислать ответ за 5 секунд, иначе он будет
                    // считаться отключенным (в нашем случае это позволит
                    // предотвратить вероятные зависания на блокирующем read,
                    // когда например робот отключился до того, как прислал
                    // ответ и сокет не распрознал это как разрыв связи с
                    // выбросом IOException)
                    socket.setSoTimeout(SERVER_SO_TIMEOUT);

                    // Получаем доступ к потокам ввода/вывода сокета для общения
                    // с сервером (роботом)
                    serverOut = socket.getOutputStream();
                    serverIn = socket.getInputStream();

                    debug("Connected");
                    // TODO: разобраться, почему на этой строке может подвисать
                    connectionInfo = socket.getInetAddress().getHostName()
                            + ":" + socket.getPort();
                    debug("Connection info: " + connectionInfo);
                    setConnectionStatus(ConnectionStatus.CONNECTED);

                    // Подключились к серверу, теперь можно отправлять команды
                    startServerOutputWriter();
                } catch (final Exception e) {
                    socket = null;
                    serverOut = null;
                    serverIn = null;

                    debug("Error connecting to server: " + e.getMessage());
                    setConnectionStatus(ConnectionStatus.ERROR);
                    connectionErrorMessage = e.getMessage();

                    e.printStackTrace();
                }
            }
        }.start();
    }

    /**
     * Отладочные сообщения.
     * 
     * @param msg
     */
    private void debug(final String msg) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                txtDebug.append(msg + "\n");
            }
        });
        System.out.println(msg);
    }

    /**
     * Отключиться от сервера - закрыть все потоки и сокет, обнулить переменные.
     */
    private void disconnectFromServer() {
        try {
            if (serverIn != null) {
                serverIn.close();
            }
            if (serverOut != null) {
                serverOut.close();
            }
            if (socket != null) {
                socket.close();
            }
        } catch (final IOException e) {
            e.printStackTrace();
        } finally {
            serverIn = null;
            serverOut = null;
            socket = null;

            // очистить "очередь" команд
            nextCommand = null;
            nextCommandListener = null;

            debug("Disconnected");
            setConnectionStatus(ConnectionStatus.DISCONNECTED);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_robot_car_pult);

        txtStatus = (TextView) findViewById(R.id.txt_status);
        txtDebug = (TextView) findViewById(R.id.txt_debug);

        btnConnect = (Button) findViewById(R.id.btn_connect);
        btnConnect.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                connectToServer(DEFAULT_SERVER_HOST, DEFAULT_SERVER_PORT);
            }
        });

        btnCmdForward = (ImageButton) findViewById(R.id.btn_cmd_forward);
        // btnCmdForward.setOnClickListener(new View.OnClickListener() {
        btnCmdForward.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    sendCommand(CMD_FORWARD, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    sendCommand(CMD_STOP, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                }
                return false;
            }
        });

        btnCmdBackward = (ImageButton) findViewById(R.id.btn_cmd_backward);
        btnCmdBackward.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    sendCommand(CMD_BACKWARD, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    sendCommand(CMD_STOP, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                }
                return false;
            }
        });
        // btnCmdBackward.setOnClickListener(new View.OnClickListener() {
        //
        // @Override
        // public void onClick(View v) {
        // sendCommand(CMD_BACKWARD, new CommandListener() {
        //
        // @Override
        // public void onCommandExecuted(final String cmd,
        // final String reply) {
        // handler.post(new Runnable() {
        //
        // @Override
        // public void run() {
        // Toast.makeText(
        // RobotCarPultActivity.this,
        // "Command: " + cmd + "\n" + "Reply: "
        // + reply, Toast.LENGTH_SHORT)
        // .show();
        // }
        // });
        // }
        // });
        // }
        // });

        btnCmdLeft = (ImageButton) findViewById(R.id.btn_cmd_left);
        // btnCmdLeft.setOnClickListener(new View.OnClickListener() {
        //
        // @Override
        // public void onClick(View v) {
        // sendCommand(CMD_LEFT, new CommandListener() {
        //
        // @Override
        // public void onCommandExecuted(final String cmd,
        // final String reply) {
        // handler.post(new Runnable() {
        //
        // @Override
        // public void run() {
        // Toast.makeText(
        // RobotCarPultActivity.this,
        // "Command: " + cmd + "\n" + "Reply: "
        // + reply, Toast.LENGTH_SHORT)
        // .show();
        // }
        // });
        // }
        // });
        // }
        // });
        btnCmdLeft.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    sendCommand(CMD_LEFT, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    sendCommand(CMD_STOP, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                }
                return false;
            }
        });

        btnCmdRight = (ImageButton) findViewById(R.id.btn_cmd_right);
        // btnCmdRight.setOnClickListener(new View.OnClickListener() {
        //
        // @Override
        // public void onClick(View v) {
        // sendCommand(CMD_RIGHT, new CommandListener() {
        //
        // @Override
        // public void onCommandExecuted(final String cmd,
        // final String reply) {
        // handler.post(new Runnable() {
        //
        // @Override
        // public void run() {
        // Toast.makeText(
        // RobotCarPultActivity.this,
        // "Command: " + cmd + "\n" + "Reply: "
        // + reply, Toast.LENGTH_SHORT)
        // .show();
        // }
        // });
        // }
        // });
        // }
        // });
        btnCmdRight.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    sendCommand(CMD_RIGHT, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    sendCommand(CMD_STOP, new CommandListener() {

                        @Override
                        public void onCommandExecuted(final String cmd,
                                final String reply) {
                            handler.post(new Runnable() {

                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarPultActivity.this,
                                            "Command: " + cmd + "\n"
                                                    + "Reply: " + reply,
                                            Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });
                }
                return false;
            }
        });

        btnCmdStop = (Button) findViewById(R.id.btn_cmd_stop);
        btnCmdStop.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_STOP, new CommandListener() {

                    @Override
                    public void onCommandExecuted(final String cmd,
                            final String reply) {
                        handler.post(new Runnable() {

                            @Override
                            public void run() {
                                Toast.makeText(
                                        RobotCarPultActivity.this,
                                        "Command: " + cmd + "\n" + "Reply: "
                                                + reply, Toast.LENGTH_SHORT)
                                        .show();
                            }
                        });
                    }
                });
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();

        disconnectFromServer();
    }

    @Override
    protected void onResume() {
        super.onResume();

        connectToServer(DEFAULT_SERVER_HOST, DEFAULT_SERVER_PORT);
    }

    /**
     * Поставить комнаду в очередь для выполнения на сервере. При переполнении
     * очереди новые команды игнорируются. (в простой реализации в очереди может
     * быть всего один элемент).
     * 
     * @param cmd
     * @param cmdListener
     * @return true, если команда успешно добавлена в очередь false, если
     *         очередь переполнена и команда не может быть добавлена.
     */
    private boolean sendCommand(final String cmd,
            final CommandListener cmdListener) {
        if (nextCommand == null) {
            nextCommand = cmd;
            this.nextCommandListener = cmdListener;
            return true;
        } else {
            return false;
        }
    }

    private void setConnectionStatus(final ConnectionStatus status) {
        System.out.println("setConnectionStatus: " + status);
        this.connectionStatus = status;
        handler.post(new Runnable() {
            @Override
            public void run() {
                updateViews();
            }
        });
    }

    /**
     * Фоновый поток отправки данных на сервер: получаем команду от пользователя
     * (в переменной nextCommand), отправляем на сервер, ждем ответ, получаем
     * ответ, сообщаем о результате, ждем следующую команду от пользователя.
     */
    private void startServerOutputWriter() {
        new Thread() {
            @Override
            public void run() {
                try {
                    long lastCmdTime = System.currentTimeMillis();
                    while (true) {

                        String execCommand;
                        if (nextCommand != null) {
                            execCommand = nextCommand;
                        } else if (System.currentTimeMillis() - lastCmdTime > MAX_IDLE_TIMEOUT) {
                            execCommand = CMD_PING;
                        } else {
                            execCommand = null;
                        }

                        if (execCommand != null) {

                            // отправить команду на сервер
                            debug("Write: " + execCommand);
                            serverOut.write((execCommand).getBytes());
                            serverOut.flush();

                            // и сразу прочитать ответ
                            final byte[] readBuffer = new byte[256];
                            final int readSize = serverIn.read(readBuffer);
                            if (readSize != -1) {
                                final String reply = new String(readBuffer, 0,
                                        readSize);
                                debug("Read: " + "num bytes=" + readSize
                                        + ", value=" + reply);
                                if (nextCommandListener != null) {
                                    nextCommandListener.onCommandExecuted(
                                            execCommand, reply);
                                }
                            } else {
                                throw new IOException("End of stream");
                            }

                            // очистим "очередь" - можно добавлять следующую
                            // команду.
                            nextCommand = null;
                            nextCommandListener = null;

                            lastCmdTime = System.currentTimeMillis();
                        } else {
                            // на всякий случай - не будем напрягать систему
                            // холостыми циклами
                            try {
                                Thread.sleep(100);
                            } catch (InterruptedException e) {
                            }
                        }
                    }
                } catch (final Exception e) {
                    debug("Connection error: " + e.getMessage());
                    e.printStackTrace();
                }
                debug("Server output writer thread finish");
                disconnectFromServer();
            }
        }.start();
    }

    /**
     * Обновить элементы управления в зависимости от текущего состояния.
     */
    private void updateViews() {
        System.out.println("updateViews: " + connectionStatus);

        switch (connectionStatus) {
        case DISCONNECTED:
            txtStatus.setText(R.string.status_disconnected);

            btnConnect.setVisibility(View.VISIBLE);
            btnConnect.setEnabled(true);

            break;
        case CONNECTED:
            txtStatus.setText(getString(R.string.status_connected) + ": "
                    + connectionInfo);

            btnConnect.setVisibility(View.GONE);
            btnConnect.setEnabled(false);

            break;
        case CONNECTING:
            txtStatus.setText(R.string.status_connecting);

            btnConnect.setVisibility(View.VISIBLE);
            btnConnect.setEnabled(false);

            break;
        case ERROR:
            txtStatus.setText(getString(R.string.status_error) + ": "
                    + connectionErrorMessage);

            btnConnect.setVisibility(View.VISIBLE);
            btnConnect.setEnabled(true);

            break;
        default:
            break;
        }

        if (ConnectionStatus.CONNECTED.equals(connectionStatus)) {
            btnCmdForward.setEnabled(true);
            btnCmdBackward.setEnabled(true);
            btnCmdLeft.setEnabled(true);
            btnCmdRight.setEnabled(true);
            btnCmdStop.setEnabled(true);
        } else {
            btnCmdForward.setEnabled(false);
            btnCmdBackward.setEnabled(false);
            btnCmdLeft.setEnabled(false);
            btnCmdRight.setEnabled(false);
            btnCmdStop.setEnabled(false);
        }
    }
}
