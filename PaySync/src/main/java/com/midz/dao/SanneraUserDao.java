package com.midz.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.midz.bean.SanneraUser;
import com.midz.util.HandledException;

public class SanneraUserDao {
    private static String DATABASE_EXCEPTION = "DATABASE_EXCEPTION";

    public static int save(SanneraUser u, int createdbyUpdatedBy) throws HandledException, SQLException {
	int status = 0;
	Connection con = null;
	PreparedStatement ps = null;
	try {
	    con = SanneraDBDao.getConnection();
	    con.setAutoCommit(false);
	    ps = con.prepareStatement(
		    "insert INTO t_user(name, phase, block, lot, email, mobile, username, password, role, createdby, updatedby) "
			    + "values (?,?,?,?,?,?,?,?,?,?,?) ");

	    ps.setString(1, u.getName());
	    ps.setInt(2, u.getPhase());
	    ps.setInt(3, u.getBlock());
	    ps.setInt(4, u.getLot());
	    ps.setString(5, u.getEmail());
	    ps.setString(6, u.getMobile());
	    ps.setString(7, u.getUsername());
	    ps.setString(8, u.getPassword());
	    ps.setString(9, u.getRole());
	    ps.setInt(10, createdbyUpdatedBy);
	    ps.setInt(11, createdbyUpdatedBy);
	    status = ps.executeUpdate();
	    con.commit();
	    con.setAutoCommit(true);
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return status;
    }

    public static int update(SanneraUser u, int createdbyUpdatedBy) throws HandledException, SQLException {
	int status = 0;
	Connection con = null;
	PreparedStatement ps = null;
	try {
	    con = SanneraDBDao.getConnection();
	    con.setAutoCommit(false);

	    ps = con.prepareStatement("update t_user set name=?, phase=?, block=?, lot=?, email=?, "
		    + "mobile=?, role=?, username=?, password=?, createdby=?, active=? where id=? ");
	    ps.setString(1, u.getName());
	    ps.setInt(2, u.getPhase());
	    ps.setInt(3, u.getBlock());
	    ps.setInt(4, u.getLot());
	    ps.setString(5, u.getEmail());
	    ps.setString(6, u.getMobile());
	    ps.setString(7, u.getRole());
	    ps.setString(8, u.getUsername());
	    ps.setString(9, u.getPassword());
	    ps.setInt(10, createdbyUpdatedBy);
	    ps.setString(11, u.getActive());
	    ps.setInt(12, u.getId());
	    status = ps.executeUpdate();
	    con.commit();
	    con.setAutoCommit(true);

	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return status;
    }

    public static int updatePassword(SanneraUser u) throws HandledException, SQLException {
	int status = 0;
	Connection con = null;
	PreparedStatement ps = null;
	try {
	    con = SanneraDBDao.getConnection();
	    con.setAutoCommit(false);

	    ps = con.prepareStatement("update t_user set password=?, updatedby=? where id=? ");
	    ps.setString(1, u.getPassword());
	    ps.setInt(2, u.getId());
	    ps.setInt(3, u.getId());
	    status = ps.executeUpdate();
	    con.commit();
	    con.setAutoCommit(true);

	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return status;
    }

    public static int updateLoginAttempt(int loginid) throws HandledException, SQLException {
	int status = 0;
	Connection con = null;
	PreparedStatement ps = null;
	try {
	    con = SanneraDBDao.getConnection();
	    con.setAutoCommit(false);

	    ps = con.prepareStatement("update t_user set login_attempted = login_attempted+1 where id=? ");
	    ps.setInt(1, loginid);
	    status = ps.executeUpdate();
	    con.commit();
	    con.setAutoCommit(true);

	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return status;
    }

    public static int delete(SanneraUser u) throws HandledException, SQLException {
	int status = 0;
	Connection con = null;
	PreparedStatement ps1, ps2, ps3 = null;
	try {
	    con = SanneraDBDao.getConnection();
	    con.setAutoCommit(false);

	    // ps1=con.prepareStatement("delete from t_payment where user_id=?");
	    // ps1.setInt(1,u.getId());
	    // status=ps1.executeUpdate();

	    // ps2=con.prepareStatement("delete from t_bill where user_id=?");
	    // ps2.setInt(1,u.getId());
	    // status=ps2.executeUpdate();

	    ps3 = con.prepareStatement("update t_user set active = 'N' where id=?");
	    ps3.setInt(1, u.getId());
	    status = ps3.executeUpdate();

	    con.commit();
	    con.setAutoCommit(true);

	    // if(ps1 != null) {ps1.close();}
	    // if(ps2 != null) {ps2.close();}
	    if (ps3 != null) {
		ps3.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return status;
    }

    public static List<SanneraUser> getAllRecords() throws HandledException, SQLException {
	List<SanneraUser> list = new ArrayList<SanneraUser>();
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
	    con = SanneraDBDao.getConnection();

	    ps = con.prepareStatement("select id, name, phase, block, lot, email, mobile, role, username, "
		    + "password, createdon, createdby, updatedon, updatedby, login_attempted, active from t_user");
	    rs = ps.executeQuery();
	    while (rs.next()) {
		SanneraUser u = new SanneraUser();
		u.setId(rs.getInt("id"));
		u.setName(rs.getString("name"));
		u.setPhase(rs.getInt("phase"));
		u.setBlock(rs.getInt("block"));
		u.setLot(rs.getInt("lot"));
		u.setEmail(rs.getString("email"));
		u.setMobile(rs.getString("mobile"));
		u.setRole(rs.getString("role"));
		u.setUsername(rs.getString("username"));
		u.setPassword(rs.getString("password"));
		u.setCreatedOn(rs.getDate("createdon"));
		u.setCreatedBy(rs.getInt("createdby"));
		u.setUpdatedOn(rs.getDate("updatedon"));
		u.setUpdatedBy(rs.getInt("updatedby"));
		u.setLoginAttempt(rs.getInt("login_attempted"));
		u.setActive(rs.getString("active"));
		;
		list.add(u);
	    }
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return list;
    }

    public static SanneraUser getRecordById(int id) throws HandledException, SQLException {
	SanneraUser u = null;
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
	    con = SanneraDBDao.getConnection();
	    ps = con.prepareStatement(
		    "select id, name, phase, block, lot, email, mobile, upper(role) role, username, password, login_attempted, active from t_user where id=?");
	    ps.setInt(1, id);
	    rs = ps.executeQuery();
	    while (rs.next()) {
		u = new SanneraUser();
		u.setId(rs.getInt("id"));
		u.setName(rs.getString("name"));
		u.setPhase(rs.getInt("phase"));
		u.setBlock(rs.getInt("block"));
		u.setLot(rs.getInt("lot"));
		u.setEmail(rs.getString("email"));
		u.setMobile(rs.getString("mobile"));
		u.setRole(rs.getString("role"));
		u.setUsername(rs.getString("username"));
		u.setPassword(rs.getString("password"));
		u.setLoginAttempt(rs.getInt("login_attempted"));
		u.setActive(rs.getString("active"));
	    }
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return u;
    }

    public static List<SanneraUser> getLoginVerification(SanneraUser ui) throws HandledException, SQLException {
	List<SanneraUser> list = new ArrayList<SanneraUser>();
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
	    con = SanneraDBDao.getConnection();
	    ps = con.prepareStatement("select id, name, phase, block, lot, email, mobile, role, username, "
		    + "password, createdon, createdby, updatedon, updatedby, login_attempted from t_user "
		    + "where username = ? and password = ? and role = ? and active = 'Y' ");
	    ps.setString(1, ui.getUsername());
	    ps.setString(2, ui.getPassword());
	    ps.setString(3, ui.getRole());

	    rs = ps.executeQuery();
	    while (rs.next()) {
		SanneraUser u = new SanneraUser();
		u.setId(rs.getInt("id"));
		u.setName(rs.getString("name"));
		u.setPhase(rs.getInt("phase"));
		u.setBlock(rs.getInt("block"));
		u.setLot(rs.getInt("lot"));
		u.setEmail(rs.getString("email"));
		u.setMobile(rs.getString("mobile"));
		u.setRole(rs.getString("role"));
		u.setUsername(rs.getString("username"));
		u.setPassword(rs.getString("password"));
		u.setCreatedOn(rs.getDate("createdon"));
		u.setCreatedBy(rs.getInt("createdby"));
		u.setUpdatedOn(rs.getDate("updatedon"));
		u.setUpdatedBy(rs.getInt("updatedby"));
		list.add(u);

		// update login attempted
		updateLoginAttempt(rs.getInt("id"));
	    }
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	} catch (Exception e) {
	    System.out.println(e);
	    con.rollback();
	    if (rs != null) {
		rs.close();
	    }
	    if (ps != null) {
		ps.close();
	    }
	    if (con != null) {
		con.close();
	    }
	    throw new HandledException(DATABASE_EXCEPTION, e.getMessage(), e);
	}
	return list;
    }

}
