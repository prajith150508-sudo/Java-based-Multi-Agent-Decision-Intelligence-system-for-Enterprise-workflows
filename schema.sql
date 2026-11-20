-- ==============================================================================
-- Database Schema for Java-Based Multi-Agent Decision Intelligence System
-- Compatible with MySQL 8.0+ and MariaDB
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS multiagent_db;
USE multiagent_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role ENUM('EMPLOYEE', 'MANAGER', 'ADMIN') NOT NULL DEFAULT 'EMPLOYEE',
    department VARCHAR(100) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL DEFAULT 85000.00,
    annual_salary DECIMAL(14, 2) NOT NULL DEFAULT 1020000.00,
    total_annual_leave INT NOT NULL DEFAULT 24,
    leave_taken INT NOT NULL DEFAULT 8,
    leave_balance INT NOT NULL DEFAULT 16,
    employment_status VARCHAR(100) NOT NULL DEFAULT 'Permanent Full-Time',
    joining_date VARCHAR(50) NOT NULL DEFAULT '2022-03-15',
    performance_score DECIMAL(3, 1) NOT NULL DEFAULT 4.8,
    performance_rating VARCHAR(100) NOT NULL DEFAULT 'Exceeds Expectations (4.8 / 5.0)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Enterprise Central Inventory Table
CREATE TABLE IF NOT EXISTS inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    unit_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    supplier_name VARCHAR(150) NOT NULL,
    supplier_contact VARCHAR(100),
    status ENUM('IN_STOCK', 'LOW_STOCK', 'OUT_OF_STOCK') DEFAULT 'IN_STOCK'
);

-- 3. Enterprise Requests Table
CREATE TABLE IF NOT EXISTS workflow_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    request_type ENUM('LEAVE_REQUEST', 'PURCHASE_REQUEST', 'EXPENSE_CLAIM', 'ASSET_REQUEST', 'FUND_ALLOCATION') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(14, 2) DEFAULT 0.00,
    quantity INT DEFAULT 1,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('SUBMITTED', 'ANALYZING', 'PENDING_MANAGER', 'APPROVED', 'REJECTED') DEFAULT 'SUBMITTED',
    metadata_json TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Specialized Agent Results Table
CREATE TABLE IF NOT EXISTS agent_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    agent_name VARCHAR(50) NOT NULL,
    recommendation ENUM('APPROVE', 'REVIEW', 'REJECT') NOT NULL,
    score INT NOT NULL,
    risk_level ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL,
    reasoning TEXT NOT NULL,
    metrics_json TEXT,
    evaluated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES workflow_requests(id) ON DELETE CASCADE
);

-- 5. Decision Agent & Manager Synthesis Table
CREATE TABLE IF NOT EXISTS decisions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL UNIQUE,
    ai_recommendation ENUM('APPROVE', 'REVIEW', 'REJECT') NOT NULL,
    confidence_score DECIMAL(5, 2) NOT NULL,
    explanation TEXT NOT NULL,
    supporting_evidence TEXT,
    concerns_warnings TEXT,
    manager_decision ENUM('APPROVED', 'REJECTED', 'PENDING') DEFAULT 'PENDING',
    manager_notes TEXT,
    decided_by_user_id INT,
    decided_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES workflow_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (decided_by_user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 6. Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('INFO', 'AGENT_ALERT', 'DECISION', 'ACTION_REQUIRED') DEFAULT 'INFO',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. Audit Logs Table
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT NOT NULL,
    ip_address VARCHAR(50) DEFAULT '127.0.0.1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Supporting Documents Table
CREATE TABLE IF NOT EXISTS documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    file_type VARCHAR(100) NOT NULL,
    file_content_base64 LONGTEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES workflow_requests(id) ON DELETE CASCADE
);

