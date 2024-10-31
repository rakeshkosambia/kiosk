package com.midz.serial;

import java.io.IOException;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class SerialExample {
   private SerialPort serialPort;
   private int arduinoData = 0;
	
   public static void main(String[] args) {
	   try {
	    	 SerialExample main = new SerialExample();
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
          // Read data from the port
          while (true) 
          {
        	  /*
        	  Logging.log("-->"+serialPort.bytesAvailable());
        	  byte[] readBuffer = new byte[100];
              int numRead = serialPort.readBytes(readBuffer, readBuffer.length);
              if (numRead > 0) {
            	  String str = new String(readBuffer, "UTF-8");
            	  Logging.log("->"+str);
              } 
              */
        	  if (serialPort.bytesAvailable() > 0) {  
            	   byte[] readBuffer = new byte[serialPort.bytesAvailable()];
            	   int numReadBytes = serialPort.readBytes(readBuffer, readBuffer.length);
            	   if (numReadBytes > 0) {
                	  StringBuilder digitsBuilder = new StringBuilder();
                	  for (byte b : readBuffer) {
                	      char c = (char) b;
                	      if (Character.isDigit(c)) {
                	          digitsBuilder.append(c);
                	      }
                	  } //end of for
                	  if ( !digitsBuilder.isEmpty() ) {
                    	  String strDigits = digitsBuilder.toString();
                    	  Logging.log("1.string->$"+strDigits+"$");
                    	  if ( !strDigits.isEmpty() ) {
                    		  arduinoData = Integer.parseInt(strDigits);
                    		  Logging.log("  2.bill->$"+arduinoData+"$");
                    	  }
                	  }//end of if digitsBuilder
                   } //end of numReadBytes
		       } //end of if   
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
