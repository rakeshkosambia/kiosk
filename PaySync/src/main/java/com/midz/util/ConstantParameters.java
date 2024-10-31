package com.midz.util;

public class ConstantParameters {
    private ConstantParameters() {
    }
    
    // Parameter changes due to KIOSK or Development Env
    public static final String ARDUINO_PORT_NAME = "COM6"; // port of computer usb for kiosk=COM6
    public static final String PRINT_SILENT_NORMAL = "SILENT"; // NORMAL or SILENT
	
    public static final int MINPAYMENT = 500;
    public static final int LOG_MODE = 1; // 1 for logging all info passed (applicable for development)
					  // 2 for not logging any info (applicable for live site)
    public static final int ARDUINO_BAUD_RATE = 9600; // baud rate

    public static final String start_1 = "(Technical Issue) Missing 'action' parameter";
    public static final String start_2 = "Please INSERT your payment NOW";// killed old session of others,
											// if old session of same then
											// no action
    public static final String start_3 = "Please INSERT your payment now";
    public static final String start_4 = "Please INSERT your payment now"; // "(Technical Issue) KIOSK not available";
    public static final String stop_1 = "(Technical Issue) KIOSK is not able to compute";
    public static final String success = "CASH inserted amount";
    public static final String total_bill = "CASH inserted amount";
    public static final String fail = "(Technical Issue) Action is not valid/IllegalState";
    public static final String reminder_submit = "Please click 'Submit'<br>after the payment";

    public static final String readQueryStringOrSession = "SESSION"; // SESSION or QUERYSTRING

    public static final String loginExpired = "Login expired. Please login again.";
    public static final String loginFirst = "Recommended to change password for First time login.";
    public static final String updatedPassword = "Password updated succesfully.";
}
