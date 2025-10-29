package model;

public class ASNItem {
    // Primary fields
    private int itemId;
    private int asnId;
    private String medicineCode;
    private int quantity;
    private String lotNumber;
    
    // Medicine details (joined from Medicines table)
    private String medicineName;
    private String medicineCategory;
    private String strength;
    private String dosageForm;
    private String unit;
    private String manufacturer;
    private String activeIngredient;
    
    // Additional fields
    private int receivedQuantity; // For delivery confirmation
    private String notes;
    
    // Constructors
    public ASNItem() {
    }
    
    public ASNItem(int asnId, String medicineCode, int quantity) {
        this.asnId = asnId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
    }
    
    public ASNItem(int asnId, String medicineCode, int quantity, String lotNumber) {
        this.asnId = asnId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
        this.lotNumber = lotNumber;
    }
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public int getAsnId() {
        return asnId;
    }
    
    public void setAsnId(int asnId) {
        this.asnId = asnId;
    }
    
    public String getMedicineCode() {
        return medicineCode;
    }
    
    public void setMedicineCode(String medicineCode) {
        this.medicineCode = medicineCode;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getLotNumber() {
        return lotNumber;
    }
    
    public void setLotNumber(String lotNumber) {
        this.lotNumber = lotNumber;
    }
    
    // Medicine details getters/setters
    public String getMedicineName() {
        return medicineName;
    }
    
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }
    
    public String getMedicineCategory() {
        return medicineCategory;
    }
    
    public void setMedicineCategory(String medicineCategory) {
        this.medicineCategory = medicineCategory;
    }
    
    public String getStrength() {
        return strength;
    }
    
    public void setStrength(String strength) {
        this.strength = strength;
    }
    
    public String getDosageForm() {
        return dosageForm;
    }
    
    public void setDosageForm(String dosageForm) {
        this.dosageForm = dosageForm;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public String getManufacturer() {
        return manufacturer;
    }
    
    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }
    
    public String getActiveIngredient() {
        return activeIngredient;
    }
    
    public void setActiveIngredient(String activeIngredient) {
        this.activeIngredient = activeIngredient;
    }
    
    // Additional fields getters/setters
    public int getReceivedQuantity() {
        return receivedQuantity;
    }
    
    public void setReceivedQuantity(int receivedQuantity) {
        this.receivedQuantity = receivedQuantity;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    // Helper methods
    public boolean hasLotNumber() {
        return lotNumber != null && !lotNumber.trim().isEmpty();
    }
    
    public boolean isFullyReceived() {
        return receivedQuantity >= quantity;
    }
    
    public boolean isPartiallyReceived() {
        return receivedQuantity > 0 && receivedQuantity < quantity;
    }
    
    public int getRemainingQuantity() {
        return quantity - receivedQuantity;
    }
    
    public String getReceiveStatus() {
        if (receivedQuantity == 0) {
            return "Pending";
        } else if (receivedQuantity >= quantity) {
            return "Complete";
        } else {
            return "Partial";
        }
    }
    
    public String getReceiveStatusBadgeClass() {
        switch (getReceiveStatus()) {
            case "Pending":
                return "badge bg-warning";
            case "Complete":
                return "badge bg-success";
            case "Partial":
                return "badge bg-info";
            default:
                return "badge bg-secondary";
        }
    }
    
    public String getMedicineFullName() {
        StringBuilder fullName = new StringBuilder();
        
        if (medicineName != null) {
            fullName.append(medicineName);
        }
        
        if (strength != null && !strength.trim().isEmpty()) {
            fullName.append(" ").append(strength);
        }
        
        if (dosageForm != null && !dosageForm.trim().isEmpty()) {
            fullName.append(" (").append(dosageForm).append(")");
        }
        
        return fullName.toString();
    }
    
    @Override
    public String toString() {
        return "ASNItem{" +
                "itemId=" + itemId +
                ", asnId=" + asnId +
                ", medicineCode='" + medicineCode + '\'' +
                ", medicineName='" + medicineName + '\'' +
                ", quantity=" + quantity +
                ", lotNumber='" + lotNumber + '\'' +
                ", receivedQuantity=" + receivedQuantity +
                '}';
    }
}