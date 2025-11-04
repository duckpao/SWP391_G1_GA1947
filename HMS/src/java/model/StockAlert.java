package model;

import java.sql.Date;

public class StockAlert {
    private int medicineId;
    private String medicineName;
    private String category;
    private int currentQuantity;
    private int threshold;
    private Date nearestExpiry;
    private String alertLevel; // Critical, High, Medium

    public StockAlert() {
    }

    // Getters and Setters
    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
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

    public int getCurrentQuantity() {
        return currentQuantity;
    }

    public void setCurrentQuantity(int currentQuantity) {
        this.currentQuantity = currentQuantity;
    }

    public int getThreshold() {
        return threshold;
    }

    public void setThreshold(int threshold) {
        this.threshold = threshold;
    }

    public Date getNearestExpiry() {
        return nearestExpiry;
    }

    public void setNearestExpiry(Date nearestExpiry) {
        this.nearestExpiry = nearestExpiry;
    }

    public String getAlertLevel() {
        return alertLevel;
    }

    public void setAlertLevel(String alertLevel) {
        this.alertLevel = alertLevel;
    }

    public String getAlertLevelBadgeClass() {
        switch (alertLevel) {
            case "Critical":
                return "badge bg-danger";
            case "High":
                return "badge bg-warning";
            case "Medium":
                return "badge bg-info";
            default:
                return "badge bg-secondary";
        }
    }
}