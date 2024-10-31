package com.midz.serial.test;

import java.io.InputStream;
import java.util.Scanner;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class TrySerialExample {
   private SerialPort serialPort;
   private InputStream inputStream;
   private int	counter = 0;
	
   public static void main(String[] args) {
	   try {
	    	 TrySerialExample main = new TrySerialExample();
	         main.connect();
	         main.disconnect();
	   } 
	   catch (Exception e) {
	      e.printStackTrace();
	      Logging.log(e.toString());
	   }
   }//end of main	   
   
   public void connect() throws Exception {
	 try {
		  //Logging.allPortAvailableInfo();
		  // Open the serial port where Bill Acceptor Port is connected
	      serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
	      Logging.portInfo(serialPort);
	      // Setting all parameters for serialPort
	      serialPort.setComPortParameters(com.midz.util.ConstantParameters.ARDUINO_BAUD_RATE, 
	    		  						  8, 
	    		  						  SerialPort.ONE_STOP_BIT, 
	    		  						  SerialPort.NO_PARITY);
	      //serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING,1000,0);
	      serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING,1000,0);
	      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
	      // Opening the Port which is causing problem
	      serialPort.openPort();
	      //Checking the port
	      if (serialPort.isOpen()) {
	    	  Logging.log("Serial port opened successfully.");
	      } else {
	    	  Logging.log("Serial port unsuccessful to open.");
	    	  return;
	      }
	      // Get the input and output streams
	      inputStream = serialPort.getInputStream();
	      Scanner scanner = new Scanner(inputStream	);
          // Read data from the port
          while (true) {
            if (scanner.hasNextLine()) {
            	counter=counter+1;
                String line = scanner.nextLine();
                Logging.log(counter+"->"+line);
            }
          }
	 } //end of try 
     catch(Exception ex) {
       System.out.println("Exception caught :"+ex.getClass().toString()+" : "+ex.toString());
       ex.printStackTrace();
     }
	 finally {
		 if(serialPort.isOpen()) {
			 serialPort.closePort();
		 }
	 }
   }//end of connect
   
   public void disconnect() {
	   if (serialPort.isOpen()) {
		   serialPort.closePort();
		   Logging.log("Serial port found open, so closed.");
	   }    
   }//end of disconnect
}//end of class
