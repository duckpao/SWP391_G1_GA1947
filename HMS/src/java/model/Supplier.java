
package model;

import java.time.LocalDateTime;

public class Supplier {
    private int supplierId;
    private String name;
    private String contactEmail;
    private String contactPhone;
    private String address;
    private Double performanceRating; // Có thể null
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructor mặc định
    public Supplier() {
    }

    // Constructor có tham số
    public Supplier(int supplierId, String name, String contactEmail, String contactPhone,
            String address, Double performanceRating, LocalDateTime createdAt,
            LocalDateTime updatedAt) {
        this.supplierId = supplierId;
        this.name = name;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.address = address;
        this.performanceRating = performanceRating;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter và Setter
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

}