package com.midz.serial.test;

import java.io.IOException;
import java.io.InputStream;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class LCDSerialMonitor {
	private static SerialPort serialPort;
	private static InputStream inputStream;
	
    public static void main(String[] args) throws IOException, InterruptedException {    	
    	//Logging.allPortAvailableInfo();
    	
    	// Open the serial port where Bill Acceptor Port is connected
	    serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
	    //serialPort = SerialPort.getCommPort("COM3");	      
	    Logging.portInfo(serialPort);
		            
	    // Setting all parameters for serialPort
	    serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);
	    serialPort.setComPortTimeouts(SerialPort.TIMEOUT_WRITE_BLOCKING,0,0);
	    //serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
        
        if (serialPort.openPort()) {
            System.out.println("Serial port opened successfully.");
        } else { 
        	System.out.println("Serial port not opened successfully.");
            return;
        }
        // Sending to Serial
        /*
        for (Integer i=0; i<50; ++i) {
        	serialPort.getOutputStream().write(i.byteValue());
        	serialPort.getOutputStream().flush();
        	Logging.log("Java Sent: "+i);
        	Thread.sleep(1000);
        }
        */
        // Receive from Serial
        try {
        	byte[] readBuffer = new byte[20];
            while (serialPort.getInputStream().available() > 0) {
                int numBytes = serialPort.getInputStream().read(readBuffer);
                Logging.log("The Read Bytes from SerialPort are");
                Logging.log(readBuffer.toString());
            }
            Logging.log(new String(readBuffer));
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (serialPort.closePort()) {
        	Logging.log("Serial port is closed");
        } else {
        	Logging.log("Serial port is not closed");
        }
    }//main
}//class    
