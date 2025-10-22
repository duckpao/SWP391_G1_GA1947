USE master;
GO

-- Safely drop and recreate the database
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SWP391')
BEGIN
    ALTER DATABASE SWP391 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SWP391;
END
GO

CREATE DATABASE SWP391;
GO

USE SWP391;
GO

-- Drop all tables in reverse dependency order to avoid FK issues
IF OBJECT_ID('AuditReports', 'U') IS NOT NULL DROP TABLE AuditReports;
IF OBJECT_ID('SystemLogs', 'U') IS NOT NULL DROP TABLE SystemLogs;
IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions;
IF OBJECT_ID('Invoices', 'U') IS NOT NULL DROP TABLE Invoices;
IF OBJECT_ID('DeliveryNotes', 'U') IS NOT NULL DROP TABLE DeliveryNotes;
IF OBJECT_ID('ASNItems', 'U') IS NOT NULL DROP TABLE ASNItems;
IF OBJECT_ID('AdvancedShippingNotices', 'U') IS NOT NULL DROP TABLE AdvancedShippingNotices;
IF OBJECT_ID('PurchaseOrderItems', 'U') IS NOT NULL DROP TABLE PurchaseOrderItems;
IF OBJECT_ID('PurchaseOrders', 'U') IS NOT NULL DROP TABLE PurchaseOrders;
IF OBJECT_ID('MedicationRequestItems', 'U') IS NOT NULL DROP TABLE MedicationRequestItems;
IF OBJECT_ID('MedicationRequests', 'U') IS NOT NULL DROP TABLE MedicationRequests;
IF OBJECT_ID('Batches', 'U') IS NOT NULL DROP TABLE Batches;
IF OBJECT_ID('Medicines', 'U') IS NOT NULL DROP TABLE Medicines;
IF OBJECT_ID('UserPermissions', 'U') IS NOT NULL DROP TABLE UserPermissions;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Permissions', 'U') IS NOT NULL DROP TABLE Permissions;
IF OBJECT_ID('SystemConfig', 'U') IS NOT NULL DROP TABLE SystemConfig;
GO

-- Create core tables in dependency order
CREATE TABLE Permissions ( 
    permission_id INT IDENTITY(1,1) PRIMARY KEY, 
    permission_name NVARCHAR(100) UNIQUE NOT NULL, 
    description NVARCHAR(MAX) 
);

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(255),
    phone NVARCHAR(50),
    role NVARCHAR(50) NOT NULL CHECK (role IN ('Doctor', 'Pharmacist', 'Manager', 'Auditor', 'Admin', 'Supplier')),
    is_active BIT DEFAULT 1,
    failed_attempts INT DEFAULT 0 CHECK (failed_attempts <= 5),
    last_login DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE FOREIGN KEY REFERENCES Users(user_id),
    name NVARCHAR(100) NOT NULL,
    contact_email NVARCHAR(255),
    contact_phone NVARCHAR(50),
    address NVARCHAR(MAX),
    performance_rating DECIMAL(3,2) DEFAULT 0.0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT CHK_Supplier_UserRole CHECK (user_id IS NOT NULL)
);

CREATE TABLE UserPermissions ( 
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
    permission_id INT FOREIGN KEY REFERENCES Permissions(permission_id) ON DELETE CASCADE, 
    PRIMARY KEY (user_id, permission_id) 
);

-- Create Medicines table with medicine_code as primary key
CREATE TABLE Medicines ( 
    medicine_code NVARCHAR(50) PRIMARY KEY,  -- Updated to use medicine_code as primary key
    name NVARCHAR(100) NOT NULL, 
    category NVARCHAR(50), 
    description NVARCHAR(MAX), 
    active_ingredient NVARCHAR(255), -- Hoạt chất
    dosage_form NVARCHAR(50), -- Dạng bào chế
    strength NVARCHAR(50), -- Hàm lượng
    unit NVARCHAR(20), -- Đơn vị tính (mg, ml, v.v.)
    manufacturer NVARCHAR(100), -- Nhà sản xuất
    country_of_origin NVARCHAR(100), -- Nước sản xuất
    drug_group NVARCHAR(50), -- Nhóm thuốc (ví dụ: thuốc giảm đau, thuốc kháng sinh)
    drug_type NVARCHAR(50) CHECK (drug_type IN ('Bảo hiểm', 'Đặc trị', 'Khác')), -- Phân loại thuốc
    created_at DATETIME DEFAULT GETDATE(), 
    updated_at DATETIME DEFAULT GETDATE() 
);

