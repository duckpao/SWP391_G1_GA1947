package model;

import java.sql.Date;

/**
 * Model cho bảng Batches
 *
 * QUAN TRỌNG:
 * - batchQuantity: Số lượng thực tế của riêng lô này (không đổi sau khi tạo)
 * - currentQuantity: Tổng số lượng còn lại của TẤT CẢ các lô cùng medicine_code
 *   có status = 'Approved' (tự động tính bởi trigger DB)
 * - initialQuantity: Số lượng ban đầu khi nhập kho (để tracking lịch sử)
 */
public class Batches {

    // Core fields từ DB
    private int batchId;
    private String medicineCode;
    private int supplierId;
    private String lotNumber;
    private Date expiryDate;
    private Date receivedDate;
    private int initialQuantity;     // Số lượng nhập ban đầu (lịch sử)
    private int batchQuantity;       // Số lượng thực tế của lô này (không đổi)
    private int currentQuantity;     // Tổng tồn thuốc (trigger DB)
    private String status;           // Quarantined, Received, Approved, Rejected, Expired
    private String quarantineNotes;
    private Date createdAt;
    private Date updatedAt;

    // Additional fields cho hiển thị / join với bảng khác
    private String medicineName;
    private String supplierName;
    private String category;
    private String manufacturer;
    private String countryOfOrigin;

    // Constructors
    public Batches() {
        this.status = "Quarantined";   // Default khi mới nhập
        this.currentQuantity = 0;      // Sẽ được trigger DB tính lại
    }

    public Batches(int batchId, String medicineCode, int supplierId, String lotNumber,
                   Date expiryDate, Date receivedDate, int initialQuantity,
                   int batchQuantity, int currentQuantity, String status,
                   String quarantineNotes, Date createdAt, Date updatedAt) {
        this.batchId = batchId;
        this.medicineCode = medicineCode;
        this.supplierId = supplierId;
        this.lotNumber = lotNumber;
        this.expiryDate = expiryDate;
        this.receivedDate = receivedDate;
        this.initialQuantity = initialQuantity;
        this.batchQuantity = batchQuantity;
        this.currentQuantity = currentQuantity;
        this.status = status;
        this.quarantineNotes = quarantineNotes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters & Setters
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }

    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getLotNumber() { return lotNumber; }
    public void setLotNumber(String lotNumber) { this.lotNumber = lotNumber; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public Date getReceivedDate() { return receivedDate; }
    public void setReceivedDate(Date receivedDate) { this.receivedDate = receivedDate; }

    public int getInitialQuantity() { return initialQuantity; }
    public void setInitialQuantity(int initialQuantity) { this.initialQuantity = initialQuantity; }

    /** Số lượng thực tế của riêng lô này (không thay đổi) */
    public int getBatchQuantity() { return batchQuantity; }
    public void setBatchQuantity(int batchQuantity) { this.batchQuantity = batchQuantity; }

    /** Tổng tồn thuốc khả dụng (được trigger DB tự động cập nhật) - Read-only trong app */
    public int getCurrentQuantity() { return currentQuantity; }
    public void setCurrentQuantity(int currentQuantity) { this.currentQuantity = currentQuantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getQuarantineNotes() { return quarantineNotes; }
    public void setQuarantineNotes(String quarantineNotes) { this.quarantineNotes = quarantineNotes; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    // Additional display fields
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getCountryOfOrigin() { return countryOfOrigin; }
    public void setCountryOfOrigin(String countryOfOrigin) { this.countryOfOrigin = countryOfOrigin; }

    // Utility methods (giữ nguyên từ Code 1 - rất hữu ích cho UI)
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return expiryDate.before(new Date(System.currentTimeMillis()));
    }

    public boolean isApproved() {
        return "Approved".equals(status);
    }

    public boolean isInQuarantine() {
        return "Quarantined".equals(status) || "Received".equals(status);
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        return switch (status) {
            case "Approved" -> "badge-success";
            case "Quarantined", "Received" -> "badge-warning";
            case "Rejected" -> "badge-danger";
            case "Expired" -> "badge-dark";
            default -> "badge-secondary";
        };
    }

    public long getDaysUntilExpiry() {
        if (expiryDate == null) return -1;
        long diff = expiryDate.getTime() - System.currentTimeMillis();
        return diff / (1000 * 60 * 60 * 24);
    }

    public boolean isNearExpiry() {
        long days = getDaysUntilExpiry();
        return days >= 0 && days <= 30;
    }

    @Override
    public String toString() {
        return "Batches{" +
                "batchId=" + batchId +
                ", medicineCode='" + medicineCode + '\'' +
                ", lotNumber='" + lotNumber + '\'' +
                ", batchQuantity=" + batchQuantity +
                ", currentQuantity=" + currentQuantity +
                ", status='" + status + '\'' +
                ", expiryDate=" + expiryDate +
                ", createdAt=" + createdAt +
                '}';
    }
}