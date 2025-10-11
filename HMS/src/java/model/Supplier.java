package model;

import java.sql.Timestamp;

public class Supplier {
    private int supplierId;
    private String name;
    private String contactEmail;
    private String contactPhone;
    private String address;
    private Double performanceRating;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Supplier() {
    }

    // Getters and Setters
    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Double getPerformanceRating() {
        return performanceRating;
    }

    public void setPerformanceRating(Double performanceRating) {
        this.performanceRating = performanceRating;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper method for display
    public String getRatingStars() {
        if (performanceRating == null) return "N/A";
        int stars = (int) Math.round(performanceRating);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            sb.append(i < stars ? "★" : "☆");
        }
        return sb.toString();
    }

    public String getRatingBadgeClass() {
        if (performanceRating == null) return "badge bg-secondary";
        if (performanceRating >= 4.0) return "badge bg-success";
        if (performanceRating >= 3.0) return "badge bg-warning";
        return "badge bg-danger";
    }
}