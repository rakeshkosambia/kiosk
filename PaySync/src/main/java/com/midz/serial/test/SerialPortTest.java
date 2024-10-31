package com.midz.serial.test;

import java.io.InputStream;
import java.io.OutputStream;

import com.fazecast.jSerialComm.SerialPort;

public class SerialPortTest {

    public static void main(String[] args) {
        // Get an instance of SerialPort for the port "COM3"
        SerialPort serialPort = SerialPort.getCommPort("COM7");

        // Set the communication parameters
        serialPort.setComPortParameters(9600, 8, 1, SerialPort.NO_PARITY);

        // Set the read and write timeouts
        serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 100, 0);

        // Open the port
        if (serialPort.openPort()) {
            System.out.println("Serial port successfully opened.");
        } else {
            System.err.println("Error: Could not open serial port.");
            //return;
        }

        // Optionally, configure the port further
         serialPort.setDTR();
         
        // Use the input and output streams to communicate with the device
         InputStream in = serialPort.getInputStream();
         OutputStream out = serialPort.getOutputStream();

        // Close the port when done
        serialPort.closePort();
        System.out.println("Serial port closed.");
    }

}
