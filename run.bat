@echo off
setlocal
echo ==============================================================================
echo   Java-Based Multi-Agent Decision Intelligence System
echo ==============================================================================

rem Check if bin directory exists
if not exist "bin" mkdir "bin"

echo [1/3] Compiling Java backend classes...
javac -cp "lib/mysql-connector-j-8.3.0.jar" -d bin src/com/enterprise/multiagent/config/*.java src/com/enterprise/multiagent/util/*.java src/com/enterprise/multiagent/model/*.java src/com/enterprise/multiagent/agents/*.java src/com/enterprise/multiagent/db/*.java src/com/enterprise/multiagent/service/*.java src/com/enterprise/multiagent/server/handlers/*.java src/com/enterprise/multiagent/server/*.java src/com/enterprise/multiagent/*.java
if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b %errorlevel%
)
echo [OK] Compilation successful!

echo [2/3] Checking MySQL database setup...
where mysql >nul 2>nul
if %errorlevel% equ 0 (
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS multiagent_db;" 2>nul
    mysql -u root multiagent_db < schema.sql 2>nul
    echo [INFO] MySQL initialized with schema.sql
) else (
    echo [INFO] MySQL CLI not in PATH. System will run self-initializing database or in-memory enterprise store.
)

echo [3/3] Starting Java HttpServer...
echo Point your browser to: http://localhost:8080
java -cp "bin;lib/mysql-connector-j-8.3.0.jar" com.enterprise.multiagent.Main
pause