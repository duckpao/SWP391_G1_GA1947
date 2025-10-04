package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Medicine {
    private int medicineId;
    private String name;
    private String category;
    private String description;
    private List<BatchDetail> batches = new ArrayList<>();

    // Inner class for batch details
    public static class BatchDetail {
        private int batchId;
        private String lotNumber;
        private Date expiryDate;
        private int currentQuantity;
        private String status;
        private Date receivedDate;

        // Getters and Setters
        public int getBatchId() { return batchId; }
        public void setBatchId(int batchId) { this.batchId = batchId; }
        public String getLotNumber() { return lotNumber; }
        public void setLotNumber(String lotNumber) { this.lotNumber = lotNumber; }
        public Date getExpiryDate() { return expiryDate; }
        public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
        public int getCurrentQuantity() { return currentQuantity; }
        public void setCurrentQuantity(int currentQuantity) { this.currentQuantity = currentQuantity; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public Date getReceivedDate() { return receivedDate; }
        public void setReceivedDate(Date receivedDate) { this.receivedDate = receivedDate; }
    }

    // Getters and Setters
    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<BatchDetail> getBatches() { return batches; }
    public void setBatches(List<BatchDetail> batches) { this.batches = batches; }
}