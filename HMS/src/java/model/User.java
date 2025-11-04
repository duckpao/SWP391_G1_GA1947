package model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String passwordHash;
    private String email;
    private String phone;
    private String role;
    private boolean isActive;
    private int failedAttempts;
    private Timestamp lastLogin;
    
    public User() {
    }
    
    public User(int userId, String username, String email, String phone, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }
    
    public User(String username, String passwordHash, String email, String phone, String role) {
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }
    
    public User(int userId, String username, String passwordHash, String email, String phone, 
                String role, boolean isActive, int failedAttempts, Timestamp lastLogin) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.isActive = isActive;
        this.failedAttempts = failedAttempts;
        this.lastLogin = lastLogin;
    }

    public User(int userId, String username, String email, String phone, String hashedPassword, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.passwordHash = hashedPassword;
        this.role = role;
    }
    
    
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    // QUAN TRỌNG: Phải là isActive() không phải isIsActive()
    public boolean isActive() {
        return isActive;
    }
    
    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    // Thêm getter alternative cho JSP
    public boolean getIsActive() {
        return isActive;
    }
    
    public int getFailedAttempts() {
        return failedAttempts;
    }
    
    public void setFailedAttempts(int failedAttempts) {
        this.failedAttempts = failedAttempts;
    }
    
    public Timestamp getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
}