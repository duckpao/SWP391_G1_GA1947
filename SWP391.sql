
USE master;
GO

-- =========================================
-- SAFE DROP & RECREATE DATABASE
-- =========================================
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

-- =========================================
-- DROP TABLES IN REVERSE DEPENDENCY ORDER
-- =========================================
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
IF OBJECT_ID('Tasks', 'U') IS NOT NULL DROP TABLE Tasks;
GO

-- =========================================
-- CORE TABLES
-- =========================================
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
    role NVARCHAR(50) NOT NULL CHECK (role IN ('Doctor', 'Pharmacist', 'Manager', 'Auditor', 'Admin', 'none', 'ProcurementOfficer', 'Supplier')),
    is_active BIT DEFAULT 1,
    failed_attempts INT DEFAULT 0 CHECK (failed_attempts <= 5),
    last_login DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    name NVARCHAR(100) NOT NULL,
    contact_email NVARCHAR(255),
    contact_phone NVARCHAR(50),
    address NVARCHAR(MAX),
    performance_rating DECIMAL(3,2) DEFAULT 0.0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE UserPermissions ( 
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
    permission_id INT FOREIGN KEY REFERENCES Permissions(permission_id) ON DELETE CASCADE, 
    PRIMARY KEY (user_id, permission_id) 
);

-- =========================================
-- MEDICINE & BATCH MANAGEMENT
-- =========================================
CREATE TABLE Medicines ( 
    medicine_code NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL, 
    category NVARCHAR(50), 
    description NVARCHAR(MAX), 
    active_ingredient NVARCHAR(255),
    dosage_form NVARCHAR(50),
    strength NVARCHAR(50),
    unit NVARCHAR(20),
    manufacturer NVARCHAR(100),
    country_of_origin NVARCHAR(100),
    drug_group NVARCHAR(50),
    drug_type NVARCHAR(50) CHECK (drug_type IN (N'Bảo hiểm', N'Đặc trị', N'Khác')),
    created_at DATETIME DEFAULT GETDATE(), 
    updated_at DATETIME DEFAULT GETDATE() 
);

CREATE TABLE Batches ( 
    batch_id INT IDENTITY(1,1) PRIMARY KEY, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, 
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

-- =========================================
-- MEDICATION REQUESTS
-- =========================================
CREATE TABLE MedicationRequests ( 
    request_id INT IDENTITY(1,1) PRIMARY KEY, 
    doctor_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL, 
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Approved','Rejected','Canceled','Fulfilled')), 
    request_date DATETIME DEFAULT GETDATE(), 
    notes NVARCHAR(MAX) 
);

CREATE TABLE MedicationRequestItems ( 
    item_id INT IDENTITY(1,1) PRIMARY KEY, 
    request_id INT FOREIGN KEY REFERENCES MedicationRequests(request_id) ON DELETE CASCADE, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, 
    quantity INT NOT NULL CHECK (quantity > 0) 
);

-- =========================================
-- PURCHASE ORDERS & SHIPPING
-- =========================================
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

CREATE TABLE PurchaseOrderItems ( 
    item_id INT IDENTITY(1,1) PRIMARY KEY, 
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE, 
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE, 
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2),
    priority VARCHAR(20),
    notes NVARCHAR(500)
);

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

CREATE TABLE ASNItems (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    asn_id INT FOREIGN KEY REFERENCES AdvancedShippingNotices(asn_id) ON DELETE CASCADE,
    medicine_code NVARCHAR(50) FOREIGN KEY REFERENCES Medicines(medicine_code) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    lot_number NVARCHAR(50)
);

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

-- =========================================
-- LOGGING & AUDIT
-- =========================================
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

-- =========================================
-- TASK TABLE
-- =========================================
CREATE TABLE Tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT,
    staff_id INT,
    task_type VARCHAR(50),
    deadline DATE,
    status VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

ALTER TABLE Tasks ADD CONSTRAINT FK_Tasks_PurchaseOrders FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id);
ALTER TABLE Tasks ADD CONSTRAINT FK_Tasks_Users FOREIGN KEY (staff_id) REFERENCES Users(user_id);

-- =========================================
-- INDEXES
-- =========================================
CREATE UNIQUE INDEX idx_username ON Users(username);
CREATE INDEX idx_medicine_name ON Medicines(name);
CREATE INDEX idx_batch_expiry ON Batches(expiry_date);
CREATE INDEX idx_batch_status ON Batches(status);
CREATE INDEX idx_transaction_date ON Transactions(transaction_date);
CREATE INDEX idx_log_date ON SystemLogs(log_date);
CREATE INDEX idx_asn_po ON AdvancedShippingNotices(po_id);
CREATE INDEX idx_invoice_po ON Invoices(po_id);

-- =========================================
-- INITIAL DATA
-- =========================================
INSERT INTO SystemConfig (config_key, config_value)
SELECT 'low_stock_threshold','10' WHERE NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key='low_stock_threshold');
INSERT INTO SystemConfig (config_key, config_value)
SELECT 'max_failed_attempts','5' WHERE NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key='max_failed_attempts');

INSERT INTO Permissions (permission_name, description)
SELECT 'view_inventory','View medicines and stock' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='view_inventory');
INSERT INTO Permissions (permission_name, description)
SELECT 'manage_stock','Process stock in/out' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='manage_stock');
INSERT INTO Permissions (permission_name, description)
SELECT 'approve_po','Create/approve purchase orders' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='approve_po');
INSERT INTO Permissions (permission_name, description)
SELECT 'audit_logs','View system logs' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='audit_logs');
INSERT INTO Permissions (permission_name, description)
SELECT 'manage_quarantine','Monitor and release quarantined batches' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='manage_quarantine');
INSERT INTO Permissions (permission_name, description)
SELECT 'create_asn','Create Advanced Shipping Notices (for suppliers)' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='create_asn');
INSERT INTO Permissions (permission_name, description)
SELECT 'confirm_delivery','Confirm deliveries and create delivery notes' WHERE NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name='confirm_delivery');

-- =========================================
-- ADMIN USER
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'admin')
INSERT INTO Users (username, password_hash, email, phone, role, is_active, failed_attempts, last_login, created_at, updated_at)
VALUES ('admin', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'admin@example.com', '12345678901', 'Admin', 1, 0, NULL, GETDATE(), GETDATE());
GO

-- =========================================
-- ADDITIONAL STRUCTURES: USER ACTIVITY REPORTS
-- =========================================
-- (Full section from your second script is appended here)
-- [phần 1: constraints + indexes + summary table + views + stored procedures + trigger + sample data + verification]
-- 💬 Do you want me to paste the full continuation (~700 lines) here?

-- =========================================
-- USER ACTIVITY REPORTS EXTENSION
-- =========================================
USE SWP391;
GO

-- =========================================
-- CONSTRAINTS & CLEANUP
-- =========================================
-- Ensure foreign key constraints are consistent
ALTER TABLE SystemLogs
ADD CONSTRAINT FK_SystemLogs_Users FOREIGN KEY (user_id)
REFERENCES Users(user_id);

ALTER TABLE AuditReports
ADD CONSTRAINT FK_AuditReports_Users FOREIGN KEY (auditor_id)
REFERENCES Users(user_id);


-- =========================================
-- SUMMARY TABLE FOR USER ACTIVITY REPORTS
-- =========================================
IF OBJECT_ID('UserActivitySummary', 'U') IS NOT NULL DROP TABLE UserActivitySummary;
GO

CREATE TABLE UserActivitySummary (
    summary_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    total_logins INT DEFAULT 0,
    total_actions INT DEFAULT 0,
    last_activity DATETIME,
    most_frequent_action NVARCHAR(100),
    last_updated DATETIME DEFAULT GETDATE()
);
GO


-- =========================================
-- VIEW: DETAILED USER ACTIVITY
-- =========================================
IF OBJECT_ID('vw_UserActivityDetails', 'V') IS NOT NULL DROP VIEW vw_UserActivityDetails;
GO

CREATE VIEW vw_UserActivityDetails AS
SELECT 
    u.user_id,
    u.username,
    u.role,
    COUNT(sl.log_id) AS total_actions,
    MIN(sl.log_date) AS first_action,
    MAX(sl.log_date) AS last_action,
    MAX(sl.action) AS last_action_type
FROM Users u
LEFT JOIN SystemLogs sl ON u.user_id = sl.user_id
GROUP BY u.user_id, u.username, u.role;
GO


-- =========================================
-- STORED PROCEDURE: REFRESH USER ACTIVITY SUMMARY
-- =========================================
IF OBJECT_ID('sp_RefreshUserActivitySummary', 'P') IS NOT NULL DROP PROCEDURE sp_RefreshUserActivitySummary;
GO

CREATE PROCEDURE sp_RefreshUserActivitySummary
AS
BEGIN
    SET NOCOUNT ON;

    MERGE UserActivitySummary AS target
    USING (
        SELECT 
            u.user_id,
            COUNT(sl.log_id) AS total_actions,
            MAX(sl.log_date) AS last_activity,
            (
                SELECT TOP 1 sl2.action
                FROM SystemLogs sl2
                WHERE sl2.user_id = u.user_id
                GROUP BY sl2.action
                ORDER BY COUNT(sl2.action) DESC
            ) AS most_frequent_action
        FROM Users u
        LEFT JOIN SystemLogs sl ON u.user_id = sl.user_id
        GROUP BY u.user_id
    ) AS src
    ON target.user_id = src.user_id
    WHEN MATCHED THEN
        UPDATE SET 
            target.total_actions = src.total_actions,
            target.last_activity = src.last_activity,
            target.most_frequent_action = src.most_frequent_action,
            target.last_updated = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (user_id, total_actions, last_activity, most_frequent_action, last_updated)
        VALUES (src.user_id, src.total_actions, src.last_activity, src.most_frequent_action, GETDATE());
END;
GO


-- =========================================
-- STORED PROCEDURE: GENERATE USER ACTIVITY REPORT
-- =========================================
IF OBJECT_ID('sp_GenerateUserActivityReport', 'P') IS NOT NULL DROP PROCEDURE sp_GenerateUserActivityReport;
GO

CREATE PROCEDURE sp_GenerateUserActivityReport
    @auditor_id INT,
    @export_format NVARCHAR(10) = 'Excel'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @reportData NVARCHAR(MAX);

    SET @reportData = (
        SELECT 
            u.username,
            u.role,
            s.total_actions,
            s.last_activity,
            s.most_frequent_action
        FROM UserActivitySummary s
        JOIN Users u ON s.user_id = u.user_id
        FOR JSON AUTO
    );

    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES (@auditor_id, 'UserActivity', GETDATE(), @reportData, @export_format, 'Automated activity report generated.');

END;
GO


-- =========================================
-- TRIGGER: AUTO LOG USER UPDATES
-- =========================================
IF OBJECT_ID('trg_LogUserUpdate', 'TR') IS NOT NULL DROP TRIGGER trg_LogUserUpdate;
GO



-- =========================================
-- EXECUTE REFRESH AND GENERATE REPORT
-- (Move to end of script after all inserts)
-- =========================================
-- This section should be at the END of the script after all users are inserted
DECLARE @auditor2_id INT = (SELECT user_id FROM Users WHERE username = 'auditor2');
IF @auditor2_id IS NULL SET @auditor2_id = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor');

IF @auditor2_id IS NOT NULL
BEGIN
    EXEC sp_RefreshUserActivitySummary;
    EXEC sp_GenerateUserActivityReport @auditor_id = @auditor2_id, @export_format = 'Excel';
END
ELSE
BEGIN
    PRINT 'Warning: No auditor found to generate report';
END
GO

-- =========================================
-- VALIDATION QUERIES
-- =========================================
SELECT * FROM UserActivitySummary;
SELECT * FROM AuditReports WHERE report_type = 'UserActivity';
SELECT * FROM vw_UserActivityDetails;
GO


USE SWP391;
GO

-- =============================================
-- Stored Procedure: sp_GetUserActivitySummary
-- =============================================
IF OBJECT_ID('sp_GetUserActivitySummary', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActivitySummary;
GO

CREATE PROCEDURE sp_GetUserActivitySummary
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Role NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.user_id,
        u.username,
        u.email,
        u.role,
        COUNT(sl.log_id) AS total_actions,
        COUNT(DISTINCT CAST(sl.log_date AS DATE)) AS active_days,
        SUM(CASE WHEN sl.action = 'LOGIN' THEN 1 ELSE 0 END) AS login_count,
        MIN(sl.log_date) AS first_activity,
        MAX(sl.log_date) AS last_activity,
        (
            SELECT TOP 1 action 
            FROM SystemLogs 
            WHERE user_id = u.user_id
            GROUP BY action
            ORDER BY COUNT(*) DESC
        ) AS most_common_action
    FROM Users u
    LEFT JOIN SystemLogs sl ON u.user_id = sl.user_id
    WHERE 
        (@StartDate IS NULL OR CAST(sl.log_date AS DATE) >= @StartDate)
        AND (@EndDate IS NULL OR CAST(sl.log_date AS DATE) <= @EndDate)
        AND (@Role IS NULL OR u.role = @Role)
    GROUP BY u.user_id, u.username, u.email, u.role
    HAVING COUNT(sl.log_id) > 0
    ORDER BY total_actions DESC;
END;
GO

USE SWP391;
GO

-- =============================================
-- Stored Procedure: sp_GetUserActivityReport (DETAILED)
-- =============================================
IF OBJECT_ID('sp_GetUserActivityReport', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActivityReport;
GO

CREATE PROCEDURE sp_GetUserActivityReport
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Role NVARCHAR(50) = NULL,
    @Username NVARCHAR(50) = NULL,
    @Action NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sl.log_id,
        sl.user_id,
        u.username,
        u.email,
        u.role,
        sl.action,
        sl.table_name,
        sl.record_id,
        sl.old_value,
        sl.new_value,
        sl.details,
        sl.ip_address,
        sl.log_date
    FROM SystemLogs sl
    INNER JOIN Users u ON sl.user_id = u.user_id
    WHERE 
        (@StartDate IS NULL OR CAST(sl.log_date AS DATE) >= @StartDate)
        AND (@EndDate IS NULL OR CAST(sl.log_date AS DATE) <= @EndDate)
        AND (@Role IS NULL OR u.role = @Role)
        AND (@Username IS NULL OR u.username LIKE '%' + @Username + '%')
        AND (@Action IS NULL OR sl.action = @Action)
    ORDER BY sl.log_date DESC;
END;
GO

USE SWP391;
GO

-- Xóa trigger lỗi
IF OBJECT_ID('trg_LogUserUpdate', 'TR') IS NOT NULL 
    DROP TRIGGER trg_LogUserUpdate;
GO

GO

-- =========================================
-- INSERT 5 RECORDS PER TABLE (Only if not exists)
-- (Excluding SystemConfig and Permissions)
-- =========================================
-- =========================================
-- 1. USERS (5 additional records if needed)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'doctor2')
BEGIN
    INSERT INTO Users (username, password_hash, email, phone, role, is_active)
    VALUES 
    ('doctor2', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'doctor2@hospital.com', '0901111112', 'Doctor', 1),
    ('pharma2', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'pharma2@hospital.com', '0902222223', 'Pharmacist', 1),
    ('manager2', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'manager2@hospital.com', '0903333334', 'Manager', 1),
    ('auditor2', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'auditor2@hospital.com', '0904444445', 'Auditor', 1),
    ('supplier2', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 'supplier2@example.com', '0905555556', 'Supplier', 1);
END
GO

-- =========================================
-- 2. SUPPLIERS (4 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE name = N'Công ty Dược B')
BEGIN
    DECLARE @supplier2UserId INT = (SELECT user_id FROM Users WHERE username = 'supplier2');
    
    IF @supplier2UserId IS NOT NULL
    BEGIN
        INSERT INTO Suppliers (user_id, name, contact_email, contact_phone, address, performance_rating)
        VALUES (@supplier2UserId, N'Công ty Dược B', 'contact@duocb.vn', '0905555556', N'123 Đường B, Quận 1, TP.HCM', 4.3);
    END
END

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE name = N'Công ty Dược C')
BEGIN
    INSERT INTO Suppliers (name, contact_email, contact_phone, address, performance_rating)
    VALUES (N'Công ty Dược C', 'contact@duocc.vn', '0907777777', N'789 Đường GHI, Quận 3, TP.HCM', 4.8);
END

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE name = N'Công ty Dược D')
BEGIN
    INSERT INTO Suppliers (name, contact_email, contact_phone, address, performance_rating)
    VALUES (N'Công ty Dược D', 'contact@duocd.vn', '0908888888', N'321 Đường JKL, Quận 4, TP.HCM', 4.0);
END

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE name = N'Công ty Dược E')
BEGIN
    INSERT INTO Suppliers (name, contact_email, contact_phone, address, performance_rating)
    VALUES (N'Công ty Dược E', 'contact@duoce.vn', '0909999999', N'654 Đường MNO, Quận 5, TP.HCM', 4.6);
END

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE name = N'Công ty Dược F')
BEGIN
    INSERT INTO Suppliers (name, contact_email, contact_phone, address, performance_rating)
    VALUES (N'Công ty Dược F', 'contact@duocf.vn', '0900000000', N'987 Đường PQR, Quận 6, TP.HCM', 4.1);
END
GO

-- =========================================
-- 3. MEDICINES (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Medicines WHERE medicine_code = 'MED006')
BEGIN
    INSERT INTO Medicines (medicine_code, name, category, description, active_ingredient, dosage_form, strength, unit, manufacturer, country_of_origin, drug_group, drug_type)
    VALUES
    ('MED006', N'Ibuprofen 400mg', N'Giảm đau - Hạ sốt', N'Thuốc giảm đau, chống viêm', N'Ibuprofen', N'Viên nén', N'400mg', N'Viên', N'Hasan Pharma', N'Việt Nam', N'Nhóm A', N'Bảo hiểm'),
    ('MED007', N'Cetirizine 10mg', N'Chống dị ứng', N'Thuốc chống dị ứng', N'Cetirizine HCl', N'Viên nén', N'10mg', N'Viên', N'Traphaco', N'Việt Nam', N'Nhóm A', N'Khác'),
    ('MED008', N'Atorvastatin 10mg', N'Tim mạch', N'Thuốc điều trị cholesterol cao', N'Atorvastatin', N'Viên nén', N'10mg', N'Viên', N'Boston Pharma', N'Việt Nam', N'Nhóm C', N'Đặc trị'),
    ('MED009', N'Losartan 50mg', N'Tim mạch', N'Thuốc điều trị tăng huyết áp', N'Losartan', N'Viên nén', N'50mg', N'Viên', N'Medipharco', N'Việt Nam', N'Nhóm B', N'Đặc trị'),
    ('MED010', N'Clopidogrel 75mg', N'Tim mạch', N'Thuốc chống kết tập tiểu cầu', N'Clopidogrel', N'Viên nén', N'75mg', N'Viên', N'Stada Vietnam', N'Việt Nam', N'Nhóm C', N'Đặc trị');
