package com.midz.util;

// Serial Port classes
import com.fazecast.jSerialComm.SerialPort;

public class Logging {

	public static void log(String str) {
		
		switch(ConstantParameters.LOG_MODE) {
		case 1:
			  System.out.println(str);
		    break;
		case 2:
		    // for doing nothing
		    break;
		  default:
		      // default
		}
	}//end of log
	
	public static void portInfo(SerialPort S) {
	    String openCLOSED = "";
	    log("******************************************** BEGIN **********************************************");
	    if (S.isOpen())
		openCLOSED = "OPEN";
	    else
		openCLOSED = "CLOSED";
	    log("Port is Open or Not Open                  ->                          -> " + openCLOSED);
	    log("Port Bytes Available                      -> .bytesAvailable()        -> " + S.bytesAvailable());
	    log("Port Number                               -> .getSystemPortName()     -> " + S.getSystemPortName());
	    log("Port Physical Location (OS)               -> .getSystemPortPath()     -> " + S.getSystemPortPath());
	    log("Port Physical Location (USB hub)          -> .getSystemPortLocation() -> " + S.getPortLocation());
	    log("Port Description as reported by the device-> .getDescriptivePortName()-> "
		    + S.getDescriptivePortName());
	    log("Port Description  .toString()             -> .toString()              -> " + S.toString());
	    log("Selected Baud rate                        -> .getBaudRate()           -> " + S.getBaudRate());
	    log("Selected Number of DataBits               -> .getNumDataBits()        -> " + S.getNumDataBits());
	    log("Selected Number of StopBits               -> .getNumStopBits()        -> " + S.getNumStopBits());
	    log("Selected Parity                           -> .getParity()             -> " + S.getParity());
	    log("Selected Read Time Out                    -> .getReadTimeout()        -> " + S.getReadTimeout()
		    + "mS");
	    log("******************************************** END   **********************************************");
	}
	
	public static void allPortAvailableInfo() {
		SerialPort [] AvailablePorts = SerialPort.getCommPorts();
		log("-------------------------------------------------------------------------------------------------");
		log("                                        AVAILABLE PORTS                                          ");
		log("-------------------------------------------------------------------------------------------------");		
		for(SerialPort avaiableSerial : AvailablePorts){
			switch (avaiableSerial.getSystemPortName().toString()) {
            case com.midz.util.ConstantParameters.ARDUINO_PORT_NAME:
            	 portInfo(avaiableSerial);
            	 break;
            default:
            	 portInfo(avaiableSerial);
          	     break;
            }//switch
		} //end of for loop
		log("-------------------------------------------------------------------------------------------------");
	}
}//end of Logging
