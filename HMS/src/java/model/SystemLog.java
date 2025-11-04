package model;

import java.sql.Timestamp;

/**
 * Model class for SystemLogs table
 * Represents a single log entry for user activities
 */
public class SystemLog {
    private int logId;
    private int userId;
    private String action;
    private String tableName;
    private Integer recordId;
    private String oldValue;
    private String newValue;
    private String details;
    private String ipAddress;
    private Timestamp logDate;
    
    // Extended fields for JOIN queries
    private String username;
    private String email;
    private String role;
    
    // Constructors
    public SystemLog() {
    }
    
    /**
     * Constructor for creating new log entry
     */
    public SystemLog(int userId, String action, String details) {
        this.userId = userId;
        this.action = action;
        this.details = details;
        this.logDate = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Full constructor with all fields
     */
    public SystemLog(int userId, String action, String tableName, Integer recordId, 
                     String oldValue, String newValue, String details, String ipAddress) {
        this.userId = userId;
        this.action = action;
        this.tableName = tableName;
        this.recordId = recordId;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.details = details;
        this.ipAddress = ipAddress;
        this.logDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getLogId() {
        return logId;
    }
    
    public void setLogId(int logId) {
        this.logId = logId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getAction() {
        return action;
    }
    
    public void setAction(String action) {
        this.action = action;
    }
    
    public String getTableName() {
        return tableName;
    }
    
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
    public Integer getRecordId() {
        return recordId;
    }
    
    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }
    
    public String getOldValue() {
        return oldValue;
    }
    
    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }
    
    public String getNewValue() {
        return newValue;
    }
    
    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }
    
    public String getDetails() {
        return details;
    }
    
    public void setDetails(String details) {
        this.details = details;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public Timestamp getLogDate() {
        return logDate;
    }
    
    public void setLogDate(Timestamp logDate) {
        this.logDate = logDate;
    }
    
    // Extended fields getters/setters
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    @Override
    public String toString() {
        return "SystemLog{" +
                "logId=" + logId +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", action='" + action + '\'' +
                ", details='" + details + '\'' +
                ", logDate=" + logDate +
                '}';
    }
}