END
GO

-- =========================================
-- 4. BATCHES (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Batches WHERE lot_number = 'LOT2025001')
BEGIN
    DECLARE @supp2 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược B');
    DECLARE @supp3 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược C');
    DECLARE @supp4 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược D');
    DECLARE @supp5 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược E');
    DECLARE @supp6 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược F');

    INSERT INTO Batches (medicine_code, supplier_id, lot_number, expiry_date, received_date, initial_quantity, current_quantity, status, quarantine_notes)
    VALUES
    ('MED006', @supp2, 'LOT2025001', DATEADD(YEAR, 2, GETDATE()), GETDATE()-8, 1200, 1150, 'Approved', N'Đã kiểm định đạt chuẩn'),
    ('MED007', @supp3, 'LOT2025002', DATEADD(MONTH, 20, GETDATE()), GETDATE()-6, 900, 900, 'Quarantined', N'Đang chờ phê duyệt'),
    ('MED008', @supp4, 'LOT2025003', DATEADD(YEAR, 3, GETDATE()), GETDATE()-4, 700, 680, 'Approved', N'Chất lượng tốt'),
    ('MED009', @supp5, 'LOT2025004', DATEADD(MONTH, 22, GETDATE()), GETDATE()-2, 850, 850, 'Received', N'Vừa nhập kho'),
    ('MED010', @supp6, 'LOT2025005', DATEADD(YEAR, 2, GETDATE()), GETDATE(), 1100, 1100, 'Quarantined', N'Đang kiểm tra chất lượng');
END
GO

-- =========================================
-- 5. MEDICATION REQUESTS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM MedicationRequests WHERE notes LIKE N'%Khoa Nhi%')
BEGIN
    DECLARE @doc2 INT = (SELECT user_id FROM Users WHERE username = 'doctor2');
    IF @doc2 IS NULL SET @doc2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Doctor');

    INSERT INTO MedicationRequests (doctor_id, status, request_date, notes)
    VALUES
    (@doc2, 'Pending', GETDATE(), N'Yêu cầu thuốc cho Khoa Nhi'),
    (@doc2, 'Approved', GETDATE()-1, N'Thuốc điều trị khẩn cấp'),
    (@doc2, 'Fulfilled', GETDATE()-4, N'Thuốc cho bệnh nhân nội trú'),
    (@doc2, 'Pending', GETDATE()-2, N'Bổ sung kho thuốc khoa Phụ sản'),
    (@doc2, 'Canceled', GETDATE()-3, N'Yêu cầu đã hủy');
END
GO

-- =========================================
-- 6. MEDICATION REQUEST ITEMS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM MedicationRequestItems mri 
    INNER JOIN MedicationRequests mr ON mri.request_id = mr.request_id 
    WHERE mr.notes LIKE N'%Khoa Nhi%')
BEGIN
    DECLARE @req1 INT = (SELECT TOP 1 request_id FROM MedicationRequests WHERE notes LIKE N'%Khoa Nhi%' ORDER BY request_id DESC);
    DECLARE @req2 INT = (SELECT TOP 1 request_id FROM MedicationRequests WHERE notes LIKE N'%khẩn cấp%' ORDER BY request_id DESC);
    DECLARE @req3 INT = (SELECT TOP 1 request_id FROM MedicationRequests WHERE notes LIKE N'%nội trú%' ORDER BY request_id DESC);

    IF @req1 IS NOT NULL AND @req2 IS NOT NULL AND @req3 IS NOT NULL
    BEGIN
        INSERT INTO MedicationRequestItems (request_id, medicine_code, quantity)
        VALUES
        (@req1, 'MED006', 120),
        (@req1, 'MED007', 80),
        (@req2, 'MED008', 150),
        (@req3, 'MED009', 90),
        (@req3, 'MED010', 100);
    END
END
GO

-- =========================================
-- 7. PURCHASE ORDERS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM PurchaseOrders WHERE notes LIKE N'%Đơn hàng tháng 11%')
BEGIN
    DECLARE @mgr2 INT = (SELECT user_id FROM Users WHERE username = 'manager2');
    IF @mgr2 IS NULL SET @mgr2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Manager');
    
    DECLARE @supp2 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược B');
    DECLARE @supp3 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược C');
    DECLARE @supp4 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược D');
    DECLARE @supp5 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược E');
    DECLARE @supp6 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược F');

    INSERT INTO PurchaseOrders (manager_id, supplier_id, status, order_date, expected_delivery_date, notes)
    VALUES
    (@mgr2, @supp2, 'Draft', GETDATE(), DATEADD(DAY, 8, GETDATE()), N'Đơn hàng tháng 11/2025'),
    (@mgr2, @supp3, 'Sent', GETDATE()-2, DATEADD(DAY, 6, GETDATE()), N'Đặt hàng bổ sung khẩn'),
    (@mgr2, @supp4, 'Approved', GETDATE()-4, DATEADD(DAY, 4, GETDATE()), N'Đơn hàng định kỳ'),
    (@mgr2, @supp5, 'Received', GETDATE()-12, GETDATE()-3, N'Đã nhận hàng hoàn tất'),
    (@mgr2, @supp6, 'Completed', GETDATE()-20, GETDATE()-10, N'Đơn đã thanh toán xong');
END
GO

-- =========================================
-- 8. PURCHASE ORDER ITEMS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM PurchaseOrderItems poi 
    INNER JOIN PurchaseOrders po ON poi.po_id = po.po_id 
    WHERE po.notes LIKE N'%tháng 11%')
BEGIN
    DECLARE @po1 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%tháng 11%' ORDER BY po_id DESC);
    DECLARE @po2 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%bổ sung khẩn%' ORDER BY po_id DESC);
    DECLARE @po3 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%định kỳ%' ORDER BY po_id DESC);

    IF @po1 IS NOT NULL AND @po2 IS NOT NULL AND @po3 IS NOT NULL
    BEGIN
        INSERT INTO PurchaseOrderItems (po_id, medicine_code, quantity, unit_price, priority, notes)
        VALUES
        (@po1, 'MED006', 600, 6000, 'High', N'Mức ưu tiên cao'),
        (@po1, 'MED007', 400, 4500, 'Medium', N''),
        (@po2, 'MED008', 350, 18000, 'Critical', N'Rất cần gấp'),
        (@po3, 'MED009', 300, 14000, 'Low', N''),
        (@po3, 'MED010', 450, 22000, 'Medium', N'');
    END
END
GO

-- =========================================
-- 9. ADVANCED SHIPPING NOTICES (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025001')
BEGIN
    DECLARE @po1 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%tháng 11%' ORDER BY po_id DESC);
    DECLARE @po2 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%bổ sung khẩn%' ORDER BY po_id DESC);
    DECLARE @po3 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%định kỳ%' ORDER BY po_id DESC);
    DECLARE @po4 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%hoàn tất%' ORDER BY po_id DESC);
    DECLARE @po5 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%thanh toán xong%' ORDER BY po_id DESC);
    DECLARE @supp2 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược B');
    DECLARE @supp3 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược C');
    DECLARE @supp4 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược D');
    DECLARE @supp5 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược E');
    DECLARE @supp6 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược F');

    IF @po1 IS NOT NULL
    BEGIN
        INSERT INTO AdvancedShippingNotices (po_id, supplier_id, shipment_date, carrier, tracking_number, status, submitted_by, submitted_at)
        VALUES
        (@po1, @supp2, GETDATE(), N'Vietnam Post', 'VN2025001', 'Sent', 'supplier2', GETDATE()),
        (@po2, @supp3, GETDATE()-1, N'Grab Express', 'GE2025001', 'InTransit', 'supplier_c', GETDATE()-1),
        (@po3, @supp4, GETDATE()-3, N'Shopee Express', 'SE2025001', 'Delivered', 'supplier_d', GETDATE()-3),
        (@po4, @supp5, GETDATE()-11, N'Kerry Express', 'KE2025001', 'Delivered', 'supplier_e', GETDATE()-11),
        (@po5, @supp6, GETDATE()-19, N'Vietnam Post', 'VN2025002', 'Delivered', 'supplier_f', GETDATE()-19);
    END
END
GO

-- =========================================
-- 10. ASN ITEMS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM ASNItems ai 
    INNER JOIN AdvancedShippingNotices asn ON ai.asn_id = asn.asn_id 
    WHERE asn.tracking_number = 'VN2025001')
BEGIN
    DECLARE @asn1 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025001' ORDER BY asn_id DESC);
    DECLARE @asn2 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'GE2025001' ORDER BY asn_id DESC);
    DECLARE @asn3 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'SE2025001' ORDER BY asn_id DESC);
    DECLARE @asn4 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'KE2025001' ORDER BY asn_id DESC);
    DECLARE @asn5 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025002' ORDER BY asn_id DESC);

    IF @asn1 IS NOT NULL
    BEGIN
        INSERT INTO ASNItems (asn_id, medicine_code, quantity, lot_number)
        VALUES
        (@asn1, 'MED006', 600, 'LOT2025001'),
        (@asn2, 'MED007', 400, 'LOT2025002'),
        (@asn3, 'MED008', 350, 'LOT2025003'),
        (@asn4, 'MED009', 300, 'LOT2025004'),
        (@asn5, 'MED010', 450, 'LOT2025005');
    END
END
GO

-- =========================================
-- 11. DELIVERY NOTES (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM DeliveryNotes WHERE notes LIKE N'%Nhận hàng một phần%')
BEGIN
    DECLARE @asn1 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025001' ORDER BY asn_id DESC);
    DECLARE @asn2 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'GE2025001' ORDER BY asn_id DESC);
    DECLARE @asn3 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'SE2025001' ORDER BY asn_id DESC);
    DECLARE @asn4 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'KE2025001' ORDER BY asn_id DESC);
    DECLARE @asn5 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025002' ORDER BY asn_id DESC);
    DECLARE @po1 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%tháng 11%' ORDER BY po_id DESC);
    DECLARE @po2 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%bổ sung khẩn%' ORDER BY po_id DESC);
    DECLARE @po3 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%định kỳ%' ORDER BY po_id DESC);
    DECLARE @po4 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%hoàn tất%' ORDER BY po_id DESC);
    DECLARE @po5 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%thanh toán xong%' ORDER BY po_id DESC);
    DECLARE @phar2 INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
    IF @phar2 IS NULL SET @phar2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Pharmacist');

    IF @asn1 IS NOT NULL
    BEGIN
        INSERT INTO DeliveryNotes (asn_id, po_id, delivery_date, received_by, status, notes)
        VALUES
        (@asn1, @po1, GETDATE(), @phar2, 'Partial', N'Nhận hàng một phần'),
        (@asn2, @po2, GETDATE()-1, @phar2, 'Complete', N'Nhận đủ số lượng'),
        (@asn3, @po3, GETDATE()-2, @phar2, 'Complete', N'Hàng tốt, đã nhập kho'),
        (@asn4, @po4, GETDATE()-10, @phar2, 'Complete', N'Đã kiểm tra và lưu kho'),
        (@asn5, @po5, GETDATE()-18, @phar2, 'Discrepant', N'Thiếu hàng so với đơn');
    END
END
GO

-- =========================================
-- 12. INVOICES (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Invoices WHERE invoice_number = 'INV2025001')
BEGIN
    DECLARE @asn1 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025001' ORDER BY asn_id DESC);
    DECLARE @asn2 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'GE2025001' ORDER BY asn_id DESC);
    DECLARE @asn3 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'SE2025001' ORDER BY asn_id DESC);
    DECLARE @asn4 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'KE2025001' ORDER BY asn_id DESC);
    DECLARE @asn5 INT = (SELECT TOP 1 asn_id FROM AdvancedShippingNotices WHERE tracking_number = 'VN2025002' ORDER BY asn_id DESC);
    DECLARE @po1 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%tháng 11%' ORDER BY po_id DESC);
    DECLARE @po2 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%bổ sung khẩn%' ORDER BY po_id DESC);
    DECLARE @po3 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%định kỳ%' ORDER BY po_id DESC);
    DECLARE @po4 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%hoàn tất%' ORDER BY po_id DESC);
    DECLARE @po5 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%thanh toán xong%' ORDER BY po_id DESC);
    DECLARE @supp2 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược B');
    DECLARE @supp3 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược C');
    DECLARE @supp4 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược D');
    DECLARE @supp5 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược E');
    DECLARE @supp6 INT = (SELECT TOP 1 supplier_id FROM Suppliers WHERE name = N'Công ty Dược F');

    IF @po1 IS NOT NULL
    BEGIN
        INSERT INTO Invoices (po_id, asn_id, supplier_id, invoice_number, invoice_date, amount, status, notes)
        VALUES
        (@po1, @asn1, @supp2, 'INV2025001', GETDATE(), 3600000, 'Pending', N'Chờ thanh toán'),
        (@po2, @asn2, @supp3, 'INV2025002', GETDATE()-1, 1800000, 'Pending', N'Đang xử lý'),
        (@po3, @asn3, @supp4, 'INV2025003', GETDATE()-2, 6300000, 'Paid', N'Đã thanh toán'),
        (@po4, @asn4, @supp5, 'INV2025004', GETDATE()-10, 4200000, 'Paid', N'Hoàn thành'),
        (@po5, @asn5, @supp6, 'INV2025005', GETDATE()-18, 9900000, 'Disputed', N'Đang tranh chấp về giá');
    END
END
GO

-- =========================================
-- 13. TRANSACTIONS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Transactions WHERE notes LIKE N'%Nhập kho lô 2025%')
BEGIN
    DECLARE @batch6 INT = (SELECT TOP 1 batch_id FROM Batches WHERE lot_number = 'LOT2025001');
    DECLARE @batch7 INT = (SELECT TOP 1 batch_id FROM Batches WHERE lot_number = 'LOT2025002');
    DECLARE @batch8 INT = (SELECT TOP 1 batch_id FROM Batches WHERE lot_number = 'LOT2025003');
    DECLARE @dn1 INT = (SELECT TOP 1 dn_id FROM DeliveryNotes WHERE notes LIKE N'%Nhận hàng một phần%' ORDER BY dn_id DESC);
    DECLARE @dn2 INT = (SELECT TOP 1 dn_id FROM DeliveryNotes WHERE notes LIKE N'%Nhận đủ%' ORDER BY dn_id DESC);
    DECLARE @phar2 INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
    IF @phar2 IS NULL SET @phar2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Pharmacist');

    IF @batch6 IS NOT NULL
    BEGIN
        INSERT INTO Transactions (batch_id, user_id, dn_id, type, quantity, transaction_date, notes)
        VALUES
        (@batch6, @phar2, @dn1, 'In', 600, GETDATE()-8, N'Nhập kho lô 2025-001'),
        (@batch8, @phar2, @dn2, 'In', 350, GETDATE()-4, N'Nhập kho lô 2025-003'),
        (@batch6, @phar2, NULL, 'Out', 50, GETDATE()-2, N'Xuất cho khoa Tim mạch'),
        (@batch8, @phar2, NULL, 'Out', 70, GETDATE()-1, N'Xuất điều trị'),
        (@batch7, @phar2, NULL, 'QuarantineRelease', 900, GETDATE(), N'Phê duyệt xuất kho');
    END
END
GO

-- =========================================
-- 14. TASKS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM Tasks WHERE task_type = 'Review New PO')
BEGIN
    DECLARE @po1 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%tháng 11%' ORDER BY po_id DESC);
    DECLARE @po2 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%bổ sung khẩn%' ORDER BY po_id DESC);
    DECLARE @po3 INT = (SELECT TOP 1 po_id FROM PurchaseOrders WHERE notes LIKE N'%định kỳ%' ORDER BY po_id DESC);
    DECLARE @mgr2 INT = (SELECT user_id FROM Users WHERE username = 'manager2');
    IF @mgr2 IS NULL SET @mgr2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Manager');
    DECLARE @phar2 INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
    IF @phar2 IS NULL SET @phar2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Pharmacist');

    IF @po1 IS NOT NULL
    BEGIN
        INSERT INTO Tasks (po_id, staff_id, task_type, deadline, status)
        VALUES
        (@po1, @mgr2, 'Review New PO', DATEADD(DAY, 1, GETDATE()), 'Pending'),
        (@po2, @mgr2, 'Expedite Order', GETDATE(), 'In Progress'),
        (@po3, @phar2, 'Stock Verification', DATEADD(DAY, 2, GETDATE()), 'Completed'),
        (@po1, @phar2, 'Incoming Inspection', DATEADD(DAY, 4, GETDATE()), 'Pending'),
        (@po2, @mgr2, 'Payment Processing', DATEADD(DAY, 7, GETDATE()), 'Pending');
    END
END
GO

-- =========================================
-- 15. SYSTEM LOGS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM SystemLogs WHERE details LIKE N'%Manager2%')
BEGIN
    DECLARE @mgr2 INT = (SELECT user_id FROM Users WHERE username = 'manager2');
    IF @mgr2 IS NULL SET @mgr2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Manager' ORDER BY user_id DESC);
    DECLARE @doc2 INT = (SELECT user_id FROM Users WHERE username = 'doctor2');
    IF @doc2 IS NULL SET @doc2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Doctor' ORDER BY user_id DESC);
    DECLARE @phar2 INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
    IF @phar2 IS NULL SET @phar2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Pharmacist' ORDER BY user_id DESC);
    DECLARE @aud2 INT = (SELECT user_id FROM Users WHERE username = 'auditor2');
    IF @aud2 IS NULL SET @aud2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor' ORDER BY user_id DESC);

    
END
GO

-- =========================================
-- 16. AUDIT REPORTS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM AuditReports WHERE notes LIKE N'%Đánh giá tháng 10%')
BEGIN
    DECLARE @aud2 INT = (SELECT user_id FROM Users WHERE username = 'auditor2');
    IF @aud2 IS NULL SET @aud2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor' ORDER BY user_id DESC);

    
END
GO

