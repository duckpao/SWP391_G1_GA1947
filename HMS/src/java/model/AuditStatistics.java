package model;

/**
 * Model for Procurement-Focused Audit Statistics
 * Tracks actions related to purchase orders, invoices, shipping, etc.
 */
public class AuditStatistics {
    // Overall metrics
    private int totalActions;
    private int activeUsers;
    private int affectedTables;
    private int activeDays;
    
    // PROCUREMENT-SPECIFIC METRICS (thay vì login/create/update/delete)
    private int purchaseOrderActions;   // Đơn đặt hàng
    private int invoiceActions;         // Hóa đơn thanh toán
    private int shippingActions;        // Vận chuyển (ASN)
    private int deliveryActions;        // Giao hàng
    private int inventoryActions;       // Giao dịch kho
    
    // Approval/Rejection stats
    private int totalApprovals;
    private int totalRejections;
    
    // Manager vs Supplier activity
    private int managerActions;
    private int supplierActions;
    
    // Viewer info
    private String viewerRole;
    private String accessScope;

    // Constructors
    public AuditStatistics() {
    }

    // Getters and Setters
    public int getTotalActions() {
        return totalActions;
    }

    public void setTotalActions(int totalActions) {
        this.totalActions = totalActions;
    }

    public int getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }

    public int getAffectedTables() {
        return affectedTables;
    }

    public void setAffectedTables(int affectedTables) {
        this.affectedTables = affectedTables;
    }

    public int getActiveDays() {
        return activeDays;
    }

    public void setActiveDays(int activeDays) {
        this.activeDays = activeDays;
    }

    public int getPurchaseOrderActions() {
        return purchaseOrderActions;
    }

    public void setPurchaseOrderActions(int purchaseOrderActions) {
        this.purchaseOrderActions = purchaseOrderActions;
    }

    public int getInvoiceActions() {
        return invoiceActions;
    }

    public void setInvoiceActions(int invoiceActions) {
        this.invoiceActions = invoiceActions;
    }

    public int getShippingActions() {
        return shippingActions;
    }

    public void setShippingActions(int shippingActions) {
        this.shippingActions = shippingActions;
    }

    public int getDeliveryActions() {
        return deliveryActions;
    }

    public void setDeliveryActions(int deliveryActions) {
        this.deliveryActions = deliveryActions;
    }

    public int getInventoryActions() {
        return inventoryActions;
    }

    public void setInventoryActions(int inventoryActions) {
        this.inventoryActions = inventoryActions;
    }

    public int getTotalApprovals() {
        return totalApprovals;
    }

    public void setTotalApprovals(int totalApprovals) {
        this.totalApprovals = totalApprovals;
    }

    public int getTotalRejections() {
        return totalRejections;
    }

    public void setTotalRejections(int totalRejections) {
        this.totalRejections = totalRejections;
    }

    public int getManagerActions() {
        return managerActions;
    }

    public void setManagerActions(int managerActions) {
        this.managerActions = managerActions;
    }

    public int getSupplierActions() {
        return supplierActions;
    }

    public void setSupplierActions(int supplierActions) {
        this.supplierActions = supplierActions;
    }

    public String getViewerRole() {
        return viewerRole;
    }

    public void setViewerRole(String viewerRole) {
        this.viewerRole = viewerRole;
    }

    public String getAccessScope() {
        return accessScope;
    }

    public void setAccessScope(String accessScope) {
        this.accessScope = accessScope;
    }

    // Helper method: Get total procurement actions
    public int getTotalProcurementActions() {
        return purchaseOrderActions + invoiceActions + shippingActions + deliveryActions + inventoryActions;
    }

    // Helper method: Get approval rate (percentage)
    public double getApprovalRate() {
        int total = totalApprovals + totalRejections;
        if (total == 0) return 0.0;
        return (double) totalApprovals / total * 100;
    }

    // Helper method: Get average actions per day
    public double getAverageActionsPerDay() {
        if (activeDays == 0) return 0.0;
        return (double) totalActions / activeDays;
    }

    @Override
    public String toString() {
        return "AuditStatistics{" +
                "totalActions=" + totalActions +
                ", activeUsers=" + activeUsers +
                ", purchaseOrderActions=" + purchaseOrderActions +
                ", invoiceActions=" + invoiceActions +
                ", shippingActions=" + shippingActions +
                ", deliveryActions=" + deliveryActions +
                ", inventoryActions=" + inventoryActions +
                ", totalApprovals=" + totalApprovals +
                ", totalRejections=" + totalRejections +
                ", managerActions=" + managerActions +
                ", supplierActions=" + supplierActions +
                '}';
    }
}