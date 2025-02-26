package com.midz.serial;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class OldBillAcceptorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private SerialPort serialPort;
    private boolean running = false;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {

	String userid = request.getParameter("userid");
	String name = request.getParameter("name");
	String action = request.getParameter("action");
	String billdata = request.getParameter("billdata");
	String timestamp = request.getParameter("timestamp");
	String resourceURL = "";
	boolean portOpen = false;
	AtomicReference<String> billdataRef = new AtomicReference<>("");
	// ********************************************************
	Logging.log("1.doGet() :action->" + action);
	StringWriter stringWriter = new StringWriter();
	PrintWriter printWriter = new PrintWriter(stringWriter);
	stringWriter.getBuffer().setLength(0);
	// ------- userid -------
	if (userid != null) {
	    printWriter.write(userid);
	    userid = stringWriter.toString();
	    stringWriter.getBuffer().setLength(0);
	}
	// ------- name -------
	if (name != null) {
	    printWriter.write(name);
	    name = stringWriter.toString();
	    stringWriter.getBuffer().setLength(0);
	}
	// ------- action -------
	if (action != null) {
	    printWriter.write(action);
	    action = stringWriter.toString();
	    stringWriter.getBuffer().setLength(0);
	}
	// ********************************************************
	if (action != null && action.equals("stop")) {
	    // Set the stop flag
	    // stopFlag.set(true);
	    return;
	}

	if ("start".equals(action)) {
	    if (!running) {
		Logging.log("  2.running->" + running + " :action: " + action);
		// Open the serial port
		serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
		Logging.portInfo(serialPort);

		serialPort.setComPortParameters(com.midz.util.ConstantParameters.ARDUINO_BAUD_RATE, 8,
			SerialPort.ONE_STOP_BIT, SerialPort.NO_PARITY);
		serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 1000, 0);
		serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
		serialPort.openPort();
		// Checking the port
		if (serialPort.isOpen()) {
		    portOpen = true;
		    Logging.log("   3.running->" + running + " :isOpen->" + portOpen);

		    // Start a new thread to read data from the serial port

		    Thread thread = new Thread(new SerialReader(serialPort, billdata, billdataRef));
		    thread.start();
		    running = true;
		    Logging.log("    4.running->" + running + " :thread->start");

		    try {
			thread.join();
		    } catch (InterruptedException e) {
			Logging.log("error:" + e.toString());
		    }
		    billdata = billdataRef.get();
		    Logging.log("     5.running->" + running + " :billdata->" + billdata);

		} else {
		    portOpen = false;
		    Logging.log("   3.running->" + running + " :isOpen->" + portOpen);
		}
	    }
	} else if ("stop".equals(action)) {
	    if (running) {
		Logging.log("  2.running->" + running + " :action-: " + action);
		running = false;
		if (serialPort != null && serialPort.isOpen())
		    serialPort.closePort();
		Logging.log("   3.serialPort->closePort");
		Logging.log("    4.running->" + running + " :isOpen->" + portOpen);
	    }
	} else if ("date".equals(action)) {
	    Date dateObj = new Date();
	    billdata = dateObj.toString();
	    Logging.log("  2.action: " + action + " :billdata->" + billdata);

	}
	// response.getWriter().println(billdata);
	// ********************************************************
	// PrintWriter out = response.getWriter();
	// out.print(billdata);
	// out.close();
	// ********************************************************
	// ------- data -------
	if (billdata != null) {
	    printWriter.write(billdata);
	    billdata = stringWriter.toString();
	    stringWriter.getBuffer().setLength(0);
	}
	Logging.log("##### billdata : " + billdata);
	// ------- passing parameters from url -------
	response.setContentType("text/html; charset=UTF-8");
	resourceURL = request.getContextPath() + "/paybill_billacceptor.jsp";
	resourceURL = resourceURL + "?" + "userid=" + userid + "&name=" + name + "&action=" + action;
	resourceURL = resourceURL + "&billdata=" + billdata;
	Logging.log("       7.URL->" + resourceURL);
	// ------- url redirect -------
	Logging.log("        8.exit.doGet() :actionstart: " + action);
	response.sendRedirect(resourceURL);
	// ********************************************************
    }// doGet

    private class SerialReader implements Runnable {
	private String billdata;
	private AtomicReference<String> billdataRef;

	public SerialReader(SerialPort serialPort, String billdata, AtomicReference<String> billdataRef) {
	    this.billdata = billdata;
	    this.billdataRef = billdataRef;
	    Logging.log("     5.SerialReader : billdataRef->" + billdataRef);
	    Logging.log("     5.SerialReader : this.billdataRef->" + this.billdataRef);
	}

	@Override
	public void run() {
	    try {
		Logging.log("      6.0.run()");
		while (true) {
		    if (serialPort.bytesAvailable() > 0) {
			Logging.log("       6.1.bytesAvailable()->" + serialPort.bytesAvailable());
			byte[] readBuffer = new byte[serialPort.bytesAvailable()];
			int numReadBytes = serialPort.readBytes(readBuffer, readBuffer.length);
			if (numReadBytes > 0) {
			    StringBuilder digitsBuilder = new StringBuilder();
			    for (byte b : readBuffer) {
				char c = (char) b;
				if (Character.isDigit(c)) {
				    digitsBuilder.append(c);
				}
			    }
			    try {
				Logging.log("        6.2.sleep for 1 second");
				TimeUnit.SECONDS.sleep(1);
			    } catch (InterruptedException e) {
				Logging.log("error:" + e.toString());
			    }
			    Logging.log("         6.3.digitsBuilder->" + digitsBuilder);
			    if (!digitsBuilder.isEmpty()) {
				billdata = digitsBuilder.toString();
				if (!billdata.isEmpty()) {
				    Logging.log("          6.4.billdata->" + billdata + "<-");
				    billdataRef.set(billdata);
				}
			    }
			}
		    } // bytesAvailable
		} // while
	    } catch (Exception e) {
		e.printStackTrace();
	    }
	}// run()

	public void destroy() {
	    // Close the serial port
	    if (serialPort != null && serialPort.isOpen()) {
		serialPort.closePort();
		Logging.log("serialPort->closePort");
	    }
	}

    }// SerialReader
} // OldBillAcceptorServlet