-- Create Batches table with foreign key to medicine_code
CREATE TABLE Batches ( 
    batch_id INT IDENTITY(1,1) PRIMARY KEY, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, -- Changed to medicine_code
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id), 
    lot_number NVARCHAR(50) NOT NULL, 
    expiry_date DATE NOT NULL CHECK (expiry_date > GETDATE()), 
    received_date DATE DEFAULT GETDATE(), 
    initial_quantity INT NOT NULL CHECK (initial_quantity >= 0),
    current_quantity INT NOT NULL CHECK (current_quantity >= 0), 
    status NVARCHAR(20) DEFAULT 'Quarantined' CHECK (status IN ('Received','Quarantined','Approved','Rejected','Expired')), 
    quarantine_notes NVARCHAR(MAX), 
    created_at DATETIME DEFAULT GETDATE(), 
    updated_at DATETIME DEFAULT GETDATE() 
);

-- Create MedicationRequests table with foreign key to doctor_id
CREATE TABLE MedicationRequests ( 
    request_id INT IDENTITY(1,1) PRIMARY KEY, 
    doctor_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL, 
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Approved','Rejected','Canceled','Fulfilled')), 
    request_date DATETIME DEFAULT GETDATE(), 
    notes NVARCHAR(MAX) 
);

-- Create MedicationRequestItems table with foreign key to medicine_code
CREATE TABLE MedicationRequestItems ( 
    item_id INT IDENTITY(1,1) PRIMARY KEY, 
    request_id INT FOREIGN KEY REFERENCES MedicationRequests(request_id) ON DELETE CASCADE, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, -- Changed to medicine_code
    quantity INT NOT NULL CHECK (quantity > 0) 
);

-- Create PurchaseOrders table
CREATE TABLE PurchaseOrders ( 
    po_id INT IDENTITY(1,1) PRIMARY KEY, 
    manager_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL, 
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE CASCADE, 
    status NVARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft','Sent','Approved','Received','Rejected','Completed')), 
    order_date DATETIME DEFAULT GETDATE(), 
    expected_delivery_date DATE, 
    notes NVARCHAR(MAX),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Create PurchaseOrderItems table with foreign key to medicine_code
CREATE TABLE PurchaseOrderItems ( 
    item_id INT IDENTITY(1,1) PRIMARY KEY, 
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, -- Changed to medicine_code
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2),
    priority VARCHAR(20),
    notes NVARCHAR(500)
);

