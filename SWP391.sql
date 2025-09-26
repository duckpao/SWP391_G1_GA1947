IF DB_ID('SWP391') IS NOT NULL 
    DROP DATABASE	SWP391;
GO

CREATE DATABASE SWP391;
GO

USE SWP391;
GO

IF OBJECT_ID('Permissions', 'U') IS NOT NULL DROP TABLE Permissions; 
CREATE TABLE Permissions ( 
	permission_id INT IDENTITY(1,1) PRIMARY KEY, 
	permission_name NVARCHAR(100) UNIQUE NOT NULL, 
	description NVARCHAR(MAX) 
);

IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers; 
CREATE TABLE Suppliers ( supplier_id INT IDENTITY(1,1) PRIMARY KEY, 
	name NVARCHAR(100) NOT NULL, contact_email NVARCHAR(255), 
	contact_phone NVARCHAR(50), 
	address NVARCHAR(MAX), 
	performance_rating DECIMAL(3,2) DEFAULT 0.0, created_at DATETIME DEFAULT GETDATE(), 
	updated_at DATETIME DEFAULT GETDATE() 
);

IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users; 
CREATE TABLE Users ( 
	user_id INT IDENTITY(1,1) PRIMARY KEY, 
	username NVARCHAR(50) UNIQUE NOT NULL, 
	password_hash NVARCHAR(255) NOT NULL, 
	email NVARCHAR(255), 
	phone NVARCHAR(50), 
	role NVARCHAR(50) NOT NULL CHECK (role IN ('Doctor', 'Pharmacist', 'Manager', 'Auditor', 'Admin', 'ProcurementOfficer', 'Supplier')), 
	supplier_id INT NULL FOREIGN KEY REFERENCES Suppliers(supplier_id), 
	is_active BIT DEFAULT 1, 
	failed_attempts INT DEFAULT 0 CHECK (failed_attempts <= 5), 
	last_login DATETIME NULL, created_at DATETIME DEFAULT GETDATE(), updated_at DATETIME DEFAULT GETDATE() 
);

IF OBJECT_ID('UserPermissions', 'U') IS NOT NULL DROP TABLE UserPermissions; 
CREATE TABLE UserPermissions ( 
	user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE CASCADE,
	permission_id INT FOREIGN KEY REFERENCES Permissions(permission_id) ON DELETE CASCADE, 
	PRIMARY KEY (user_id, permission_id) 
);

IF OBJECT_ID('Medicines', 'U') IS NOT NULL DROP TABLE Medicines; 
CREATE TABLE Medicines ( 
	medicine_id INT IDENTITY(1,1) PRIMARY KEY, 
	name NVARCHAR(100) NOT NULL, 
	category NVARCHAR(50), 
	description NVARCHAR(MAX), 
	created_at DATETIME DEFAULT GETDATE(), 
	updated_at DATETIME DEFAULT GETDATE() 
);

