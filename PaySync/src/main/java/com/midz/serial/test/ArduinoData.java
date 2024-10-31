package com.midz.serial.test;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class ArduinoData {
   private static String arduinoData = "";
   private static SerialPort serialPort;

   public static void main(String[] args) throws InterruptedException {
	 //SerialPort serialPort = SerialPort.getCommPort("COM3"); 
	   serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
	   Logging.portInfo(serialPort);

	 //serialPort.setBaudRate(9600); 
	   serialPort.setComPortParameters(com.midz.util.ConstantParameters.ARDUINO_BAUD_RATE, 
	    		  					   8, 
	    		  					   SerialPort.ONE_STOP_BIT, 
	    		  					   SerialPort.NO_PARITY);
	   serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING,1000,0);
	   serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
       serialPort.openPort();
	 //Checking the port
	   if (serialPort.isOpen()) {
		   Logging.log("Serial port opened successfully.");
	   } else {
		   Logging.log("Serial port unsuccessful to open.");
	       return;
	   }
       // Read data from the port
       while (true) 
       {
    	   if (serialPort.bytesAvailable() > 0) {
    		   Logging.log("-->"+serialPort.bytesAvailable());
    		// byte[] readBuffer = new byte[100];
    		   byte[] readBuffer = new byte[serialPort.bytesAvailable()];   		
    		// int numRead = serialPort.readBytes(readBuffer, readBuffer.length);
    		// if (numRead > 0) {
    		// String str = new String(readBuffer, "UTF-8");	
    		// Logging.log("->"+str);
    		// }
    		   serialPort.readBytes(readBuffer, readBuffer.length);
    		   arduinoData = new String(readBuffer);
    	    } //end of if
    	    Thread.sleep(100);
       } //end of while
   } // void main
   
   public static String getArduinoData() {
       return arduinoData;
   }
} // ArduinoData