-- Create AdvancedShippingNotices table
CREATE TABLE AdvancedShippingNotices (
    asn_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE NO ACTION,
    shipment_date DATE NOT NULL,
    carrier NVARCHAR(100),
    tracking_number NVARCHAR(50),
    status NVARCHAR(20) DEFAULT 'Sent' CHECK (status IN ('Sent','InTransit','Delivered')),
    notes NVARCHAR(MAX),
    submitted_by NVARCHAR(100),
    approved_by NVARCHAR(100),
    submitted_at DATETIME,
    approved_at DATETIME,
    rejection_reason NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Create ASNItems table with foreign key to medicine_code
CREATE TABLE ASNItems (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    asn_id INT FOREIGN KEY REFERENCES AdvancedShippingNotices(asn_id) ON DELETE CASCADE,
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, -- Changed to medicine_code
    quantity INT NOT NULL CHECK (quantity > 0),
    lot_number NVARCHAR(50)
);

-- Create DeliveryNotes table
CREATE TABLE DeliveryNotes (
    dn_id INT IDENTITY(1,1) PRIMARY KEY,
    asn_id INT FOREIGN KEY REFERENCES AdvancedShippingNotices(asn_id) ON DELETE SET NULL,
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE NO ACTION,
    delivery_date DATE DEFAULT GETDATE(),
    received_by INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL,
    status NVARCHAR(20) DEFAULT 'Complete' CHECK (status IN ('Partial','Complete','Discrepant')),
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

-- Create Invoices table
CREATE TABLE Invoices (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
    asn_id INT FOREIGN KEY REFERENCES AdvancedShippingNotices(asn_id) ON DELETE NO ACTION,
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE NO ACTION,
    invoice_number NVARCHAR(50) UNIQUE NOT NULL,
    invoice_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Paid','Disputed')),
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Create Transactions table
CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    batch_id INT FOREIGN KEY REFERENCES Batches(batch_id) ON DELETE CASCADE,
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL,
    dn_id INT FOREIGN KEY REFERENCES DeliveryNotes(dn_id) ON DELETE SET NULL,
    type NVARCHAR(30) NOT NULL CHECK (type IN ('In','Out','Expired','Damaged','Adjustment','QuarantineRelease')),
    quantity INT NOT NULL,
    transaction_date DATETIME DEFAULT GETDATE(),
    notes NVARCHAR(MAX)
);

CREATE TABLE SystemLogs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    action NVARCHAR(100) NOT NULL,
    table_name NVARCHAR(50),
    record_id INT,
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX),
    details NVARCHAR(MAX),
    ip_address NVARCHAR(50),
    log_date DATETIME DEFAULT GETDATE()
);

-- Thêm bảng Tasks vào database SWP391
CREATE TABLE Tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT,
    staff_id INT,
    task_type varchar(50),
    deadline date,
    status varchar(20),
    created_at datetime DEFAULT GETDATE(),
    updated_at datetime DEFAULT GETDATE()
);

-- Thêm khóa ngoại nếu cần thiết
ALTER TABLE Tasks
ADD CONSTRAINT FK_Tasks_PurchaseOrders FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id);

ALTER TABLE Tasks
ADD CONSTRAINT FK_Tasks_Users FOREIGN KEY (staff_id) REFERENCES Users(user_id);

CREATE TABLE AuditReports (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    auditor_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL,
    report_type NVARCHAR(50) NOT NULL CHECK (report_type IN ('SupplierPerformance','PurchaseHistory','InventoryAudit','UserActivity')),
    generated_date DATETIME DEFAULT GETDATE(),
    data NVARCHAR(MAX),
    exported_format NVARCHAR(10) CHECK (exported_format IN ('Excel','PDF')),
    notes NVARCHAR(MAX)
);

CREATE TABLE SystemConfig (
    config_key NVARCHAR(50) PRIMARY KEY,
    config_value NVARCHAR(MAX),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- Initial data inserts
-- (Same as previous code for inserting initial values)
GO

-- Legacy role update
UPDATE Users SET role = 'Supplier' WHERE role = 'ProcurementOfficer';
GO

-- Insert admin user
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'admin')
    INSERT INTO Users (username, password_hash, email, phone, role, is_active, failed_attempts, last_login, created_at, updated_at)
    VALUES ('admin', '$2a$12$K9nUjmnWq6sNYy0npqvGEuvghhATiOb2jCck9yA/foqghFG9lYK4u', 'admin@example.com', '12345678901', 'Admin', 1, 0, NULL, GETDATE(), GETDATE());
GO

-- Update existing PurchaseOrders updated_at (if any records exist)
UPDATE PurchaseOrders SET updated_at = COALESCE(updated_at, GETDATE()) WHERE updated_at IS NULL;
GO

-- Additional constraint for MedicationRequests
ALTER TABLE MedicationRequests
ADD CONSTRAINT CK_MedicationRequests_Status
CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Cancelled'));
GO

PRINT 'SWP391 database cleaned and setup completed successfully.';
