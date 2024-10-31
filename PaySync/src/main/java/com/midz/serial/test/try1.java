package com.midz.serial.test;
// Serial Port classes
import com.fazecast.jSerialComm.SerialPort;

public class try1 {

	public try1() {
		// TODO Auto-generated constructor stub
	}

	public static void serialProcess(SerialPort S) {
		int BaudRate = 9600;
		int DataBits = 8;
		int StopBits = SerialPort.ONE_STOP_BIT;
		int Parity   = SerialPort.NO_PARITY;
	    //private InputStream input;
	    //private OutputStream output;
		
    	//Sets all serial port parameters at one time
        S.setComPortParameters(BaudRate,DataBits,StopBits,Parity);
        //Set Read Time outs
        S.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 1000, 0);
        //.setComPortTimeouts(TIMEOUT_Mode, READ_TIMEOUT_milliSec, WRITE_TIMEOUT_milliSec);
		
		System.out.println("****************************************************************************");
		System.out.println("Port Number                                -> .getSystemPortName()     -> " + S.getSystemPortName()); //Gives the number of com port,Eg COM9
		System.out.println("Port Physical Location (OS)                -> .getSystemPortPath()     -> " + S.getSystemPortPath());
	    System.out.println("Port Physical Location (USB hub)           -> .getSystemPortLocation() -> " + S.getPortLocation());
	    System.out.println("Port Description as reported by the device -> .getDescriptivePortName()-> " + S.getDescriptivePortName());
        System.out.println("Port Description  .toString()              -> .toString()              -> " + S.toString());
      	System.out.println(" Selected Baud rate          			   -> .getBaudRate()           -> = " + S.getBaudRate());
        System.out.println(" Selected Number of DataBits 			   -> .getNumDataBits()        -> = " + S.getNumDataBits());
      	System.out.println(" Selected Number of StopBits 			   -> .getNumStopBits()        -> = " + S.getNumStopBits());
      	System.out.println(" Selected Parity             			   -> .getParity()             -> = " + S.getParity());
      	System.out.println(" Selected Read Time Out      			   -> .getReadTimeout()        -> = " + S.getReadTimeout() + "mS");
        System.out.println("");
		
        S.openPort(); //open the port
        if (S.isOpen()) {
        	System.out.println(S.getSystemPortName()+" : IsOpen");
            //input = port.getInputStream();
            //output = port.getOutputStream();
        }
        else {
        	System.out.println(S.getSystemPortName()+" : NotOpen");
        }
        System.out.println("                 Transmit buffer size -> "+S.getDeviceWriteBufferSize()+" : Receiver buffer size -> "+S.getDeviceReadBufferSize());
      	//**************************************************
        	S.flushIOBuffers();
        	try {   
    			if (S.bytesAvailable() > 1) {
    	  			byte[] readBuffer = new byte[100];
    	  			int numRead = S.readBytes(readBuffer, readBuffer.length);
    	  			String BYTES_CONVERT_STR = new String(readBuffer, "UTF-8");
    	  			System.out.println("Received   -> Length:"+numRead+" -> Bytes:"+readBuffer.toString()+" -> ConvertedString:"+BYTES_CONVERT_STR);
    			}
    		} 
    		catch (Exception e) {
    			System.out.println(e.getMessage());
    			e.printStackTrace();
    		}
        	/*
          	try {   
    			while (true) {
    	  			byte[] readBuffer = new byte[100];
    	  			int numRead = S.readBytes(readBuffer, readBuffer.length);
    	  			System.out.print("Read :" + numRead + ": bytes");
    	  			//System.out.println(readBuffer);
    	  			String BYTES_CONVERT_STR = new String(readBuffer, "UTF-8"); //convert bytes to String
    	  			System.out.println("Received   -> Length:"+numRead+" -> Bytes:"+readBuffer.toString()+" -> ConvertedString:"+BYTES_CONVERT_STR);
    			}
    		} 
    		catch (Exception e) {
    			System.out.println(e.getMessage());
    			e.printStackTrace(); 
    		}
    		*/
        //**************************************************
        S.closePort(); //Close the port
      	if (S.isOpen())
    		System.out.println(S.getSystemPortName()+" : Manually close so check again -> IsOpen");
        else
   			System.out.println(S.getSystemPortName()+" : Manually close so check again -> NotOpen");
		
	} //serialProcess
	
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String ArduinoPort = "COM7";
		String AllPort = "ALL";
		
		SerialPort [] AvailablePorts = SerialPort.getCommPorts();	
		// use the for loop to print the available serial ports
		System.out.println("----------------------------------------------------------------------------");
		System.out.println("    Available Ports ");
		System.out.println("----------------------------------------------------------------------------");
		
		for(SerialPort S : AvailablePorts){
			switch (S.getSystemPortName().toString()) {
            case "COM7":
            	  serialProcess(S);
            	  break;
            default:	
          	      serialProcess(S);
          	      break;
           }//switch
		} //end of for loop
		System.out.println("------------------------------ End of Program ------------------------------");
	} //end of main

} // end of try1
