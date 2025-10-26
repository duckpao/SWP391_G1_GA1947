package model;

import java.sql.Timestamp;

/**
 * Model class for User Activity Report
 * Contains aggregated data for report display
 */
public class UserActivityReport {
    private int userId;
    private String username;
    private String email;
    private String role;
    private int totalActions;
    private int activeDays;
    private int loginCount;
    private Timestamp firstActivity;
    private Timestamp lastActivity;
    private String mostCommonAction;
    
    // For detailed activity breakdown
    private int createActions;
    private int updateActions;
    private int deleteActions;
    private int viewActions;
    
    // Constructors
    public UserActivityReport() {
    }
    
    /**
     * Constructor for summary report
     */
    public UserActivityReport(int userId, String username, String email, String role,
                             int totalActions, int activeDays, int loginCount,
                             Timestamp firstActivity, Timestamp lastActivity,
                             String mostCommonAction) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.role = role;
        this.totalActions = totalActions;
        this.activeDays = activeDays;
        this.loginCount = loginCount;
        this.firstActivity = firstActivity;
        this.lastActivity = lastActivity;
        this.mostCommonAction = mostCommonAction;
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
    
    public int getTotalActions() {
        return totalActions;
    }
    
    public void setTotalActions(int totalActions) {
        this.totalActions = totalActions;
    }
    
    public int getActiveDays() {
        return activeDays;
    }
    
    public void setActiveDays(int activeDays) {
        this.activeDays = activeDays;
    }
    
    public int getLoginCount() {
        return loginCount;
    }
    
    public void setLoginCount(int loginCount) {
        this.loginCount = loginCount;
    }
    
    public Timestamp getFirstActivity() {
        return firstActivity;
    }
    
    public void setFirstActivity(Timestamp firstActivity) {
        this.firstActivity = firstActivity;
    }
    
    public Timestamp getLastActivity() {
        return lastActivity;
    }
    
    public void setLastActivity(Timestamp lastActivity) {
        this.lastActivity = lastActivity;
    }
    
    public String getMostCommonAction() {
        return mostCommonAction;
    }
    
    public void setMostCommonAction(String mostCommonAction) {
        this.mostCommonAction = mostCommonAction;
    }
    
    public int getCreateActions() {
        return createActions;
    }
    
    public void setCreateActions(int createActions) {
        this.createActions = createActions;
    }
    
    public int getUpdateActions() {
        return updateActions;
    }
    
    public void setUpdateActions(int updateActions) {
        this.updateActions = updateActions;
    }
    
    public int getDeleteActions() {
        return deleteActions;
    }
    
    public void setDeleteActions(int deleteActions) {
        this.deleteActions = deleteActions;
    }
    
    public int getViewActions() {
        return viewActions;
    }
    
    public void setViewActions(int viewActions) {
        this.viewActions = viewActions;
    }
    
    /**
     * Calculate average actions per day
     */
    public double getAverageActionsPerDay() {
        if (activeDays == 0) return 0;
        return (double) totalActions / activeDays;
    }
    
    @Override
    public String toString() {
        return "UserActivityReport{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", totalActions=" + totalActions +
                ", activeDays=" + activeDays +
                ", loginCount=" + loginCount +
                '}';
    }
}