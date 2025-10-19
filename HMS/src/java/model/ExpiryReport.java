package model;

import java.sql.Date;

// =========================================
// ExpiryReport Model
// =========================================
public class ExpiryReport {
    private int batchId;
    private int medicineId;
    private String medicineName;
    private String category;
    private String lotNumber;
    private Date expiryDate;
    private int currentQuantity;
    private String supplierName;
    private String status;
    private int daysUntilExpiry; // positive = days until, negative = days expired

    public ExpiryReport() {}

    // Getters & Setters
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getLotNumber() { return lotNumber; }
    public void setLotNumber(String lotNumber) { this.lotNumber = lotNumber; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public int getCurrentQuantity() { return currentQuantity; }
    public void setCurrentQuantity(int currentQuantity) { this.currentQuantity = currentQuantity; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getDaysUntilExpiry() { return daysUntilExpiry; }
    public void setDaysUntilExpiry(int daysUntilExpiry) { this.daysUntilExpiry = daysUntilExpiry; }

    public String getAlertLevel() {
        if (daysUntilExpiry <= 0) return "Expired";
        if (daysUntilExpiry <= 7) return "Critical";
        if (daysUntilExpiry <= 14) return "High";
        if (daysUntilExpiry <= 30) return "Medium";
        return "Low";
    }
}