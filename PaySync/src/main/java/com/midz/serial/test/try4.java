package com.midz.serial.test;
import java.io.InputStream;
import java.io.OutputStream;

import com.fazecast.jSerialComm.SerialPort;
import com.fazecast.jSerialComm.SerialPortDataListener;
import com.fazecast.jSerialComm.SerialPortEvent;
import com.midz.util.Logging;

public class try4 implements SerialPortDataListener {
   private SerialPort serialPort;
   private OutputStream outputStream;
   private InputStream inputStream;
   
   public static void main(String[] args) {
     try {
           try4 main = new try4();
           main.connect();
     } catch (Exception e) {
         e.printStackTrace();
         Logging.log(e.toString());
     }
   }
   
   public void connect() throws Exception {
	  //Logging.allPortAvailableInfo();
	  
	  // Open the serial port where Bill Acceptor Port is connected
      serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
      //serialPort = SerialPort.getCommPort("COM3");
      
      Logging.portInfo(serialPort);
      
      serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
      serialPort.addDataListener(this);
      
      if (serialPort.openPort()) {
    	  Logging.log("Serial port opened successfully.");
      } else {
    	  Logging.log("Failed to open serial port.");
    	  Logging.log("Forcefully calling disconnect method & exit");
    	  disconnect();
    	  System.exit(1);
      }
      
      // Get the input and output streams
      outputStream = serialPort.getOutputStream();
      inputStream = serialPort.getInputStream();
      
      // Write data to the serial port
      String message = "Hello, world!";
      outputStream.write(message.getBytes());
      
      Logging.portInfo(serialPort);
      Logging.log("END OF connect()");
   }

   public int getListeningEvents() {
	  Logging.log("Entry & Exit OF getListeningEvents()"); 
      return SerialPort.LISTENING_EVENT_DATA_AVAILABLE;
   }

   public void serialEvent(SerialPortEvent event) {
      if (event.getEventType() == SerialPort.LISTENING_EVENT_DATA_AVAILABLE) {  
    	// Read data from the serial port
        try {
        	    Logging.log("BEGINING OF serialEvent()"); 
                int availableBytes = this.inputStream.available();
                Logging.log("1111");
                byte[] serialData = new byte[availableBytes];
                Logging.log("2222");
                int readResult = inputStream.read(serialData, 0, availableBytes);
                Logging.log("3333");
                if (readResult > 0) {
                	Logging.log("4444");
                    String serialString = new String(serialData);
                    Logging.log("5555");
                    Logging.log(serialString);
                }
                Logging.log("END OF serialEvent()"); 
        } 
        catch (Exception ex) {
              Logging.log("EXCEPTION OF serialEvent => "+ex.toString());
        }
      } //end of if
   } //end of serialEvent
   
   public void disconnect() {
       serialPort.removeDataListener();
       serialPort.closePort();
       Logging.log("Called disconnect method");
   }
} //end of try4
