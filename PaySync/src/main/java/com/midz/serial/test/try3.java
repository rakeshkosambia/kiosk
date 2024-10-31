package com.midz.serial.test;
import java.io.InputStream;
import java.io.OutputStream;

import com.fazecast.jSerialComm.SerialPort;
import com.fazecast.jSerialComm.SerialPortTimeoutException;
import com.midz.util.Logging;

public class try3 {
   SerialPort serialPort;
   OutputStream outputStream;
   InputStream inputStream;
   
   public static void main(String[] args) {
      try {
         try3 main = new try3();
         main.connect();
      } catch (Exception e) {
    	 e.printStackTrace();
    	 Logging.log(e.toString()); 
    	 
      }
   }
   
   public void connect() throws Exception {
      // Open the serial port
      serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
      Logging.portInfo(serialPort);
      
      serialPort.openPort();
      serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
      serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
      
      // Get the input and output streams
      outputStream = serialPort.getOutputStream();
      inputStream = serialPort.getInputStream();
      
      // Write data to the serial port
      String message = "Hello, world!";
      outputStream.write(message.getBytes());
      
      // Read data from the serial port
      try {
          int availableBytes = inputStream.available();
          byte[] serialData = new byte[availableBytes];
          int readResult = inputStream.read(serialData, 0, availableBytes);
          if (readResult > 0) {
              String serialString = new String(serialData);
              System.out.println(serialString);
          }
      } catch (SerialPortTimeoutException ex) {
          Logging.log("1=>"+ex.toString());
      } catch (Exception ex) {
          if (ex instanceof com.fazecast.jSerialComm.SerialPortIOException) {
              Logging.log(" ----- Port closed! ----- ");
              Logging.log("2=>"+ex.toString());
          } else {
        	  Logging.log("3=>"+ex.toString());
          }
      }
      
      
      // Close the serial port
      serialPort.closePort();
   }
}

