package com.midz.serial.test;

import java.io.InputStream;
import java.io.OutputStream;

import com.fazecast.jSerialComm.SerialPort;
import com.fazecast.jSerialComm.SerialPortDataListener;
import com.fazecast.jSerialComm.SerialPortEvent;
import com.midz.util.Logging;

public class SerialTestDataListener implements Runnable  {
   private SerialPort serialPort;
   private OutputStream outputStream;
   private InputStream inputStream;
	
   public static void main(String[] args) {
	   try {
	    	 SerialTestDataListener main = new SerialTestDataListener();
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
	      serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
	      serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING,0,0);
	      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
	      // Get the input and output streams
	      outputStream = serialPort.getOutputStream();
	      inputStream = serialPort.getInputStream();
	      // Opening the Port which is causing problem
	      serialPort.openPort();	      
	      //Checking the port
	      if (serialPort.isOpen()) {
	    	  Logging.log("Serial port opened successfully.");
	      } else {
	    	  Logging.log("Failed to open serial port.");
	    	  return;
	      }	    
	      //Thread implementation
	      Thread readThread = new Thread(this);
          readThread.start();
	      Logging.log("---------- Data Available for Reading Example ----------");
	      // Setting DataListerner for SerialPort
	      serialPort.addDataListener(new SerialPortDataListener() {
		        @Override
		        public int getListeningEvents() {
		           Logging.log("a.getListeningEvents ");	
		           return SerialPort.LISTENING_EVENT_DATA_AVAILABLE;
		        }
	    	    @Override
		        public void serialEvent(SerialPortEvent event) {
	    	      try {
	    	    	  	Logging.log("b.serialEvent ");	
	    	    	  	if (event.getEventType() == SerialPort.LISTENING_EVENT_DATA_AVAILABLE) {
			           	    //syntax 1
		    	    	  	byte[] readBuffer = new byte[100];
			        	    int numRead = serialPort.readBytes(readBuffer, readBuffer.length);
			        	    Logging.log("Read " + numRead + " bytes -> ");
			        	    String str = new String(readBuffer, "UTF-8"); 
			        	    Logging.log("Received -> "+ str);
			        	    //syntax 2
			                //byte[] buffer = new byte[serialPort.bytesAvailable()];
			                //int lengthRead = serialPort.readBytes(buffer, buffer.length);
			                //Logging.log("Read " + lengthRead + " bytes: " + new String(buffer));
	    	    	  	}//end of if
		        	  } //end of try
		        	  catch(Exception em) {
		        		  Logging.log("I'm from DataListener Exception:"+em.toString());
		        	  }
		        }//end of serialEvent
	      });
	      
	      // Write data to the serial port
	      //String message = "Hello, world!";
	      //outputStream.write(message.getBytes());
	      
	      Logging.log("END OF connect()");
	 } //end of try 
     catch(Exception ex) {
       System.out.println("I'm end of connect Exception:"+ex.toString());
       ex.printStackTrace();
     }
   }//end of connect

   public void run() {
   try {
           Thread.sleep(10);
       } catch (InterruptedException e) {
           e.printStackTrace();
       }
   }//end of run
   
   public void disconnect() {
	   if (serialPort.isOpen()) {
		   serialPort.removeDataListener();
		   serialPort.closePort();
		   Logging.log("Closed opened port");
	   } else {
		   Logging.log("No open port to close anything");
	   }
   }
}//end of class
