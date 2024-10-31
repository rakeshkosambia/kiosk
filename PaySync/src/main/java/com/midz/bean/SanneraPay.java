package com.midz.bean;
import java.util.Date;

public class SanneraPay {
	
private int payid,userid,offsetstatus,createdby,updatedby,payOffsetPendId;
private float paidamount,offsetamount,offsetpendingamount;
private Date paiddate,updatedon,createdon;
private String offsetdispay,name,address,paidmonthyear,showdate;

public int getPayId() {
	return payid;
}
public void setPayId(int payid) {
	this.payid = payid;
}
public int getPayOffsetPendId() {
	return payOffsetPendId;
}
public void setPayOffsetPendId(int payOffsetPendId) {
	this.payOffsetPendId = payOffsetPendId;
}
public int getUserId() {
	return userid;
}
public void setUserId(int userid) {
	this.userid = userid;
}
public Date getPaidDate() {
	return paiddate; 
}
public void setPaidDate(Date paiddate) {
	this.paiddate = paiddate;
}
public float getPaidAmount() {
	return paidamount;
}
public void setPaidAmount(float paidamount) {
	this.paidamount = paidamount;
}
public int getOffsetStatus() {
	return offsetstatus;
}
public void setOffsetStatus(int offsetstatus) {
	this.offsetstatus = offsetstatus;
}
public float getOffsetAmount() {
	return offsetamount;
}
public void setOffsetAmount(float offsetamount) {
	this.offsetamount = offsetamount;
}
public float getOffsetPendAmount() {
	return offsetpendingamount;
}
public void setOffsetPendAmount(float offsetpendingamount) {
	this.offsetpendingamount = offsetpendingamount;
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
public String getOffsetDisplay() {
	return offsetdispay;
}
public void setOffsetDisplay(String offsetdispay) {
	this.offsetdispay = offsetdispay;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getAddress() {
	return address;
}
public void setAddress(String address) {
	this.address = address;
}
public String getPaidMonthYear() {
	return paidmonthyear;
}
public void setPaidMonthYear(String paidmonthyear) {
	this.paidmonthyear = paidmonthyear;
}
public String getShowDate() {
	return showdate; 
}
public void setShowDate(String showdate) {
	this.showdate = showdate;
}

}
