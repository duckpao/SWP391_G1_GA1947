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
    role NVARCHAR(50) NOT NULL CHECK (role IN ('Doctor', 'Pharmacist', 'Manager', 'Auditor', 'Admin', 'ProcurementOfficer', 'Supplier')),
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
INSERT INTO SystemConfig (config_key, config_value)
SELECT 'quarantine_period_days','14' WHERE NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key='quarantine_period_days');

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

CREATE TRIGGER trg_LogUserUpdate
ON Users
AFTER UPDATE
AS
BEGIN
    INSERT INTO SystemLogs (user_id, action, table_name, record_id, old_value, new_value, details, ip_address, log_date)
    SELECT 
        i.user_id,
        'UpdateProfile',
        'Users',
        i.user_id,
        (SELECT STRING_AGG(CONCAT(c.name, ': ', CONVERT(NVARCHAR(MAX), d.value)), ', ') 
         FROM sys.columns c
         CROSS APPLY (SELECT CONVERT(NVARCHAR(MAX), d.c.value('(./text())[1]', 'NVARCHAR(MAX)')) AS value) d
         WHERE c.object_id = OBJECT_ID('Users')),
        NULL,
        'User profile updated',
        '127.0.0.1',
        GETDATE()
    FROM inserted i;
END;
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

    INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, ip_address, log_date)
    VALUES
    (@mgr2, 'LOGIN', 'Users', @mgr2, N'Manager2 đăng nhập', '192.168.1.105', GETDATE()-6),
    (@doc2, 'CREATE', 'MedicationRequests', NULL, N'Tạo yêu cầu thuốc mới', '192.168.1.106', GETDATE()-4),
    (@phar2, 'UPDATE', 'Batches', NULL, N'Cập nhật trạng thái lô hàng', '192.168.1.107', GETDATE()-2),
    (@mgr2, 'APPROVE', 'PurchaseOrders', NULL, N'Phê duyệt đơn đặt hàng', '192.168.1.105', GETDATE()-1),
    (@aud2, 'GENERATE', 'AuditReports', NULL, N'Tạo báo cáo kiểm toán', '192.168.1.108', GETDATE());
END
GO

-- =========================================
-- 16. AUDIT REPORTS (5 additional records)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM AuditReports WHERE notes LIKE N'%Đánh giá tháng 10%')
BEGIN
    DECLARE @aud2 INT = (SELECT user_id FROM Users WHERE username = 'auditor2');
    IF @aud2 IS NULL SET @aud2 = (SELECT TOP 1 user_id FROM Users WHERE role = 'Auditor' ORDER BY user_id DESC);

    INSERT INTO AuditReports (auditor_id, report_type, generated_date, data, exported_format, notes)
    VALUES
    (@aud2, 'SupplierPerformance', GETDATE()-8, '{"suppliers":[{"name":"Công ty Dược C","rating":4.8}]}', 'Excel', N'Đánh giá tháng 10/2025'),
    (@aud2, 'PurchaseHistory', GETDATE()-6, '{"total_orders":25,"total_amount":75000000}', 'PDF', N'Lịch sử mua hàng quý 4/2024'),
    (@aud2, 'InventoryAudit', GETDATE()-4, '{"total_medicines":200,"total_value":350000000}', 'Excel', N'Kiểm kê tồn kho tháng 10'),
    (@aud2, 'UserActivity', GETDATE()-2, '{"active_users":30,"total_actions":650}', 'Excel', N'Hoạt động người dùng 2 tuần qua'),
    (@aud2, 'SupplierPerformance', GETDATE(), '{"suppliers":[{"name":"Công ty Dược D","rating":4.0}]}', 'PDF', N'Báo cáo nhà cung cấp mới nhất');
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

