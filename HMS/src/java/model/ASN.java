package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class ASN {
    private int asnId;
    private int poId;
    private int supplierId;
    private LocalDate shipmentDate;
    private String carrier;
    private String trackingNumber;
    private String status;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Các trường mới cho workflow
    private String submittedBy;
    private String approvedBy;
    private LocalDateTime submittedAt;
    private LocalDateTime approvedAt;
    private String rejectionReason;

    // Constructors
    public ASN() {
    }

    public ASN(int asnId, int poId, int supplierId, LocalDate shipmentDate, 
               String carrier, String trackingNumber, String status, String notes,
               LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.asnId = asnId;
        this.poId = poId;
        this.supplierId = supplierId;
        this.shipmentDate = shipmentDate;
        this.carrier = carrier;
        this.trackingNumber = trackingNumber;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getAsnId() {
        return asnId;
    }

    public void setAsnId(int asnId) {
        this.asnId = asnId;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public LocalDate getShipmentDate() {
        return shipmentDate;
    }

    public void setShipmentDate(LocalDate shipmentDate) {
        this.shipmentDate = shipmentDate;
    }

    public String getCarrier() {
        return carrier;
    }

    public void setCarrier(String carrier) {
        this.carrier = carrier;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Getters and Setters cho các trường workflow
    public String getSubmittedBy() {
        return submittedBy;
    }

    public void setSubmittedBy(String submittedBy) {
        this.submittedBy = submittedBy;
    }

    public String getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(String approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    // Utility methods for status
    public boolean isDraft() {
        return "DRAFT".equalsIgnoreCase(status);
    }

    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(status) || "PENDING_APPROVAL".equalsIgnoreCase(status);
    }

    public boolean isApproved() {
        return "APPROVED".equalsIgnoreCase(status);
    }

    public boolean isShipped() {
        return "SHIPPED".equalsIgnoreCase(status);
    }

    public boolean isReceived() {
        return "RECEIVED".equalsIgnoreCase(status);
    }

    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(status);
    }

    // Business logic methods
    public boolean canBeSubmitted() {
        return isDraft();
    }

    public boolean canBeApproved() {
        return isPending();
    }

    public boolean canBeRejected() {
        return isPending();
    }


}