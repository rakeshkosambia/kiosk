package com.midz.serial;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fazecast.jSerialComm.SerialPort;
import com.midz.util.Logging;

public class BillAcceptorServlet extends javax.servlet.http.HttpServlet {

    private static final long serialVersionUID = 1L;
    private SerialReader task;
    private SerialPort serialPort;

    // @Override
    // public void init() throws ServletException {
    // Logging.log("-->>>>>>>> first time called ---->>>>");
    // super.init();
    // }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.setBufferSize(64 * 1024);

	String userid = request.getParameter("userid");
	String paidamount = request.getParameter("paidamount");
	String payOffsetPendId = request.getParameter("payOffsetPendId");

	String action = request.getParameter("action");
	String name = request.getParameter("name");
	String timestamp = request.getParameter("timestamp");
	String jsStep = request.getParameter("jsStep");

	String resourceURL = "";
	String techmessage = "";
	String billRefresh = "";
	String billTotal = "";

	HttpSession session = request.getSession();
	String jspSessionID = request.getParameter("sessionID");
	String currentSessionID = session.getId();
	boolean directDBPage = false;

	try {
	    Logging.log("=>==================================> NEW REQUEST ==================================>");
	    Logging.log("STEP " + jsStep + ". -> doGet()->begin : action->" + action + " :userid->" + userid
		    + ":paidamount:" + paidamount + ":payOffsetPendId:" + payOffsetPendId);
	    directDBPage = false;

	    if (action != null) {
		session.setAttribute("sessionaction", action);
	    } else {
		session.setAttribute("sessionaction", "");
	    }

	    if (action == null) {
		// response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'action'
		// parameter");
		// return;
		techmessage = "start_1"; // "Missing 'action' parameter";
	    }

	    if (currentSessionID.equals(jspSessionID)) {
		if (task != null && task.isRunning() && action.equals("start")) {
		    techmessage = "start_2"; // "KIOSK is already ready to accept money";
		    task.requestKill();
		    // Logging.log("==>2.TASK RUNNING FOR ANOTHER USER SO KILLED ->action->" +
		    // action + " :techmessage:"
		    // + techmessage);
		}
	    } else {
		// ************************* START *************************
		if (action.equals("start")) {
		    if (task != null && task.isRunning()) {
			// response.sendError(HttpServletResponse.SC_CONFLICT, "Computation already
			// running");
			// return;
			techmessage = "start_2"; // "KIOSK is already ready to accept money";
			// Logging.log(
			// "==>2.TASK RUNNING SO NO ACTION ->action->" + action + " :techmessage:" +
			// techmessage);
		    } else {
			// Logging.log("==>2.doGet()->action->" + action + " :SerialPort->Opening the
			// port");
			serialPort = SerialPort.getCommPort(com.midz.util.ConstantParameters.ARDUINO_PORT_NAME);
			Logging.portInfo(serialPort);
			serialPort.setComPortParameters(com.midz.util.ConstantParameters.ARDUINO_BAUD_RATE, 8,
				SerialPort.ONE_STOP_BIT, SerialPort.NO_PARITY);
			serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 1000, 0);
			serialPort.setFlowControl(SerialPort.FLOW_CONTROL_DISABLED);
			serialPort.openPort();
			techmessage = "start_2"; // "KIOSK is already ready to accept money";
			// Logging.log("==>2.TASK NOT RUNNING SO STARTED TASK, OPENING PORT->action->" +
			// action
			// + " :techmessage:" + techmessage + ":serialPort.isOpen():" +
			// serialPort.isOpen());
		    }
		    if (serialPort.isOpen()) {
			// Logging.log("==>3.ENTER.Thread.doGet()->action->" + action + " :techmessage:"
			// + techmessage
			// + ":serialPort.isOpen():" + serialPort.isOpen());

			// Logging.log("==================> THREAD STARTED ==================>");
			task = new SerialReader(serialPort, session, techmessage);
			Thread thread = new Thread(task);
			thread.start();
			techmessage = "start_3"; // "KIOSK is ready to accept money";
			// Logging.log("==>3.EXIST.Thread.doGet()->action->" + action + " :techmessage:"
			// + techmessage
			// + ":serialPort.isOpen():" + serialPort.isOpen());
			// response.getWriter().print("Computation started");
		    } else {
			// response.sendError(HttpServletResponse.SC_CONFLICT, "Bill acceptor port not
			// open");
			// return;
			techmessage = "start_4"; // "KIOSK not available";
			// Logging.log("==>4.PORT NOT ABLE TO OPEN->action->" + action + "
			// :techmessage:" + techmessage
			// + ":serialPort.isOpen():" + serialPort.isOpen());
		    }
		} else if (action.equals("stop")) {
		    session.setAttribute("sessionaction", action);
		    if (task == null || !task.isRunning()) {
			// response.sendError(HttpServletResponse.SC_CONFLICT, "Computation not
			// running");
			// return;
			techmessage = "stop_1"; // "KIOSK is not ready/accepting";
			// Logging.log(
			// "===>6.STOP but no task running->action->" + action + " :techmessage:" +
			// techmessage);
		    }
		    if ((task != null) && (task.isRunning())) {
			Logging.log("===>6.STOP PERFORMED->action->" + action + " :techmessage:" + techmessage);
			Logging.log(
				"==================> STOP OF TRANSACTION (by JAVA as STOP pressed by user) ==================>");
			task.requestStop();
			directDBPage = true;
			if (task.getBillResult() != null) {
			    // intBillTotal = (session.getAttribute("intBillTotal") != null) ?
			    // Integer.parseInt((String) session.getAttribute("intBillTotal")) : 0;
			    // intBillTotal += Integer.parseInt(billdata);
			    // session.setAttribute("intBillTotal", intBillTotal);
			    billRefresh = (task.getBillResult().get("billRefresh") != null)
				    ? task.getBillResult().get("billRefresh").toString()
				    : "0";
			    billTotal = (task.getBillResult().get("billTotal") != null)
				    ? task.getBillResult().get("billTotal").toString()
				    : "0";
			    techmessage = "success_" + billRefresh;
			    Logging.log("==>3.TASK GOT:billRefresh->" + billRefresh + ":billTotal->" + billTotal
				    + ":techmessage->" + techmessage);

			    // response.getWriter().print("Computation stopped. Result: " + intBillTotal);
			    if (serialPort.isOpen()) {
				serialPort.closePort();
				// Logging.log("==>6.CLOSE PORT IF FOUND OPEN.serial port is open so closing");
			    }
			    // REDIRECT FOR DB PAYMENT
			} // if (task.getBillResult() != null) {
		    } // if ((task != null) && (task.isRunning()))
		} else { // } else if (action.equals("stop")) {
		    session.setAttribute("sessionaction", action);
		    // Logging.log("==>6.doGet()->action->" + action
		    // + " :action->Action is not valid should be either start or stop");
		    // response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid 'flag'
		    // parameter value");
		    techmessage = "fail"; // "Action is not valid should be either start or stop";
		}
		// ************************* END *************************
	    } // currentSessionID.equals(jspSessionID)
	    if (action == null) {
		action = session.getAttribute("sessionaction").toString();
	    }
	    if (directDBPage) {
		// REDIRECT FOR DB PAYMENT
		response.setContentType("text/html; charset=UTF-8");
		resourceURL = request.getContextPath() + "/paybill_billacceptor.jsp"; // instead of paybillsubmit.jsp
		resourceURL = resourceURL + "?" + "userid=" + userid + "&name=" + name + "&action=" + action;
		resourceURL = resourceURL + "&billTotal=" + billTotal + "&techmessage=" + techmessage + "&paidamount="
			+ paidamount + "&payOffsetPendId=" + payOffsetPendId + "&isDBSubmit=Y";

		Logging.log("URL FOR DB PAYMENT: action->" + action + ": url->" + resourceURL);
		session.setAttribute("techmessage", techmessage);
		session.setAttribute("isDBSubmit", "Y");
		session.setAttribute("payOffsetPendId", payOffsetPendId);
		session.setAttribute("paidamount", paidamount);
		Logging.log("SESSION SERVLET: techmessage->" + session.getAttribute("techmessage").toString());
		Logging.log("############################################################");
		response.sendRedirect(resourceURL);
	    } else {
		// REDIRECT TO JSP PAGE
		response.setContentType("text/html; charset=UTF-8");
		resourceURL = request.getContextPath() + "/paybill_billacceptor.jsp";
		resourceURL = resourceURL + "?" + "userid=" + userid + "&name=" + name + "&action=" + action;
		resourceURL = resourceURL + "&billTotal=" + billTotal + "&techmessage=" + techmessage + "&paidamount="
			+ paidamount + "&payOffsetPendId=" + payOffsetPendId + "&isDBSubmit=N";

		Logging.log("URL BACK TO SAME JSP: action->" + action + ": url->" + resourceURL);
		session.setAttribute("techmessage", techmessage);
		session.setAttribute("isDBSubmit", "Y");
		session.setAttribute("payOffsetPendId", payOffsetPendId);
		session.setAttribute("paidamount", paidamount);
		Logging.log("SESSION SERVLET: techmessage->" + session.getAttribute("techmessage").toString());
		Logging.log("############################################################");
		response.sendRedirect(resourceURL);
	    }
	} catch (Exception ex) {
	    Logging.log("Exception caught in doGET: " + ex.toString());
	    ex.printStackTrace();
	}
    } // toGet()

    private static class SerialReader implements Runnable {
	private boolean stopRequested = false;
	private boolean running = false;
	private String billRefresh;
	private SerialPort serialPort;
	private int billTotal = 0;
	HttpSession session;
	private Hashtable hashValue = new Hashtable();
	private int loop = 0;
	private String techmessage = "";
	private boolean sot = false;

	public SerialReader(SerialPort serialPort, HttpSession session, String techmessage) {
	    this.serialPort = serialPort;
	    this.session = session;
	    this.techmessage = techmessage;
	    // Logging.log("===>3.1.SerialReader : constructor->begin");
	}

	@Override
	public void run() {
	    running = true;
	    billRefresh = "";
	    billTotal = 0;
	    loop = 0;

	    if (session.getAttribute("billRefresh") != null) {
		session.setAttribute("billRefresh", "");
	    }
	    if (session.getAttribute("billTotal") != null) {
		session.setAttribute("billTotal", "");
	    }

	    // Logging.log("***************3.2->BEGIN run()->billRefresh->" + billRefresh +
	    // ":billTotal->" + billTotal);
	    while (!stopRequested) {
		try {
		    /*
		     * if need make it sleep while (serialPort.bytesAvailable() == 0) { try {
		     * Thread.sleep(1); } catch (InterruptedException e) { e.printStackTrace(); } }
		     * java send "sot" son10.00# (insert 20 pesso) 10.00# java send "eot" sum20.00#
		     */
		    // First loop need to send start of transaction sot
		    if (!sot) {
			Logging.log(
				"==================> sot START OF TRANSACTION (by JAVA as START pressed by user) ==================>");
			String textToSend = "sot\n";
			byte[] newData = textToSend.getBytes();
			serialPort.writeBytes(newData, newData.length);
			Logging.log("==================> need to verify sot in bill_acceptor ==================>");

			// Wait for the port to be ready
			try {
			    // Logging.log("==================> SLEEP for LOOP." + loop +
			    // "==================>");
			    // Thread.sleep(1000);
			    // Logging.log("sleeping for 1000 ");
			} catch (Exception e) {
			    e.printStackTrace();
			}
		    } // if (!sot)
		      // Logging.log("**********> THREAD LOOP. " + loop + "**********>");
		      // reading the serial port

		    int dynamicBytes = serialPort.bytesAvailable();
		    dynamicBytes = dynamicBytes + 1024;
		    // Logging.log("*****NEW :" + dynamicBytes + "**********");
		    byte[] readBuffer = new byte[dynamicBytes];
		    int numBytes = serialPort.readBytes(readBuffer, readBuffer.length);
		    String input = new String(readBuffer, 0, numBytes);
		    // replace those charaters
		    // input = ((input.replaceAll("\\r\\n", "")).replaceAll("\\D", "")).trim();
		    // input = input.trim();

		    if (input != null && input.trim().length() > 0 && !sot) {
			sot = true;
			input = input.trim();
			if (input.contains("sot")) {
			    Logging.log("sot---------->start of note---------->");
			    billRefresh = "";
			    billTotal = 0;
			    if (session.getAttribute("billRefresh") != null) {
				session.setAttribute("billRefresh", "");
			    }
			    if (session.getAttribute("billTotal") != null) {
				session.setAttribute("billTotal", "");
			    }
			    Logging.log("------------------------------------>");
			} // if (input.equalsIgnoreCase("sot"))
		    }

		    if (input != null && input.trim().length() > 0) {
			// Logging.log("000.input->" + input);
			input = input.replaceAll("sot", "");
			input = input.replaceAll("sum", "");
			input = (input.replaceAll("\\r\\n", "")).trim();
			// Logging.log("00.input->" + input);

			String[] lines = input.split("#"); // Split the input string into an array of lines
			for (String line : lines) {
			    loop = loop + 1;
			    // Logging.log(" 1.input->" + input);
			    String numberString = line.replace(".00", ""); // Remove ".00" character
			    int intBillRefresh = 0;
			    billRefresh = numberString;
			    try {
				intBillRefresh = Integer.parseInt(billRefresh);
			    } catch (Exception ex) {
				Logging.log("SILENT PRINTING for Integer.parseInt(billRefresh): " + ex.toString());
				intBillRefresh = 0;
			    }

			    // Logging.log(" 2.input->" + billRefresh);
			    if ((billRefresh.length() > 1) && (intBillRefresh > 1)) {
				// old code
				// billTotal = billTotal + Integer.parseInt(billRefresh);

				// new code
				billTotal = intBillRefresh;

				session.setAttribute("billRefresh", billRefresh);
				session.setAttribute("billTotal", billTotal);

				hashValue.put("billRefresh", billRefresh);
				hashValue.put("billTotal", billTotal);

				Logging.log(loop + ".a==>inserted->" + billRefresh + "(session:"
					+ session.getAttribute("billRefresh") + ")");
				Logging.log("     .b===>total->" + billTotal + "(session:"
					+ session.getAttribute("billTotal") + ")");
				Logging.log("------------------------------------>");

			    } // if ((billRefresh.length() > 1) && (Integer.parseInt(billRefresh) > 1))
			} // for (String line : lines)

		    } // if(input!=null && input.trim().length()>0)
		} catch (Exception ee) {
		    Logging.log("3.5.b.SILENT EXCEPTION :" + ee.toString());
		    stopRequested = true;
		    running = false;
		    techmessage = "fail";

		    Logging.log(
			    "SILENT EXCETPTION will happen after click stop button as will try intercept existing loop and close :stopRequested->"
				    + stopRequested + ":running->" + running + ":billTotal->" + billTotal);
		} // end of try
	    } // while
	    running = false;
	    if (serialPort.isOpen()) {
		serialPort.closePort();
		Logging.log("3.6.b.serial port is open so closing");
	    }
	    // Logging.log("3.7.c.EXIT run() ------>stopRequested->" + stopRequested +
	    // ":running->" + running
	    // + ":billTotal->" + billTotal);
	} // run()

	public Hashtable getBillResult() {
	    return hashValue;
	}

	public boolean isRunning() {
	    return running;
	}

	public void requestStop() throws Exception {
	    stopRequested = true;

	    Logging.log(
		    "==================> eot END OF TRANSACTION (by JAVA as STOP pressed by user) ==================>");
	    String textToStop = "eot\n";
	    byte[] newDataStop = textToStop.getBytes();
	    serialPort.writeBytes(newDataStop, newDataStop.length);
	    Logging.log("==================> need to verify eot in bill_acceptor ==================>");
	    Logging.log("------------------------------------>");

	    /*
	     * // Wait for the port to be ready try { Thread.sleep(2000);
	     * Logging.log("sleep if needed"); } catch (Exception e) { e.printStackTrace();
	     * }
	     * 
	     * byte[] readStopBuffer = new byte[1024]; int numStopBytes =
	     * serialPort.readBytes(readStopBuffer, readStopBuffer.length); String inputStop
	     * = new String(readStopBuffer, 0, numStopBytes);
	     * 
	     * Logging.log("1.stop.input->" + inputStop); if (inputStop.contains("sum")) {
	     * inputStop = inputStop.replaceAll("sum", ""); inputStop =
	     * inputStop.replaceAll(".00#", ""); Logging.log("found sum .00$eon->replaced->"
	     * + inputStop); billTotal = Integer.parseInt(inputStop);
	     * Logging.log("BILLTOTAL -> final value->" + billTotal); }
	     * Logging.log("------------------------------------>");
	     */
	} // requestStop()

	public void requestKill() {
	    Logging.log("c.requestKill.called");
	    stopRequested = true;
	    running = false;
	    if (session.getAttribute("billRefresh") != null) {
		session.setAttribute("billRefresh", "");
	    }
	    if (session.getAttribute("billTotal") != null) {
		session.setAttribute("billTotal", "");
	    }
	    hashValue.put("billRefresh", "");
	    hashValue.put("billTotal", "");
	    billTotal = 0;
	    billRefresh = "";
	    if (serialPort.isOpen()) {
		serialPort.closePort();
		Logging.log("c.requestKill.serial port is open so closing");
	    }
	}
    } // Runnable
}// BillAcceptorServlet
