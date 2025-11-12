package model;

import java.util.Date;
import java.util.List;

public class IssueSlip {
    private int slipId;
    private String slipCode;
    private int requestId;
    private int pharmacistId;
    private int doctorId;
    private Date createdDate;
    private String notes;
    private List<IssueSlipItem> items;

    // 🔹 Thêm tên bác sĩ và tên dược sĩ
    private String pharmacistName;
    private String doctorName;

    public IssueSlip() {}

    // Getter - Setter cơ bản
    public int getSlipId() { return slipId; }
    public void setSlipId(int slipId) { this.slipId = slipId; }

    public String getSlipCode() { return slipCode; }
    public void setSlipCode(String slipCode) { this.slipCode = slipCode; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getPharmacistId() { return pharmacistId; }
    public void setPharmacistId(int pharmacistId) { this.pharmacistId = pharmacistId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<IssueSlipItem> getItems() { return items; }
    public void setItems(List<IssueSlipItem> items) { this.items = items; }

    // 🔹 Getter & Setter cho tên
    public String getPharmacistName() { return pharmacistName; }
    public void setPharmacistName(String pharmacistName) { this.pharmacistName = pharmacistName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
}
