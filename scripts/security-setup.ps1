# security-setup.ps1
# VIBE-Claude-Plugin Security Tools Installer for Windows
# 为 vibe-security 技能安装所需的开源安全扫描工具
# 工具清单：npm audit / pip-audit / Semgrep / gitleaks / TruffleHog

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  VIBE Security Tools Setup (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WithPip {
    param([string]$Package)
    try {
        # 优先用 pip3，兼容老系统用 pip
        if (Test-Command "pip3") {
            pip3 install $Package --quiet
        } else {
            pip install $Package --quiet
        }
        return $true
    } catch {
        Write-Host "  pip install $Package failed: $_" -ForegroundColor Red
        return $false
    }
}

# ---------- 1. Node.js / npm ----------
Write-Host "[1/5] Checking Node.js / npm..." -ForegroundColor Yellow
$hasNpm = $false
if (Test-Command "npm") {
    $nodeVer = node --version
    $npmVer = npm --version
    Write-Host "  [OK] Node.js $nodeVer, npm $npmVer" -ForegroundColor Green
    $hasNpm = $true
} else {
    Write-Host "  [MISSING] Node.js not found" -ForegroundColor Red
    Write-Host "          Install from: https://nodejs.org/" -ForegroundColor DarkGray
}

# ---------- 2. Python / pip ----------
Write-Host "[2/5] Checking Python / pip..." -ForegroundColor Yellow
$hasPip = $false
if (Test-Command "pip") {
    $pyVer = python --version 2>&1
    Write-Host "  [OK] $pyVer" -ForegroundColor Green
    $hasPip = $true
} else {
    Write-Host "  [MISSING] Python/pip not found" -ForegroundColor Red
    Write-Host "          Install from: https://www.python.org/" -ForegroundColor DarkGray
}

# ---------- 3. Semgrep (SAST 静态分析) ----------
Write-Host "[3/5] Checking Semgrep..." -ForegroundColor Yellow
$hasSemgrep = $false
if (Test-Command "semgrep") {
    $sgVer = semgrep --version 2>&1
    Write-Host "  [OK] Semgrep $sgVer" -ForegroundColor Green
    $hasSemgrep = $true
} else {
    Write-Host "  [MISSING] Semgrep not found, installing..." -ForegroundColor Yellow
    if ($hasPip) {
        $ok = Install-WithPip "semgrep"
        if ($ok -and (Test-Command "semgrep")) {
            Write-Host "  [INSTALLED] Semgrep installed via pip" -ForegroundColor Green
            $hasSemgrep = $true
        } else {
            Write-Host "  [FAILED] Semgrep installation failed" -ForegroundColor Red
        }
    } else {
        Write-Host "  [SKIPPED] pip not available, cannot install Semgrep" -ForegroundColor Red
    }
}

# ---------- 4. gitleaks (密钥泄露扫描) ----------
Write-Host "[4/5] Checking gitleaks..." -ForegroundColor Yellow
$hasGitleaks = $false
if (Test-Command "gitleaks") {
    $glVer = gitleaks version 2>&1
    Write-Host "  [OK] gitleaks $glVer" -ForegroundColor Green
    $hasGitleaks = $true
} else {
    Write-Host "  [MISSING] gitleaks not found" -ForegroundColor Yellow
    if (Test-Command "choco") {
        Write-Host "  Attempting install via Chocolatey..." -ForegroundColor Yellow
        try {
            choco install gitleaks -y 2>$null
            if (Test-Command "gitleaks") {
                Write-Host "  [INSTALLED] gitleaks installed via choco" -ForegroundColor Green
                $hasGitleaks = $true
            } else {
                Write-Host "  [FAILED] gitleaks install via choco failed" -ForegroundColor Red
            }
        } catch {
            Write-Host "  [FAILED] choco install error: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  [SKIPPED] Chocolatey not found." -ForegroundColor Red
        Write-Host "          Manual install: https://github.com/gitleaks/gitleaks/releases" -ForegroundColor DarkGray
    }
}

# ---------- 5. pip-audit (Python 依赖漏洞扫描) ----------
Write-Host "[5/5] Checking pip-audit..." -ForegroundColor Yellow
$hasPipAudit = $false
if (Test-Command "pip-audit") {
    Write-Host "  [OK] pip-audit available" -ForegroundColor Green
    $hasPipAudit = $true
} else {
    if ($hasPip) {
        Write-Host "  [MISSING] pip-audit not found, installing..." -ForegroundColor Yellow
        $ok = Install-WithPip "pip-audit"
        if ($ok -and (Test-Command "pip-audit")) {
            Write-Host "  [INSTALLED] pip-audit installed via pip" -ForegroundColor Green
            $hasPipAudit = $true
        } else {
            Write-Host "  [FAILED] pip-audit installation failed" -ForegroundColor Red
        }
    } else {
        Write-Host "  [SKIPPED] pip not available" -ForegroundColor Red
    }
}

# ---------- 汇总报告 ----------
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Security Tools Setup Summary" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$tools = @(
    @{ Name = "npm";        OK = $hasNpm },
    @{ Name = "pip";        OK = $hasPip },
    @{ Name = "semgrep";    OK = $hasSemgrep },
    @{ Name = "gitleaks";   OK = $hasGitleaks },
    @{ Name = "pip-audit";  OK = $hasPipAudit }
)

$available = 0
foreach ($tool in $tools) {
    if ($tool.OK) {
        $available++
        Write-Host "  [OK]      $($tool.Name)" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($tool.Name)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Available: $available / $($tools.Count)" -ForegroundColor $(if ($available -eq $tools.Count) { "Green" } else { "Yellow" })
Write-Host ""

if ($available -eq $tools.Count) {
    Write-Host "All security tools are ready." -ForegroundColor Green
    Write-Host "vibe-security can now run full scans (CVE + SAST + Secrets + LLM audit)." -ForegroundColor Green
} else {
    Write-Host "Some tools are missing. vibe-security AI will attempt auto-install on next run." -ForegroundColor Yellow
    Write-Host "Missing tools will be installed automatically when /vibe triggers security audit." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done." -ForegroundColor Cyan
Write-Host ""
