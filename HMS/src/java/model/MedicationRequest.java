package model;

import java.util.Date;
import java.util.List;

public class MedicationRequest {

    private int requestId;
    private int doctorId;
    private String status;
    private Date requestDate;
    private String notes;
    private String doctorName;
    private List<MedicationRequestItem> items;

    // Constructor mặc định (thêm để fix lỗi)
    public MedicationRequest() {
    }

    // Constructor đầy đủ (giữ nguyên)
    public MedicationRequest(int requestId, int doctorId, String status, Date requestDate, String notes, List<MedicationRequestItem> items) {
        this.requestId = requestId;
        this.doctorId = doctorId;
        this.status = status;
        this.requestDate = requestDate;
        this.notes = notes;
        this.items = items;
    }

    // Getters/Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<MedicationRequestItem> getItems() {
        return items;
    }

    public void setItems(List<MedicationRequestItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "MedicationRequest{" + "requestId=" + requestId + ", doctorId=" + doctorId + ", status=" + status + ", requestDate=" + requestDate + ", notes=" + notes + ", items=" + items + '}';
    }

 public String getDoctorName() {
    return doctorName;
}

public void setDoctorName(String doctorName) {
    this.doctorName = doctorName;
}
}