-- 9. Company Funds Table
CREATE TABLE IF NOT EXISTS company_funds (
    id INT PRIMARY KEY,
    balance DECIMAL(14, 2) NOT NULL DEFAULT 2500000.00,
    reserved_funds DECIMAL(14, 2) NOT NULL DEFAULT 85000.00,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Seed Company Funds
INSERT INTO company_funds (id, balance, reserved_funds) VALUES (1, 2500000.00, 85000.00)
ON DUPLICATE KEY UPDATE balance = balance;

-- Seed Inventory Catalog
INSERT INTO inventory (id, item_name, category, stock_quantity, unit_price, supplier_name, supplier_contact, status) VALUES
(1, 'High-Performance AI Workstation', 'IT Hardware', 4, 85000.00, 'Dell Enterprise India', '+91-80-2222-1111', 'IN_STOCK'),
(2, 'MacBook Pro 16-inch M3 Max', 'IT Hardware', 6, 245000.00, 'Apple India Direct', '+91-22-3333-4444', 'IN_STOCK'),
(3, 'Dell UltraSharp 32-inch 4K Monitor', 'IT Hardware', 12, 42000.00, 'Dell Enterprise India', '+91-80-2222-1111', 'IN_STOCK'),
(4, 'Ergonomic Mesh Office Chair', 'Office Furniture', 18, 16500.00, 'Featherlite Workspaces', '+91-80-4444-5555', 'IN_STOCK'),
(5, 'Standing Motorized Desk', 'Office Furniture', 8, 28000.00, 'Featherlite Workspaces', '+91-80-4444-5555', 'IN_STOCK'),
(6, 'Cloud GPU Server Instance (Monthly)', 'Cloud & Software', 20, 35000.00, 'AWS Cloud Direct', 'aws-support@enterprise.com', 'IN_STOCK'),
(7, 'Enterprise Noise-Cancelling Headset', 'Accessories', 25, 14000.00, 'Jabra Corporate India', '+91-11-5555-6666', 'IN_STOCK'),
(8, 'Mechanical Keyboard & Precision Mouse Set', 'Accessories', 30, 7500.00, 'Logitech Business', '+91-11-7777-8888', 'IN_STOCK')
ON DUPLICATE KEY UPDATE stock_quantity=VALUES(stock_quantity);

-- Seed Users
INSERT INTO users (username, email, password_hash, full_name, role, department, salary, annual_salary, total_annual_leave, leave_taken, leave_balance, employment_status, joining_date, performance_score, performance_rating) VALUES
('alex.taylor', 'employee@enterprise.com', '848c9094feecb5f10b3780c1285098ceaa8bfa79f676bd65f2efb4da3d61ce10', 'Alex Taylor', 'EMPLOYEE', 'Engineering', 85000.00, 1020000.00, 24, 8, 16, 'Permanent Full-Time', '2022-03-15', 4.8, 'Exceeds Expectations (4.8 / 5.0)'),
('sarah.connor', 'manager@enterprise.com', 'a7f79477e7a834d8ef2797e8cb30f0e08f5d0f622d17efac9e22312b9104fa28', 'Sarah Connor', 'MANAGER', 'Operations', 140000.00, 1680000.00, 26, 4, 22, 'Executive Management', '2020-01-10', 4.9, 'Outstanding Leadership (4.9 / 5.0)'),
('david.ross', 'admin@enterprise.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'David Ross', 'ADMIN', 'IT & Governance', 175000.00, 2100000.00, 30, 5, 25, 'Enterprise Administration', '2019-06-01', 5.0, 'Executive Tier (5.0 / 5.0)')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name), salary=VALUES(salary), performance_rating=VALUES(performance_rating);

-- Sample Request 1
INSERT INTO workflow_requests (id, user_id, request_type, title, description, amount, quantity, priority, status, metadata_json) VALUES
(1, 1, 'ASSET_REQUEST', 'High-Performance AI Workstation', 'Requested a 64GB RAM workstation with RTX GPU for artificial intelligence and machine learning engineering workloads.', 85000.00, 1, 'HIGH', 'PENDING_MANAGER', '{"category":"Hardware","urgency":"High"}')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO agent_results (request_id, agent_name, recommendation, score, risk_level, reasoning) VALUES
(1, 'HR Agent', 'APPROVE', 98, 'LOW', 'Approved. Full Eligibility Confirmed. Alex Taylor (Engineering, Permanent Full-Time) has 16 remaining leave days out of 24 annual days. Performance Rating: Exceeds Expectations (4.8 / 5.0). Role is fully verified for workstation allocation.'),
(1, 'Finance Agent', 'APPROVE', 96, 'LOW', 'Approved. Affordable & Budgeted. The cost of ₹85,000.00 is well within company available funds (₹25,00,000.00). Reserve impact is only 3.4% of total company reserves.'),
(1, 'Inventory Agent', 'APPROVE', 99, 'LOW', 'Approved from Existing Stock. Verified High-Performance AI Workstation in central warehouse (4 unit(s) on hand, Unit Value: ₹85,000.00, Supplier: Dell Enterprise India). Existing stock will be directly allocated.'),
(1, 'Risk Agent', 'APPROVE', 97, 'LOW', 'Low Risk. Zero fraud indicators, verified employee performance standing (Exceeds Expectations), reasonable financial ratio, and clear business justification.'),
(1, 'Compliance Agent', 'APPROVE', 98, 'LOW', 'Approved. Procurement Guidelines Satisfied. Request follows organizational asset requisition thresholds and authorized procurement channels.')
ON DUPLICATE KEY UPDATE reasoning=VALUES(reasoning);

INSERT INTO decisions (request_id, ai_recommendation, confidence_score, explanation, supporting_evidence, concerns_warnings, manager_decision) VALUES
(1, 'APPROVE', 96.80, 'All 5 specialized agents (HR, Finance, Inventory, Risk, and Compliance) independently evaluated this request and recommend approval. Employee eligibility is confirmed, funds/resources are available, and all company policies are met.', 'HR: Eligible with 4.8/5.0 rating | Finance: ₹85,000 within company funds | Inventory: In-stock central depot | Risk: Low risk | Compliance: All policies satisfied.', 'No conflicts or concerns found. All 5 agents in full agreement.', 'PENDING')
ON DUPLICATE KEY UPDATE confidence_score=VALUES(confidence_score);

INSERT INTO notifications (user_id, title, message, type) VALUES
(1, 'Analysis Complete', 'Your Asset Request #1 has completed multi-agent analysis with 96.8% confidence (APPROVE). Awaiting manager approval.', 'DECISION'),
(2, 'Review Needed', 'Asset Request #1 from Alex Taylor requires manager approval. AI confidence: 96.8% (APPROVE).', 'ACTION_REQUIRED');

INSERT INTO audit_logs (request_id, user_id, action, details) VALUES
(1, 1, 'SUBMIT_REQUEST', 'Request #1 created by Alex Taylor.'),
(1, NULL, 'AGENTS_SYNTHESIS', 'Multi-agent analysis completed. Recommendation: APPROVE (96.8%).');
