package com.midz.serial;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class SerialReadServlet extends javax.servlet.http.HttpServlet {
	private static final long serialVersionUID = 1L;
	private SerialPort serialPort;
    private Thread readThread;
    private volatile boolean reading = false;
    private byte[] readBuffer = new byte[1024];
    private int numBytes;


	public void init(ServletConfig config) throws ServletException {
       // Set up the serial port
 	   serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
 	   Logging.portInfo(serialPort);
 	   
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
	   // Start the read thread
	   reading = true;
	   readThread = new Thread(new Runnable() {
	      @Override
	    public void run() {
	          while (reading) {
	             numBytes = serialPort.readBytes(readBuffer, readBuffer.length);
	             
	             /*
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
	             */
	          }//while
	      }//run()
	   });
	   readThread.start();	   
	} //init

    @Override
    public void destroy() {
        // Clean up resources
        reading = false;
        try {
            readThread.join();
            serialPort.closePort();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } //destroy

	//response.getWriter().append("Served at: ").append(request.getContextPath());
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Display the data on the JSP page
        String data = new String(readBuffer, 0, numBytes);
        request.setAttribute("data", data);
        Logging.log("->"+data);
        request.getRequestDispatcher("arduinoread.jsp").forward(request, response);
    } //doGet

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Start or stop reading data based on the form input
        String action = request.getParameter("action");
        if (action != null) {
            if (action.equals("start")) {
                reading = true;
            } else if (action.equals("stop")) {
                reading = false;
            }
        }
        Logging.log(request.getContextPath() + "/serial-read");
        response.sendRedirect(request.getContextPath() + "/serial-read");
    } //doPost

} //end of SerialReadServlet
