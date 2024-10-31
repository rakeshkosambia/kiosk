package com.midz.bean;
import java.util.Date;

public class SanneraUser {
	
private int id,phase,block,lot,createdby,updatedby,loginattempt;
private String name, email, role, mobile, username, password, confirmpassword, errormsg, successmsg, active;
private Date createdon,updatedon;

public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public int getPhase() {
	return phase;
}
public void setPhase(int phase) {
	this.phase = phase;
}
public int getBlock() {
	return block;
}
public void setBlock(int block) {
	this.block = block;
}
public int getLot() {
	return lot;
}
public void setLot(int lot) {
	this.lot = lot;
}
public String getEmail() {
	return email;
}
public void setEmail(String email) {
	this.email = email;
}
public String getMobile() {
	return mobile;
}
public void setMobile(String mobile) {
	this.mobile = mobile;
}
public String getRole() {
	return role;
}
public void setRole(String role) {
	this.role = role;
}
public String getUsername() {
	return username;
}
public void setUsername(String username) {
	this.username = username;
}
public String getPassword() {
	return password;
}

public String getConfirmPassword() {
    return confirmpassword;
}
public void setPassword(String password) {
	this.password = password;
}

public void setConfirmPassword(String confirmpassword) {
    this.confirmpassword = confirmpassword;
}
public int getLoginAttempt() {
	return loginattempt;
}
public void setLoginAttempt(int loginattempt) {
	this.loginattempt = loginattempt;
}
public int getCreatedBy() {
	return createdby;
}
public void setCreatedBy(int createdby) {
	this.createdby = createdby;
}
public int getUpdatedBy() {
	return updatedby;
}
public void setUpdatedBy(int updatedby) {
	this.updatedby = updatedby;
}
public String getErrorMsg() {
	return errormsg;
}
public void setErrorMsg(String errormsg) {
	this.errormsg = errormsg;
}
public String getSuccessMsg() {
	return successmsg;
}
public void setSuccessMsg(String successmsg) {
	this.successmsg = successmsg;
}
public Date getUpdatedOn() {
	return updatedon;
}
public void setUpdatedOn(Date updatedon) {
	this.updatedon = updatedon;
}
public Date getCreatedOn() {
	return createdon;
}
public void setCreatedOn(Date createdon) {
	this.createdon = createdon;
}

public String getActive() {
    return active;
}

public void setActive(String active) {
    this.active = active;
}
}
