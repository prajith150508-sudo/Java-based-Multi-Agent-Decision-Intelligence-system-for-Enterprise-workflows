# Aegis Decision Intelligence System
### Java-Based Multi-Agent Decision Intelligence System for Enterprise Workflows

A simple, transparent, and explainable enterprise decision intelligence platform built strictly using:
- **Backend:** Pure Java 21 (`com.sun.net.httpserver.HttpServer`, Java Virtual Threads, and JDBC).
- **Frontend:** Vanilla HTML5, CSS3 (Enterprise Cyber-Glassmorphic Dark UI), and Vanilla ES6 JavaScript (`fetch()`).
- **Database:** MySQL 8.0+ / MariaDB with official `mysql-connector-j-8.3.0.jar` (with automatic in-memory fallback store).
- **Currency:** Indian Rupees (₹) across all calculations, funds, and salary metrics.
- **Frameworks Used:** NONE (No Spring, No Node.js, No React, No Bootstrap, No Maven, No Gradle).

---

## 1. What's New & Improved

1. **Employee Dashboard**:
   - **Visible Workflow Category Dropdown**: The dropdown is fully styled and 100% visible on all screens without needing to hover. Plus, interactive 1-click category selection cards are added for instant selection.
   - **Employee Details Displayed**: Clearly shows Monthly Salary (`₹85,000 / Month`), Available Leave Balance (`16 Days`), and Performance Details (`Exceeds Expectations (4.8 / 5.0)`).
   - **AI Agents Use Employee Details**: HR, Finance, and Risk agents directly verify employee salary, leave days, and performance score when reviewing requests.
   - **Simple Submission Form**: Clean, clutter-free form with straightforward fields and helpful hints.

2. **Manager Dashboard**:
   - **Company Available Funds in Indian Rupees (₹)**: Prominently displayed (e.g. `₹25,00,000.00`).
   - **Automatic Balance Deduction**: When an Expense Claim, Purchase Request, or Asset Request is approved, the requested amount is automatically subtracted from company funds.
   - **Fund Allocation**: Managers can click **"+ Add Funds"** to allocate new budget into company funds at any time.
   - **Clear Request Triage**: Shows employee name, department, salary, performance rating, amount in ₹, agent scores, and 1-click Approve/Reject.

3. **Multi-Agent System with Simple English**:
   - **HR Agent**: Validates leave days against available balance and verifies employee performance.
   - **Finance Agent**: Checks request amounts against company funds (₹) and employee monthly salary.
   - **Inventory Agent**: Checks office inventory and warehouse stock availability.
   - **Risk Agent**: Evaluates expense reasonableness compared to monthly salary and past performance.
   - **Compliance Agent**: Confirms company policy compliance and verifies attached receipts or bills.
   - **Decision Agent**: Combines all 5 agents into a clear, unified recommendation (APPROVE / REVIEW / REJECT) with a 0-100% confidence rating.

---

## 2. Default Enterprise Demo Accounts

| Role | Username / Email | Password | What You Can Test |
|---|---|---|---|
| **Employee** | `employee@enterprise.com` | `employee123` | View monthly salary (₹85,000), leave balance, performance rating (4.8/5.0), and submit requests |
| **Manager** | `manager@enterprise.com` | `manager123` | View company available funds (₹25,00,000), allocate new funds, review requests, and approve/reject |
| **Admin** | `admin@enterprise.com` | `admin123` | System oversight and full administrative control |

---

## 3. How to Run

### Option A: Using Windows PowerShell
```powershell
.\run.ps1
```

### Option B: Using Windows Command Prompt / Batch
```cmd
run.bat
```

### Option C: Manual Launch
1. Compile:
```powershell
javac -encoding UTF-8 -cp "lib/mysql-connector-j-8.3.0.jar" -d bin (Get-ChildItem -Path src -Filter *.java -Recurse | Select-Object -ExpandProperty FullName)
```
2. Run:
```powershell
java -cp "bin;lib/mysql-connector-j-8.3.0.jar" com.enterprise.multiagent.Main
```
3. Open browser:
```
http://localhost:8080
```