package model;

import java.sql.Date;

public class ExpiryReport {
    private int batchId;
    private String medicineCode;  // Changed from medicineId (int)
    private String medicineName;
    private String category;
    private String lotNumber;
    private Date expiryDate;
    private int currentQuantity;
    private String supplierName;
    private String status;
    private int daysUntilExpiry;
    private String alertLevel;
    
    // Constructors
    public ExpiryReport() {}
    
    // Getters and Setters
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }
    
    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }
    
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
    
    public String getAlertLevel() { return alertLevel; }
    public void setAlertLevel(String alertLevel) { this.alertLevel = alertLevel; }
}
