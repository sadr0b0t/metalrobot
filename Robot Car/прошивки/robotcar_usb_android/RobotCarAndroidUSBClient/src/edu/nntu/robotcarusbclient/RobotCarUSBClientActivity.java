package edu.nntu.robotcarusbclient;

import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbAccessory;
import android.hardware.usb.UsbManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.ParcelFileDescriptor;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

/**
 * 
 * @author Anton Moiseev
 * 
 */
public class RobotCarUSBClientActivity extends Activity {
    // Да, имя этого системного акшена не определено в виде строковой константы
    // в UsbManager разработчиками андроида, сделаем это за них:
    private static final String ACTION_USB_PERMISSION = "com.google.android.DemoKit.action.USB_PERMISSION";
    private final static int READ_BUFFER_SIZE = 128;

    public static final String CMD_FORWARD = "forward";
    public static final String CMD_BACKWARD = "backward";
    public static final String CMD_LEFT = "left";
    public static final String CMD_RIGHT = "right";
    public static final String CMD_STOP = "stop";
    public static final String CMD_LETMEGO = "letmego";

    public static final String REPLY_GETOUT = "getout";

    private UsbManager usbManager;
    private UsbAccessory usbAccessory;
    private ParcelFileDescriptor fileDescriptor;
    private FileInputStream accessoryInput;
    private FileOutputStream accessoryOutput;

    private TextView txtStatus;
    private Button btnCmdForward;
    private Button btnCmdBackward;
    private Button btnCmdLeft;
    private Button btnCmdRight;
    private Button btnCmdStop;
    private TextView txtDebug;

    private boolean requestingPermission = false;

    private final Handler handler = new Handler();