IF OBJECT_ID('Batches', 'U') IS NOT NULL DROP TABLE Batches; 
CREATE TABLE Batches ( 
	batch_id INT IDENTITY(1,1) PRIMARY KEY, 
	medicine_id INT FOREIGN KEY REFERENCES Medicines(medicine_id) ON DELETE CASCADE, 
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

IF OBJECT_ID('MedicationRequests', 'U') IS NOT NULL DROP TABLE MedicationRequests; 
CREATE TABLE MedicationRequests ( 
	request_id INT IDENTITY(1,1) PRIMARY KEY, 
	doctor_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL, 
	status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending','Approved','Rejected','Canceled','Fulfilled')), 
	request_date DATETIME DEFAULT GETDATE(), notes NVARCHAR(MAX) 
);

IF OBJECT_ID('MedicationRequestItems', 'U') IS NOT NULL DROP TABLE MedicationRequestItems; 
CREATE TABLE MedicationRequestItems ( 
	item_id INT IDENTITY(1,1) PRIMARY KEY, 
	request_id INT FOREIGN KEY REFERENCES MedicationRequests(request_id) ON DELETE CASCADE, 
	medicine_id INT FOREIGN KEY REFERENCES Medicines(medicine_id) ON DELETE CASCADE, 
	quantity INT NOT NULL CHECK (quantity > 0) 
);

IF OBJECT_ID('PurchaseOrders', 'U') IS NOT NULL DROP TABLE PurchaseOrders; 
CREATE TABLE PurchaseOrders ( 
	po_id INT IDENTITY(1,1) PRIMARY KEY, 
	manager_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL, 
	supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE CASCADE, 
	status NVARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft','Sent','Received','Rejected','Completed')), 
	order_date DATETIME DEFAULT GETDATE(), expected_delivery_date DATE, notes NVARCHAR(MAX) 
);

IF OBJECT_ID('PurchaseOrderItems', 'U') IS NOT NULL DROP TABLE PurchaseOrderItems; 
CREATE TABLE PurchaseOrderItems ( 
	item_id INT IDENTITY(1,1) PRIMARY KEY, 
	po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE, 
	medicine_id INT FOREIGN KEY REFERENCES Medicines(medicine_id) ON DELETE CASCADE, 
	quantity INT NOT NULL CHECK (quantity > 0),
	unit_price DECIMAL(10,2) 
);

IF OBJECT_ID('AdvancedShippingNotices', 'U') IS NOT NULL DROP TABLE AdvancedShippingNotices;
CREATE TABLE AdvancedShippingNotices (
    asn_id INT IDENTITY(1,1) PRIMARY KEY,
    po_id INT FOREIGN KEY REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id) ON DELETE NO ACTION,
    shipment_date DATE NOT NULL,
    carrier NVARCHAR(100),
    tracking_number NVARCHAR(50),
    status NVARCHAR(20) DEFAULT 'Sent' CHECK (status IN ('Sent','InTransit','Delivered')),
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- =========================================
-- ASNItems
-- =========================================
IF OBJECT_ID('ASNItems', 'U') IS NOT NULL DROP TABLE ASNItems;
CREATE TABLE ASNItems (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    asn_id INT FOREIGN KEY REFERENCES AdvancedShippingNotices(asn_id) ON DELETE CASCADE,
    medicine_id INT FOREIGN KEY REFERENCES Medicines(medicine_id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    lot_number NVARCHAR(50)
);

-- =========================================
-- DeliveryNotes
-- =========================================
IF OBJECT_ID('DeliveryNotes', 'U') IS NOT NULL DROP TABLE DeliveryNotes;
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


-- =========================================
-- Invoices
-- =========================================
IF OBJECT_ID('Invoices', 'U') IS NOT NULL DROP TABLE Invoices;
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

-- =========================================
-- Transactions
-- =========================================
IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions;
CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    batch_id INT FOREIGN KEY REFERENCES Batches(batch_id) ON DELETE CASCADE,
    user_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL,
    dn_id INT FOREIGN KEY REFERENCES DeliveryNotes(dn_id) ON DELETE SET NULL,
    type NVARCHAR(30) NOT NULL CHECK (type IN 
        ('In','Out','Expired','Damaged','Adjustment','QuarantineRelease')),
    quantity INT NOT NULL,
    transaction_date DATETIME DEFAULT GETDATE(),
    notes NVARCHAR(MAX)
);

-- =========================================
-- SystemLogs
-- =========================================
IF OBJECT_ID('SystemLogs', 'U') IS NOT NULL DROP TABLE SystemLogs;
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

-- =========================================
-- AuditReports
-- =========================================
IF OBJECT_ID('AuditReports', 'U') IS NOT NULL DROP TABLE AuditReports;
CREATE TABLE AuditReports (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    auditor_id INT FOREIGN KEY REFERENCES Users(user_id) ON DELETE SET NULL,
    report_type NVARCHAR(50) NOT NULL CHECK (report_type IN 
        ('SupplierPerformance','PurchaseHistory','InventoryAudit','UserActivity')),
    generated_date DATETIME DEFAULT GETDATE(),
    data NVARCHAR(MAX),
    exported_format NVARCHAR(10) CHECK (exported_format IN ('Excel','PDF')),
    notes NVARCHAR(MAX)
);

-- =========================================
-- SystemConfig
-- =========================================
IF OBJECT_ID('SystemConfig', 'U') IS NOT NULL DROP TABLE SystemConfig;
CREATE TABLE SystemConfig (
    config_key NVARCHAR(50) PRIMARY KEY,
    config_value NVARCHAR(MAX),
    updated_at DATETIME DEFAULT GETDATE()
);

-- =========================================
-- Indexes (safe re-run)
-- =========================================
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_username' AND object_id = OBJECT_ID('Users'))
    DROP INDEX idx_username ON Users;
CREATE UNIQUE INDEX idx_username ON Users(username);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_medicine_name' AND object_id = OBJECT_ID('Medicines'))
    DROP INDEX idx_medicine_name ON Medicines;
CREATE INDEX idx_medicine_name ON Medicines(name);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_batch_expiry' AND object_id = OBJECT_ID('Batches'))
    DROP INDEX idx_batch_expiry ON Batches;
CREATE INDEX idx_batch_expiry ON Batches(expiry_date);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_batch_status' AND object_id = OBJECT_ID('Batches'))
    DROP INDEX idx_batch_status ON Batches;
CREATE INDEX idx_batch_status ON Batches(status);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_transaction_date' AND object_id = OBJECT_ID('Transactions'))
    DROP INDEX idx_transaction_date ON Transactions;
CREATE INDEX idx_transaction_date ON Transactions(transaction_date);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_log_date' AND object_id = OBJECT_ID('SystemLogs'))
    DROP INDEX idx_log_date ON SystemLogs;
CREATE INDEX idx_log_date ON SystemLogs(log_date);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_asn_po' AND object_id = OBJECT_ID('AdvancedShippingNotices'))
    DROP INDEX idx_asn_po ON AdvancedShippingNotices;
CREATE INDEX idx_asn_po ON AdvancedShippingNotices(po_id);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_invoice_po' AND object_id = OBJECT_ID('Invoices'))
    DROP INDEX idx_invoice_po ON Invoices;
CREATE INDEX idx_invoice_po ON Invoices(po_id);

-- =========================================
-- Initial Data (safe insert)
-- =========================================
IF NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key = 'low_stock_threshold')
    INSERT INTO SystemConfig (config_key, config_value) VALUES ('low_stock_threshold', '10');

