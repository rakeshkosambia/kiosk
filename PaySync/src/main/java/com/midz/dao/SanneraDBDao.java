package com.midz.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class SanneraDBDao {
private static String DATABASE_EXCEPTION = "DATABASE_EXCEPTION";

public static Connection getConnection(){
	Connection con=null;	
	try{
		Class.forName("com.mysql.jdbc.Driver");
			//System.out.println("Driver successful");
		con=DriverManager.getConnection("jdbc:mysql://localhost:3306/sannera","midz","midz");
		
		if (!con.isClosed())
            System.out.println("Successfully connected to MySQL server using TCP/IP...");
        else 
        	System.out.println("Failed to connect to MySQL Server");
	}
	catch(Exception e){
		System.err.println("RK Exception: " + e.getMessage());
		System.out.println(e);
					  }
	return con;
}

}
