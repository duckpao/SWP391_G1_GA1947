package model;

public class AuditStatistics {
    private int totalActions;
    private int activeUsers;
    private int affectedTables;
    private int activeDays;
    private int totalLogins;
    private int totalCreates;
    private int totalUpdates;
    private int totalDeletes;
    private int totalApprovals;
    
    // Getters and Setters
    public int getTotalActions() { return totalActions; }
    public void setTotalActions(int totalActions) { this.totalActions = totalActions; }
    
    public int getActiveUsers() { return activeUsers; }
    public void setActiveUsers(int activeUsers) { this.activeUsers = activeUsers; }
    
    public int getAffectedTables() { return affectedTables; }
    public void setAffectedTables(int affectedTables) { this.affectedTables = affectedTables; }
    
    public int getActiveDays() { return activeDays; }
    public void setActiveDays(int activeDays) { this.activeDays = activeDays; }
    
    public int getTotalLogins() { return totalLogins; }
    public void setTotalLogins(int totalLogins) { this.totalLogins = totalLogins; }
    
    public int getTotalCreates() { return totalCreates; }
    public void setTotalCreates(int totalCreates) { this.totalCreates = totalCreates; }
    
    public int getTotalUpdates() { return totalUpdates; }
    public void setTotalUpdates(int totalUpdates) { this.totalUpdates = totalUpdates; }
    
    public int getTotalDeletes() { return totalDeletes; }
    public void setTotalDeletes(int totalDeletes) { this.totalDeletes = totalDeletes; }
    
    public int getTotalApprovals() { return totalApprovals; }
    public void setTotalApprovals(int totalApprovals) { this.totalApprovals = totalApprovals; }
}