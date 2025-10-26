package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Medicine {
    private int medicineId;
    private String medicineCode;
    private String name;
    private String category;
    private String description;
    private String activeIngredient;
    private String dosageForm;
    private String strength;
    private String unit;
    private String manufacturer;
    private String countryOfOrigin;
    private String drugGroup;
    private String drugType;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Danh sách các lô thuốc (batch)
    private List<BatchDetail> batches = new ArrayList<>();

    // Inner class for batch details
    public static class BatchDetail {
        private int batchId;
        private String lotNumber;
        private Date expiryDate;
        private int currentQuantity;
        private String status;
        private Date receivedDate;

        // Constructors
        public BatchDetail() {}

        public BatchDetail(String lotNumber, Date expiryDate, int currentQuantity, String status, Date receivedDate) {
            this.lotNumber = lotNumber;
            this.expiryDate = expiryDate;
            this.currentQuantity = currentQuantity;
            this.status = status;
            this.receivedDate = receivedDate;
        }

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

        @Override
        public String toString() {
            return "BatchDetail{" +
                    "batchId=" + batchId +
                    ", lotNumber='" + lotNumber + '\'' +
                    ", expiryDate=" + expiryDate +
                    ", currentQuantity=" + currentQuantity +
                    ", status='" + status + '\'' +
                    ", receivedDate=" + receivedDate +
                    '}';
        }
    }

    // Constructors
    public Medicine() {}

    public Medicine(String medicineCode, String name, String category) {
        this.medicineCode = medicineCode;
        this.name = name;
        this.category = category;
    }

    public Medicine(int medicineId, String medicineCode, String name, String category) {
        this.medicineId = medicineId;
        this.medicineCode = medicineCode;
        this.name = name;
        this.category = category;
    }

    // Getters and Setters
    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getActiveIngredient() { return activeIngredient; }
    public void setActiveIngredient(String activeIngredient) { this.activeIngredient = activeIngredient; }

    public String getDosageForm() { return dosageForm; }
    public void setDosageForm(String dosageForm) { this.dosageForm = dosageForm; }

    public String getStrength() { return strength; }
    public void setStrength(String strength) { this.strength = strength; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getCountryOfOrigin() { return countryOfOrigin; }
    public void setCountryOfOrigin(String countryOfOrigin) { this.countryOfOrigin = countryOfOrigin; }

    public String getDrugGroup() { return drugGroup; }
    public void setDrugGroup(String drugGroup) { this.drugGroup = drugGroup; }

    public String getDrugType() { return drugType; }
    public void setDrugType(String drugType) { this.drugType = drugType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public List<BatchDetail> getBatches() { return batches; }
    public void setBatches(List<BatchDetail> batches) { this.batches = batches; }

    // Thêm một batch
    public void addBatch(BatchDetail batch) {
        if (this.batches == null) {
            this.batches = new ArrayList<>();
        }
        this.batches.add(batch);
    }

    // Helper method to display medicine name with strength and form
    public String getDisplayName() {
        StringBuilder display = new StringBuilder(name);
        if (strength != null && !strength.isEmpty()) {
            display.append(" ").append(strength);
        }
        if (unit != null && !unit.isEmpty()) {
            display.append(" ").append(unit);
        }
        if (dosageForm != null && !dosageForm.isEmpty()) {
            display.append(" - ").append(dosageForm);
        }
        return display.toString();
    }

    @Override
    public String toString() {
        return "Medicine{" +
                "medicineId=" + medicineId +
                ", medicineCode='" + medicineCode + '\'' +
                ", name='" + name + '\'' +
                ", category='" + category + '\'' +
                ", strength='" + strength + '\'' +
                ", dosageForm='" + dosageForm + '\'' +
                ", manufacturer='" + manufacturer + '\'' +
                ", batchesCount=" + (batches != null ? batches.size() : 0) +
                '}';
    }
}