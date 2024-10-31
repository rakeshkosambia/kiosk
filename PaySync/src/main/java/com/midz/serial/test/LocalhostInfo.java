package com.midz.serial.test;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

public class LocalhostInfo {
    public static void main(String[] args) {
        try {
            // Get the IP address of the localhost
            InetAddress localhost = InetAddress.getLocalHost();
            System.out.println("IP address:  ("+localhost.getHostAddress().replace(".", ", ")+")");

            // Get the MAC address of the localhost
            NetworkInterface networkInterface = NetworkInterface.getByInetAddress(localhost);
            if (networkInterface != null) {
                byte[] macAddress = networkInterface.getHardwareAddress();
                if (macAddress != null) {
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < macAddress.length; i++) {
                        sb.append(String.format("%02X%s", macAddress[i], (i < macAddress.length - 1) ? ", 0x" : ""));
                    }
                    System.out.println("MAC address: { 0x"+sb.toString()+" }");
                }
            }
        } catch (UnknownHostException | SocketException e) {
            e.printStackTrace();
        }
    }
}