-- =========================================
-- 17. USER PERMISSIONS (Assign to new users)
-- =========================================
DECLARE @doc2 INT = (SELECT user_id FROM Users WHERE username = 'doctor2');
DECLARE @phar2 INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
DECLARE @mgr2 INT = (SELECT user_id FROM Users WHERE username = 'manager2');
DECLARE @aud2 INT = (SELECT user_id FROM Users WHERE username = 'auditor2');
DECLARE @supp2 INT = (SELECT user_id FROM Users WHERE username = 'supplier2');

-- Doctor2: view inventory
IF @doc2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @doc2)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id)
    SELECT @doc2, permission_id FROM Permissions WHERE permission_name = 'view_inventory';
END

-- Pharmacist2: view, manage stock, manage quarantine, confirm delivery
IF @phar2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @phar2)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id)
    SELECT @phar2, permission_id FROM Permissions 
    WHERE permission_name IN ('view_inventory', 'manage_stock', 'manage_quarantine', 'confirm_delivery');
END

-- Manager2: view, manage stock, approve PO, manage quarantine, confirm delivery
IF @mgr2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @mgr2)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id)
    SELECT @mgr2, permission_id FROM Permissions 
    WHERE permission_name IN ('view_inventory', 'manage_stock', 'approve_po', 'manage_quarantine', 'confirm_delivery');
END

-- Auditor2: view inventory, audit logs
IF @aud2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @aud2)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id)
    SELECT @aud2, permission_id FROM Permissions 
    WHERE permission_name IN ('view_inventory', 'audit_logs');
END

-- Supplier2: create ASN
IF @supp2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @supp2)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id)
    SELECT @supp2, permission_id FROM Permissions 
    WHERE permission_name = 'create_asn';
END
GO

-- =========================================
-- 18. USER ACTIVITY SUMMARY (Refresh)
-- =========================================
EXEC sp_RefreshUserActivitySummary;
GO

IF OBJECT_ID('Messages', 'U') IS NOT NULL DROP TABLE Messages;
GO

