package model;

import java.util.Date;

public class IssueSlipItem {
    private int itemId;          // item_id
    private int slipId;          // slip_id
    private String medicineCode; // medicine_code
    private int quantity;        // số lượng
private String medicineName;
private String unit;
private Integer batchId; // batch có thể null nên dùng Integer
private Date expiryDate; // java.sql.Date
    // Constructor
    public IssueSlipItem() {}

    public IssueSlipItem(int itemId, int slipId, String medicineCode, int quantity) {
        this.itemId = itemId;
        this.slipId = slipId;
        this.medicineCode = medicineCode;
        this.quantity = quantity;
    }

    // Getter & Setter
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getSlipId() { return slipId; }
    public void setSlipId(int slipId) { this.slipId = slipId; }

    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { this.medicineCode = medicineCode; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    // getter/setter
public String getMedicineName() { return medicineName; }
public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

public String getUnit() { return unit; }
public void setUnit(String unit) { this.unit = unit; }

public Integer getBatchId() { return batchId; }
public void setBatchId(Integer batchId) { this.batchId = batchId; }

public Date getExpiryDate() { return expiryDate; }
public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
}
