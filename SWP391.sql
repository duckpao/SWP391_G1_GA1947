-- Hospital Warehouse Management System (HWMS) - SQL Server Version
-- Compatible with SQL Server 2016+ (using SQL_Latin1_General_CP1_CI_AS)
-- Last Updated: 2025-09-23 17:02 +07

SET NOCOUNT ON;
GO

-- Drop and recreate database
BEGIN TRY
    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'hwms')
    BEGIN
        -- Kill all active connections except the current session
        DECLARE @killCommand NVARCHAR(4000) = '';
        SELECT @killCommand += 'KILL ' + CAST(session_id AS NVARCHAR(10)) + ';'
        FROM sys.dm_exec_sessions
        WHERE database_id = DB_ID('hwms')
        AND session_id <> @@SPID;

        IF @killCommand <> ''
            EXEC sp_executesql @killCommand;

        -- Set to single user mode and drop
        ALTER DATABASE hwms SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE hwms;
        PRINT 'Database hwms dropped successfully.';
    END

    CREATE DATABASE hwms COLLATE SQL_Latin1_General_CP1_CI_AS;
    PRINT 'Database hwms created successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error creating/dropping database: ' + ERROR_MESSAGE();
    RETURN;
END CATCH
GO

USE hwms;
GO

-- Drop all tables in reverse dependency order
BEGIN TRY
    DROP TABLE IF EXISTS AuditReports;
    DROP TABLE IF EXISTS Transactions;
    DROP TABLE IF EXISTS DeliveryNotes;
    DROP TABLE IF EXISTS Invoices;
    DROP TABLE IF EXISTS ASNItems;
    DROP TABLE IF EXISTS AdvancedShippingNotices;
    DROP TABLE IF EXISTS PurchaseOrderItems;
    DROP TABLE IF EXISTS PurchaseOrders;
    DROP TABLE IF EXISTS MedicationRequestItems;
    DROP TABLE IF EXISTS MedicationRequests;
    DROP TABLE IF EXISTS Batches;
    DROP TABLE IF EXISTS UserPermissions;
    DROP TABLE IF EXISTS Users;
    DROP TABLE IF EXISTS Medicines;
    DROP TABLE IF EXISTS Suppliers;
    DROP TABLE IF EXISTS Permissions;
    DROP TABLE IF EXISTS SystemLogs;
    DROP TABLE IF EXISTS SystemConfig;
    PRINT 'Existing tables dropped successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error dropping tables: ' + ERROR_MESSAGE();
END CATCH
GO