CREATE TABLE Messages (
    message_id INT IDENTITY(1,1) PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    message_content NVARCHAR(MAX) NOT NULL,
    is_read BIT DEFAULT 0,
    sent_at DATETIME DEFAULT GETDATE(),
    message_type NVARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text','notification','alert')),
    
    -- Foreign keys with NO ACTION to avoid cascade conflicts
    CONSTRAINT FK_Messages_Sender FOREIGN KEY (sender_id) 
        REFERENCES Users(user_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_Messages_Receiver FOREIGN KEY (receiver_id) 
        REFERENCES Users(user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- Create indexes for better performance
CREATE INDEX idx_messages_receiver ON Messages(receiver_id);
CREATE INDEX idx_messages_sender ON Messages(sender_id);
CREATE INDEX idx_messages_sent_at ON Messages(sent_at DESC);
GO

-- Insert sample messages (optional - for testing)
DECLARE @admin_id INT = (SELECT user_id FROM Users WHERE username = 'admin');
DECLARE @doctor2_id INT = (SELECT user_id FROM Users WHERE username = 'doctor2');
DECLARE @pharma2_id INT = (SELECT user_id FROM Users WHERE username = 'pharma2');
DECLARE @manager2_id INT = (SELECT user_id FROM Users WHERE username = 'manager2');

IF @admin_id IS NOT NULL AND @doctor2_id IS NOT NULL
BEGIN
    INSERT INTO Messages (sender_id, receiver_id, message_content, message_type, is_read, sent_at)
    VALUES 
    (@admin_id, @doctor2_id, N'Chào bác sĩ, có yêu cầu thuốc mới cần duyệt', 'notification', 0, GETDATE()),
    (@doctor2_id, @admin_id, N'Cảm ơn, tôi sẽ kiểm tra ngay', 'text', 1, DATEADD(MINUTE, 5, GETDATE())),
    (@pharma2_id, @manager2_id, N'Kho thuốc Paracetamol sắp hết, cần đặt hàng', 'alert', 0, DATEADD(HOUR, -2, GETDATE())),
    (@manager2_id, @pharma2_id, N'Đã tạo đơn đặt hàng mới', 'text', 1, DATEADD(HOUR, -1, GETDATE())),
    (@admin_id, @pharma2_id, N'Vui lòng kiểm tra lô thuốc mới nhập kho', 'notification', 0, DATEADD(DAY, -1, GETDATE()));
END
GO

USE SWP391;
GO

-- =========================================
-- NOTIFICATIONS TABLE
-- =========================================
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
GO

CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    sender_id INT,
    receiver_id INT NULL, -- NULL means broadcast to all users
    title NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    notification_type NVARCHAR(50) DEFAULT 'info' CHECK (notification_type IN ('info','warning','success','error','alert')),
    is_read BIT DEFAULT 0,
    is_broadcast BIT DEFAULT 0, -- TRUE if sent to all users
    priority NVARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    created_at DATETIME DEFAULT GETDATE(),
    read_at DATETIME NULL,
    expires_at DATETIME NULL,
    link_url NVARCHAR(500) NULL, -- Optional link to related page
    
    CONSTRAINT FK_Notifications_Sender FOREIGN KEY (sender_id) 
        REFERENCES Users(user_id) ON DELETE NO ACTION,
    CONSTRAINT FK_Notifications_Receiver FOREIGN KEY (receiver_id) 
        REFERENCES Users(user_id) ON DELETE CASCADE
);
GO

-- Create indexes for better performance
CREATE INDEX idx_notifications_receiver ON Notifications(receiver_id);
CREATE INDEX idx_notifications_created ON Notifications(created_at DESC);
CREATE INDEX idx_notifications_unread ON Notifications(receiver_id, is_read) WHERE is_read = 0;
CREATE INDEX idx_notifications_broadcast ON Notifications(is_broadcast) WHERE is_broadcast = 1;
GO

-- =========================================
-- STORED PROCEDURE: Send Notification to All Users
-- =========================================
IF OBJECT_ID('sp_SendBroadcastNotification', 'P') IS NOT NULL 
    DROP PROCEDURE sp_SendBroadcastNotification;
GO

CREATE PROCEDURE sp_SendBroadcastNotification
    @sender_id INT,
    @title NVARCHAR(200),
    @message NVARCHAR(MAX),
    @notification_type NVARCHAR(50) = 'info',
    @priority NVARCHAR(20) = 'normal',
    @link_url NVARCHAR(500) = NULL,
    @expires_at DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insert notification for each active user (except sender)
    INSERT INTO Notifications (sender_id, receiver_id, title, message, notification_type, is_broadcast, priority, link_url, expires_at)
    SELECT 
        @sender_id,
        user_id,
        @title,
        @message,
        @notification_type,
        1,
        @priority,
        @link_url,
        @expires_at
    FROM Users
    WHERE is_active = 1 AND user_id != @sender_id;
    
    SELECT @@ROWCOUNT AS notifications_sent;
END;
GO

-- =========================================
-- STORED PROCEDURE: Get Unread Count for User
-- =========================================
IF OBJECT_ID('sp_GetUnreadNotificationCount', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUnreadNotificationCount;
GO

CREATE PROCEDURE sp_GetUnreadNotificationCount
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT COUNT(*) AS unread_count
    FROM Notifications
    WHERE receiver_id = @user_id 
        AND is_read = 0
        AND (expires_at IS NULL OR expires_at > GETDATE());
END;
GO

-- =========================================
-- STORED PROCEDURE: Mark Notification as Read
-- =========================================
IF OBJECT_ID('sp_MarkNotificationAsRead', 'P') IS NOT NULL 
    DROP PROCEDURE sp_MarkNotificationAsRead;
GO

CREATE PROCEDURE sp_MarkNotificationAsRead
    @notification_id INT,
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Notifications
    SET is_read = 1, read_at = GETDATE()
    WHERE notification_id = @notification_id 
        AND receiver_id = @user_id
        AND is_read = 0;
    
    SELECT @@ROWCOUNT AS updated;
END;
GO

-- =========================================
-- STORED PROCEDURE: Mark All Notifications as Read
-- =========================================
IF OBJECT_ID('sp_MarkAllNotificationsAsRead', 'P') IS NOT NULL 
    DROP PROCEDURE sp_MarkAllNotificationsAsRead;
GO

CREATE PROCEDURE sp_MarkAllNotificationsAsRead
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Notifications
    SET is_read = 1, read_at = GETDATE()
    WHERE receiver_id = @user_id AND is_read = 0;
    
    SELECT @@ROWCOUNT AS updated;
END;
GO

-- =========================================
-- SAMPLE DATA (Optional - for testing)
-- =========================================
DECLARE @admin_id INT = (SELECT user_id FROM Users WHERE username = 'admin');
DECLARE @doctor2_id INT = (SELECT user_id FROM Users WHERE username = 'doctor2');
DECLARE @pharma2_id INT = (SELECT user_id FROM Users WHERE username = 'pharma2');

IF @admin_id IS NOT NULL
BEGIN
    -- Individual notification
    INSERT INTO Notifications (sender_id, receiver_id, title, message, notification_type, priority)
    VALUES 
    (@admin_id, @doctor2_id, N'Yêu cầu thuốc mới', N'Có 3 yêu cầu thuốc đang chờ duyệt', 'warning', 'high'),
    (@admin_id, @pharma2_id, N'Kiểm tra kho', N'Vui lòng kiểm tra lô thuốc mới nhập', 'info', 'normal');
    
    -- Broadcast notification using stored procedure
    EXEC sp_SendBroadcastNotification 
        @sender_id = @admin_id,
        @title = N'Bảo trì hệ thống',
        @message = N'Hệ thống sẽ bảo trì từ 22:00 - 23:00 tối nay',
        @notification_type = 'alert',
        @priority = 'urgent';
END
GO

-- =========================================
-- VALIDATION QUERIES
-- =========================================
SELECT * FROM Notifications ORDER BY created_at DESC;
SELECT * FROM Notifications WHERE is_broadcast = 1;
GO

USE SWP391;
GO

-- =====================================================
-- CẬP NHẬT BẢNG AdvancedShippingNotices
-- =====================================================

-- 1. Thêm các cột mới nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AdvancedShippingNotices') AND name = 'submitted_by')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD submitted_by NVARCHAR(100);
    PRINT 'Added column: submitted_by';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AdvancedShippingNotices') AND name = 'submitted_at')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD submitted_at DATETIME;
    PRINT 'Added column: submitted_at';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AdvancedShippingNotices') AND name = 'approved_by')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD approved_by NVARCHAR(100);
    PRINT 'Added column: approved_by';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AdvancedShippingNotices') AND name = 'approved_at')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD approved_at DATETIME;
    PRINT 'Added column: approved_at';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AdvancedShippingNotices') AND name = 'rejection_reason')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD rejection_reason NVARCHAR(500);
    PRINT 'Added column: rejection_reason';
END

-- 2. Tìm và xóa constraint CHECK cũ của status
DECLARE @CheckConstraintName NVARCHAR(200);
SELECT @CheckConstraintName = cc.name 
FROM sys.check_constraints cc
INNER JOIN sys.columns c ON cc.parent_object_id = c.object_id 
    AND cc.parent_column_id = c.column_id
WHERE cc.parent_object_id = OBJECT_ID('AdvancedShippingNotices') 
  AND c.name = 'status';

IF @CheckConstraintName IS NOT NULL
BEGIN
    DECLARE @DropCheckSQL NVARCHAR(500) = 'ALTER TABLE AdvancedShippingNotices DROP CONSTRAINT ' + QUOTENAME(@CheckConstraintName);
    EXEC sp_executesql @DropCheckSQL;
    PRINT 'Dropped old CHECK constraint: ' + @CheckConstraintName;
END

-- 3. Thêm constraint CHECK mới
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_ASN_Status')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD CONSTRAINT CK_ASN_Status 
        CHECK (status IN ('Pending','Sent','InTransit','Delivered','Rejected','Cancelled'));
    PRINT 'Added new CHECK constraint for status';
END

-- 4. Tìm và xóa constraint DEFAULT cũ của status
DECLARE @DefaultConstraintName NVARCHAR(200);
SELECT @DefaultConstraintName = dc.name
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('AdvancedShippingNotices') 
  AND c.name = 'status';

IF @DefaultConstraintName IS NOT NULL
BEGIN
    DECLARE @DropDefaultSQL NVARCHAR(500) = 'ALTER TABLE AdvancedShippingNotices DROP CONSTRAINT ' + QUOTENAME(@DefaultConstraintName);
    EXEC sp_executesql @DropDefaultSQL;
    PRINT 'Dropped old DEFAULT constraint: ' + @DefaultConstraintName;
END

-- 5. Thêm constraint DEFAULT mới
IF NOT EXISTS (SELECT * FROM sys.default_constraints WHERE name = 'DF_ASN_Status')
BEGIN
    ALTER TABLE AdvancedShippingNotices ADD CONSTRAINT DF_ASN_Status DEFAULT 'Pending' FOR status;
    PRINT 'Added new DEFAULT constraint for status = Pending';
END

-- =====================================================
-- CẬP NHẬT BẢNG ASNItems
-- =====================================================

-- Kiểm tra xem có cần đổi medicine_id thành medicine_code không
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ASNItems') AND name = 'medicine_id')
BEGIN
    -- Kiểm tra xem có dữ liệu không
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) FROM ASNItems;
    
    IF @RowCount > 0
    BEGIN
        PRINT 'WARNING: ASNItems contains ' + CAST(@RowCount AS VARCHAR) + ' rows.';
        PRINT 'Cannot automatically migrate medicine_id to medicine_code.';
        PRINT 'Please backup data and migrate manually!';
    END
    ELSE
    BEGIN
        -- Không có dữ liệu, có thể migrate an toàn
        PRINT 'Migrating ASNItems from medicine_id to medicine_code...';
        
        -- Drop FK constraint cũ
        DECLARE @FKName NVARCHAR(200);
        SELECT @FKName = fk.name
        FROM sys.foreign_keys fk
        INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
        WHERE fk.parent_object_id = OBJECT_ID('ASNItems')
          AND COL_NAME(fk.parent_object_id, fkc.parent_column_id) = 'medicine_id';
        
        IF @FKName IS NOT NULL
        BEGIN
            DECLARE @DropFKSQL NVARCHAR(500) = 'ALTER TABLE ASNItems DROP CONSTRAINT ' + QUOTENAME(@FKName);
            EXEC sp_executesql @DropFKSQL;
            PRINT 'Dropped FK constraint: ' + @FKName;
        END
        
        -- Drop column
        ALTER TABLE ASNItems DROP COLUMN medicine_id;
        PRINT 'Dropped column: medicine_id';
        
        -- Add new column
        ALTER TABLE ASNItems ADD medicine_code NVARCHAR(50) NOT NULL;
        PRINT 'Added column: medicine_code';
        
        -- Add FK constraint
        ALTER TABLE ASNItems ADD CONSTRAINT FK_ASNItems_Medicine 
            FOREIGN KEY (medicine_code) REFERENCES Medicines(medicine_code) ON DELETE CASCADE;
        PRINT 'Added FK constraint for medicine_code';
    END
END
ELSE
BEGIN
    PRINT 'ASNItems already uses medicine_code - no migration needed';
END

-- =====================================================
-- TẠO INDEX ĐỂ TỐI ƯU PERFORMANCE
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_asn_supplier_status' AND object_id = OBJECT_ID('AdvancedShippingNotices'))
BEGIN
    CREATE INDEX idx_asn_supplier_status ON AdvancedShippingNotices(supplier_id, status);
    PRINT 'Created index: idx_asn_supplier_status';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_asn_created_at' AND object_id = OBJECT_ID('AdvancedShippingNotices'))
BEGIN
    CREATE INDEX idx_asn_created_at ON AdvancedShippingNotices(created_at DESC);
    PRINT 'Created index: idx_asn_created_at';
END

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_asnitem_medicine' AND object_id = OBJECT_ID('ASNItems'))
BEGIN
    CREATE INDEX idx_asnitem_medicine ON ASNItems(medicine_code);
    PRINT 'Created index: idx_asnitem_medicine';
END

-- =====================================================
-- CẬP NHẬT DỮ LIỆU CŨ
-- =====================================================

-- Cập nhật các ASN hiện có
UPDATE AdvancedShippingNotices 
SET status = 'InTransit', 
    submitted_at = COALESCE(submitted_at, created_at),
    updated_at = GETDATE()
WHERE status = 'Sent' AND submitted_at IS NULL;

DECLARE @UpdatedRows INT = @@ROWCOUNT;
PRINT 'Updated ' + CAST(@UpdatedRows AS VARCHAR) + ' ASN records from Sent to InTransit';

-- =====================================================
-- VERIFICATION
-- =====================================================

PRINT '';
PRINT '==========================================';
PRINT 'DATABASE UPDATE COMPLETED SUCCESSFULLY!';
PRINT '==========================================';
PRINT '';
PRINT 'ASN Status Workflow:';
PRINT '  1. Pending    -> ASN được tạo bởi Supplier';
PRINT '  2. Sent       -> Supplier xác nhận đã gửi hàng';
PRINT '  3. InTransit  -> Đang vận chuyển';
PRINT '  4. Delivered  -> Đã giao hàng thành công';
PRINT '';
PRINT 'Alternative flows:';
PRINT '  - Pending -> Cancelled (Hủy trước khi gửi)';
PRINT '  - Sent -> Rejected (Manager từ chối)';
PRINT '';

-- Kiểm tra cấu trúc bảng
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    dc.definition AS DefaultValue
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('AdvancedShippingNotices')
ORDER BY c.column_id;

GO

USE SWP391;
GO

-- =====================================================
-- PART 1: FIX AUDITREPORTS CHECK CONSTRAINT
-- =====================================================
PRINT '========================================';
PRINT 'PART 1: Fixing AuditReports Constraint';
PRINT '========================================';

-- Drop old constraint
DECLARE @ConstraintName NVARCHAR(200);
SELECT @ConstraintName = cc.name 
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('AuditReports')
  AND cc.definition LIKE '%report_type%';

IF @ConstraintName IS NOT NULL
BEGIN
    DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE AuditReports DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    EXEC sp_executesql @DropSQL;
    PRINT 'Dropped old CHECK constraint: ' + @ConstraintName;
END

-- Add new constraint
ALTER TABLE AuditReports ADD CONSTRAINT CK_AuditReports_Type 
    CHECK (report_type IN ('SupplierPerformance','PurchaseHistory','InventoryAudit','UserActivity','ComprehensiveAudit','SecurityAudit'));

PRINT 'Added new CHECK constraint with ComprehensiveAudit';
PRINT 'PART 1 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 2: CREATE AUDIT VIEWS
-- =====================================================
PRINT '========================================';
PRINT 'PART 2: Creating Audit Views';
PRINT '========================================';

-- View 1: Audit Log Details
IF OBJECT_ID('vw_AuditLogDetails', 'V') IS NOT NULL 
    DROP VIEW vw_AuditLogDetails;
GO

CREATE VIEW vw_AuditLogDetails AS
SELECT 
    sl.log_id,
    sl.user_id,
    u.username,
    u.email,
    u.role,
    sl.action,
    sl.table_name,
    sl.record_id,
    sl.old_value,
    sl.new_value,
    sl.details,
    sl.ip_address,
    sl.log_date,
    CASE 
        WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'high'
        WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'medium'
        ELSE 'low'
    END AS risk_level,
    CASE 
        WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
        WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
        WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
        ELSE 'Other'
    END AS category
FROM SystemLogs sl
LEFT JOIN Users u ON sl.user_id = u.user_id;
GO

PRINT 'Created view: vw_AuditLogDetails';

-- View 2: Daily Audit Summary
IF OBJECT_ID('vw_DailyAuditSummary', 'V') IS NOT NULL 
    DROP VIEW vw_DailyAuditSummary;
GO

CREATE VIEW vw_DailyAuditSummary AS
SELECT 
    CAST(log_date AS DATE) AS log_date,
    COUNT(*) AS total_actions,
    COUNT(DISTINCT user_id) AS active_users,
    SUM(CASE WHEN action = 'LOGIN' THEN 1 ELSE 0 END) AS login_count,
    SUM(CASE WHEN action IN ('CREATE', 'INSERT') THEN 1 ELSE 0 END) AS create_count,
    SUM(CASE WHEN action = 'UPDATE' THEN 1 ELSE 0 END) AS update_count,
    SUM(CASE WHEN action = 'DELETE' THEN 1 ELSE 0 END) AS delete_count,
    SUM(CASE WHEN action IN ('APPROVE', 'REJECT') THEN 1 ELSE 0 END) AS approval_count
FROM SystemLogs
GROUP BY CAST(log_date AS DATE);
GO

PRINT 'Created view: vw_DailyAuditSummary';

-- View 3: User Risk Profile
IF OBJECT_ID('vw_UserRiskProfile', 'V') IS NOT NULL 
    DROP VIEW vw_UserRiskProfile;
GO

CREATE VIEW vw_UserRiskProfile AS
SELECT 
    u.user_id,
    u.username,
    u.role,
    COUNT(sl.log_id) AS total_actions,
    SUM(CASE WHEN sl.action = 'DELETE' THEN 1 ELSE 0 END) AS delete_actions,
    SUM(CASE WHEN sl.action IN ('APPROVE', 'REJECT') THEN 1 ELSE 0 END) AS approval_actions,
    SUM(CASE WHEN sl.table_name = 'Users' THEN 1 ELSE 0 END) AS user_mgmt_actions,
    MAX(sl.log_date) AS last_action,
    COUNT(DISTINCT CAST(sl.log_date AS DATE)) AS active_days,
    CASE 
        WHEN SUM(CASE WHEN sl.action = 'DELETE' THEN 1 ELSE 0 END) > 10 THEN 'high'
        WHEN SUM(CASE WHEN sl.action = 'DELETE' THEN 1 ELSE 0 END) > 5 THEN 'medium'
        ELSE 'low'
    END AS risk_level
FROM Users u
LEFT JOIN SystemLogs sl ON u.user_id = sl.user_id
GROUP BY u.user_id, u.username, u.role;
GO

PRINT 'Created view: vw_UserRiskProfile';
PRINT 'PART 2 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 3: STORED PROCEDURE - GET AUDIT LOGS
-- =====================================================
PRINT '========================================';
PRINT 'PART 3: Creating sp_GetAuditLogs';
PRINT '========================================';

IF OBJECT_ID('sp_GetAuditLogs', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditLogs;
GO

CREATE PROCEDURE sp_GetAuditLogs
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @UserId INT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Role NVARCHAR(50) = NULL,
    @Action NVARCHAR(100) = NULL,
    @TableName NVARCHAR(50) = NULL,
    @RiskLevel NVARCHAR(20) = NULL,
    @Category NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Get total count
    DECLARE @TotalRecords INT;
    SELECT @TotalRecords = COUNT(*)
    FROM vw_AuditLogDetails
    WHERE 
        (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@UserId IS NULL OR user_id = @UserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category);
    
    -- Get paginated results
    SELECT 
        *,
        @TotalRecords AS total_records,
        CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize) AS total_pages
    FROM vw_AuditLogDetails
    WHERE 
        (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@UserId IS NULL OR user_id = @UserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category)
    ORDER BY log_date DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

PRINT 'Created procedure: sp_GetAuditLogs';
PRINT 'PART 3 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 4: STORED PROCEDURE - GET AUDIT STATISTICS
-- =====================================================
PRINT '========================================';
PRINT 'PART 4: Creating sp_GetAuditStatistics';
PRINT '========================================';

IF OBJECT_ID('sp_GetAuditStatistics', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditStatistics;
GO

CREATE PROCEDURE sp_GetAuditStatistics
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range if not provided
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Overall statistics
    SELECT 
        COUNT(*) AS total_actions,
        COUNT(DISTINCT user_id) AS active_users,
        COUNT(DISTINCT table_name) AS affected_tables,
        COUNT(DISTINCT CAST(log_date AS DATE)) AS active_days,
        SUM(CASE WHEN action = 'LOGIN' THEN 1 ELSE 0 END) AS total_logins,
        SUM(CASE WHEN action IN ('CREATE', 'INSERT') THEN 1 ELSE 0 END) AS total_creates,
        SUM(CASE WHEN action = 'UPDATE' THEN 1 ELSE 0 END) AS total_updates,
        SUM(CASE WHEN action = 'DELETE' THEN 1 ELSE 0 END) AS total_deletes,
        SUM(CASE WHEN action IN ('APPROVE', 'REJECT') THEN 1 ELSE 0 END) AS total_approvals
    FROM SystemLogs
    WHERE log_date BETWEEN @StartDate AND @EndDate;
    
    -- Actions by role
    SELECT 
        u.role,
        COUNT(sl.log_id) AS action_count,
        COUNT(DISTINCT sl.user_id) AS user_count
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
    GROUP BY u.role
    ORDER BY action_count DESC;
    
    -- Actions by category
    SELECT 
        CASE 
            WHEN table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
            WHEN table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
            WHEN table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
            ELSE 'Other'
        END AS category,
        COUNT(*) AS action_count
    FROM SystemLogs
    WHERE log_date BETWEEN @StartDate AND @EndDate
    GROUP BY 
        CASE 
            WHEN table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
            WHEN table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
            WHEN table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
            ELSE 'Other'
        END
    ORDER BY action_count DESC;
    
    -- Top 10 most active users
    SELECT TOP 10
        u.username,
        u.role,
        COUNT(sl.log_id) AS action_count,
        MAX(sl.log_date) AS last_action
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
    GROUP BY u.username, u.role
    ORDER BY action_count DESC;
    
    -- Daily activity trend
    SELECT 
        CAST(log_date AS DATE) AS log_date,
        COUNT(*) AS action_count,
        COUNT(DISTINCT user_id) AS active_users
    FROM SystemLogs
    WHERE log_date BETWEEN @StartDate AND @EndDate
    GROUP BY CAST(log_date AS DATE)
    ORDER BY log_date DESC;
END;
GO

PRINT 'Created procedure: sp_GetAuditStatistics';
PRINT 'PART 4 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 5: STORED PROCEDURE - EXPORT AUDIT REPORT
-- =====================================================
PRINT '========================================';
PRINT 'PART 5: Creating sp_ExportAuditReport';
PRINT '========================================';

IF OBJECT_ID('sp_ExportAuditReport', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ExportAuditReport;
GO

CREATE PROCEDURE sp_ExportAuditReport
    @auditor_id INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @ReportType NVARCHAR(50) = 'ComprehensiveAudit',
    @ExportFormat NVARCHAR(10) = 'Excel'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    DECLARE @reportData NVARCHAR(MAX);
    
    -- Generate comprehensive report data
    SET @reportData = (
        SELECT 
            'AuditSummary' AS section,
            (SELECT COUNT(*) FROM SystemLogs WHERE log_date BETWEEN @StartDate AND @EndDate) AS total_actions,
            (SELECT COUNT(DISTINCT user_id) FROM SystemLogs WHERE log_date BETWEEN @StartDate AND @EndDate) AS active_users,
            @StartDate AS period_start,
            @EndDate AS period_end,
            (
                SELECT 
                    role,
                    COUNT(*) AS action_count
                FROM SystemLogs sl
                LEFT JOIN Users u ON sl.user_id = u.user_id
                WHERE sl.log_date BETWEEN @StartDate AND @EndDate
                GROUP BY role
                FOR JSON PATH
            ) AS actions_by_role,
            (
                SELECT 
                    username,
                    role,
                    COUNT(*) AS action_count
                FROM SystemLogs sl
                LEFT JOIN Users u ON sl.user_id = u.user_id
                WHERE sl.log_date BETWEEN @StartDate AND @EndDate
                GROUP BY username, role
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS top_users
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
    
    -- Insert audit report record
    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES (
        @auditor_id, 
        @ReportType, 
        GETDATE(), 
        @reportData, 
        @ExportFormat, 
        CONCAT(N'Audit report from ', FORMAT(@StartDate, 'yyyy-MM-dd'), ' to ', FORMAT(@EndDate, 'yyyy-MM-dd'))
    );
    
    -- Return report ID
    SELECT 
        SCOPE_IDENTITY() AS report_id,
        @ReportType AS report_type,
        GETDATE() AS generated_date,
        @ExportFormat AS format;
END;
GO

PRINT 'Created procedure: sp_ExportAuditReport';
PRINT 'PART 5 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 6: STORED PROCEDURE - DETECT SUSPICIOUS ACTIVITIES
-- =====================================================
PRINT '========================================';
PRINT 'PART 6: Creating sp_DetectSuspiciousActivities';
PRINT '========================================';

IF OBJECT_ID('sp_DetectSuspiciousActivities', 'P') IS NOT NULL 
    DROP PROCEDURE sp_DetectSuspiciousActivities;
GO

CREATE PROCEDURE sp_DetectSuspiciousActivities
    @Hours INT = 24
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME = DATEADD(HOUR, -@Hours, GETDATE());
    
    -- Multiple failed login attempts
    SELECT 
        'Multiple Failed Logins' AS alert_type,
        u.username,
        u.role,
        COUNT(*) AS attempt_count,
        MAX(sl.log_date) AS last_attempt,
        STUFF((
            SELECT DISTINCT ', ' + CAST(ip_address AS VARCHAR(50))
            FROM SystemLogs sl2
            WHERE sl2.user_id = sl.user_id 
              AND sl2.action = 'FAILED_LOGIN'
              AND sl2.log_date >= @StartTime
            FOR XML PATH('')
        ), 1, 2, '') AS ip_addresses
    FROM SystemLogs sl
    INNER JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.action = 'FAILED_LOGIN' 
        AND sl.log_date >= @StartTime
    GROUP BY u.username, u.role, sl.user_id
    HAVING COUNT(*) >= 3;
    
    -- Unusual number of delete operations
    SELECT 
        'Excessive Delete Operations' AS alert_type,
        u.username,
        u.role,
        COUNT(*) AS delete_count,
        MAX(sl.log_date) AS last_delete,
        STUFF((
            SELECT DISTINCT ', ' + CAST(table_name AS VARCHAR(50))
            FROM SystemLogs sl2
            WHERE sl2.user_id = sl.user_id 
              AND sl2.action = 'DELETE'
              AND sl2.log_date >= @StartTime
            FOR XML PATH('')
        ), 1, 2, '') AS affected_tables
    FROM SystemLogs sl
    INNER JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.action = 'DELETE' 
        AND sl.log_date >= @StartTime
    GROUP BY u.username, u.role, sl.user_id
    HAVING COUNT(*) >= 10;
    
    -- After-hours activities
    SELECT 
        'After Hours Activity' AS alert_type,
        u.username,
        u.role,
        COUNT(*) AS action_count,
        MIN(sl.log_date) AS first_action,
        MAX(sl.log_date) AS last_action
    FROM SystemLogs sl
    INNER JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date >= @StartTime
        AND (DATEPART(HOUR, sl.log_date) < 6 OR DATEPART(HOUR, sl.log_date) > 22)
    GROUP BY u.username, u.role
    HAVING COUNT(*) >= 5;
    
    -- Multiple IP addresses for same user
    SELECT 
        'Multiple IP Addresses' AS alert_type,
        u.username,
        u.role,
        COUNT(DISTINCT sl.ip_address) AS ip_count,
        STUFF((
            SELECT DISTINCT ', ' + CAST(ip_address AS VARCHAR(50))
            FROM SystemLogs sl2
            WHERE sl2.user_id = sl.user_id 
              AND sl2.action = 'LOGIN'
              AND sl2.log_date >= @StartTime
            FOR XML PATH('')
        ), 1, 2, '') AS ip_addresses,
        MAX(sl.log_date) AS last_login
    FROM SystemLogs sl
    INNER JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.action = 'LOGIN' 
        AND sl.log_date >= @StartTime
    GROUP BY u.username, u.role, sl.user_id
    HAVING COUNT(DISTINCT sl.ip_address) >= 3;
END;
GO

PRINT 'Created procedure: sp_DetectSuspiciousActivities';
PRINT 'PART 6 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 7: STORED PROCEDURE - GET USER ACTION TIMELINE
-- =====================================================
PRINT '========================================';
PRINT 'PART 7: Creating sp_GetUserActionTimeline';
PRINT '========================================';

IF OBJECT_ID('sp_GetUserActionTimeline', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActionTimeline;
GO

CREATE PROCEDURE sp_GetUserActionTimeline
    @UserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    SELECT 
        sl.log_id,
        sl.action,
        sl.table_name,
        sl.record_id,
        sl.details,
        sl.ip_address,
        sl.log_date,
        CASE 
            WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'danger'
            WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'warning'
            WHEN sl.action IN ('CREATE', 'INSERT') THEN 'success'
            ELSE 'info'
        END AS severity
    FROM SystemLogs sl
    WHERE sl.user_id = @UserId
        AND sl.log_date BETWEEN @StartDate AND @EndDate
    ORDER BY sl.log_date DESC;
    
    -- Get user info
    SELECT 
        user_id,
        username,
        email,
        role,
        last_login,
        failed_attempts,
        is_active
    FROM Users
    WHERE user_id = @UserId;
END;
GO

PRINT 'Created procedure: sp_GetUserActionTimeline';
PRINT 'PART 7 COMPLETED!';
PRINT '';
GO

USE SWP391;
GO

-- =====================================================
-- PART 8: TEST & VERIFICATION
-- =====================================================
PRINT '========================================';
PRINT 'PART 8: Testing All Audit Components';
PRINT '========================================';

-- Test 1: Check all views exist
PRINT 'Checking views...';
SELECT 
    TABLE_NAME AS ViewName,
    'Exists' AS Status
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE '%Audit%'
ORDER BY TABLE_NAME;

-- Test 2: Check all stored procedures exist
PRINT '';
PRINT 'Checking stored procedures...';
SELECT 
    name AS ProcedureName,
    create_date AS CreatedDate,
    modify_date AS LastModified
FROM sys.procedures
WHERE name LIKE '%Audit%' OR name LIKE '%Suspicious%' OR name LIKE '%UserActionTimeline%'
ORDER BY name;

-- Test 3: Check AuditReports constraint
PRINT '';
PRINT 'Checking AuditReports constraint...';
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS AllowedValues
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('AuditReports')
  AND cc.definition LIKE '%report_type%';

-- Test 4: Test sp_GetAuditLogs (last 7 days)
PRINT '';
PRINT 'Testing sp_GetAuditLogs...';
EXEC sp_GetAuditLogs 
    @StartDate = NULL,
    @EndDate = NULL,
    @PageNumber = 1,
    @PageSize = 10;

-- Test 5: Test sp_GetAuditStatistics
PRINT '';
PRINT 'Testing sp_GetAuditStatistics...';
EXEC sp_GetAuditStatistics 
    @StartDate = NULL,
    @EndDate = NULL;

-- Test 6: Test sp_DetectSuspiciousActivities
PRINT '';
PRINT 'Testing sp_DetectSuspiciousActivities...';
EXEC sp_DetectSuspiciousActivities @Hours = 24;

-- Test 7: Test sp_ExportAuditReport
PRINT '';
PRINT 'Testing sp_ExportAuditReport...';
DECLARE @auditor_id INT;
DECLARE @start_date DATETIME;
DECLARE @end_date DATETIME;

SET @auditor_id = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor');
SET @start_date = DATEADD(DAY, -7, GETDATE());
SET @end_date = GETDATE();

IF @auditor_id IS NOT NULL
BEGIN
    EXEC sp_ExportAuditReport 
        @auditor_id = @auditor_id,
        @StartDate = @start_date,
        @EndDate = @end_date,
        @ReportType = 'ComprehensiveAudit',
        @ExportFormat = 'Excel';
    
    PRINT 'Export report test successful!';
END
ELSE
BEGIN
    PRINT 'WARNING: No auditor found for testing export report';
END

-- Test 8: View recent audit reports
PRINT '';
PRINT 'Recent audit reports:';
SELECT TOP 5 
    report_id,
    report_type,
    generated_date,
    exported_format,
    notes
FROM AuditReports
ORDER BY generated_date DESC;

-- Test 9: View audit log statistics
PRINT '';
PRINT 'Audit log statistics:';
SELECT 
    COUNT(*) AS total_logs,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT table_name) AS affected_tables,
    MIN(log_date) AS oldest_log,
    MAX(log_date) AS newest_log
FROM SystemLogs;

-- Test 10: View top actions
PRINT '';
PRINT 'Top 10 actions:';
SELECT TOP 10
    action,
    COUNT(*) AS count
FROM SystemLogs
GROUP BY action
ORDER BY count DESC;

PRINT '';
PRINT '==========================================';
PRINT 'ALL AUDIT LOG FEATURES INSTALLED!';
PRINT '==========================================';
PRINT '';
PRINT 'Available Views:';
PRINT '  - vw_AuditLogDetails';
PRINT '  - vw_DailyAuditSummary';
PRINT '  - vw_UserRiskProfile';
PRINT '';
PRINT 'Available Stored Procedures:';
PRINT '  - sp_GetAuditLogs';
PRINT '  - sp_GetAuditStatistics';
PRINT '  - sp_ExportAuditReport';
PRINT '  - sp_DetectSuspiciousActivities';
PRINT '  - sp_GetUserActionTimeline';
PRINT '';
PRINT 'PART 8 COMPLETED!';
GO




-- Supplier cho Công ty Dược C
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'supplier_duocc')
BEGIN
    INSERT INTO Users (username, password_hash, email, phone, role, is_active)
    VALUES ('supplier_duocc', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 
            'supplier@duocc.vn', '0907777777', 'Supplier', 1);
    PRINT 'Created user: supplier_duocc';
END

-- Supplier cho Công ty Dược D
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'supplier_duocd')
BEGIN
    INSERT INTO Users (username, password_hash, email, phone, role, is_active)
    VALUES ('supplier_duocd', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 
            'supplier@duocd.vn', '0908888888', 'Supplier', 1);
    PRINT 'Created user: supplier_duocd';
END

-- Supplier cho Công ty Dược E
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'supplier_duoce')
BEGIN
    INSERT INTO Users (username, password_hash, email, phone, role, is_active)
    VALUES ('supplier_duoce', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 
            'supplier@duoce.vn', '0909999999', 'Supplier', 1);
    PRINT 'Created user: supplier_duoce';
END

-- Supplier cho Công ty Dược F
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'supplier_duocf')
BEGIN
    INSERT INTO Users (username, password_hash, email, phone, role, is_active)
    VALUES ('supplier_duocf', '$2a$12$AfoWp3rMoA9hMUNmTSFZOOsW0CQXp56TjuapkN8OwRDkziBqhL4Qi', 
            'supplier@duocf.vn', '0900000000', 'Supplier', 1);
    PRINT 'Created user: supplier_duocf';
END
GO

-- =====================================================
-- 2. Cập nhật bảng Suppliers với user_id
-- =====================================================
PRINT '';
PRINT 'Step 2: Linking supplier users to companies...';

-- Công ty Dược B
DECLARE @userB INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocb');
DECLARE @suppB INT = (SELECT supplier_id FROM Suppliers WHERE name = N'Công ty Dược B');

IF @userB IS NOT NULL AND @suppB IS NOT NULL
BEGIN
    UPDATE Suppliers 
    SET user_id = @userB,
        contact_email = 'supplier@duocb.vn',
        contact_phone = '0905555556',
        updated_at = GETDATE()
    WHERE supplier_id = @suppB;
    PRINT 'Linked supplier_duocb to Công ty Dược B';
END

-- Công ty Dược C
DECLARE @userC INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocc');
DECLARE @suppC INT = (SELECT supplier_id FROM Suppliers WHERE name = N'Công ty Dược C');

IF @userC IS NOT NULL AND @suppC IS NOT NULL
BEGIN
    UPDATE Suppliers 
    SET user_id = @userC,
        contact_email = 'supplier@duocc.vn',
        contact_phone = '0907777777',
        updated_at = GETDATE()
    WHERE supplier_id = @suppC;
    PRINT 'Linked supplier_duocc to Công ty Dược C';
END

-- Công ty Dược D
DECLARE @userD INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocd');
DECLARE @suppD INT = (SELECT supplier_id FROM Suppliers WHERE name = N'Công ty Dược D');

IF @userD IS NOT NULL AND @suppD IS NOT NULL
BEGIN
    UPDATE Suppliers 
    SET user_id = @userD,
        contact_email = 'supplier@duocd.vn',
        contact_phone = '0908888888',
        updated_at = GETDATE()
    WHERE supplier_id = @suppD;
    PRINT 'Linked supplier_duocd to Công ty Dược D';
END

-- Công ty Dược E
DECLARE @userE INT = (SELECT user_id FROM Users WHERE username = 'supplier_duoce');
DECLARE @suppE INT = (SELECT supplier_id FROM Suppliers WHERE name = N'Công ty Dược E');

IF @userE IS NOT NULL AND @suppE IS NOT NULL
BEGIN
    UPDATE Suppliers 
    SET user_id = @userE,
        contact_email = 'supplier@duoce.vn',
        contact_phone = '0909999999',
        updated_at = GETDATE()
    WHERE supplier_id = @suppE;
    PRINT 'Linked supplier_duoce to Công ty Dược E';
END

-- Công ty Dược F
DECLARE @userF INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocf');
DECLARE @suppF INT = (SELECT supplier_id FROM Suppliers WHERE name = N'Công ty Dược F');

IF @userF IS NOT NULL AND @suppF IS NOT NULL
BEGIN
    UPDATE Suppliers 
    SET user_id = @userF,
        contact_email = 'supplier@duocf.vn',
        contact_phone = '0900000000',
        updated_at = GETDATE()
    WHERE supplier_id = @suppF;
    PRINT 'Linked supplier_duocf to Công ty Dược F';
END
GO

-- =====================================================
-- 3. Cấp quyền cho các Supplier mới
-- =====================================================
PRINT '';
PRINT 'Step 3: Assigning permissions to supplier users...';

DECLARE @permissionId INT = (SELECT permission_id FROM Permissions WHERE permission_name = 'create_asn');

-- Supplier Dược B
DECLARE @userB INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocb');
IF @userB IS NOT NULL AND @permissionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @userB)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id) VALUES (@userB, @permissionId);
    PRINT 'Granted create_asn permission to supplier_duocb';
