package com.midz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.midz.bean.SanneraBill;
import com.midz.util.HandledException;

public class SanneraBillDao {
	private static String DATABASE_EXCEPTION = "DATABASE_EXCEPTION";

	public static SanneraBill getRecordByBillId(int bill_id) throws HandledException, SQLException {
		SanneraBill b=null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement(" select bill_id, user_id, name, bill_date, amount, date_format(bill_date, '%Y-%m-%d') duration from t_bill, t_user "
			   					   +" where user_id = id and bill_id = ? ");
			ps.setInt(1,bill_id);
			rs=ps.executeQuery();
			while(rs.next()){
				b=new SanneraBill();
				b.setBillId(rs.getInt("bill_id"));
				b.setUserId(rs.getInt("user_id"));
				b.setName(rs.getString("name"));
				b.setDuration(rs.getString("bill_date"));
				b.setAmount(rs.getFloat("amount"));
				b.setDuration(rs.getString("duration"));
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return b;
	}
	
	public static int save(SanneraBill bill) throws HandledException, SQLException {
		int status=0;
		Connection con = null;
		PreparedStatement ps = null;
		try{
			java.util.Date utilBillDate = new java.util.Date();
			utilBillDate = bill.getBillDate();
			java.sql.Date sqlBillDate = new java.sql.Date(utilBillDate.getTime());
			
			con=SanneraDBDao.getConnection();
			con.setAutoCommit(false);

			ps=con.prepareStatement("insert INTO t_bill(user_id, bill_date, amount, "
					              + "pay_offset_status, pay_offset_pending_amount, pay_offset_amount, "
					              + "createdby, updatedby) "
			                      + "values (?,?,?,?,?,?,?,?) ");	
			ps.setInt(1,bill.getUserId());
			ps.setDate(2,sqlBillDate);
			ps.setFloat(3,bill.getAmount());
			ps.setInt(4,0);
			ps.setFloat(5,0);
			ps.setFloat(6,0);
			ps.setInt(7,bill.getCreatedBy());
			ps.setInt(8,bill.getUpdatedBy());
			status=ps.executeUpdate();
			con.commit();
			con.setAutoCommit(true);
			
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e){
			   System.out.println(e);
			   if(ps != null) {ps.close();}
			   if(ps != null) {con.close();}
			   throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
			}
		return status;
	}	
	
	public static int saveAll(SanneraBill bill) throws HandledException, SQLException {
	    int status = 0;
	    Connection con = null;
	    PreparedStatement ps = null;
	    try {
		java.util.Date utilBillDate = new java.util.Date();
		utilBillDate = bill.getBillDate();
		java.sql.Date sqlBillDate = new java.sql.Date(utilBillDate.getTime());

		con = SanneraDBDao.getConnection();
		con.setAutoCommit(false);

		ps = con.prepareStatement(
			"insert INTO t_bill (user_id, bill_date, amount, pay_offset_status, pay_offset_pending_amount, pay_offset_amount, createdby, updatedby) "
				+ " select id, ?, ?, ?, ?, ?, ?, ? from t_user where role = 'user' ");

		ps.setDate(1, sqlBillDate);
		ps.setFloat(2, bill.getAmount());
		ps.setInt(3, 0);
		ps.setFloat(4, 0);
		ps.setFloat(5, 0);
		ps.setInt(6, bill.getCreatedBy());
		ps.setInt(7, bill.getUpdatedBy());
		status = ps.executeUpdate();
		con.commit();
		con.setAutoCommit(true);

		if (ps != null) {
		    ps.close();
		}
		if (ps != null) {
		    con.close();
		}
	    } catch (Exception e) {
		System.out.println(e);
		if (ps != null) {
		    ps.close();
		}
		if (ps != null) {
		    con.close();
		}
		throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	    }
	    return status;
	}

	public static int update(SanneraBill u) throws HandledException, SQLException {
		int status=0;
		Connection con = null;
		PreparedStatement ps = null;
		try{
			java.util.Date utilBillDate = new java.util.Date();
			utilBillDate = u.getBillDate();
			java.sql.Date sqlBillDate = new java.sql.Date(utilBillDate.getTime());
			
			con=SanneraDBDao.getConnection();
			con.setAutoCommit(false);
			
			ps=con.prepareStatement("update t_bill set amount=?, bill_date=? "
					               +"where bill_id=? ");
			ps.setFloat(1,u.getAmount());
			ps.setDate(2,sqlBillDate);
			ps.setInt(3,u.getBillId());
			status=ps.executeUpdate();
			con.commit();
			con.setAutoCommit(true);
			
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
			}
		return status;
	}

	public static int delete(SanneraBill u) throws HandledException, SQLException {
		int status=0;
		Connection con = null;
		PreparedStatement ps = null;
		try{
			con=SanneraDBDao.getConnection();
			con.setAutoCommit(false);

			ps=con.prepareStatement("delete from t_bill where bill_id=?");
			ps.setInt(1,u.getBillId());
			status=ps.executeUpdate();
			con.commit();
			con.setAutoCommit(true);

			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
			}
		return status;
	}	
	
	public static List<SanneraBill> getAllRecords() throws HandledException, SQLException {
		List<SanneraBill> list=new ArrayList<SanneraBill>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement("select a.bill_id, b.name, a.user_id, a.bill_date, a.amount, a.createdby, a.createdon, a.updatedon, a.updatedby "
					              + "from t_bill a, t_user b where a.user_id = b.id ");
			rs=ps.executeQuery();
			while(rs.next()){
				SanneraBill u=new SanneraBill();
				u.setBillId(rs.getInt("bill_id"));
				u.setUserId(rs.getInt("user_id"));
				u.setName(rs.getString("name"));
				u.setBillDate(rs.getDate("bill_date"));
				u.setAmount(rs.getFloat("amount"));
				u.setCreatedOn(rs.getDate("createdon"));
				u.setCreatedBy(rs.getInt("createdby"));
				u.setUpdatedOn(rs.getDate("updatedon"));
				u.setUpdatedBy(rs.getInt("updatedby"));
				list.add(u);
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return list;
	}
	
	public static List<SanneraBill> getAllRecordsUserId(int userid) throws HandledException, SQLException {
		List<SanneraBill> list=new ArrayList<SanneraBill>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement("select a.bill_id, b.name, a.user_id, a.bill_date, a.amount, a.pay_id, c.offset_display, a.pay_offset_status, "
		                           +"a.pay_offset_amount, a.pay_offset_pending_amount, a.createdby, a.createdon, a.updatedon, a.updatedby "
		                           +"from t_bill a, t_user b,  t_offset c "
		                           +"where a.user_id = b.id and a.pay_offset_status = c.offset_status and a.user_id=? "); 
			//ps=con.prepareStatement("select a.bill_id, b.name, a.user_id, a.bill_date, a.amount, "
			//		              + "a.createdby, a.createdon, a.updatedon, a.updatedby "
			//		              + "from t_bill a, t_user b where a.user_id = b.id and a.user_id=? ");
			ps.setInt(1,userid);
			rs=ps.executeQuery();
			while(rs.next()){
				SanneraBill u=new SanneraBill();
				u.setBillId(rs.getInt("bill_id"));
				u.setUserId(rs.getInt("user_id"));
				u.setName(rs.getString("name"));
				u.setBillDate(rs.getDate("bill_date"));
				u.setAmount(rs.getFloat("amount"));
				u.setPayId(rs.getInt("pay_id"));
				u.setPayOffsetDisplay(rs.getString("offset_display"));
				u.setPayOffsetStatus(rs.getInt("pay_offset_status"));
				u.setPayOffsetAmount(rs.getFloat("pay_offset_amount"));
				u.setPayOffsetPendAmount(rs.getFloat("pay_offset_pending_amount"));
				u.setCreatedOn(rs.getDate("createdon"));
				u.setCreatedBy(rs.getInt("createdby"));
				u.setUpdatedOn(rs.getDate("updatedon"));
				u.setUpdatedBy(rs.getInt("updatedby"));
				list.add(u);
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
		}catch(Exception e) {
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(ps != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return list;
	}	
	
	public static List<SanneraBill> getAllRecordsAllUsers() throws HandledException, SQLException {
	    List<SanneraBill> list = new ArrayList<SanneraBill>();
	    Connection con = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    try {
		con = SanneraDBDao.getConnection();
		ps = con.prepareStatement(
			"select a.bill_id, b.name, a.user_id, a.bill_date, a.amount, a.pay_id, c.offset_display, a.pay_offset_status, "
				+ "a.pay_offset_amount, a.pay_offset_pending_amount, a.createdby, a.createdon, a.updatedon, a.updatedby "
				+ "from t_bill a, t_user b,  t_offset c "
				+ "where a.user_id = b.id and a.pay_offset_status = c.offset_status and a.pay_offset_status = 0 ");
		// ps=con.prepareStatement("select a.bill_id, b.name, a.user_id, a.bill_date,
		// a.amount, "
		// + "a.createdby, a.createdon, a.updatedon, a.updatedby "
		// + "from t_bill a, t_user b where a.user_id = b.id and a.user_id=? ");
		rs = ps.executeQuery();
		while (rs.next()) {
		    SanneraBill u = new SanneraBill();
		    u.setBillId(rs.getInt("bill_id"));
		    u.setUserId(rs.getInt("user_id"));
		    u.setName(rs.getString("name"));
		    u.setBillDate(rs.getDate("bill_date"));
		    u.setAmount(rs.getFloat("amount"));
		    u.setPayId(rs.getInt("pay_id"));
		    u.setPayOffsetDisplay(rs.getString("offset_display"));
		    u.setPayOffsetStatus(rs.getInt("pay_offset_status"));
		    u.setPayOffsetAmount(rs.getFloat("pay_offset_amount"));
		    u.setPayOffsetPendAmount(rs.getFloat("pay_offset_pending_amount"));
		    u.setCreatedOn(rs.getDate("createdon"));
		    u.setCreatedBy(rs.getInt("createdby"));
		    u.setUpdatedOn(rs.getDate("updatedon"));
		    u.setUpdatedBy(rs.getInt("updatedby"));
		    list.add(u);
		}
		if (rs != null) {
		    rs.close();
		}
		if (ps != null) {
		    ps.close();
		}
		if (ps != null) {
		    con.close();
		}
	    } catch (Exception e) {
		System.out.println(e);
		if (rs != null) {
		    rs.close();
		}
		if (ps != null) {
		    ps.close();
		}
		if (ps != null) {
		    con.close();
		}
		throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	    }
	    return list;
	}
	
}
