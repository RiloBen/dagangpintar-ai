-- Inisialisasi Database DagangPintar AI
CREATE DATABASE IF NOT EXISTS dagangpintar_db;
USE dagangpintar_db; 

-- 1. Tabel SKU / Produk
CREATE TABLE IF NOT EXISTS skus (
    sku_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    category VARCHAR(50) NOT NULL,
    hpp DECIMAL(12, 2) NOT NULL, 
    normal_price DECIMAL(12, 2) NOT NULL,
    floor_price DECIMAL(12, 2) NOT NULL,
    stock_active INT NOT NULL DEFAULT 0,
    unit VARCHAR(20) NOT NULL,
    is_dead_stock TINYINT(1) DEFAULT 0,
    is_expiring TINYINT(1) DEFAULT 0,
    days_until_expiry INT DEFAULT 999,
    last_sold_date DATE 
);

-- Seed Data Skenario Master COMPFEST
INSERT INTO skus (
    sku_id, name, category, hpp, normal_price, floor_price, 
    stock_active, unit, is_dead_stock, is_expiring, 
    days_until_expiry, last_sold_date
) 
VALUES (
    'SKU-01', 'Minyak Goreng Pouch 2L', 'Sembako', 32000.00, 
    38000.00, 35000.00, 6, 'Pouch', 0, 0, 180, CURDATE()    
), 
(
    'SKU-08', 'Saus Sambal Botol 135ml', 'Bumbu', 6000.00, 8500.00, 6200.00, 
    120, 'Botol', 1, 1, 20, DATE_SUB(CURDATE(), INTERVAL 35 DAY)
);

-- 2. Tabel Sesi Negosiasi (Untuk Pelacakan Count Low Offer & Handover)
CREATE TABLE IF NOT EXISTS negotiation_sessions(
    session_id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    sku_id VARCHAR(50) NOT NULL,
    low_offer_count INT DEFAULT 0,
    is_handover TINYINT(1) DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Tabel Invoice Draft (Valid 2 Jam)
CREATE TABLE IF NOT EXISTS invoice_drafts (
    invoice_id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    sku_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    agreed_price DECIMAL(12, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);