    private final BroadcastReceiver usbReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (ACTION_USB_PERMISSION.equals(action)) {
                final UsbAccessory accessory = (UsbAccessory) intent
                        .getParcelableExtra(UsbManager.EXTRA_ACCESSORY);
                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED,
                        false)) {
                    debug("Broadcast: accessory permission granted");

                    openAccessory(accessory);
                } else {
                    debug("Broadcast: permission denied for accessory");
                }
                requestingPermission = false;
                updateViews();
            } else if (UsbManager.ACTION_USB_ACCESSORY_DETACHED.equals(action)) {
                final UsbAccessory accessory = (UsbAccessory) intent
                        .getParcelableExtra(UsbManager.EXTRA_ACCESSORY);
                if (accessory != null && accessory.equals(usbAccessory)) {
                    debug("Broadcast: accessory detached");

                    disconnectFromAccessory();
                    updateViews();
                }
            }
        }
    };

    /**
     * Пробует подключиться к указанному аксессуару. Открывает канал
     * коммуникации, если все хорошо, при необходимости запрашивает разрешение
     * пользователя.
     * 
     * @param accessory
     *            аксессуар для подключения
     */
    private void connectToAccessory(UsbAccessory accessory) {
        if (accessory != null) {
            if (usbManager.hasPermission(accessory)) {
                debug("connectToAccessory: has permission => openAccessory");
                openAccessory(accessory);
            } else {
                if (!requestingPermission) {
                    debug("connectToAccessory: no permission => requestPermission");
                    // Нет разрешения открыть аксессуар, запросим у пользователя
                    requestingPermission = true;
                    usbManager.requestPermission(accessory, PendingIntent
                            .getBroadcast(this, 0, new Intent(
                                    ACTION_USB_PERMISSION), 0));
                } else {
                    debug("connectToAccessory: requesting permission => skip");
                }
            }
        } else {
            debug("connectToAccessory: no accessories found");
        }
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
     * Закрыть канал коммуникации с аксессуаром.
     */
    private void disconnectFromAccessory() {
        try {
            if (fileDescriptor != null) {
                // Попросить аксессуар отключиться (требуется для корректного
                // завершения потока, читающего входящие сообщения)
                sendCommand(CMD_LETMEGO);

                fileDescriptor.close();

                debug("Disconnected from accessory");
            }
        } catch (IOException e) {
        } finally {
            usbAccessory = null;
            fileDescriptor = null;
            accessoryInput = null;
            accessoryOutput = null;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_robotcarusbclient);

        // Системные штуки
        usbManager = (UsbManager) getSystemService(Context.USB_SERVICE);

        final IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
        filter.addAction(UsbManager.ACTION_USB_ACCESSORY_DETACHED);
        // Судя по всему Android не позволяет принимать сообщения о событии
        // ACTION_USB_ACCESSORY_ATTACHED при помощи BroadcastReceiver,
        // поэтому будем использовать меню "Подключить аксессуар". Другой
        // вариант - закрывать активити каждый раз, когда аксессуар отключен и
        // открывать заново, когда подключен снова.
        // filter.addAction(UsbManager.ACTION_USB_ACCESSORY_ATTACHED);
        registerReceiver(usbReceiver, filter);

        // Интерфейс
        txtStatus = (TextView) findViewById(R.id.txt_status);
        txtDebug = (TextView) findViewById(R.id.txt_debug);

        btnCmdForward = (Button) findViewById(R.id.btn_cmd_forward);
        btnCmdForward.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_FORWARD);
            }
        });
        btnCmdBackward = (Button) findViewById(R.id.btn_cmd_backward);
        btnCmdBackward.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_BACKWARD);
            }
        });

        btnCmdLeft = (Button) findViewById(R.id.btn_cmd_left);
        btnCmdLeft.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_LEFT);
            }
        });

        btnCmdRight = (Button) findViewById(R.id.btn_cmd_right);
        btnCmdRight.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_RIGHT);
            }
        });

        btnCmdStop = (Button) findViewById(R.id.btn_cmd_stop);
        btnCmdStop.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                sendCommand(CMD_STOP);
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_usbclient, menu);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public void onDestroy() {
        unregisterReceiver(usbReceiver);
        super.onDestroy();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
        case R.id.action_connect_to_accessory:

            // сначала закроем текущее подключение, если оно активно
            disconnectFromAccessory();

            // Попробуем подключиться к аксессуару, если он подсоединен.
            // Получить список доступных аксессуаров из истемы.
            final UsbAccessory[] accessories = usbManager.getAccessoryList();
            // Максимальное число подключенных аксессуаров в текущей реализации
            // Android - 1, поэтому можем просто брать 1й элемент, если он есть.
            final UsbAccessory accessory = (accessories == null ? null
                    : accessories[0]);
            connectToAccessory(accessory);
            updateViews();

            return true;
        case R.id.action_disconnect_from_accessory:

            // Отключиться от аксессуара
            disconnectFromAccessory();
            updateViews();

            return true;
        default:
            return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onPause() {
        disconnectFromAccessory();
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();

        // Попробуем подключиться к аксессуару, если он подсоединен.
        if (usbAccessory == null) {
            // Получить список доступных аксессуаров из истемы.
            final UsbAccessory[] accessories = usbManager.getAccessoryList();
            // Максимальное число подключенных аксессуаров в текущей реализации
            // Android - 1, поэтому можем просто брать 1й элемент, если он есть.
            final UsbAccessory accessory = (accessories == null ? null
                    : accessories[0]);
            connectToAccessory(accessory);
        }

        updateViews();
    }

    /**
     * Открыть канал коммуникации с указанным аксессуаром.
     * 
     * @param accessory
     *            аксессуар для подключения
     */
    private void openAccessory(UsbAccessory accessory) {
        fileDescriptor = usbManager.openAccessory(accessory);
        if (fileDescriptor != null) {
            this.usbAccessory = accessory;
            final FileDescriptor fd = fileDescriptor.getFileDescriptor();

            accessoryInput = new FileInputStream(fd);
            accessoryOutput = new FileOutputStream(fd);
            new Thread(new Runnable() {

                @Override
                public void run() {
                    byte[] readBuffer = new byte[READ_BUFFER_SIZE];
                    int readSize = 0;
                    while (readSize >= 0) {
                        try {
                            debug("read bytes...");
                            // Этот вызов разблокируется только тогда, когда
                            // аксессуар пришлет какие-то данные или когда
                            // он будет отсоединен физически.
                            // Закрывать IntputStream, FileDescriptor, Accessory
                            // и что угодно еще из Java не поможет
                            // (см обсуждение здесь:
                            // http://code.google.com/p/android/issues/detail?id=20545
                            // ).
                            readSize = accessoryInput.read(readBuffer);
                            final String reply = new String(readBuffer);

                            final String postMessage = "Read: " + "num bytes="
                                    + readSize + ", value="
                                    + new String(readBuffer);

                            debug(postMessage);
                            handler.post(new Runnable() {
                                @Override
                                public void run() {
                                    Toast.makeText(
                                            RobotCarUSBClientActivity.this,
                                            postMessage, Toast.LENGTH_SHORT)
                                            .show();
                                }
                            });

                            // Поэтому нам нужна специальная команда "letmego",
                            // на которую аксессуар пришлет ответ "getout"
                            // и этот поток сможет завершиться.
                            if (REPLY_GETOUT.equals(reply)) {
                                break;
                            }
                        } catch (final Exception e) {
                            debug("Accessory read error: " + e.getMessage());
                            e.printStackTrace();
                            break;
                        }
                    }
                    debug("Input reader thread finish");
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            updateViews();
                        }
                    });
                }
            }).start();

            debug("openAccessory: connected accessory: manufacturer="
                    + usbAccessory.getManufacturer() + ", model="
                    + usbAccessory.getModel());
        } else {
            debug("openAccessory: Failed to open accessory");
        }
    }

    /**
     * Отправить команду подключенному аксессуару.
     * 
     * @param command
     *            команда для отправки
     */
    public void sendCommand(String command) {
        if (accessoryOutput != null) {
            try {
                debug("Write: " + command);

                accessoryOutput.write(command.getBytes());
                accessoryOutput.flush();
            } catch (IOException e) {
                debug("Write error: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Обновить элементы управления в зависимости от текущего состояния.
     */
    private void updateViews() {
        final boolean accessoryConnected = usbAccessory != null;
        if (accessoryConnected) {
            txtStatus.setText(getString(R.string.connected_to_accessory)
                    + ":\n" + "    manufacturer: "
                    + usbAccessory.getManufacturer() + "\n" + "    model: "
                    + usbAccessory.getModel() + "\n" + "    description: "
                    + usbAccessory.getDescription() + "\n" + "    version: "
                    + usbAccessory.getVersion() + "\n" + "    serial: "
                    + usbAccessory.getSerial() + "\n" + "    uri: "
                    + usbAccessory.getUri());
            btnCmdForward.setEnabled(true);
            btnCmdBackward.setEnabled(true);
            btnCmdLeft.setEnabled(true);
            btnCmdRight.setEnabled(true);
            btnCmdStop.setEnabled(true);
        } else {
            txtStatus.setText(R.string.no_accessory);
            btnCmdForward.setEnabled(false);
            btnCmdBackward.setEnabled(false);
            btnCmdLeft.setEnabled(false);
            btnCmdRight.setEnabled(false);
            btnCmdStop.setEnabled(false);
        }
    }
}
