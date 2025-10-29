package model;

public class PurchaseOrderItem {
    // Primary fields
    private int poItemId;
    private int poId;
    private String medicineCode;
    private int quantity;
    private double unitPrice;
    private String priority;
    private String notes;
    
    // Medicine details (joined from Medicines table)
    private String medicineName;
    private String medicineCategory;
    private String medicineStrength;
    private String medicineDosageForm;
    private String medicineManufacturer;
    private String unit;
    private String activeIngredient;
    
    // Constructors
    public PurchaseOrderItem() {
    }
    
    public PurchaseOrderItem(int poId, String medicineCode, int quantity) {
        this.poId = poId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getPoItemId() {
        return poItemId;
    }
    
    public void setPoItemId(int poItemId) {
        this.poItemId = poItemId;
    }
    
    public int getItemId() {
        return poItemId;
    }
    
    public void setItemId(int itemId) {
        this.poItemId = itemId;
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
    
    public double getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
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
    
    // Medicine detail getters/setters
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
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public String getActiveIngredient() {
        return activeIngredient;
    }
    
    public void setActiveIngredient(String activeIngredient) {
        this.activeIngredient = activeIngredient;
    }
    
    @Override
    public String toString() {
        return "PurchaseOrderItem{" +
                "poItemId=" + poItemId +
                ", poId=" + poId +
                ", medicineCode='" + medicineCode + '\'' +
                ", medicineName='" + medicineName + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", priority='" + priority + '\'' +
                '}';
    }
}