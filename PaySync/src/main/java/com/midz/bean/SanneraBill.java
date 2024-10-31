package com.midz.bean;
import java.util.Date;

public class SanneraBill {
	
private int billid,userid,createdby,updatedby,payid,payoffsetstatus,payoffsetPendid;
private String duration,name,payoffsetdispay;
private float amount,payoffsetamount,payoffsetpendamount;
private Date billdate,updatedon,createdon;

public int getBillId() {
	return billid;
}
public void setBillId(int billid) {
	this.billid = billid;
}
public int getUserId() {
	return userid;
}
public void setUserId(int userid) {
	this.userid = userid;
}
public String getName() {
	return name; 
}
public void setName(String name) {
	this.name = name;
}
public String getDuration() {
	return duration; 
}
public void setDuration(String duration) {
	this.duration = duration;
}
public Date getBillDate() {
	return billdate; 
}
public void setBillDate(Date billdate) {
	this.billdate = billdate;
}
public float getAmount() {
	return amount;
}
public void setAmount(float amount) {
	this.amount = amount;
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
public int getPayId() {
	return payid;
}
public void setPayId(int payid) {
	this.payid = payid;
}
public int getPayOffsetPendId() {
	return payoffsetPendid;
}
public void setPayOffsetPendId(int payoffsetPendid) {
	this.payoffsetPendid = payoffsetPendid;
}
public int getPayOffsetStatus() {
	return payoffsetstatus;
}
public void setPayOffsetStatus(int payoffsetstatus) {
	this.payoffsetstatus = payoffsetstatus;
}
public String getPayOffsetDisplay() {
	return payoffsetdispay;
}
public void setPayOffsetDisplay(String payoffsetdispay) {
	this.payoffsetdispay = payoffsetdispay;
}
public Float getPayOffsetAmount() {
	return payoffsetamount;
}
public void setPayOffsetAmount(float f) {
	this.payoffsetamount = f;
}
public Float getPayOffsetPendAmount() {
	return payoffsetpendamount;
}
public void setPayOffsetPendAmount(float payoffsetpendamount) {
	this.payoffsetpendamount = payoffsetpendamount;
}

}
