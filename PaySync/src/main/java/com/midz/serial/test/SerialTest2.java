package com.midz.serial.test;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class SerialTest2 {
	private static SerialPort serialPort;
	private static boolean portStatus = false;

	public SerialTest2() {
        // Set the communication parameters
        //serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);

        // Set the read and write timeouts
        //serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 100, 0);
	}

	public static void main(String[] args) {
	try {	
	      //Logging.allPortAvailableInfo();		
	      
		  // Open the serial port where Bill Acceptor Port is connected
	      serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
	      //serialPort = SerialPort.getCommPort("COM3");
	      Logging.portInfo(serialPort);
	      
	      // Setting all parameters for serialPort
	      serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
	      
	      //serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING,1000,0);
	      serialPort.setComPortTimeouts(SerialPort.TIMEOUT_WRITE_BLOCKING,0,0);
	      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
	      
	      // Opening the Port which is causing problem
	      portStatus = serialPort.openPort();
	      if (portStatus) {
	    	  Logging.log("serialPort.openPort() is success");
	      } else {
	    	  Logging.log("serialPort.openPort() is not success");
	    	  return;
	      }
	      Logging.log(" serialPort.openPort() command: ");
	    } 
	    catch (Exception e) {
	      e.printStackTrace();
	      Logging.log(e.toString());
	    } //end of catch
	} //end of main
} //end of SerialTest2

/*
 --------------

private static final Logger LOG = LoggerFactory.getLogger(Rs232.class);

@Override
public void run(ApplicationArguments args) throws Exception {
    SerialPort serialPort = getSerialPort();
    initSerialPort(serialPort);
    Read5Bytes(serialPort);
    serialPort.closePort();
    LOG.info("Port closed.");
}

private SerialPort getSerialPort() {
    SerialPort[] serialPortList = SerialPort.getCommPorts();
    SerialPort preferredPort = null;
    for (SerialPort port : serialPortList) {
        String systemPortName = port.getSystemPortName();
        LOG.info("Existing Port: System name: {}", systemPortName);
        if (systemPortName.equals("ttyS0") || systemPortName.equals("COM1")) {
            preferredPort = port;
            break;
        }
    }
    return preferredPort;
}

private void initSerialPort(SerialPort serialPort) {
    LOG.info("Opening port {}", serialPort.getSystemPortName());
    serialPort.openPort();
    LOG.info("Port opened.");
    serialPort.setBaudRate(38400);
    serialPort.setNumDataBits(8);
    serialPort.setNumStopBits(1);
    serialPort.setParity(SerialPort.NO_PARITY);
    serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
    serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 0, 0);
    LOG.info("Settings done.");
}

private void Read4Bytes(SerialPort serialPort) {
    try {
        InputStream inputStream = serialPort.getInputStream();
        for (int i = 1; i < 5; i++) {
            readInput(inputStream);
        }
    } catch (Exception e) { LOG.error("Exception thrown: ", e); }
}

private int readInput(InputStream inputStream) {
    LOG.info("Reading input stream...");
    int input;
    try {
        input = inputStream.read();
        LOG.info("Byte read: {}", input);
    } catch (IOException e) {
        throw new RuntimeException(e);
    }
    return input;
}
*/