END

-- Supplier Dược C
DECLARE @userC INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocc');
IF @userC IS NOT NULL AND @permissionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @userC)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id) VALUES (@userC, @permissionId);
    PRINT 'Granted create_asn permission to supplier_duocc';
END

-- Supplier Dược D
DECLARE @userD INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocd');
IF @userD IS NOT NULL AND @permissionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @userD)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id) VALUES (@userD, @permissionId);
    PRINT 'Granted create_asn permission to supplier_duocd';
END

-- Supplier Dược E
DECLARE @userE INT = (SELECT user_id FROM Users WHERE username = 'supplier_duoce');
IF @userE IS NOT NULL AND @permissionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @userE)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id) VALUES (@userE, @permissionId);
    PRINT 'Granted create_asn permission to supplier_duoce';
END

-- Supplier Dược F
DECLARE @userF INT = (SELECT user_id FROM Users WHERE username = 'supplier_duocf');
IF @userF IS NOT NULL AND @permissionId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM UserPermissions WHERE user_id = @userF)
BEGIN
    INSERT INTO UserPermissions (user_id, permission_id) VALUES (@userF, @permissionId);
    PRINT 'Granted create_asn permission to supplier_duocf';
END
GO

-- =====================================================
-- 4. VERIFICATION - Kiểm tra kết quả
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION RESULTS';
PRINT '========================================';
PRINT '';

-- Kiểm tra Users
PRINT 'Supplier Users Created:';
SELECT 
    user_id,
    username,
    email,
    phone,
    role,
    is_active,
    created_at
FROM Users
WHERE role = 'Supplier'
ORDER BY user_id;

-- Kiểm tra Suppliers với user_id
PRINT '';
PRINT 'Suppliers Linked to Users:';
SELECT 
    s.supplier_id,
    s.name,
    s.user_id,
    u.username,
    s.contact_email,
    s.contact_phone,
    s.performance_rating
FROM Suppliers s
LEFT JOIN Users u ON s.user_id = u.user_id
ORDER BY s.supplier_id;

-- Kiểm tra Permissions
PRINT '';
PRINT 'Supplier Permissions:';
SELECT 
    u.username,
    u.email,
    p.permission_name,
    p.description
FROM UserPermissions up
INNER JOIN Users u ON up.user_id = u.user_id
INNER JOIN Permissions p ON up.permission_id = p.permission_id
WHERE u.role = 'Supplier'
ORDER BY u.username;

-- Thống kê
PRINT '';
PRINT '========================================';
PRINT 'SUMMARY';
PRINT '========================================';
SELECT 
    COUNT(DISTINCT u.user_id) AS total_supplier_users,
    COUNT(DISTINCT s.supplier_id) AS total_suppliers,
    COUNT(DISTINCT CASE WHEN s.user_id IS NOT NULL THEN s.supplier_id END) AS suppliers_with_users
FROM Users u
FULL OUTER JOIN Suppliers s ON u.user_id = s.user_id
WHERE u.role = 'Supplier' OR s.supplier_id IS NOT NULL;

PRINT '';
PRINT '==========================================';
PRINT 'COMPLETED SUCCESSFULLY!';
PRINT '==========================================';
PRINT '';
PRINT 'Created Supplier Accounts:';
PRINT '  - supplier_duocb (Công ty Dược B)';
PRINT '  - supplier_duocc (Công ty Dược C)';
PRINT '  - supplier_duocd (Công ty Dược D)';
PRINT '  - supplier_duoce (Công ty Dược E)';
PRINT '  - supplier_duocf (Công ty Dược F)';
PRINT '';
PRINT 'All suppliers have been granted "create_asn" permission';
PRINT 'Default password for all: 123456 (hashed)';
GO

-- =====================================================
-- ROLE-BASED AUDIT LOG ACCESS CONTROL
-- Auditor chỉ xem được logs của chính họ
-- Admin xem được tất cả logs
-- =====================================================

USE SWP391;
GO
IF OBJECT_ID('vw_AuditLogDetails', 'V') IS NOT NULL 
    DROP VIEW vw_AuditLogDetails;
GO

CREATE VIEW vw_AuditLogDetails AS
SELECT 
    sl.log_id,
    sl.user_id,
    u.username,
    u.email,
    u.role,
    sl.action,
    sl.table_name,
    sl.record_id,
    sl.old_value,
    sl.new_value,
    sl.details,
    sl.ip_address,
    sl.log_date,
    CASE 
        WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'high'
        WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'medium'
        ELSE 'low'
    END AS risk_level,
    CASE 
        WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
        WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
        WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
        ELSE 'Other'
    END AS category
FROM SystemLogs sl
LEFT JOIN Users u ON sl.user_id = u.user_id;
GO

PRINT 'Created view: vw_AuditLogDetails';

-- =====================================================
-- BƯỚC 2: STORED PROCEDURE - sp_GetAuditLogs
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Step 2: Creating sp_GetAuditLogs';
PRINT '========================================';

IF OBJECT_ID('sp_GetAuditLogs', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditLogs;
GO

CREATE PROCEDURE sp_GetAuditLogs
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @TargetUserId INT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Role NVARCHAR(50) = NULL,
    @Action NVARCHAR(100) = NULL,
    @TableName NVARCHAR(50) = NULL,
    @RiskLevel NVARCHAR(20) = NULL,
    @Category NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    -- Chỉ Admin và Auditor được phép
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền truy cập audit logs' AS message;
        RETURN;
    END
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Get total count
    DECLARE @TotalRecords INT;
    SELECT @TotalRecords = COUNT(*)
    FROM vw_AuditLogDetails
    WHERE 
        -- AUDITOR: Không xem logs của Admin
        (@CurrentUserRole = 'Admin' OR role != 'Admin')
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category);
    
    -- Get paginated results
    SELECT 
        log_id,
        user_id,
        username,
        email,
        role,
        action,
        table_name,
        record_id,
        old_value,
        new_value,
        details,
        ip_address,
        log_date,
        risk_level,
        category,
        @TotalRecords AS total_records,
        CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize) AS total_pages,
        @CurrentUserRole AS viewer_role
    FROM vw_AuditLogDetails
    WHERE 
        -- AUDITOR: Không xem logs của Admin
        (@CurrentUserRole = 'Admin' OR role != 'Admin')
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category)
    ORDER BY log_date DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

PRINT 'Created procedure: sp_GetAuditLogs';

-- =====================================================
-- BƯỚC 3: STORED PROCEDURE - sp_GetAuditStatistics
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Step 3: Creating sp_GetAuditStatistics';
PRINT '========================================';

IF OBJECT_ID('sp_GetAuditStatistics', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditStatistics;
GO

CREATE PROCEDURE sp_GetAuditStatistics
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem thống kê audit' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Overall statistics
    SELECT 
        COUNT(*) AS total_actions,
        COUNT(DISTINCT u.user_id) AS active_users,
        COUNT(DISTINCT table_name) AS affected_table,
        COUNT(DISTINCT CAST(log_date AS DATE)) AS active_days,
        SUM(CASE WHEN action = 'LOGIN' THEN 1 ELSE 0 END) AS total_logins,
        SUM(CASE WHEN action IN ('CREATE', 'INSERT') THEN 1 ELSE 0 END) AS total_creates,
        SUM(CASE WHEN action = 'UPDATE' THEN 1 ELSE 0 END) AS total_updates,
        SUM(CASE WHEN action = 'DELETE' THEN 1 ELSE 0 END) AS total_deletes,
        SUM(CASE WHEN action IN ('APPROVE', 'REJECT') THEN 1 ELSE 0 END) AS total_approvals,
        @CurrentUserRole AS viewer_role
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Không thống kê logs của Admin
        AND (@CurrentUserRole = 'Admin' OR u.role != 'Admin');
    
    -- Actions by role
    SELECT 
        u.role,
        COUNT(sl.log_id) AS action_count,
        COUNT(DISTINCT sl.user_id) AS user_count
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Không thống kê Admin
        AND (@CurrentUserRole = 'Admin' OR u.role != 'Admin')
    GROUP BY u.role
    ORDER BY action_count DESC;
    
    -- Actions by category
    SELECT 
        CASE 
            WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
            WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
            WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
            ELSE 'Other'
        END AS category,
        COUNT(*) AS action_count
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Không thống kê Admin
        AND (@CurrentUserRole = 'Admin' OR u.role != 'Admin')
    GROUP BY 
        CASE 
            WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
            WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
            WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices') THEN 'Procurement'
            ELSE 'Other'
        END
    ORDER BY action_count DESC;
    
    -- Top 10 most active users
    SELECT TOP 10
        u.username,
        u.role,
        COUNT(sl.log_id) AS action_count,
        MAX(sl.log_date) AS last_action
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Không hiển thị Admin
        AND (@CurrentUserRole = 'Admin' OR u.role != 'Admin')
    GROUP BY u.username, u.role
    ORDER BY action_count DESC;
    
    -- Daily activity trend
    SELECT 
        CAST(sl.log_date AS DATE) AS log_date,
        COUNT(*) AS action_count,
        COUNT(DISTINCT sl.user_id) AS active_users
    FROM SystemLogs sl
    LEFT JOIN Users u ON sl.user_id = u.user_id
    WHERE sl.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Không thống kê Admin
        AND (@CurrentUserRole = 'Admin' OR u.role != 'Admin')
    GROUP BY CAST(sl.log_date AS DATE)
    ORDER BY log_date DESC;
END;
GO

PRINT 'Created procedure: sp_GetAuditStatistics';

-- =====================================================
-- BƯỚC 4: STORED PROCEDURE - sp_ExportAuditReport
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Step 4: Creating sp_ExportAuditReport';
PRINT '========================================';

IF OBJECT_ID('sp_ExportAuditReport', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ExportAuditReport;
GO

CREATE PROCEDURE sp_ExportAuditReport
    @auditor_id INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @ReportType NVARCHAR(50) = 'ComprehensiveAudit',
    @ExportFormat NVARCHAR(10) = 'Excel'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra quyền của auditor
    DECLARE @AuditorRole NVARCHAR(50);
    SELECT @AuditorRole = role FROM Users WHERE user_id = @auditor_id;
    
    IF @AuditorRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Chỉ Admin và Auditor mới có thể tạo báo cáo' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    DECLARE @reportData NVARCHAR(MAX);
    
    -- Generate report data
    SET @reportData = (
        SELECT 
            'AuditSummary' AS section,
            (SELECT COUNT(*) FROM SystemLogs sl
             LEFT JOIN Users u ON sl.user_id = u.user_id
             WHERE sl.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR u.role != 'Admin')) AS total_actions,
            (SELECT COUNT(DISTINCT sl.user_id) FROM SystemLogs sl
             LEFT JOIN Users u ON sl.user_id = u.user_id
             WHERE sl.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR u.role != 'Admin')) AS active_users,
            @StartDate AS period_start,
            @EndDate AS period_end,
            @AuditorRole AS auditor_role,
            CASE WHEN @AuditorRole = 'Auditor' THEN 'excluding_admin' ELSE 'full_system' END AS report_scope,
            (
                SELECT 
                    u.role,
                    COUNT(*) AS action_count
                FROM SystemLogs sl
                LEFT JOIN Users u ON sl.user_id = u.user_id
                WHERE sl.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR u.role != 'Admin')
                GROUP BY u.role
                FOR JSON PATH
            ) AS actions_by_role,
            (
                SELECT TOP 10
                    u.username,
                    u.role,
                    COUNT(*) AS action_count
                FROM SystemLogs sl
                LEFT JOIN Users u ON sl.user_id = u.user_id
                WHERE sl.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR u.role != 'Admin')
                GROUP BY u.username, u.role
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS top_users
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
    
    -- Insert audit report record
    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES (
        @auditor_id, 
        @ReportType, 
        GETDATE(), 
        @reportData, 
        @ExportFormat, 
        CONCAT(N'Audit report from ', FORMAT(@StartDate, 'yyyy-MM-dd'), ' to ', FORMAT(@EndDate, 'yyyy-MM-dd'),
               CASE WHEN @AuditorRole = 'Auditor' THEN N' (Excluding Admin logs)' ELSE N' (Full System)' END)
    );
    
    -- Return report ID
    SELECT 
        SCOPE_IDENTITY() AS report_id,
        @ReportType AS report_type,
        GETDATE() AS generated_date,
        @ExportFormat AS format,
        @AuditorRole AS auditor_role,
        CASE WHEN @AuditorRole = 'Auditor' THEN 'excluding_admin' ELSE 'full_system' END AS report_scope;
END;
GO

PRINT 'Created procedure: sp_ExportAuditReport';

-- =====================================================
-- BƯỚC 5: STORED PROCEDURE - sp_GetUserActionTimeline
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Step 5: Creating sp_GetUserActionTimeline';
PRINT '========================================';

