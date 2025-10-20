package model;

public class PurchaseOrderItem {
<<<<<<< HEAD
    private int itemId;
=======
>>>>>>> 4645b2a (tam)
    private int poId;
    private int medicineId;
    private int quantity;
    private String priority;
    private String notes;
<<<<<<< HEAD
    private double unitPrice;
    
    // Transient field - không lưu trong DB
    private String medicineName;

    // Constructors
    public PurchaseOrderItem() {
    }

    public PurchaseOrderItem(int poId, int medicineId, int quantity, String priority, String notes) {
        this.poId = poId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.priority = priority;
        this.notes = notes;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

=======

    // Getters and Setters
>>>>>>> 4645b2a (tam)
    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
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
<<<<<<< HEAD

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    @Override
    public String toString() {
        return "PurchaseOrderItem{" +
                "itemId=" + itemId +
                ", poId=" + poId +
                ", medicineId=" + medicineId +
                ", medicineName='" + medicineName + '\'' +
                ", quantity=" + quantity +
                ", priority='" + priority + '\'' +
                ", unitPrice=" + unitPrice +
                '}';
    }
=======
>>>>>>> 4645b2a (tam)
}