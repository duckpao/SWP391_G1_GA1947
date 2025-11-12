package model;

import java.sql.Date;

public class Batches {
    private int batchId;
    private String medicineCode;
    private int supplierId;
    private String lotNumber;
    private Date expiryDate;
    private Date receivedDate;
    private int initialQuantity;
    private int currentQuantity;
    private String status;
    private String quarantineNotes;
    private Date createdAt;
    private Date updatedAt;
    
    private String medicineName;
    private String category;
    private String manufacturer;
    private String countryOfOrigin;

    public Batches() {}

    // Constructor
    public Batches(int batchId, String medicineCode, int supplierId, String lotNumber, Date expiryDate,
                   Date receivedDate, int initialQuantity, int currentQuantity, String status,
                   String quarantineNotes, Date createdAt, Date updatedAt) {
        this.batchId = batchId;
        this.medicineCode = medicineCode;
        this.supplierId = supplierId;
        this.lotNumber = lotNumber;
        this.expiryDate = expiryDate;
        this.receivedDate = receivedDate;
        this.initialQuantity = initialQuantity;
        this.currentQuantity = currentQuantity;
        this.status = status;
        this.quarantineNotes = quarantineNotes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getCountryOfOrigin() {
        return countryOfOrigin;
    }

    public void setCountryOfOrigin(String countryOfOrigin) {
        this.countryOfOrigin = countryOfOrigin;
    }

    // Getters và setters
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
}
