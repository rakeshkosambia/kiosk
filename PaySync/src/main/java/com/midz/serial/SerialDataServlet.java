package com.midz.serial;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class SerialDataServlet extends javax.servlet.http.HttpServlet {
    private static final long serialVersionUID = 1L;
    private SerialPort serialPort;
    private String data = "";
    private volatile boolean reading = false;
    private volatile boolean portOpen = false;
    private volatile boolean toForward = false;

    public SerialDataServlet() {
	super();
	// TODO Auto-generated constructor stub
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	try {
	    Logging.log("doGet() started");
	    // Set the response content type
	    response.setContentType("text/plain");

	    /*
	     * //To test date if it is refreshing on the jsp Date dateObj = new Date(); data
	     * = dateObj.toString(); request.setAttribute("data", data);
	     * Logging.log("Setting data object :"+data.toString());
	     */
	    // ------------------------
	    String paramValue = request.getParameter("action");
	    if (paramValue != null) {
		if (request.getParameter("action").equalsIgnoreCase("stop")) {
		    reading = false;
		    Logging.log("action is STOP so reading = false");
		    data = "Bill Accetptor is disconnected.";
		    toForward = false;
		    request.setAttribute("action", "stop");
		}
		if (request.getParameter("action").equalsIgnoreCase("start")) {
		    reading = true;
		    Logging.log("action is START so reading = true");
		    data = "Bill Accetptor is connected, please now insert money.";
		    toForward = false;
		    request.setAttribute("action", "start");
		}
	    } else {
		reading = false;
		Logging.log("No action yet taken so reading = false");
		response.reset();
		data = "Need to take action  by clicking to start pay.";
		toForward = false;
	    }

	    if (reading) {
		serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
		Logging.portInfo(serialPort);

		serialPort.setComPortParameters(com.midz.util.ConstantParameters.ARDUINO_BAUD_RATE, 8,
			SerialPort.ONE_STOP_BIT, SerialPort.NO_PARITY);
		serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 1000, 0);
		serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
		serialPort.openPort();
		// Checking the port
		if (serialPort.isOpen()) {
		    Logging.log("Serial port opened successfully.");
		    portOpen = true;
		} else {
		    Logging.log("Serial port unsuccessful to open.");
		    portOpen = false;
		    toForward = false;
		    // RequestDispatcher dispatcher =
		    // request.getRequestDispatcher("arduinodata.jsp");
		    // dispatcher.forward(request, response);
		}
		request.setAttribute("action", "start");
		request.setAttribute("portOpen", portOpen);
	    }

	    // Write data to the port to start sending the data
	    // serialPort.writeBytes("start".getBytes(), "start".length());

	    // Read data from the port
	    while (reading) {
		if (serialPort.bytesAvailable() > 0) {
		    Logging.log("reading value for : TRUE");
		    byte[] readBuffer = new byte[serialPort.bytesAvailable()];
		    int numReadBytes = serialPort.readBytes(readBuffer, readBuffer.length);
		    if (numReadBytes > 0) {
			StringBuilder digitsBuilder = new StringBuilder();
			for (byte b : readBuffer) {
			    char c = (char) b;
			    if (Character.isDigit(c)) {
				digitsBuilder.append(c);
			    }
			} // end of for
			Logging.log("0.->" + digitsBuilder);
			if (!digitsBuilder.isEmpty()) {
			    data = digitsBuilder.toString();
			    Logging.log(" 1.string->$" + data + "$");
			    // sending data to jsp
			    response.getWriter().println(data);
			    // Thread.sleep(1000);

			    // if ( !data.isEmpty() ) {
			    // data = Integer.parseInt(data);
			    // Logging.log(" 2.bill->$"+data+"$");
			    // }

			} // end of if digitsBuilder
		    } // end of numReadBytes
		      // Thread.sleep(1000);
		    if (!reading)
			break;
		} // end of if
	    } // end of while
	    // Send a command to the Arduino board to stop sending data
	    // serialPort.writeBytes("stop".getBytes(), "stop".length());

	    /*
	     * if (portOpen) { serialPort.closePort();
	     * Logging.log("Serial port found open, so closed."); }
	     */
	    // --------------------------
	    // if (toForward) {
	    // sending data to jsp
	    response.reset();
	    response.flushBuffer();
	    response.getWriter().println(data);
	    // RequestDispatcher dispatcher = request.getRequestDispatcher("paybill.jsp");
	    // dispatcher.forward(request, response);
	    // response.sendRedirect(request.getContextPath() + "/paybill.jsp");
	    // response.getWriter().append("Served at: ").append("arduinodata.jsp");
	    // }
	    Logging.log("doGet() ended");
	} // end of try
	catch (Exception ex) {
	    Logging.log("Exception caught :" + ex.getClass().toString() + " : " + ex.toString());
	    ex.printStackTrace();
	} finally {
	    // if (portOpen)
	    // serialPort.closePort();
	}
    } // doGet

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	// TODO Auto-generated method stub
	Logging.log("doPost() started");
	// Start or stop reading data based on the form input
	String action = request.getParameter("action");
	if (action != null) {
	    if (action.equals("start")) {
		request.setAttribute("action", "start");
		reading = true;
	    } else if (action.equals("stop")) {
		request.setAttribute("action", "stop");
		reading = false;
	    }
	}
	// Logging.log(request.getContextPath() + "/SerialDataServlet");
	// response.sendRedirect(request.getContextPath() + "/SerialDataServlet");
	// doGet(request, response);
	response.sendRedirect(request.getContextPath() + "/paybill.jsp");
    }

}// SerialDataServlet
