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
    user_id INT UNIQUE FOREIGN KEY REFERENCES Users(user_id),
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
VALUES ('admin', '$2a$12$K9nUjmnWq6sNYy0npqvGEuvghhATiOb2jCck9yA/foqghFG9lYK4u', 'admin@example.com', '12345678901', 'Admin', 1, 0, NULL, GETDATE(), GETDATE());
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
-- SAMPLE DATA FOR USER ACTIVITY
-- =========================================
INSERT INTO Users (username, password_hash, email, phone, role)
VALUES 
('doctor1', 'hash1', 'doctor1@hospital.com', '0900000001', 'Doctor'),
('pharma1', 'hash2', 'pharma1@hospital.com', '0900000002', 'Pharmacist'),
('auditor1', 'hash3', 'audit@hospital.com', '0900000003', 'Auditor');
GO

INSERT INTO SystemLogs (user_id, action, table_name, details, log_date)
VALUES
(2, 'Login', 'Users', 'Doctor logged in', GETDATE()-1),
(2, 'View', 'Medicines', 'Doctor viewed drug list', GETDATE()),
(3, 'Login', 'Users', 'Pharmacist logged in', GETDATE()-2),
(3, 'Add', 'Batches', 'Added new medicine batch', GETDATE()-1),
(3, 'Update', 'Batches', 'Updated stock quantity', GETDATE()),
(4, 'Login', 'Users', 'Auditor logged in', GETDATE());
GO

-- =========================================
-- EXECUTE REFRESH AND GENERATE REPORT
-- =========================================
EXEC sp_RefreshUserActivitySummary;
GO

EXEC sp_GenerateUserActivityReport @auditor_id = 4, @export_format = 'Excel';
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
