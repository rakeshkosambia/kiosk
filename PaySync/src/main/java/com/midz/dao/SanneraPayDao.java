package com.midz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.midz.bean.SanneraBill;
import com.midz.bean.SanneraPay;
import com.midz.util.HandledException;

public class SanneraPayDao {
	private static String DATABASE_EXCEPTION = "DATABASE_EXCEPTION";

	public static int save(SanneraPay pay) throws HandledException, SQLException {
		int status=0, offsetConstant=0;
		float paidAmount=0,billCharged=0,count=0;
		float moveablePaidAmount=0,moveableBillCharged=0,previousPayExtra=0;
		Connection con = null;
		PreparedStatement ps=null,ps1=null,ps2=null,ps3=null,ps4=null,ps5=null;
		ResultSet rs1=null,rs2=null,rs5=null;
		SanneraBill bill=null;
		int returnPayId = 0;     //receipt ++				 
		try{
			//java.util.Date utilBillDate = new java.util.Date();
			//utilBillDate = pay.getBillDate();
			//java.sql.Date sqlBillDate = new java.sql.Date(utilBillDate.getTime());
			con=SanneraDBDao.getConnection();
			con.setAutoCommit(false);
			ps=con.prepareStatement("insert INTO t_payment(user_id, paid_amount, "
					              + "offset_status, offset_amount, offset_pending_amount, "
					              + "createdby, updatedby) "
			                      + "values (?,?,?,?,?,?,?) ");	
			paidAmount=pay.getPaidAmount();
			ps.setInt(1,pay.getUserId());
			ps.setFloat(2,paidAmount);
			ps.setInt(3,0);
			ps.setFloat(4,0);
			ps.setFloat(5,0);
			ps.setInt(6,pay.getCreatedBy());
			ps.setInt(7,pay.getUpdatedBy());
			status=ps.executeUpdate();
			// Offset Logic for t_bill table
			//******************************
				// Getting the pay_id auto incremented
				ps1=con.prepareStatement("SELECT LAST_INSERT_ID() pay_id");
				rs1=ps1.executeQuery();
				while(rs1.next()) {
					// pay.setPayId(rs1.getInt("pay_id"));   // receipt comment
					returnPayId = rs1.getInt("pay_id");      // receipt ++
					pay.setPayId(returnPayId);               // receipt ++
				}
				if(rs1 != null) {rs1.close();}
				if(ps1 != null) {ps1.close();}
				// Getting the getOffsetPendAmount from previous pending bill
				ps5=con.prepareStatement("select a.offset_pending_amount from t_payment a where a.user_id = ? and a.offset_status = 2");
				ps5.setInt(1,pay.getUserId());
				rs5=ps5.executeQuery();
				while(rs5.next()) {
					pay.setOffsetPendAmount(rs5.getFloat("offset_pending_amount"));
				}
				if(rs5 != null) {rs5.close();}
				if(ps5 != null) {ps5.close();}
			    // Getting Bill record to OFFSET
				ps2=con.prepareStatement(" select a.bill_date, a.amount, a.bill_id, a.pay_id, "
						               + " a.pay_offset_amount, a.pay_offset_pending_amount, a.pay_offset_status "
						               + " from t_bill a where a.user_id = ? and a.pay_offset_status = 0 "
						               + " order by a.bill_id asc ");
			    ps2.setInt(1,pay.getUserId());
			    rs2=ps2.executeQuery();
			    
			    billCharged=0;
			    count=0;			  
			    moveablePaidAmount=0;
			    moveableBillCharged=0;
			    previousPayExtra=0;
			    
			    //previousPayExtra
			    previousPayExtra = pay.getOffsetPendAmount();
		    	//moveablePaidAmount
		    	moveablePaidAmount = paidAmount+previousPayExtra;
        System.out.println("Initial:billCharged:"+billCharged+":paidAmount:"+paidAmount);
			    while(rs2.next()){
			    	count=count+1;
			    	//billCharged
			    	billCharged = rs2.getFloat("amount");
					if (moveablePaidAmount >= billCharged) { // iterate till there is sufficient paid Amount + paid Extra to pay bill
						//moveableBillCharged
				    	moveableBillCharged = moveableBillCharged + billCharged;
		System.out.println(count+".billCharged:"+billCharged+":paidAmount:"+paidAmount);
		System.out.println(count+".moveableBillCharged:"+moveableBillCharged+":moveablePaidAmount:"+moveablePaidAmount);				
						bill=new SanneraBill();
						bill.setPayId(pay.getPayId()); // Setting Bill Object
						if (pay.getPayOffsetPendId() != 0) {
							bill.setPayOffsetPendId(pay.getPayOffsetPendId());
						}
						bill.setBillId(rs2.getInt("bill_id"));
						bill.setPayOffsetAmount(billCharged);
						bill.setPayOffsetStatus(1);
						if (moveablePaidAmount > billCharged) {
							bill.setPayOffsetPendAmount(moveablePaidAmount-billCharged);
						} else {
							bill.setPayOffsetPendAmount(0);
						}
						ps3=con.prepareStatement(" update t_bill set pay_id=?, pay_offset_pending_id=?, "
								               + " pay_offset_amount=?, pay_offset_pending_amount=?, "
								               + " pay_offset_status=? where bill_id=? ");
						ps3.setInt(1,bill.getPayId());
						ps3.setInt(2,bill.getPayOffsetPendId());
						ps3.setFloat(3,bill.getPayOffsetAmount());
						ps3.setFloat(4,bill.getPayOffsetPendAmount());
						ps3.setInt(5,bill.getPayOffsetStatus());
						ps3.setInt(6,bill.getBillId());
						status=ps3.executeUpdate();
						if(ps3 != null) {ps3.close();}						
		System.out.println("Summary.billCharged:"+billCharged+":paidAmount:"+paidAmount);		
		System.out.println("Summary.moveableBillCharged:"+moveableBillCharged+":moveablePaidAmount:"+moveablePaidAmount);		
				    	// Re-assign the variables for next round
						moveablePaidAmount = moveablePaidAmount - billCharged;
					} // end of if			
			    	else {
			    		break;
			    	}
				} // while rs2
			    // updating t_payment
		    	ps4=con.prepareStatement(" update t_payment a set a.offset_pending_amount=?, "
    		                           + " a.offset_amount=?, a.offset_status=? where a.pay_id=? ");	
		    	if ((paidAmount+previousPayExtra) > moveableBillCharged) {
		    		ps4.setFloat(1,((paidAmount+previousPayExtra)-moveableBillCharged));
				} else {
					ps4.setFloat(1,0);
				}
				ps4.setFloat(2,moveableBillCharged);
				if ((paidAmount+previousPayExtra)-moveableBillCharged > 0) {
					offsetConstant = 2;
				} else {
					offsetConstant = 1;
				}
				ps4.setInt(3,offsetConstant);
				ps4.setInt(4, pay.getPayId());
				status=ps4.executeUpdate();
		    	if(ps4 != null) {ps4.close();}
		    	
			    if(rs2 != null) {rs2.close();}
				if(ps2 != null) {ps2.close();}
				con.commit();
				con.setAutoCommit(true);
				if(status>0) {                 // receipt ++
					status = returnPayId;      // receipt ++
				}		  
			//******************************
			if(ps5 != null) {ps5.close();}	
			if(rs5 != null) {rs5.close();}	
			if(ps4 != null) {ps4.close();}	
			if(rs2 != null) {rs2.close();}
			if(ps2 != null) {ps2.close();}
			if(rs1 != null) {rs1.close();}
			if(ps1 != null) {ps1.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		} catch (Exception e){
			   System.out.println(e);
			   con.rollback();
			   if(ps4 != null) {ps4.close();}	
			   if(ps3 != null) {ps3.close();}
			   if(rs2 != null) {rs2.close();}
			   if(ps2 != null) {ps2.close();}
			   if(rs1 != null) {rs1.close();}
			   if(ps1 != null) {ps1.close();}
			   if(ps != null) {ps.close();}
			   if(con != null) {con.close();}
			   throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
			}
		return status;
	}	
	
	public static List<SanneraPay> getAllRecordsUserId(int userid) throws HandledException, SQLException {
		List<SanneraPay> list=new ArrayList<SanneraPay>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement("select a.pay_id, b.name, a.user_id, a.paid_date, a.paid_amount, a.offset_status, c.offset_display, "
		                           +"a.offset_amount, a.offset_pending_amount, a.createdby, a.createdon, a.updatedon, a.updatedby  "
		                           +"from t_payment a, t_user b,  t_offset c "
				+ "where a.user_id = b.id and a.offset_status = c.offset_status and a.user_id=? order by a.pay_id desc");
			ps.setInt(1,userid);
			rs=ps.executeQuery();
			while(rs.next()){
				SanneraPay u=new SanneraPay();
				u.setPayId(rs.getInt("pay_id"));
				u.setName(rs.getString("name"));
				u.setUserId(rs.getInt("user_id"));
				u.setPaidDate(rs.getDate("paid_date"));
				u.setPaidAmount(rs.getFloat("paid_amount"));
				u.setOffsetStatus(rs.getInt("offset_status"));
				u.setOffsetDisplay(rs.getString("offset_display"));
				u.setOffsetAmount(rs.getFloat("offset_amount"));
				u.setOffsetPendAmount(rs.getFloat("offset_pending_amount"));
				u.setCreatedOn(rs.getDate("createdon"));
				u.setCreatedBy(rs.getInt("createdby"));
				u.setUpdatedOn(rs.getDate("updatedon"));
				u.setUpdatedBy(rs.getInt("updatedby"));
				list.add(u);
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		}catch(Exception e) {
			System.out.println(e);
			con.rollback();
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return list;
	}	
	
	public static SanneraPay getRecordById(int userid) throws HandledException, SQLException {
		SanneraPay b=null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement(" select a.pay_id, a.offset_pending_amount from t_payment a where a.user_id = ? and a.offset_status = 2 ");
			ps.setInt(1,userid);
			rs=ps.executeQuery();
			while(rs.next()){
				b=new SanneraPay();
				b.setOffsetPendAmount(rs.getFloat("offset_pending_amount"));
				b.setPayOffsetPendId(rs.getInt("pay_id"));
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return b;
	}
	
	// receipt ++
	public static SanneraPay getRecordByPayId(int payid) throws HandledException, SQLException {
		SanneraPay b=null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps = con.prepareStatement(
				" select a.pay_id, date_format(a.paid_date, '%b %Y') show_date, a.paid_amount from t_payment a where a.pay_id = ?");
			ps.setInt(1,payid);
			rs=ps.executeQuery();
			while(rs.next()){
				b=new SanneraPay();
				b.setShowDate(rs.getString("show_date"));	
				b.setPaidAmount(rs.getFloat("paid_amount"));
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return b;
	}
	
	public static List<SanneraPay> getAllRecordsPayment() throws HandledException, SQLException {
		List<SanneraPay> list=new ArrayList<SanneraPay>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			con=SanneraDBDao.getConnection();
			ps = con.prepareStatement(
				"select a.user_id, b.name, concat('Phase', b.phase, ', ', 'Block', b.block, ' #', 'Lot', b.lot) address, "
					+ "	                sum(a.paid_amount) paid_amount, "
					+ "                     concat(MONTHNAME(a.paid_date), ' ', YEAR(a.paid_date)) paid_month, "
					+ "                     a.offset_status, c.offset_display "
					+ "                from t_payment a, t_user b, t_offset c "
					+ "               where a.user_id = b.id and a.offset_status in (1,2)  and c.offset_status = a.offset_status "
					+ "            group by a.user_id, b.name, concat('Phase', b.phase, ', ', 'Block', b.block, ' #', 'Lot', b.lot), "
					+ "	                a.paid_amount, concat(MONTHNAME(a.paid_date), ' ', YEAR(a.paid_date)), "
					+ "                     a.offset_status, c.offset_display ");
			rs=ps.executeQuery();
			while(rs.next()){
				SanneraPay u=new SanneraPay();
				u.setUserId(rs.getInt("user_id"));
				u.setName(rs.getString("name"));
				u.setAddress(rs.getString("address"));
				u.setPaidAmount(rs.getFloat("paid_amount"));
				u.setPaidMonthYear(rs.getString("paid_month"));
				u.setOffsetStatus(rs.getInt("offset_status"));
				u.setOffsetDisplay(rs.getString("offset_display"));
				list.add(u);
			}
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		}catch(Exception e){
			System.out.println(e);
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
			throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
		}
		return list;
	}
/*	
	public static int update(SanneraBill u) throws HandledException, SQLException {
		int status=0;
		Connection con = null;
		PreparedStatement ps = null;
		try{
			java.util.Date utilBillDate = new java.util.Date();
			utilBillDate = u.getBillDate();
			java.sql.Date sqlBillDate = new java.sql.Date(utilBillDate.getTime());
			
			con=SanneraDBDao.getConnection();
			ps=con.prepareStatement("update t_bill set amount=?, bill_date=? "
					               +"where bill_id=? ");
			ps.setFloat(1,u.getAmount());
			ps.setDate(2,sqlBillDate);
			ps.setInt(3,u.getBillId());
			status=ps.executeUpdate();
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
			ps=con.prepareStatement("delete from t_bill where bill_id=?");
			ps.setInt(1,u.getBillId());
			status=ps.executeUpdate();
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
	*/
	
}
