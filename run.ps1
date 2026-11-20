Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  Java-Based Multi-Agent Decision Intelligence System" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

if (!(Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
}

Write-Host "[1/3] Compiling Java backend classes..." -ForegroundColor Yellow
$sources = Get-ChildItem -Path "src" -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName
javac -encoding UTF-8 -cp "lib/mysql-connector-j-8.3.0.jar" -d bin $sources

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Java compilation failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "[OK] Compilation completed successfully." -ForegroundColor Green

Write-Host "[2/3] Checking MySQL database setup..." -ForegroundColor Yellow
$mysqlCmd = Get-Command "mysql" -ErrorAction SilentlyContinue
if ($mysqlCmd) {
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS multiagent_db;" 2>$null
    Get-Content "schema.sql" | mysql -u root multiagent_db 2>$null
    Write-Host "[INFO] MySQL initialized with schema.sql" -ForegroundColor Green
} else {
    Write-Host "[INFO] MySQL CLI not in PATH. System will use self-initializing JDBC or fallback store." -ForegroundColor Yellow
}

Write-Host "[3/3] Launching Java built-in HttpServer on http://localhost:8080 ..." -ForegroundColor Cyan
java -cp "bin;lib/mysql-connector-j-8.3.0.jar" com.enterprise.multiagent.Main