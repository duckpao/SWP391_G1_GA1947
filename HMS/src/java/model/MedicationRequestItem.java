package model;

public class MedicationRequestItem {
    private int itemId;
    private int requestId;
    private String medicineCode;  // ✅ ĐỔI từ int medicineId sang String medicineCode
    private int quantity;
    private String medicineName;
    
    // Constructors
    public MedicationRequestItem() {}
    
    public MedicationRequestItem(int requestId, String medicineCode, int quantity) {
        this.requestId = requestId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public int getRequestId() {
        return requestId;
    }
    
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }
    
    // ✅ ĐỔI: getMedicineId() → getMedicineCode()
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
    
    public String getMedicineName() {
        return medicineName;
    }
    
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }
    
    // ✅ THÊM: Phương thức tiện ích
    @Override
    public String toString() {
        return "MedicationRequestItem{" +
                "itemId=" + itemId +
                ", requestId=" + requestId +
                ", medicineCode='" + medicineCode + '\'' +
                ", quantity=" + quantity +
                ", medicineName='" + medicineName + '\'' +
                '}';
    }
    
    // ✅ THÊM: Validation helper
    public boolean isValid() {
        return medicineCode != null && !medicineCode.trim().isEmpty() && quantity > 0;
    }
}