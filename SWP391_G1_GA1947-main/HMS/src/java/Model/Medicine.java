package Model;

import java.sql.Date;

public class Medicine {
    private int id;
    private String name;
    private String category;
    private String description;

    private String supplierName;   // chỉ hiển thị tên nhà cung cấp
    private int totalStock;        // tổng tồn kho
    private Date nearestExpiry;    // hạn sử dụng gần nhất
    private String status;         // trạng thái (Còn hàng, Hết hạn, Hết hàng)

    // ===== Getters & Setters =====
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getTotalStock() { return totalStock; }
    public void setTotalStock(int totalStock) { this.totalStock = totalStock; }

    public Date getNearestExpiry() { return nearestExpiry; }
    public void setNearestExpiry(Date nearestExpiry) { this.nearestExpiry = nearestExpiry; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