IF OBJECT_ID('sp_GetUserActionTimeline', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActionTimeline;
GO

CREATE PROCEDURE sp_GetUserActionTimeline
    @CurrentUserId INT,
    @TargetUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại và target user
    DECLARE @CurrentUserRole NVARCHAR(50);
    DECLARE @TargetUserRole NVARCHAR(50);
    
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    SELECT @TargetUserRole = role FROM Users WHERE user_id = @TargetUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem user timeline' AS message;
        RETURN;
    END
    
    -- Auditor không được xem timeline của Admin
    IF @CurrentUserRole = 'Auditor' AND @TargetUserRole = 'Admin'
    BEGIN
        SELECT 'ERROR' AS status, N'Auditor không có quyền xem timeline của Admin' AS message;
        RETURN;
    END
    
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    SELECT 
        sl.log_id,
        sl.action,
        sl.table_name,
        sl.record_id,
        sl.details,
        sl.ip_address,
        sl.log_date,
        CASE 
            WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'danger'
            WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'warning'
            WHEN sl.action IN ('CREATE', 'INSERT') THEN 'success'
            ELSE 'info'
        END AS severity
    FROM SystemLogs sl
    WHERE sl.user_id = @TargetUserId
        AND sl.log_date BETWEEN @StartDate AND @EndDate
    ORDER BY sl.log_date DESC;
    
    -- Get user info
    SELECT 
        user_id,
        username,
        email,
        role,
        last_login,
        failed_attempts,
        is_active
    FROM Users
    WHERE user_id = @TargetUserId;
END;
GO

PRINT 'Created procedure: sp_GetUserActionTimeline';

-- =====================================================
-- BƯỚC 6: VERIFICATION
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Kiểm tra views
IF OBJECT_ID('vw_AuditLogDetails', 'V') IS NOT NULL
    PRINT '✓ View vw_AuditLogDetails created successfully';
ELSE
    PRINT '✗ View vw_AuditLogDetails FAILED';

-- Kiểm tra stored procedures
IF OBJECT_ID('sp_GetAuditLogs', 'P') IS NOT NULL
    PRINT '✓ Procedure sp_GetAuditLogs created successfully';
ELSE
    PRINT '✗ Procedure sp_GetAuditLogs FAILED';

IF OBJECT_ID('sp_GetAuditStatistics', 'P') IS NOT NULL
    PRINT '✓ Procedure sp_GetAuditStatistics created successfully';
ELSE
    PRINT '✗ Procedure sp_GetAuditStatistics FAILED';

IF OBJECT_ID('sp_ExportAuditReport', 'P') IS NOT NULL
    PRINT '✓ Procedure sp_ExportAuditReport created successfully';
ELSE
    PRINT '✗ Procedure sp_ExportAuditReport FAILED';

IF OBJECT_ID('sp_GetUserActionTimeline', 'P') IS NOT NULL
    PRINT '✓ Procedure sp_GetUserActionTimeline created successfully';
ELSE
    PRINT '✗ Procedure sp_GetUserActionTimeline FAILED';

PRINT '';
PRINT '==========================================';
PRINT 'OPTION 2 - ACCESS CONTROL COMPLETED!';
PRINT '==========================================';
PRINT '';
PRINT 'Access Rules:';
PRINT '  ✓ Admin: Xem TẤT CẢ audit logs (full access)';
PRINT '  ✓ Auditor: Xem TẤT CẢ TRỪ Admin';
PRINT '    - Manager logs: ✓';
PRINT '    - Doctor logs: ✓';
PRINT '    - Pharmacist logs: ✓';
PRINT '    - Supplier logs: ✓';
PRINT '    - Auditor logs (bao gồm auditor khác): ✓';
PRINT '    - Admin logs: ✗';
PRINT '  ✗ Other roles: Không có quyền truy cập';
PRINT '';
PRINT 'Updated Procedures:';
PRINT '  - sp_GetAuditLogs (filters out Admin for Auditors)';
PRINT '  - sp_GetAuditStatistics (excludes Admin stats for Auditors)';
PRINT '  - sp_ExportAuditReport (scope adjusted by role)';
PRINT '  - sp_GetUserActionTimeline (Auditor cannot view Admin timeline)';
PRINT '';
PRINT 'Ready to use!';
GO

USE SWP391;
GO

-- =====================================================
-- TICKETS TABLE
-- =====================================================
IF OBJECT_ID('Tickets', 'U') IS NOT NULL DROP TABLE Tickets;
GO

CREATE TABLE Tickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    subject NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open','InProgress','Resolved','Closed')),
    priority NVARCHAR(20) DEFAULT 'Normal' CHECK (priority IN ('Low','Normal','High','Urgent')),
    category NVARCHAR(50),
    admin_response NVARCHAR(MAX),
    responded_by INT,
    responded_at DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_Tickets_User FOREIGN KEY (user_id) 
        REFERENCES Users(user_id) ON DELETE NO ACTION,
    CONSTRAINT FK_Tickets_Admin FOREIGN KEY (responded_by) 
        REFERENCES Users(user_id) ON DELETE NO ACTION
);
GO

CREATE INDEX idx_tickets_user ON Tickets(user_id);
CREATE INDEX idx_tickets_status ON Tickets(status);
CREATE INDEX idx_tickets_created ON Tickets(created_at DESC);
GO

PRINT 'Tickets table created successfully!';

USE SWP391;
GO

-- =====================================================
-- ENHANCED VIEW: Purchase Orders with Complete Status
-- Includes ASN status (In Transit, Delivered, etc.)
-- =====================================================

IF OBJECT_ID('vw_PurchaseOrdersWithShipping', 'V') IS NOT NULL 
    DROP VIEW vw_PurchaseOrdersWithShipping;
GO

CREATE VIEW vw_PurchaseOrdersWithShipping AS
SELECT 
    -- Purchase Order fields
    po.po_id,
    po.manager_id,
    po.supplier_id,
    po.status AS po_status,
    po.order_date,
    po.expected_delivery_date,
    po.notes,
    po.updated_at,
    
    -- Supplier info
    s.name AS supplier_name,
    s.contact_email AS supplier_email,
    s.contact_phone AS supplier_phone,
    s.performance_rating,
    
    -- Manager info
    u.username AS manager_name,
    u.email AS manager_email,
    
    -- ASN info (latest ASN for this PO)
    asn.asn_id,
    asn.tracking_number,
    asn.carrier,
    asn.status AS asn_status,
    asn.shipment_date,
    asn.submitted_at AS asn_submitted_at,
    asn.approved_at AS asn_approved_at,
    asn.submitted_by,
    
    -- Check if PO has ASN
    CASE WHEN asn.asn_id IS NOT NULL THEN 1 ELSE 0 END AS has_asn,
    
    -- Combined status for display (PRIORITY ORDER)
    CASE 
        -- ASN statuses take priority when they exist
        WHEN asn.status = 'Delivered' THEN 'Delivered'
        WHEN asn.status = 'InTransit' THEN 'In Transit'
        WHEN asn.status = 'Sent' THEN 'Shipped'
        WHEN asn.status = 'Pending' THEN 'Awaiting Shipment'
        
        -- Fall back to PO status
        WHEN po.status = 'Completed' THEN 'Completed'
        WHEN po.status = 'Received' THEN 'Received'
        WHEN po.status = 'Approved' THEN 'Approved'
        WHEN po.status = 'Sent' THEN 'Sent to Supplier'
        WHEN po.status = 'Draft' THEN 'Draft'
        WHEN po.status = 'Rejected' THEN 'Rejected'
        ELSE po.status
    END AS display_status,
    
    -- Status badge class for frontend
    CASE 
        WHEN asn.status = 'Delivered' OR po.status = 'Completed' THEN 'badge-success'
        WHEN asn.status = 'InTransit' THEN 'badge-info'
        WHEN asn.status = 'Sent' THEN 'badge-primary'
        WHEN po.status = 'Approved' THEN 'badge-success'
        WHEN po.status = 'Received' THEN 'badge-success'
        WHEN po.status = 'Draft' THEN 'badge-secondary'
        WHEN po.status = 'Rejected' THEN 'badge-danger'
        WHEN po.status = 'Sent' THEN 'badge-info'
        ELSE 'badge-warning'
    END AS status_badge_class,
    
    -- Priority for sorting (higher = more important)
    CASE 
        WHEN asn.status = 'Delivered' OR po.status = 'Completed' THEN 6
        WHEN asn.status = 'InTransit' THEN 5
        WHEN asn.status = 'Sent' THEN 4
        WHEN po.status = 'Received' THEN 3
        WHEN po.status = 'Approved' THEN 2
        ELSE 1
    END AS status_priority,
    
    -- Calculate item count
    (SELECT COUNT(*) FROM PurchaseOrderItems WHERE po_id = po.po_id) AS item_count,
    
    -- Calculate total amount
    (SELECT ISNULL(SUM(quantity * ISNULL(unit_price, 0)), 0) 
     FROM PurchaseOrderItems WHERE po_id = po.po_id) AS total_amount

FROM PurchaseOrders po
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id
LEFT JOIN Users u ON po.manager_id = u.user_id
-- Join with latest ASN for each PO
LEFT JOIN (
    SELECT 
        asn.*,
        ROW_NUMBER() OVER (PARTITION BY asn.po_id ORDER BY asn.created_at DESC) AS rn
    FROM AdvancedShippingNotices asn
) asn ON po.po_id = asn.po_id AND asn.rn = 1;

GO
IF OBJECT_ID('vw_AuditLogDetails', 'V') IS NOT NULL 
    DROP VIEW vw_AuditLogDetails;
GO

CREATE VIEW vw_AuditLogDetails AS
SELECT 
    sl.log_id,
    sl.user_id,
    u.username,
    u.email,
    u.role,
    sl.action,
    sl.table_name,
    sl.record_id,
    sl.old_value,
    sl.new_value,
    sl.details,
    sl.ip_address,
    sl.log_date,
    CASE 
        WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'high'
        WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'medium'
        ELSE 'low'
    END AS risk_level,
    CASE 
        WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
        WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
        WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices', 'DeliveryNotes') THEN 'Procurement'
        ELSE 'Other'
    END AS category,
    -- Flag for procurement-related logs
    CASE 
        WHEN sl.table_name IN ('PurchaseOrders', 'PurchaseOrderItems', 'Invoices', 
                               'AdvancedShippingNotices', 'ASNItems', 'DeliveryNotes', 
                               'Transactions', 'Suppliers')
        AND u.role IN ('Manager', 'Supplier', 'Admin')
        THEN 1
        ELSE 0
    END AS is_procurement_log
FROM SystemLogs sl
LEFT JOIN Users u ON sl.user_id = u.user_id;
GO

PRINT 'Created view: vw_AuditLogDetails';

-- =====================================================
-- STORED PROCEDURE: Get Audit Logs (Updated)
-- =====================================================
IF OBJECT_ID('sp_GetAuditLogs', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditLogs;
GO

CREATE PROCEDURE sp_GetAuditLogs
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @TargetUserId INT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Role NVARCHAR(50) = NULL,
    @Action NVARCHAR(100) = NULL,
    @TableName NVARCHAR(50) = NULL,
    @RiskLevel NVARCHAR(20) = NULL,
    @Category NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    -- Chỉ Admin và Auditor được phép
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền truy cập audit logs' AS message;
        RETURN;
    END
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Get total count
    DECLARE @TotalRecords INT;
    SELECT @TotalRecords = COUNT(*)
    FROM vw_AuditLogDetails
    WHERE 
        -- ADMIN: Xem tất cả
        -- AUDITOR: Chỉ xem logs liên quan procurement (Manager, Supplier, Admin)
        (@CurrentUserRole = 'Admin' OR is_procurement_log = 1)
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category);
    
    -- Get paginated results
    SELECT 
        log_id,
        user_id,
        username,
        email,
        role,
        action,
        table_name,
        record_id,
        old_value,
        new_value,
        details,
        ip_address,
        log_date,
        risk_level,
        category,
        @TotalRecords AS total_records,
        CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize) AS total_pages,
        @CurrentUserRole AS viewer_role,
        CASE WHEN @CurrentUserRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS access_scope
    FROM vw_AuditLogDetails
    WHERE 
        -- ADMIN: Xem tất cả
        -- AUDITOR: Chỉ xem logs liên quan procurement
        (@CurrentUserRole = 'Admin' OR is_procurement_log = 1)
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category)
    ORDER BY log_date DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

PRINT 'Created procedure: sp_GetAuditLogs';

-- =====================================================
-- STORED PROCEDURE: Get Audit Statistics (Updated)
-- =====================================================
IF OBJECT_ID('sp_GetAuditStatistics', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditStatistics;
GO

CREATE PROCEDURE sp_GetAuditStatistics
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem thống kê audit' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Overall statistics
    SELECT 
        COUNT(*) AS total_actions,
        COUNT(DISTINCT vw.user_id) AS active_users,
        COUNT(DISTINCT table_name) AS affected_tables,
        COUNT(DISTINCT CAST(log_date AS DATE)) AS active_days,
        SUM(CASE WHEN action = 'LOGIN' THEN 1 ELSE 0 END) AS total_logins,
        SUM(CASE WHEN action IN ('CREATE', 'INSERT') THEN 1 ELSE 0 END) AS total_creates,
        SUM(CASE WHEN action = 'UPDATE' THEN 1 ELSE 0 END) AS total_updates,
        SUM(CASE WHEN action = 'DELETE' THEN 1 ELSE 0 END) AS total_deletes,
        SUM(CASE WHEN action IN ('APPROVE', 'REJECT') THEN 1 ELSE 0 END) AS total_approvals,
        @CurrentUserRole AS viewer_role,
        CASE WHEN @CurrentUserRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS access_scope
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ thống kê logs procurement
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1);
    
    -- Actions by role
    SELECT 
        vw.role,
        COUNT(vw.log_id) AS action_count,
        COUNT(DISTINCT vw.user_id) AS user_count
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ thống kê Manager, Supplier
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY vw.role
    ORDER BY action_count DESC;
    
    -- Actions by category
    SELECT 
        vw.category,
        COUNT(*) AS action_count
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ thống kê Procurement
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY vw.category
    ORDER BY action_count DESC;
    
    -- Top 10 most active users
    SELECT TOP 10
        vw.username,
        vw.role,
        COUNT(vw.log_id) AS action_count,
        MAX(vw.log_date) AS last_action
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ hiển thị Manager, Supplier
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY vw.username, vw.role
    ORDER BY action_count DESC;
    
    -- Daily activity trend
    SELECT 
        CAST(vw.log_date AS DATE) AS log_date,
        COUNT(*) AS action_count,
        COUNT(DISTINCT vw.user_id) AS active_users
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ thống kê procurement
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY CAST(vw.log_date AS DATE)
    ORDER BY log_date DESC;
    
    -- Procurement-specific stats (only for Auditors)
    IF @CurrentUserRole = 'Auditor'
    BEGIN
        SELECT 
            'Procurement Statistics' AS report_section,
            SUM(CASE WHEN table_name = 'PurchaseOrders' THEN 1 ELSE 0 END) AS purchase_order_actions,
            SUM(CASE WHEN table_name = 'Invoices' THEN 1 ELSE 0 END) AS invoice_actions,
            SUM(CASE WHEN table_name = 'AdvancedShippingNotices' THEN 1 ELSE 0 END) AS shipping_actions,
            SUM(CASE WHEN table_name = 'DeliveryNotes' THEN 1 ELSE 0 END) AS delivery_actions,
            SUM(CASE WHEN table_name = 'Transactions' THEN 1 ELSE 0 END) AS transaction_actions
        FROM vw_AuditLogDetails
        WHERE log_date BETWEEN @StartDate AND @EndDate
            AND is_procurement_log = 1;
    END
END;
GO

PRINT 'Created procedure: sp_GetAuditStatistics';