IF NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key = 'max_failed_attempts')
    INSERT INTO SystemConfig (config_key, config_value) VALUES ('max_failed_attempts', '5');

IF NOT EXISTS (SELECT 1 FROM SystemConfig WHERE config_key = 'quarantine_period_days')
    INSERT INTO SystemConfig (config_key, config_value) VALUES ('quarantine_period_days', '14');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'view_inventory')
    INSERT INTO Permissions (permission_name, description) VALUES ('view_inventory', 'View medicines and stock');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'manage_stock')
    INSERT INTO Permissions (permission_name, description) VALUES ('manage_stock', 'Process stock in/out');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'approve_po')
    INSERT INTO Permissions (permission_name, description) VALUES ('approve_po', 'Create/approve purchase orders');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'audit_logs')
    INSERT INTO Permissions (permission_name, description) VALUES ('audit_logs', 'View system logs');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'manage_quarantine')
    INSERT INTO Permissions (permission_name, description) VALUES ('manage_quarantine', 'Monitor and release quarantined batches');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'create_asn')
    INSERT INTO Permissions (permission_name, description) VALUES ('create_asn', 'Create Advanced Shipping Notices (for suppliers)');

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE permission_name = 'confirm_delivery')
    INSERT INTO Permissions (permission_name, description) VALUES ('confirm_delivery', 'Confirm deliveries and create delivery notes');