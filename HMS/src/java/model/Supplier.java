package model;
import java.time.LocalDateTime;
import java.util.Objects;

public class Supplier {
    private Integer supplierId;
    private String name;
    private String contactEmail;
    private String contactPhone;
    private String address;
    private Double performanceRating;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Default constructor
    public Supplier() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Constructor with all fields
    public Supplier(Integer supplierId, String name, String contactEmail, 
                   String contactPhone, String address, Double performanceRating,
                   LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.supplierId = supplierId;
        this.name = name;
        this.contactEmail = contactEmail;
        this.contactPhone = contactPhone;
        this.address = address;
        this.performanceRating = performanceRating;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
        this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now();
    }
    
    // Getters
    public Integer getSupplierId() {
        return supplierId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getContactEmail() {
        return contactEmail;
    }
    
    public String getContactPhone() {
        return contactPhone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public Double getPerformanceRating() {
        return performanceRating;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    // Setters
    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }
    
    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public void setPerformanceRating(Double performanceRating) {
        this.performanceRating = performanceRating;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Business methods
    public void updatePerformanceRating(Double newRating) {
        if (newRating != null && newRating >= 0 && newRating <= 5) {
            this.performanceRating = newRating;
            this.updatedAt = LocalDateTime.now();
        } else {
            throw new IllegalArgumentException("Performance rating must be between 0 and 5");
        }
    }
    
    public void updateContactInfo(String email, String phone, String address) {
        if (email != null && !email.isEmpty()) {
            this.contactEmail = email;
        }
        if (phone != null && !phone.isEmpty()) {
            this.contactPhone = phone;
        }
        if (address != null && !address.isEmpty()) {
            this.address = address;
        }
        this.updatedAt = LocalDateTime.now();
    }

}