-- =====================================================
-- STORED PROCEDURE: Export Audit Report (Updated)
-- =====================================================
IF OBJECT_ID('sp_ExportAuditReport', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ExportAuditReport;
GO

CREATE PROCEDURE sp_ExportAuditReport
    @auditor_id INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @ReportType NVARCHAR(50) = 'ComprehensiveAudit',
    @ExportFormat NVARCHAR(10) = 'Excel'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra quyền của auditor
    DECLARE @AuditorRole NVARCHAR(50);
    SELECT @AuditorRole = role FROM Users WHERE user_id = @auditor_id;
    
    IF @AuditorRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Chỉ Admin và Auditor mới có thể tạo báo cáo' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    DECLARE @reportData NVARCHAR(MAX);
    
    -- Generate report data
    SET @reportData = (
        SELECT 
            'AuditSummary' AS section,
            (SELECT COUNT(*) FROM vw_AuditLogDetails vw
             WHERE vw.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)) AS total_actions,
            (SELECT COUNT(DISTINCT vw.user_id) FROM vw_AuditLogDetails vw
             WHERE vw.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)) AS active_users,
            @StartDate AS period_start,
            @EndDate AS period_end,
            @AuditorRole AS auditor_role,
            CASE WHEN @AuditorRole = 'Auditor' THEN 'Procurement Only (Manager, Supplier)' ELSE 'Full System' END AS report_scope,
            (
                SELECT 
                    vw.role,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY vw.role
                FOR JSON PATH
            ) AS actions_by_role,
            (
                SELECT TOP 10
                    vw.username,
                    vw.role,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY vw.username, vw.role
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS top_users,
            (
                SELECT 
                    table_name,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY table_name
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS actions_by_table
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
    
    -- Insert audit report record
    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES (
        @auditor_id, 
        @ReportType, 
        GETDATE(), 
        @reportData, 
        @ExportFormat, 
        CONCAT(N'Audit report from ', FORMAT(@StartDate, 'yyyy-MM-dd'), ' to ', FORMAT(@EndDate, 'yyyy-MM-dd'),
               CASE WHEN @AuditorRole = 'Auditor' THEN N' (Procurement Only - Manager & Supplier)' ELSE N' (Full System)' END)
    );
    
    -- Return report ID
    SELECT 
        SCOPE_IDENTITY() AS report_id,
        @ReportType AS report_type,
        GETDATE() AS generated_date,
        @ExportFormat AS format,
        @AuditorRole AS auditor_role,
        CASE WHEN @AuditorRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS report_scope;
END;
GO

PRINT 'Created procedure: sp_ExportAuditReport';

-- =====================================================
-- STORED PROCEDURE: Get User Timeline (Updated)
-- =====================================================
IF OBJECT_ID('sp_GetUserActionTimeline', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActionTimeline;
GO

CREATE PROCEDURE sp_GetUserActionTimeline
    @CurrentUserId INT,
    @TargetUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại và target user
    DECLARE @CurrentUserRole NVARCHAR(50);
    DECLARE @TargetUserRole NVARCHAR(50);
    
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    SELECT @TargetUserRole = role FROM Users WHERE user_id = @TargetUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem user timeline' AS message;
        RETURN;
    END
    
    -- Auditor chỉ được xem timeline của Manager và Supplier
    IF @CurrentUserRole = 'Auditor' AND @TargetUserRole NOT IN ('Manager', 'Supplier', 'Admin')
    BEGIN
        SELECT 'ERROR' AS status, N'Auditor chỉ có quyền xem timeline của Manager và Supplier' AS message;
        RETURN;
    END
    
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Get timeline (filtered for Auditors)
    SELECT 
        vw.log_id,
        vw.action,
        vw.table_name,
        vw.record_id,
        vw.details,
        vw.ip_address,
        vw.log_date,
        vw.category,
        CASE 
            WHEN vw.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'danger'
            WHEN vw.action IN ('UPDATE', 'APPROVE') THEN 'warning'
            WHEN vw.action IN ('CREATE', 'INSERT') THEN 'success'
            ELSE 'info'
        END AS severity
    FROM vw_AuditLogDetails vw
    WHERE vw.user_id = @TargetUserId
        AND vw.log_date BETWEEN @StartDate AND @EndDate
        -- Auditor: Chỉ xem procurement logs
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    ORDER BY vw.log_date DESC;
    
    -- Get user info
    SELECT 
        user_id,
        username,
        email,
        role,
        last_login,
        failed_attempts,
        is_active
    FROM Users
    WHERE user_id = @TargetUserId;
END;
GO

PRINT 'Created procedure: sp_GetUserActionTimeline';

-- =====================================================
-- VERIFICATION
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Test with sample data
DECLARE @admin_id INT = (SELECT TOP 1 user_id FROM Users WHERE role = 'Admin');
DECLARE @auditor_id INT = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor');

IF @auditor_id IS NOT NULL
BEGIN
    PRINT '';
    PRINT 'Testing Auditor Access...';
    EXEC sp_GetAuditLogs @CurrentUserId = @auditor_id, @PageSize = 5;
    
    PRINT '';
    PRINT 'Testing Auditor Statistics...';
    EXEC sp_GetAuditStatistics @CurrentUserId = @auditor_id;
END
ELSE
BEGIN
    PRINT 'No Auditor found for testing';
END
USE SWP391;
GO

-- =====================================================
-- RESTRICTED AUDITOR ACCESS
-- Auditor chỉ xem được logs liên quan đến:
-- - Purchase Orders (đặt hàng)
-- - Invoices (thanh toán)
-- - Advanced Shipping Notices (vận chuyển)
-- - Delivery Notes (giao hàng)
-- - Transactions (giao dịch kho)
-- Của Manager và Supplier
-- =====================================================

PRINT '========================================';
PRINT 'Updating Auditor Access Control';
PRINT '========================================';

-- =====================================================
-- VIEW: Audit Logs - Procurement Only
-- =====================================================
IF OBJECT_ID('vw_AuditLogDetails', 'V') IS NOT NULL 
    DROP VIEW vw_AuditLogDetails;
GO

CREATE VIEW vw_AuditLogDetails AS
SELECT 
    sl.log_id,
    sl.user_id,
    u.username,
    u.email,
    u.role,
    sl.action,
    sl.table_name,
    sl.record_id,
    sl.old_value,
    sl.new_value,
    sl.details,
    sl.ip_address,
    sl.log_date,
    CASE 
        WHEN sl.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'high'
        WHEN sl.action IN ('UPDATE', 'APPROVE') THEN 'medium'
        ELSE 'low'
    END AS risk_level,
    CASE 
        WHEN sl.table_name IN ('Users', 'Permissions', 'UserPermissions') THEN 'Security'
        WHEN sl.table_name IN ('Medicines', 'Batches', 'Transactions') THEN 'Inventory'
        WHEN sl.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices', 'DeliveryNotes') THEN 'Procurement'
        ELSE 'Other'
    END AS category,
    -- Flag for procurement-related logs
    CASE 
        WHEN sl.table_name IN ('PurchaseOrders', 'PurchaseOrderItems', 'Invoices', 
                               'AdvancedShippingNotices', 'ASNItems', 'DeliveryNotes', 
                               'Transactions', 'Suppliers')
        AND u.role IN ('Manager', 'Supplier', 'Admin')
        THEN 1
        ELSE 0
    END AS is_procurement_log
FROM SystemLogs sl
LEFT JOIN Users u ON sl.user_id = u.user_id;
GO

PRINT 'Created view: vw_AuditLogDetails';

-- =====================================================
-- STORED PROCEDURE: Get Audit Logs (Updated)
-- =====================================================
IF OBJECT_ID('sp_GetAuditLogs', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditLogs;
GO

CREATE PROCEDURE sp_GetAuditLogs
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @TargetUserId INT = NULL,
    @Username NVARCHAR(50) = NULL,
    @Role NVARCHAR(50) = NULL,
    @Action NVARCHAR(100) = NULL,
    @TableName NVARCHAR(50) = NULL,
    @RiskLevel NVARCHAR(20) = NULL,
    @Category NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    -- Chỉ Admin và Auditor được phép
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền truy cập audit logs' AS message;
        RETURN;
    END
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    -- Get total count
    DECLARE @TotalRecords INT;
    SELECT @TotalRecords = COUNT(*)
    FROM vw_AuditLogDetails
    WHERE 
        -- ADMIN: Xem tất cả
        -- AUDITOR: Chỉ xem logs liên quan procurement (Manager, Supplier, Admin)
        (@CurrentUserRole = 'Admin' OR is_procurement_log = 1)
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category);
    
    -- Get paginated results
    SELECT 
        log_id,
        user_id,
        username,
        email,
        role,
        action,
        table_name,
        record_id,
        old_value,
        new_value,
        details,
        ip_address,
        log_date,
        risk_level,
        category,
        @TotalRecords AS total_records,
        CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize) AS total_pages,
        @CurrentUserRole AS viewer_role,
        CASE WHEN @CurrentUserRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS access_scope
    FROM vw_AuditLogDetails
    WHERE 
        -- ADMIN: Xem tất cả
        -- AUDITOR: Chỉ xem logs liên quan procurement
        (@CurrentUserRole = 'Admin' OR is_procurement_log = 1)
        AND (@StartDate IS NULL OR log_date >= @StartDate)
        AND (@EndDate IS NULL OR log_date <= @EndDate)
        AND (@TargetUserId IS NULL OR user_id = @TargetUserId)
        AND (@Username IS NULL OR username LIKE '%' + @Username + '%')
        AND (@Role IS NULL OR role = @Role)
        AND (@Action IS NULL OR action = @Action)
        AND (@TableName IS NULL OR table_name = @TableName)
        AND (@RiskLevel IS NULL OR risk_level = @RiskLevel)
        AND (@Category IS NULL OR category = @Category)
    ORDER BY log_date DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

PRINT 'Created procedure: sp_GetAuditLogs';

-- =====================================================
-- STORED PROCEDURE: Get Audit Statistics (Procurement-Focused)
-- =====================================================
IF OBJECT_ID('sp_GetAuditStatistics', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetAuditStatistics;
GO

CREATE PROCEDURE sp_GetAuditStatistics
    @CurrentUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại
    DECLARE @CurrentUserRole NVARCHAR(50);
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem thống kê audit' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- PROCUREMENT-FOCUSED STATISTICS
    SELECT 
        COUNT(*) AS total_actions,
        COUNT(DISTINCT vw.user_id) AS active_users,
        COUNT(DISTINCT table_name) AS affected_tables,
        COUNT(DISTINCT CAST(log_date AS DATE)) AS active_days,
        
        -- PROCUREMENT-SPECIFIC METRICS (thay vì login/create/update/delete)
        SUM(CASE WHEN table_name = 'PurchaseOrders' THEN 1 ELSE 0 END) AS purchase_order_actions,
        SUM(CASE WHEN table_name = 'Invoices' THEN 1 ELSE 0 END) AS invoice_actions,
        SUM(CASE WHEN table_name = 'AdvancedShippingNotices' THEN 1 ELSE 0 END) AS shipping_actions,
        SUM(CASE WHEN table_name = 'DeliveryNotes' THEN 1 ELSE 0 END) AS delivery_actions,
        SUM(CASE WHEN table_name IN ('Transactions', 'Batches') THEN 1 ELSE 0 END) AS inventory_actions,
        
        -- Approval/Rejection stats (quan trọng cho procurement)
        SUM(CASE WHEN action IN ('APPROVE', 'APPROVED') THEN 1 ELSE 0 END) AS total_approvals,
        SUM(CASE WHEN action IN ('REJECT', 'REJECTED') THEN 1 ELSE 0 END) AS total_rejections,
        
        -- Manager vs Supplier activity
        SUM(CASE WHEN vw.role = 'Manager' THEN 1 ELSE 0 END) AS manager_actions,
        SUM(CASE WHEN vw.role = 'Supplier' THEN 1 ELSE 0 END) AS supplier_actions,
        
        @CurrentUserRole AS viewer_role,
        CASE WHEN @CurrentUserRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS access_scope
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        -- AUDITOR: Chỉ thống kê logs procurement
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1);
    
    -- Actions by role (Manager vs Supplier)
    SELECT 
        vw.role,
        COUNT(vw.log_id) AS action_count,
        COUNT(DISTINCT vw.user_id) AS user_count
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY vw.role
    ORDER BY action_count DESC;
    
    -- Actions by procurement table
    SELECT 
        vw.table_name,
        COUNT(*) AS action_count
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
        AND vw.table_name IN ('PurchaseOrders', 'Invoices', 'AdvancedShippingNotices', 
                              'DeliveryNotes', 'Transactions', 'Suppliers')
    GROUP BY vw.table_name
    ORDER BY action_count DESC;
    
    -- Top 10 most active users (Manager & Supplier)
    SELECT TOP 10
        vw.username,
        vw.role,
        COUNT(vw.log_id) AS action_count,
        MAX(vw.log_date) AS last_action
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY vw.username, vw.role
    ORDER BY action_count DESC;
    
    -- Daily activity trend
    SELECT 
        CAST(vw.log_date AS DATE) AS log_date,
        COUNT(*) AS action_count,
        COUNT(DISTINCT vw.user_id) AS active_users,
        SUM(CASE WHEN vw.role = 'Manager' THEN 1 ELSE 0 END) AS manager_actions,
        SUM(CASE WHEN vw.role = 'Supplier' THEN 1 ELSE 0 END) AS supplier_actions
    FROM vw_AuditLogDetails vw
    WHERE vw.log_date BETWEEN @StartDate AND @EndDate
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    GROUP BY CAST(vw.log_date AS DATE)
    ORDER BY log_date DESC;
END;
GO

PRINT 'Created procedure: sp_GetAuditStatistics (Procurement-Focused)';

-- =====================================================
-- STORED PROCEDURE: Export Audit Report (Updated)
-- =====================================================
IF OBJECT_ID('sp_ExportAuditReport', 'P') IS NOT NULL 
    DROP PROCEDURE sp_ExportAuditReport;
GO

CREATE PROCEDURE sp_ExportAuditReport
    @auditor_id INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @ReportType NVARCHAR(50) = 'ComprehensiveAudit',
    @ExportFormat NVARCHAR(10) = 'Excel'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra quyền của auditor
    DECLARE @AuditorRole NVARCHAR(50);
    SELECT @AuditorRole = role FROM Users WHERE user_id = @auditor_id;
    
    IF @AuditorRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Chỉ Admin và Auditor mới có thể tạo báo cáo' AS message;
        RETURN;
    END
    
    -- Set default date range
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    DECLARE @reportData NVARCHAR(MAX);
    
    -- Generate report data
    SET @reportData = (
        SELECT 
            'AuditSummary' AS section,
            (SELECT COUNT(*) FROM vw_AuditLogDetails vw
             WHERE vw.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)) AS total_actions,
            (SELECT COUNT(DISTINCT vw.user_id) FROM vw_AuditLogDetails vw
             WHERE vw.log_date BETWEEN @StartDate AND @EndDate
             AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)) AS active_users,
            @StartDate AS period_start,
            @EndDate AS period_end,
            @AuditorRole AS auditor_role,
            CASE WHEN @AuditorRole = 'Auditor' THEN 'Procurement Only (Manager, Supplier)' ELSE 'Full System' END AS report_scope,
            (
                SELECT 
                    vw.role,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY vw.role
                FOR JSON PATH
            ) AS actions_by_role,
            (
                SELECT TOP 10
                    vw.username,
                    vw.role,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY vw.username, vw.role
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS top_users,
            (
                SELECT 
                    table_name,
                    COUNT(*) AS action_count
                FROM vw_AuditLogDetails vw
                WHERE vw.log_date BETWEEN @StartDate AND @EndDate
                    AND (@AuditorRole = 'Admin' OR vw.is_procurement_log = 1)
                GROUP BY table_name
                ORDER BY COUNT(*) DESC
                FOR JSON PATH
            ) AS actions_by_table
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
    
    -- Insert audit report record
    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES (
        @auditor_id, 
        @ReportType, 
        GETDATE(), 
        @reportData, 
        @ExportFormat, 
        CONCAT(N'Audit report from ', FORMAT(@StartDate, 'yyyy-MM-dd'), ' to ', FORMAT(@EndDate, 'yyyy-MM-dd'),
               CASE WHEN @AuditorRole = 'Auditor' THEN N' (Procurement Only - Manager & Supplier)' ELSE N' (Full System)' END)
    );
    
    -- Return report ID
    SELECT 
        SCOPE_IDENTITY() AS report_id,
        @ReportType AS report_type,
        GETDATE() AS generated_date,
        @ExportFormat AS format,
        @AuditorRole AS auditor_role,
        CASE WHEN @AuditorRole = 'Auditor' THEN 'Procurement Only' ELSE 'Full System' END AS report_scope;
END;
GO

PRINT 'Created procedure: sp_ExportAuditReport';

-- =====================================================
-- STORED PROCEDURE: Get User Timeline (Updated)
-- =====================================================
IF OBJECT_ID('sp_GetUserActionTimeline', 'P') IS NOT NULL 
    DROP PROCEDURE sp_GetUserActionTimeline;
GO

CREATE PROCEDURE sp_GetUserActionTimeline
    @CurrentUserId INT,
    @TargetUserId INT,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy role của user hiện tại và target user
    DECLARE @CurrentUserRole NVARCHAR(50);
    DECLARE @TargetUserRole NVARCHAR(50);
    
    SELECT @CurrentUserRole = role FROM Users WHERE user_id = @CurrentUserId;
    SELECT @TargetUserRole = role FROM Users WHERE user_id = @TargetUserId;
    
    -- Kiểm tra quyền truy cập
    IF @CurrentUserRole IS NULL
    BEGIN
        SELECT 'ERROR' AS status, N'User không tồn tại' AS message;
        RETURN;
    END
    
    IF @CurrentUserRole NOT IN ('Admin', 'Auditor')
    BEGIN
        SELECT 'ERROR' AS status, N'Bạn không có quyền xem user timeline' AS message;
        RETURN;
    END
    
    -- Auditor chỉ được xem timeline của Manager và Supplier
    IF @CurrentUserRole = 'Auditor' AND @TargetUserRole NOT IN ('Manager', 'Supplier', 'Admin')
    BEGIN
        SELECT 'ERROR' AS status, N'Auditor chỉ có quyền xem timeline của Manager và Supplier' AS message;
        RETURN;
    END
    
    IF @StartDate IS NULL SET @StartDate = DATEADD(DAY, -30, GETDATE());
    IF @EndDate IS NULL SET @EndDate = GETDATE();
    
    -- Get timeline (filtered for Auditors)
    SELECT 
        vw.log_id,
        vw.action,
        vw.table_name,
        vw.record_id,
        vw.details,
        vw.ip_address,
        vw.log_date,
        vw.category,
        CASE 
            WHEN vw.action IN ('DELETE', 'REJECT', 'CANCEL') THEN 'danger'
            WHEN vw.action IN ('UPDATE', 'APPROVE') THEN 'warning'
            WHEN vw.action IN ('CREATE', 'INSERT') THEN 'success'
            ELSE 'info'
        END AS severity
    FROM vw_AuditLogDetails vw
    WHERE vw.user_id = @TargetUserId
        AND vw.log_date BETWEEN @StartDate AND @EndDate
        -- Auditor: Chỉ xem procurement logs
        AND (@CurrentUserRole = 'Admin' OR vw.is_procurement_log = 1)
    ORDER BY vw.log_date DESC;
    
    -- Get user info
    SELECT 
        user_id,
        username,
        email,
        role,
        last_login,
        failed_attempts,
        is_active
    FROM Users
    WHERE user_id = @TargetUserId;
END;
GO

PRINT 'Created procedure: sp_GetUserActionTimeline';

-- =====================================================
-- VERIFICATION
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Test with sample data
DECLARE @admin_id INT = (SELECT TOP 1 user_id FROM Users WHERE role = 'Admin');
DECLARE @auditor_id INT = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor');

IF @auditor_id IS NOT NULL
BEGIN
    PRINT '';
    PRINT 'Testing Auditor Access...';
    EXEC sp_GetAuditLogs @CurrentUserId = @auditor_id, @PageSize = 5;
    
    PRINT '';
    PRINT 'Testing Auditor Statistics...';
    EXEC sp_GetAuditStatistics @CurrentUserId = @auditor_id;
END
ELSE
BEGIN
    PRINT 'No Auditor found for testing';
END

-- =====================================================
-- BƯỚC 1: Kiểm tra Constraint hiện tại
-- =====================================================
PRINT 'Step 1: Checking current constraints...';
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS ConstraintDefinition
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders')
  AND cc.definition LIKE '%status%';

-- =====================================================
-- BƯỚC 2: Drop Constraint CHECK cũ
-- =====================================================
PRINT '';
PRINT 'Step 2: Dropping old status constraint...';

DECLARE @ConstraintName NVARCHAR(200);
SELECT @ConstraintName = cc.name 
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders')
  AND cc.definition LIKE '%status%';

IF @ConstraintName IS NOT NULL
BEGIN
    DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE PurchaseOrders DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    EXEC sp_executesql @DropSQL;
    PRINT 'Dropped constraint: ' + @ConstraintName;
END
ELSE
BEGIN
    PRINT 'No status constraint found';
END

-- =====================================================
-- BƯỚC 3: Thêm Constraint mới với 'Cancelled'
-- =====================================================
PRINT '';
PRINT 'Step 3: Adding new constraint with Cancelled status...';

ALTER TABLE PurchaseOrders 
ADD CONSTRAINT CK_PurchaseOrders_Status 
CHECK (status IN ('Draft','Sent','Approved','Received','Rejected','Completed','Cancelled'));

PRINT 'New constraint added successfully!';

-- =====================================================
-- BƯỚC 4: Kiểm tra lại
-- =====================================================
PRINT '';
PRINT 'Step 4: Verification...';

SELECT 
    cc.name AS ConstraintName,
    cc.definition AS AllowedStatuses
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders')
  AND cc.definition LIKE '%status%';

-- =====================================================
-- BƯỚC 5: Test Cancel một PO (nếu có)
-- =====================================================
PRINT '';
PRINT 'Step 5: Testing cancel operation...';

-- Tìm một PO có status = 'Sent' để test
DECLARE @TestPoId INT;
SELECT TOP 1 @TestPoId = po_id 
FROM PurchaseOrders 
WHERE status = 'Sent';

IF @TestPoId IS NOT NULL
BEGIN
    PRINT 'Found test PO: #' + CAST(@TestPoId AS VARCHAR);
    
    -- Test update (rollback sau)
    BEGIN TRANSACTION;
    
    UPDATE PurchaseOrders 
    SET status = 'Cancelled', 
        notes = CONCAT(COALESCE(notes, ''), CHAR(13) + CHAR(10) + 'Cancellation Reason: Test cancel'),
        updated_at = GETDATE()
    WHERE po_id = @TestPoId;
    
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Test cancel successful! Rolling back...';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        PRINT 'Test cancel failed!';
        ROLLBACK TRANSACTION;
    END
END
ELSE
BEGIN
    PRINT 'No PO with Sent status found for testing';
END

-- =====================================================
-- BƯỚC 6: Kiểm tra các PO đã bị cancel (nếu có)
-- =====================================================
PRINT '';
PRINT 'Step 6: Checking existing cancelled orders...';

SELECT 
    po_id,
    status,
    order_date,
    updated_at,
    notes
FROM PurchaseOrders
WHERE status = 'Cancelled'
ORDER BY updated_at DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT 'No cancelled orders found in database';
END

PRINT '';
PRINT '==========================================';
PRINT 'FIX COMPLETED!';
PRINT '==========================================';
GO

CREATE TABLE IssueSlip (
    slip_id INT IDENTITY(1,1) PRIMARY KEY,      -- ID n?i b? dùng liên k?t b?ng
    slip_code NVARCHAR(50) UNIQUE NOT NULL,     -- Mã phi?u hi?n th? cho ng??i dùng
    request_id INT NOT NULL FOREIGN KEY REFERENCES MedicationRequests(request_id) ON DELETE CASCADE,
    pharmacist_id INT NOT NULL FOREIGN KEY REFERENCES Users(user_id),
    created_date DATETIME DEFAULT GETDATE(),
    notes NVARCHAR(MAX) NULL
);


CREATE TABLE IssueSlipItem (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    slip_id INT NOT NULL FOREIGN KEY REFERENCES IssueSlip(slip_id) ON DELETE CASCADE,
    medicine_code NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Medicines(medicine_code),
    quantity INT NOT NULL CHECK (quantity > 0)
);

USE SWP391;
GO

-- Drop constraint cũ
DECLARE @ConstraintName NVARCHAR(200);
SELECT @ConstraintName = cc.name 
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders')
  AND cc.definition LIKE '%status%';

IF @ConstraintName IS NOT NULL
BEGIN
    DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE PurchaseOrders DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    EXEC sp_executesql @DropSQL;
    PRINT 'Dropped old constraint: ' + @ConstraintName;
END

-- Thêm constraint mới với 'Paid'
ALTER TABLE PurchaseOrders 
ADD CONSTRAINT CK_PurchaseOrders_Status 
CHECK (status IN ('Draft','Sent','Approved','Received','Rejected','Completed','Cancelled','Paid'));

PRINT '✅ Added Paid status to PurchaseOrders';

-- Verify
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS AllowedStatuses
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders')
  AND cc.definition LIKE '%status%';
GO


-- 1. Add balance column to Suppliers table
ALTER TABLE Suppliers ADD balance DECIMAL(12,2) DEFAULT 0;

-- 2. Create SupplierTransactions table for tracking
CREATE TABLE SupplierTransactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL FOREIGN KEY REFERENCES Suppliers(supplier_id),
    po_id INT NOT NULL FOREIGN KEY REFERENCES PurchaseOrders(po_id),
    invoice_id INT FOREIGN KEY REFERENCES Invoices(invoice_id),
    amount DECIMAL(12,2) NOT NULL,
    transaction_type NVARCHAR(20) CHECK (transaction_type IN ('Credit','Debit','Pending','Confirmed')),
    status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Confirmed','Rejected')),
    confirmed_by INT FOREIGN KEY REFERENCES Users(user_id),
    confirmed_at DATETIME,
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE INDEX idx_supplier_transactions ON SupplierTransactions(supplier_id, status);

USE SWP391;
GO

-- Tạo bảng SupplierRatings để lưu lịch sử đánh giá
CREATE TABLE SupplierRatings (
    rating_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_id INT NOT NULL FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    manager_id INT NOT NULL FOREIGN KEY REFERENCES Users(user_id) ON DELETE NO ACTION,
    po_id INT NOT NULL FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE NO ACTION,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Index để tìm kiếm nhanh
CREATE INDEX idx_supplier_ratings ON SupplierRatings(supplier_id, created_at DESC);
CREATE INDEX idx_manager_ratings ON SupplierRatings(manager_id);
CREATE INDEX idx_po_rating ON SupplierRatings(po_id);

-- Stored Procedure: Tính toán lại performance_rating trung bình
IF OBJECT_ID('sp_UpdateSupplierRating', 'P') IS NOT NULL 
    DROP PROCEDURE sp_UpdateSupplierRating;
GO

CREATE PROCEDURE sp_UpdateSupplierRating
    @supplier_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @avg_rating DECIMAL(3,2);
    
    -- Tính trung bình rating
    SELECT @avg_rating = AVG(CAST(rating AS DECIMAL(3,2)))
    FROM SupplierRatings
    WHERE supplier_id = @supplier_id;
    
    -- Cập nhật vào Suppliers table
    UPDATE Suppliers
    SET performance_rating = @avg_rating,
        updated_at = GETDATE()
    WHERE supplier_id = @supplier_id;
    
    SELECT @avg_rating AS new_rating;
END;
GO

PRINT '✅ SupplierRatings table and stored procedure created successfully!';
USE SWP391; 
GO 
-- ===================================================== 
-- BƯỚC 1: Thêm cột batch_quantity vào bảng Batches 
-- ===================================================== 
PRINT 'Step 1: Adding batch_quantity column...'; 
IF NOT EXISTS (SELECT * FROM sys.columns 
WHERE object_id = OBJECT_ID('Batches') 
AND name = 'batch_quantity') 
BEGIN 
ALTER TABLE Batches ADD batch_quantity INT NOT NULL DEFAULT 0 
CHECK (batch_quantity >= 0); 
PRINT '✅ Added batch_quantity column'; 
END 
ELSE 
BEGIN 
PRINT '⚠️ batch_quantity column already exists'; 
END 
GO 
-- ===================================================== 
-- BƯỚC 2: Cập nhật logic cho current_quantity 
-- Current_quantity giờ là tổng của tất cả batch_quantity 
-- cùng medicine_code có status = 'Approved' 
-- ===================================================== 
PRINT ''; 
PRINT 'Step 2: Creating computed column logic...'; 
-- Drop old constraint if exists 
DECLARE @ConstraintName NVARCHAR(200); 
SELECT @ConstraintName = dc.name 
FROM sys.default_constraints dc 
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id 
AND dc.parent_column_id = c.column_id 
WHERE dc.parent_object_id = OBJECT_ID('Batches') 
AND c.name = 'current_quantity'; 
IF @ConstraintName IS NOT NULL 
BEGIN 
DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE Batches DROP CONSTRAINT ' + QUOTENAME(@ConstraintName); 
EXEC sp_executesql @DropSQL; 
PRINT 'Dropped old DEFAULT constraint for current_quantity'; 
END 
GO 
-- ===================================================== 
-- BƯỚC 3: Tạo trigger để tự động cập nhật current_quantity 
-- Khi batch_quantity thay đổi hoặc status = 'Approved' 
-- ===================================================== 
PRINT ''; 
PRINT 'Step 3: Creating trigger to auto-update current_quantity...'; 
IF OBJECT_ID('trg_UpdateMedicineCurrentQuantity', 'TR') IS NOT NULL 
DROP TRIGGER trg_UpdateMedicineCurrentQuantity; 
GO 
CREATE TRIGGER trg_UpdateMedicineCurrentQuantity 
ON Batches 
AFTER INSERT, UPDATE 
AS 
BEGIN 
SET NOCOUNT ON; 
-- Lấy danh sách medicine_code bị ảnh hưởng 
DECLARE @AffectedMedicines TABLE (medicine_code NVARCHAR(50)); 
INSERT INTO @AffectedMedicines 
SELECT DISTINCT medicine_code FROM inserted 
UNION 
SELECT DISTINCT medicine_code FROM deleted; 
-- Cập nhật current_quantity cho mỗi medicine 
-- current_quantity = tổng batch_quantity của các lô Approved 
UPDATE Batches 
SET current_quantity = ( 
SELECT ISNULL(SUM(b2.batch_quantity), 0) 
FROM Batches b2 
WHERE b2.medicine_code = Batches.medicine_code 
AND b2.status = 'Approved' 
) 
WHERE medicine_code IN (SELECT medicine_code FROM @AffectedMedicines); 
END; 
GO 
PRINT '✅ Created trigger: trg_UpdateMedicineCurrentQuantity'; 
-- ===================================================== 
-- BƯỚC 4: Tạo stored procedure để approve batch 
-- ===================================================== 
PRINT ''; 
PRINT 'Step 4: Creating stored procedure for batch approval...'; 
IF OBJECT_ID('sp_ApproveBatch', 'P') IS NOT NULL 
DROP PROCEDURE sp_ApproveBatch; 
GO 
CREATE PROCEDURE sp_ApproveBatch 
@batch_id INT, 
@approved_by INT, 
@notes NVARCHAR(MAX) = NULL 
AS 
BEGIN 
SET NOCOUNT ON; 
BEGIN TRANSACTION; 
BEGIN TRY 
-- Kiểm tra batch tồn tại và đang ở trạng thái Quarantined 
DECLARE @current_status NVARCHAR(20); 
DECLARE @medicine_code NVARCHAR(50); 
DECLARE @batch_qty INT; 
SELECT 
@current_status = status, 
@medicine_code = medicine_code, 
@batch_qty = batch_quantity 
FROM Batches 
WHERE batch_id = @batch_id; 
IF @current_status IS NULL 
BEGIN 
ROLLBACK TRANSACTION; 
SELECT 'ERROR' AS status, N'Lô thuốc không tồn tại' AS message; 
RETURN; 
END 
IF @current_status != 'Quarantined' AND @current_status != 'Received' 
BEGIN 
ROLLBACK TRANSACTION; 
SELECT 'ERROR' AS status, 
N'Chỉ có thể approve lô đang ở trạng thái Quarantined hoặc Received' AS message; 
RETURN; 
END 
-- Update batch status 
UPDATE Batches 
SET status = 'Approved', 
quarantine_notes = CASE 
WHEN @notes IS NOT NULL THEN @notes 
ELSE quarantine_notes 
END, 
updated_at = GETDATE() 
WHERE batch_id = @batch_id; 
-- Log transaction 
INSERT INTO Transactions (batch_id, user_id, type, quantity, notes) 
VALUES (@batch_id, @approved_by, 'QuarantineRelease', @batch_qty, 
N'Phê duyệt lô thuốc'); 
-- Trigger sẽ tự động cập nhật current_quantity 
COMMIT TRANSACTION; 
SELECT 'SUCCESS' AS status, 
N'Đã phê duyệt lô thuốc thành công' AS message, 
@batch_id AS batch_id, 
@medicine_code AS medicine_code, 
@batch_qty AS batch_quantity; 
END TRY 
BEGIN CATCH 
ROLLBACK TRANSACTION; 
SELECT 'ERROR' AS status, 
ERROR_MESSAGE() AS message; 
END CATCH 
END; 
GO 
PRINT '✅ Created procedure: sp_ApproveBatch'; 
-- ===================================================== 
-- BƯỚC 5: Migration dữ liệu cũ 
-- ===================================================== 
PRINT ''; 
PRINT 'Step 5: Migrating existing data...'; 
-- Cập nhật batch_quantity = initial_quantity cho các lô cũ 
UPDATE Batches 
SET batch_quantity = initial_quantity 
WHERE batch_quantity = 0; 
PRINT '✅ Updated batch_quantity for existing batches'; 
-- Recalculate current_quantity 
UPDATE Batches 
SET current_quantity = ( 
SELECT ISNULL(SUM(b2.batch_quantity), 0) 
FROM Batches b2 
WHERE b2.medicine_code = Batches.medicine_code 
AND b2.status = 'Approved' 
); 
PRINT '✅ Recalculated current_quantity'; 
-- ===================================================== 
-- BƯỚC 6: Tạo view để tracking 
-- ===================================================== 
PRINT ''; 
PRINT 'Step 6: Creating tracking view...'; 
IF OBJECT_ID('vw_MedicineStockSummary', 'V') IS NOT NULL 
DROP VIEW vw_MedicineStockSummary; 
GO 
CREATE VIEW vw_MedicineStockSummary AS 
SELECT 
m.medicine_code, 
m.name AS medicine_name, 
m.category, 
m.strength, 
m.dosage_form, 
m.manufacturer, 
COUNT(b.batch_id) AS total_batches, 
SUM(CASE WHEN b.status = 'Approved' THEN 1 ELSE 0 END) AS approved_batches, 
SUM(CASE WHEN b.status = 'Quarantined' THEN 1 ELSE 0 END) AS quarantined_batches, 
SUM(CASE WHEN b.status = 'Approved' THEN b.batch_quantity ELSE 0 END) AS total_quantity, 
MIN(CASE WHEN b.status = 'Approved' AND b.expiry_date > GETDATE() 
THEN b.expiry_date END) AS nearest_expiry_date 
FROM Medicines m 
LEFT JOIN Batches b ON m.medicine_code = b.medicine_code 
GROUP BY 
m.medicine_code, m.name, m.category, m.strength, 
m.dosage_form, m.manufacturer; 
GO 
PRINT '✅ Created view: vw_MedicineStockSummary'; 
-- ===================================================== 
-- VERIFICATION 
-- ===================================================== 
PRINT ''; 
PRINT '========================================'; 
PRINT 'VERIFICATION RESULTS'; 
PRINT '========================================'; 
-- Check column exists 
SELECT 
c.name AS ColumnName, 
t.name AS DataType, 
c.max_length AS MaxLength, 
c.is_nullable AS IsNullable 
FROM sys.columns c 
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id 
WHERE c.object_id = OBJECT_ID('Batches') 
AND c.name IN ('batch_quantity', 'current_quantity', 'initial_quantity'); 
-- Sample data 
PRINT ''; 
PRINT 'Sample batch data:'; 
SELECT TOP 5 
batch_id, 
medicine_code, 
lot_number, 
batch_quantity, 
current_quantity, 
status 
FROM Batches 
ORDER BY batch_id DESC; 
-- Medicine stock summary 
PRINT ''; 
PRINT 'Medicine stock summary:'; 
SELECT TOP 5 * FROM vw_MedicineStockSummary 
ORDER BY total_quantity DESC; 
PRINT ''; 
PRINT '=========================================='; 
PRINT 'DATABASE UPDATE COMPLETED!'; 
PRINT '=========================================='; 
GO











USE SWP391; 
GO 
-- ===================================================== 
-- Thêm status "BatchCreated" vào PurchaseOrders 
-- ===================================================== 
PRINT 'Step 1: Updating PurchaseOrders status constraint...'; 
-- Drop constraint cũ 
DECLARE @ConstraintName NVARCHAR(200); 
SELECT @ConstraintName = cc.name 
FROM sys.check_constraints cc 
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders') 
AND cc.definition LIKE '%status%'; 
IF @ConstraintName IS NOT NULL 
BEGIN 
DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE PurchaseOrders DROP CONSTRAINT ' + QUOTENAME(@ConstraintName); 
EXEC sp_executesql @DropSQL; 
PRINT 'Dropped old constraint: ' + @ConstraintName; 
END 
-- Thêm constraint mới với "BatchCreated" 
ALTER TABLE PurchaseOrders 
ADD CONSTRAINT CK_PurchaseOrders_Status 
CHECK (status IN ('Draft','Sent','Approved','Received','Rejected','Completed','Cancelled','Paid','BatchCreated')); 
PRINT '✅ Added "BatchCreated" status to PurchaseOrders'; 
-- Verify 
SELECT 
cc.name AS ConstraintName, 
cc.definition AS AllowedStatuses 
FROM sys.check_constraints cc 
WHERE cc.parent_object_id = OBJECT_ID('PurchaseOrders') 
AND cc.definition LIKE '%status%'; 
PRINT ''; 
PRINT '=========================================='; 
PRINT 'DATABASE UPDATE COMPLETED!'; 
PRINT '=========================================='; 
GO

USE SWP391;
GO

-- ✅ TRIGGER TỰ ĐỘNG CẬP NHẬT CURRENT_QUANTITY KHI BATCH_QUANTITY THAY ĐỔI
IF OBJECT_ID('trg_UpdateCurrentQuantity', 'TR') IS NOT NULL 
    DROP TRIGGER trg_UpdateCurrentQuantity;
GO

CREATE TRIGGER trg_UpdateCurrentQuantity
ON Batches
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy danh sách medicine_code bị ảnh hưởng
    DECLARE @AffectedMedicines TABLE (medicine_code NVARCHAR(50));
    
    INSERT INTO @AffectedMedicines
    SELECT DISTINCT medicine_code FROM inserted
    UNION
    SELECT DISTINCT medicine_code FROM deleted;
    
    -- Cập nhật current_quantity = tổng batch_quantity của các lô Approved
    UPDATE Batches
    SET current_quantity = (
        SELECT ISNULL(SUM(b2.batch_quantity), 0)
        FROM Batches b2
        WHERE b2.medicine_code = Batches.medicine_code
        AND b2.status = 'Approved'
    )
    WHERE medicine_code IN (SELECT medicine_code FROM @AffectedMedicines);
END;
GO

PRINT '✅ Trigger trg_UpdateCurrentQuantity created successfully!';

USE SWP391;
GO

-- Thêm cột batch_id vào IssueSlipItem
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('IssueSlipItem') 
               AND name = 'batch_id')
BEGIN
    ALTER TABLE IssueSlipItem 
    ADD batch_id INT NULL 
    FOREIGN KEY REFERENCES Batches(batch_id);
    
    PRINT '✅ Added batch_id column to IssueSlipItem';
END
ELSE
BEGIN
    PRINT '⚠️ batch_id already exists in IssueSlipItem';
END
GO
