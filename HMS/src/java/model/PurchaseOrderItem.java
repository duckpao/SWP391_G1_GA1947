package model;

public class PurchaseOrderItem {

    private int poItemId;
    private int poId;
    private String medicineCode;
    private int quantity;
    private double unitPrice;
    private String priority;
    private String notes;

    // Joined fields from Medicine table
    private String medicineName;
    private String unit;
    private String medicineCategory;
    private String medicineStrength;
    private String medicineDosageForm;
    private String medicineManufacturer;

    // Constructors
    public PurchaseOrderItem() {
    }
    
    public PurchaseOrderItem(int poItemId, int poId, String medicineCode, int quantity, 
                            double unitPrice, String priority, String notes) {
        this.poItemId = poItemId;
        this.poId = poId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.priority = priority;
        this.notes = notes;
    }

    public PurchaseOrderItem(int poId, String medicineCode, int quantity, String priority) {
        this.poId = poId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
        this.priority = priority;
    }

    // Getters and Setters
    public int getPoItemId() {
        return poItemId;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public void setPoItemId(int poItemId) {
        this.poItemId = poItemId;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
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

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

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

    public String getMedicineStrength() {
        return medicineStrength;
    }

    public void setMedicineStrength(String medicineStrength) {
        this.medicineStrength = medicineStrength;
    }

    public String getMedicineDosageForm() {
        return medicineDosageForm;
    }

    public void setMedicineDosageForm(String medicineDosageForm) {
        this.medicineDosageForm = medicineDosageForm;
    }

    public String getMedicineManufacturer() {
        return medicineManufacturer;
    }

    public void setMedicineManufacturer(String medicineManufacturer) {
        this.medicineManufacturer = medicineManufacturer;
    }

    // Helper method to get full medicine display
    public String getMedicineDisplayName() {
        StringBuilder display = new StringBuilder(medicineName != null ? medicineName : "");
        if (medicineStrength != null && !medicineStrength.isEmpty()) {
            display.append(" ").append(medicineStrength);
        }
        if (medicineDosageForm != null && !medicineDosageForm.isEmpty()) {
            display.append(" - ").append(medicineDosageForm);
        }
        return display.toString();
    }

    @Override
    public String toString() {
        return "PurchaseOrderItem{"
                + "poItemId=" + poItemId
                + ", poId=" + poId
                + ", medicineCode='" + medicineCode + '\''
                + ", medicineName='" + medicineName + '\''
                + ", quantity=" + quantity
                + ", priority='" + priority + '\''
                + '}';
    }
}
