package model;

import java.sql.Date;

public class StockAlert {
    private String medicineCode;  // Changed from medicineId (int)
    private String medicineName;
    private String category;
    private int currentQuantity;
    private int threshold;
    private String alertLevel;  // "Critical", "High", "Medium"
    private Date nearestExpiry;
    
    // Constructors
    public StockAlert() {}
    
    public StockAlert(String medicineCode, String medicineName, String category, 
                      int currentQuantity, int threshold) {
        this.medicineCode = medicineCode;
        this.medicineName = medicineName;
        this.category = category;
        this.currentQuantity = currentQuantity;
        this.threshold = threshold;
        this.alertLevel = determineAlertLevel();
    }
    
    // Determine alert level based on quantity
    private String determineAlertLevel() {
        if (currentQuantity == 0) {
            return "Critical";
        } else if (currentQuantity < threshold / 2) {
            return "High";
        } else {
            return "Medium";
        }
    }
    
    // Getters and Setters
    public String getMedicineCode() { return medicineCode; }
    public void setMedicineCode(String medicineCode) { 
        this.medicineCode = medicineCode; 
    }
    
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public int getCurrentQuantity() { return currentQuantity; }
    public void setCurrentQuantity(int currentQuantity) { 
        this.currentQuantity = currentQuantity;
        this.alertLevel = determineAlertLevel();
    }
    
    public int getThreshold() { return threshold; }
    public void setThreshold(int threshold) { 
        this.threshold = threshold;
        this.alertLevel = determineAlertLevel();
    }
    
    public String getAlertLevel() { return alertLevel; }
    public void setAlertLevel(String alertLevel) { this.alertLevel = alertLevel; }
    
    public Date getNearestExpiry() { return nearestExpiry; }
    public void setNearestExpiry(Date nearestExpiry) { this.nearestExpiry = nearestExpiry; }
}