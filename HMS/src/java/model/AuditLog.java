package model;

import java.sql.Timestamp;

public class AuditLog {
    private int logId;
    private int userId;
    private String username;
    private String email;
    private String role;
    private String action;
    private String tableName;
    private int recordId;
    private String oldValue;
    private String newValue;
    private String details;
    private String ipAddress;
    private Timestamp logDate;
    private String riskLevel;
    private String category;
    
    // Constructors
    public AuditLog() {}
    
    public AuditLog(int logId, int userId, String username, String email, String role,
                   String action, String tableName, int recordId, String details,
                   String ipAddress, Timestamp logDate, String riskLevel, String category) {
        this.logId = logId;
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.role = role;
        this.action = action;
        this.tableName = tableName;
        this.recordId = recordId;
        this.details = details;
        this.ipAddress = ipAddress;
        this.logDate = logDate;
        this.riskLevel = riskLevel;
        this.category = category;
    }
    
    // Getters and Setters
    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    
    public String getTableName() { return tableName; }
    public void setTableName(String tableName) { this.tableName = tableName; }
    
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }
    
    public String getOldValue() { return oldValue; }
    public void setOldValue(String oldValue) { this.oldValue = oldValue; }
    
    public String getNewValue() { return newValue; }
    public void setNewValue(String newValue) { this.newValue = newValue; }
    
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    
    public Timestamp getLogDate() { return logDate; }
    public void setLogDate(Timestamp logDate) { this.logDate = logDate; }
    
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}