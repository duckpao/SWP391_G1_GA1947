package model;

import java.sql.Date;

public class InventoryReport {
    // For summary report
    private String medicineCode;  // Changed from medicineId (int)
    private String medicineName;
    private String category;
    private int totalBatches;
    private int totalQuantity;
    private int approvedQuantity;
    private int quarantinedQuantity;
    private Date nearestExpiry;
    private Date lastReceived;
    private int batchQuantity;
    
    // For supplier report
    private int supplierId;
    private String supplierName;
    private int medicineTypes;
    
    // For batch-level report
    private int batchId;
    private String lotNumber;
    private String status;
    private int currentQuantity;
    private Date expiryDate;
    private Date receivedDate;
    
    // Constructors
    public InventoryReport() {}
        public int getBatchQuantity() {
        return batchQuantity;
    }

    public void setBatchQuantity(int batchQuantity) {
        this.batchQuantity = batchQuantity;
    }
    
    // Getters and Setters
    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }
    
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public int getTotalBatches() { return totalBatches; }
    public void setTotalBatches(int totalBatches) { this.totalBatches = totalBatches; }
    
    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }
    
    public int getApprovedQuantity() { return approvedQuantity; }
    public void setApprovedQuantity(int approvedQuantity) { this.approvedQuantity = approvedQuantity; }
    
    public int getQuarantinedQuantity() { return quarantinedQuantity; }
    public void setQuarantinedQuantity(int quarantinedQuantity) { this.quarantinedQuantity = quarantinedQuantity; }
    
    public Date getNearestExpiry() { return nearestExpiry; }
    public void setNearestExpiry(Date nearestExpiry) { this.nearestExpiry = nearestExpiry; }
    
    public Date getLastReceived() { return lastReceived; }
    public void setLastReceived(Date lastReceived) { this.lastReceived = lastReceived; }
    
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    public int getMedicineTypes() { return medicineTypes; }
    public void setMedicineTypes(int medicineTypes) { this.medicineTypes = medicineTypes; }
    
    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }
    
    public String getLotNumber() { return lotNumber; }
    public void setLotNumber(String lotNumber) { this.lotNumber = lotNumber; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getCurrentQuantity() { return currentQuantity; }
    public void setCurrentQuantity(int currentQuantity) { this.currentQuantity = currentQuantity; }
    
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
    public Date getReceivedDate() { return receivedDate; }
    public void setReceivedDate(Date receivedDate) { this.receivedDate = receivedDate; }
}
