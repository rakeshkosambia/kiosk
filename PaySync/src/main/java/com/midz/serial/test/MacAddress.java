package com.midz.serial.test;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Arrays;

public class MacAddress {
    public static void main(String[] args) {
        try {
            InetAddress localhost = InetAddress.getLocalHost();
            NetworkInterface networkInterface = NetworkInterface.getByInetAddress(localhost);
            byte[] macAddressBytes = networkInterface.getHardwareAddress();
            if (macAddressBytes != null) {
                StringBuilder macAddressBuilder = new StringBuilder();
                for (int i = 0; i < macAddressBytes.length; i++) {
                    macAddressBuilder.append(String.format("%02X%s", macAddressBytes[i], (i < macAddressBytes.length - 1) ? "-" : ""));
                }
                String macAddress = macAddressBuilder.toString();
                System.out.println("MAC address of localhost: " + macAddress);
                System.out.println("----------");
            /*                  
            try {
                    byte[] macBytes = InetAddress.getByName(macAddress).getAddress();
                    System.out.println(Arrays.toString(macBytes));
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
            */
            //------------------------------------------------------
            String[] macParts = macAddress.split("-");
            byte[] macBytes = new byte[macParts.length];
            for (int i = 0; i < macParts.length; i++) {
                macBytes[i] = (byte) Integer.parseInt(macParts[i], 16);
            }
            System.out.println(Arrays.toString(macBytes));
            //------------------------------------------------------
            } else {
                System.out.println("Unable to retrieve MAC address");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

