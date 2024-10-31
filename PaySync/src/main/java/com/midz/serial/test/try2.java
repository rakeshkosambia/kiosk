package com.midz.serial.test;

import com.fazecast.jSerialComm.SerialPort;
import com.fazecast.jSerialComm.SerialPortDataListener;
import com.fazecast.jSerialComm.SerialPortEvent;
import com.midz.util.Logging;

public class try2 implements SerialPortDataListener {
   SerialPort serialPort;
   
   public static void main(String[] args) {
      try {
    	 Logging.log("Start of try2");
         try2 main = new try2();
         Logging.log("before main.connect()");
         main.connect();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   public void connect() throws Exception {
	  // All available Ports 
	  Logging.allPortAvailableInfo();
	   
	  // Open the serial port where Bill Acceptor Port is connected
      serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
      Logging.log("Got the serialPort Object");
      Logging.portInfo(serialPort);
      
      // Open the serial port
      serialPort.openPort();
      Logging.log("Port is opened for serialPort Object");
      
      serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
      serialPort.addDataListener(this);
      Logging.log("DataListener is added for serialPort Object");
      
   }

   public int getListeningEvents() {
	  Logging.log("getting the event which is set at SerialPort.LISTENING_EVENT_DATA_AVAILABLE:"+SerialPort.LISTENING_EVENT_DATA_AVAILABLE); 
      return SerialPort.LISTENING_EVENT_DATA_AVAILABLE;
   }

   public void serialEvent(SerialPortEvent event) {
	  Logging.log("Inside serialEvent Start"); 
      if (event.getEventType() == SerialPort.LISTENING_EVENT_DATA_AVAILABLE) {
         try {
        	Logging.log("--> event.getEventType():"+event.getEventType()); 
            byte[] readBuffer = new byte[serialPort.bytesAvailable()];
            int numBytes = serialPort.readBytes(readBuffer, readBuffer.length);
            Logging.log(new String(readBuffer));
         } catch (Exception e) {
            e.printStackTrace();
         }
      } 
   }
}