-- Create Tables
BEGIN TRY
    -- Permissions
    CREATE TABLE Permissions (
        permission_id INT IDENTITY(1,1) PRIMARY KEY,
        permission_name VARCHAR(100) UNIQUE NOT NULL,
        description NVARCHAR(MAX)
    );
    PRINT 'Permissions table created.';

    -- Suppliers
    CREATE TABLE Suppliers (
        supplier_id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        contact_email NVARCHAR(255),
        contact_phone NVARCHAR(255),
        address NVARCHAR(MAX),
        performance_rating DECIMAL(3,2) DEFAULT 0.0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'Suppliers table created.';

    -- Users
    CREATE TABLE Users (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        email NVARCHAR(255),
        phone NVARCHAR(255),
        role VARCHAR(50) CHECK (role IN ('Doctor', 'Pharmacist', 'Manager', 'Auditor', 'Admin', 'Supplier')) NOT NULL,
        supplier_id INT NULL,
        is_active BIT DEFAULT 1,
        failed_attempts INT DEFAULT 0 CHECK (failed_attempts <= 5),
        last_login DATETIME NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'Users table created.';

    -- UserPermissions
    CREATE TABLE UserPermissions (
        user_id INT,
        permission_id INT,
        PRIMARY KEY (user_id, permission_id)
    );
    PRINT 'UserPermissions table created.';

    -- Medicines
    CREATE TABLE Medicines (
        medicine_id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        category VARCHAR(50),
        description NVARCHAR(MAX),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'Medicines table created.';

    -- Batches
    CREATE TABLE Batches (
        batch_id INT IDENTITY(1,1) PRIMARY KEY,
        medicine_id INT,
        supplier_id INT,
        lot_number VARCHAR(50) NOT NULL,
        expiry_date DATE NOT NULL,
        received_date DATE DEFAULT CURRENT_TIMESTAMP,
        initial_quantity INT NOT NULL CHECK (initial_quantity >= 0),
        current_quantity INT NOT NULL CHECK (current_quantity >= 0),
        status VARCHAR(20) CHECK (status IN ('Received', 'Quarantined', 'Approved', 'Rejected', 'Expired')) DEFAULT 'Quarantined',
        quarantine_notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'Batches table created.';

    -- MedicationRequests
    CREATE TABLE MedicationRequests (
        request_id INT IDENTITY(1,1) PRIMARY KEY,
        doctor_id INT,
        status VARCHAR(20) CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Canceled', 'Fulfilled')) DEFAULT 'Pending',
        request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        notes NVARCHAR(MAX)
    );
    PRINT 'MedicationRequests table created.';

    -- MedicationRequestItems
    CREATE TABLE MedicationRequestItems (
        item_id INT IDENTITY(1,1) PRIMARY KEY,
        request_id INT,
        medicine_id INT,
        quantity INT NOT NULL CHECK (quantity > 0)
    );
    PRINT 'MedicationRequestItems table created.';

    -- PurchaseOrders
    CREATE TABLE PurchaseOrders (
        po_id INT IDENTITY(1,1) PRIMARY KEY,
        manager_id INT,
        supplier_id INT,
        status VARCHAR(20) CHECK (status IN ('Draft', 'Sent', 'Received', 'Rejected', 'Completed')) DEFAULT 'Draft',
        order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        expected_delivery_date DATE,
        notes NVARCHAR(MAX)
    );
    PRINT 'PurchaseOrders table created.';

    -- PurchaseOrderItems
    CREATE TABLE PurchaseOrderItems (
        item_id INT IDENTITY(1,1) PRIMARY KEY,
        po_id INT,
        medicine_id INT,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(10,2)
    );
    PRINT 'PurchaseOrderItems table created.';

    -- AdvancedShippingNotices
    CREATE TABLE AdvancedShippingNotices (
        asn_id INT IDENTITY(1,1) PRIMARY KEY,
        po_id INT,
        supplier_id INT,
        shipment_date DATE NOT NULL,
        carrier VARCHAR(100),
        tracking_number VARCHAR(50),
        status VARCHAR(20) CHECK (status IN ('Sent', 'InTransit', 'Delivered')) DEFAULT 'Sent',
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'AdvancedShippingNotices table created.';

    -- ASNItems
    CREATE TABLE ASNItems (
        item_id INT IDENTITY(1,1) PRIMARY KEY,
        asn_id INT,
        medicine_id INT,
        quantity INT NOT NULL CHECK (quantity > 0),
        lot_number VARCHAR(50)
    );
    PRINT 'ASNItems table created.';

    -- DeliveryNotes
    CREATE TABLE DeliveryNotes (
        dn_id INT IDENTITY(1,1) PRIMARY KEY,
        asn_id INT,
        po_id INT,
        delivery_date DATE DEFAULT CURRENT_TIMESTAMP,
        received_by INT,
        status VARCHAR(20) CHECK (status IN ('Partial', 'Complete', 'Discrepant')) DEFAULT 'Complete',
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'DeliveryNotes table created.';

    -- Invoices
    CREATE TABLE Invoices (
        invoice_id INT IDENTITY(1,1) PRIMARY KEY,
        po_id INT,
        asn_id INT,
        supplier_id INT,
        invoice_number VARCHAR(50) UNIQUE NOT NULL,
        invoice_date DATE NOT NULL,
        amount DECIMAL(12,2) NOT NULL,
        status VARCHAR(20) CHECK (status IN ('Pending', 'Paid', 'Disputed')) DEFAULT 'Pending',
        notes NVARCHAR(MAX),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'Invoices table created.';

    -- Transactions
    CREATE TABLE Transactions (
        transaction_id INT IDENTITY(1,1) PRIMARY KEY,
        batch_id INT,
        user_id INT,
        dn_id INT,
        type VARCHAR(20) CHECK (type IN ('In', 'Out', 'Expired', 'Damaged', 'Adjustment', 'QuarantineRelease')) NOT NULL,
        quantity INT NOT NULL,
        transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        notes NVARCHAR(MAX)
    );
    PRINT 'Transactions table created.';

    -- SystemLogs
    CREATE TABLE SystemLogs (
        log_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT,
        action VARCHAR(100) NOT NULL,
        table_name VARCHAR(50),
        record_id INT,
        old_value NVARCHAR(MAX),
        new_value NVARCHAR(MAX),
        details NVARCHAR(MAX),
        ip_address VARCHAR(50),
        log_date DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'SystemLogs table created.';

    -- AuditReports
    CREATE TABLE AuditReports (
        report_id INT IDENTITY(1,1) PRIMARY KEY,
        auditor_id INT,
        report_type VARCHAR(50) CHECK (report_type IN ('SupplierPerformance', 'PurchaseHistory', 'InventoryAudit', 'UserActivity')) NOT NULL,
        generated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        data NVARCHAR(MAX),
        exported_format VARCHAR(20) CHECK (exported_format IN ('Excel', 'PDF')),
        notes NVARCHAR(MAX)
    );
    PRINT 'AuditReports table created.';

    -- SystemConfig
    CREATE TABLE SystemConfig (
        config_key VARCHAR(50) PRIMARY KEY,
        config_value NVARCHAR(MAX),
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    PRINT 'SystemConfig table created.';
END TRY
BEGIN CATCH
    PRINT 'Error creating tables: ' + ERROR_MESSAGE();
END CATCH
GO

-- Add Foreign Key Constraints
BEGIN TRY
    ALTER TABLE UserPermissions ADD
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        FOREIGN KEY (permission_id) REFERENCES Permissions(permission_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to UserPermissions.';

    ALTER TABLE Batches ADD
        FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id) ON DELETE CASCADE,
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);
    PRINT 'Foreign keys added to Batches.';

    ALTER TABLE MedicationRequests ADD
        FOREIGN KEY (doctor_id) REFERENCES Users(user_id) ON DELETE SET NULL;
    PRINT 'Foreign key added to MedicationRequests.';

    ALTER TABLE MedicationRequestItems ADD
        FOREIGN KEY (request_id) REFERENCES MedicationRequests(request_id) ON DELETE CASCADE,
        FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to MedicationRequestItems.';

    ALTER TABLE PurchaseOrders ADD
        FOREIGN KEY (manager_id) REFERENCES Users(user_id) ON DELETE SET NULL,
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to PurchaseOrders.';

    ALTER TABLE PurchaseOrderItems ADD
        FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
        FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to PurchaseOrderItems.';

    ALTER TABLE AdvancedShippingNotices ADD
        FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to AdvancedShippingNotices.';

    ALTER TABLE ASNItems ADD
        FOREIGN KEY (asn_id) REFERENCES AdvancedShippingNotices(asn_id) ON DELETE CASCADE,
        FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to ASNItems.';

    ALTER TABLE DeliveryNotes ADD
        FOREIGN KEY (asn_id) REFERENCES AdvancedShippingNotices(asn_id) ON DELETE SET NULL,
        FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
        FOREIGN KEY (received_by) REFERENCES Users(user_id) ON DELETE SET NULL;
    PRINT 'Foreign keys added to DeliveryNotes.';

    ALTER TABLE Invoices ADD
        FOREIGN KEY (po_id) REFERENCES PurchaseOrders(po_id) ON DELETE CASCADE,
        FOREIGN KEY (asn_id) REFERENCES AdvancedShippingNotices(asn_id) ON DELETE SET NULL,
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE;
    PRINT 'Foreign keys added to Invoices.';

    ALTER TABLE Transactions ADD
        FOREIGN KEY (batch_id) REFERENCES Batches(batch_id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
        FOREIGN KEY (dn_id) REFERENCES DeliveryNotes(dn_id) ON DELETE SET NULL;
    PRINT 'Foreign keys added to Transactions.';

    ALTER TABLE AuditReports ADD
        FOREIGN KEY (auditor_id) REFERENCES Users(user_id) ON DELETE SET NULL;
    PRINT 'Foreign key added to AuditReports.';
END TRY
BEGIN CATCH
    PRINT 'Error adding foreign keys: ' + ERROR_MESSAGE();
END CATCH
GO

-- Create Indexes
BEGIN TRY
    CREATE INDEX idx_username ON Users(username);
    CREATE INDEX idx_medicine_name ON Medicines(name);
    CREATE INDEX idx_batch_expiry ON Batches(expiry_date);
    CREATE INDEX idx_batch_status ON Batches(status);
    CREATE INDEX idx_transaction_date ON Transactions(transaction_date);
    CREATE INDEX idx_log_date ON SystemLogs(log_date);
    CREATE INDEX idx_asn_po ON AdvancedShippingNotices(po_id);
    CREATE INDEX idx_invoice_po ON Invoices(po_id);
    CREATE INDEX idx_batch_medicine ON Batches(medicine_id); -- Added for optimization
    CREATE INDEX idx_transaction_batch ON Transactions(batch_id); -- Added for optimization
    PRINT 'Indexes created successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error creating indexes: ' + ERROR_MESSAGE();
END CATCH
GO

-- Create Update Triggers
BEGIN TRY
    -- Suppliers Update Trigger
    EXEC('CREATE TRIGGER trg_suppliers_update ON Suppliers AFTER UPDATE AS 
          BEGIN 
              UPDATE s SET updated_at = CURRENT_TIMESTAMP 
              FROM Suppliers s INNER JOIN inserted i ON s.supplier_id = i.supplier_id; 
          END');
    PRINT 'Trigger trg_suppliers_update created.';

    -- Users Update Trigger
    EXEC('CREATE TRIGGER trg_users_update ON Users AFTER UPDATE AS 
          BEGIN 
              UPDATE u SET updated_at = CURRENT_TIMESTAMP 
              FROM Users u INNER JOIN inserted i ON u.user_id = i.user_id; 
          END');
    PRINT 'Trigger trg_users_update created.';

    -- Medicines Update Trigger
    EXEC('CREATE TRIGGER trg_medicines_update ON Medicines AFTER UPDATE AS 
          BEGIN 
              UPDATE m SET updated_at = CURRENT_TIMESTAMP 
              FROM Medicines m INNER JOIN inserted i ON m.medicine_id = i.medicine_id; 
          END');
    PRINT 'Trigger trg_medicines_update created.';

    -- Batches Update Trigger
    EXEC('CREATE TRIGGER trg_batches_update ON Batches AFTER UPDATE AS 
          BEGIN 
              UPDATE b SET updated_at = CURRENT_TIMESTAMP 
              FROM Batches b INNER JOIN inserted i ON b.batch_id = i.batch_id; 
          END');
    PRINT 'Trigger trg_batches_update created.';

    -- AdvancedShippingNotices Update Trigger
    EXEC('CREATE TRIGGER trg_asn_update ON AdvancedShippingNotices AFTER UPDATE AS 
          BEGIN 
              UPDATE a SET updated_at = CURRENT_TIMESTAMP 
              FROM AdvancedShippingNotices a INNER JOIN inserted i ON a.asn_id = i.asn_id; 
          END');
    PRINT 'Trigger trg_asn_update created.';

    -- Invoices Update Trigger
    EXEC('CREATE TRIGGER trg_invoices_update ON Invoices AFTER UPDATE AS 
          BEGIN 
              UPDATE inv SET updated_at = CURRENT_TIMESTAMP 
              FROM Invoices inv INNER JOIN inserted i ON inv.invoice_id = i.invoice_id; 
          END');
    PRINT 'Trigger trg_invoices_update created.';

    -- SystemConfig Update Trigger
    EXEC('CREATE TRIGGER trg_systemconfig_update ON SystemConfig AFTER UPDATE AS 
          BEGIN 
              UPDATE sc SET updated_at = CURRENT_TIMESTAMP 
              FROM SystemConfig sc INNER JOIN inserted i ON sc.config_key = i.config_key; 
          END');
    PRINT 'Trigger trg_systemconfig_update created.';
END TRY
BEGIN CATCH
    PRINT 'Error creating update triggers: ' + ERROR_MESSAGE();
END CATCH
GO

-- Create Stock Update Trigger
BEGIN TRY
    EXEC('CREATE TRIGGER stock_update ON Transactions AFTER INSERT AS 
          BEGIN 
              -- Subtract quantity for Out, Expired, Damaged
              UPDATE b SET b.current_quantity = b.current_quantity - i.quantity 
              FROM Batches b INNER JOIN inserted i ON b.batch_id = i.batch_id 
              WHERE i.type IN (''Out'', ''Expired'', ''Damaged'') AND b.current_quantity >= i.quantity;

              -- Add quantity for In
              UPDATE b SET b.current_quantity = b.current_quantity + i.quantity 
              FROM Batches b INNER JOIN inserted i ON b.batch_id = i.batch_id 
              WHERE i.type = ''In'';

              -- Update status for QuarantineRelease
              UPDATE b SET b.status = ''Approved'' 
              FROM Batches b INNER JOIN inserted i ON b.batch_id = i.batch_id 
              WHERE i.type = ''QuarantineRelease'';
          END');
    PRINT 'Trigger stock_update created.';
END TRY
BEGIN CATCH
    PRINT 'Error creating trigger stock_update: ' + ERROR_MESSAGE();
END CATCH
GO

-- Insert Initial Data
BEGIN TRY
    INSERT INTO SystemConfig (config_key, config_value)
    VALUES 
        ('low_stock_threshold', '10'),
        ('max_failed_attempts', '5'),
        ('quarantine_period_days', '14');
    PRINT 'SystemConfig data inserted.';

    INSERT INTO Permissions (permission_name, description)
    VALUES
        ('admin', 'Full administrative access to the system'),
        ('manager', 'Manage purchase orders and inventory'),
        ('auditor', 'Audit system logs and generate reports'),
        ('doctor', 'Request medications for patients'),
        ('pharmacist', 'Dispense medications and manage stock'),
        ('supplier', 'Create and manage shipping notices');
    PRINT 'Permissions data inserted.';
END TRY
BEGIN CATCH
    PRINT 'Error inserting initial data: ' + ERROR_MESSAGE();
END CATCH
GO