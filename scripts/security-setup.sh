#!/bin/bash
# security-setup.sh
# VIBE-Claude-Plugin Security Tools Installer for macOS/Linux
# 为 vibe-security 技能安装所需的开源安全扫描工具
# 工具清单：npm audit / pip-audit / Semgrep / gitleaks / TruffleHog

set -e

echo ""
echo "=========================================="
echo -e "\033[0;36m  VIBE Security Tools Setup (macOS/Linux)\033[0m"
echo "=========================================="
echo ""

# 工具安装状态记录
declare -A TOOL_STATUS

test_command() {
    command -v "$1" >/dev/null 2>&1
}

# ---------- 1. Node.js / npm ----------
echo -e "\033[0;33m[1/5] Checking Node.js / npm...\033[0m"
if test_command "npm"; then
    node_ver=$(node --version)
    npm_ver=$(npm --version)
    echo -e "\033[0;32m  [OK] Node.js $node_ver, npm $npm_ver\033[0m"
    TOOL_STATUS["npm"]=1
else
    echo -e "\033[0;31m  [MISSING] Node.js not found\033[0m"
    echo "          npm audit will be unavailable."
    echo "          Install from: https://nodejs.org/"
    TOOL_STATUS["npm"]=0
fi

# ---------- 2. Python / pip ----------
echo -e "\033[0;33m[2/5] Checking Python / pip...\033[0m"
if test_command "pip3" || test_command "pip"; then
    py_ver=$(python3 --version 2>&1 || python --version 2>&1)
    echo -e "\033[0;32m  [OK] $py_ver\033[0m"
    TOOL_STATUS["pip"]=1
else
    echo -e "\033[0;31m  [MISSING] Python/pip not found\033[0m"
    echo "          pip-audit will be unavailable."
    echo "          Install from: https://www.python.org/"
    TOOL_STATUS["pip"]=0
fi

# 获取 pip 命令名
get_pip_cmd() {
    if test_command "pip3"; then echo "pip3"
    elif test_command "pip"; then echo "pip"
    else echo ""
    fi
}

# ---------- 3. Semgrep (SAST 静态分析) ----------
echo -e "\033[0;33m[3/5] Checking Semgrep...\033[0m"
if test_command "semgrep"; then
    sg_ver=$(semgrep --version 2>&1)
    echo -e "\033[0;32m  [OK] Semgrep $sg_ver\033[0m"
    TOOL_STATUS["semgrep"]=1
else
    echo -e "\033[0;33m  [MISSING] Semgrep not found, installing...\033[0m"
    pip_cmd=$(get_pip_cmd)
    if [ -n "$pip_cmd" ]; then
        if $pip_cmd install semgrep --quiet 2>/dev/null; then
            echo -e "\033[0;32m  [INSTALLED] Semgrep installed via $pip_cmd\033[0m"
            TOOL_STATUS["semgrep"]=1
        else
            echo -e "\033[0;31m  [FAILED] Semgrep installation failed\033[0m"
            TOOL_STATUS["semgrep"]=0
        fi
    else
        echo -e "\033[0;31m  [SKIPPED] pip not available, cannot install Semgrep\033[0m"
        TOOL_STATUS["semgrep"]=0
    fi
fi

# ---------- 4. gitleaks (密钥泄露扫描) ----------
echo -e "\033[0;33m[4/5] Checking gitleaks...\033[0m"
if test_command "gitleaks"; then
    gl_ver=$(gitleaks version 2>&1)
    echo -e "\033[0;32m  [OK] gitleaks $gl_ver\033[0m"
    TOOL_STATUS["gitleaks"]=1
else
    echo -e "\033[0;33m  [MISSING] gitleaks not found\033[0m"
    # macOS: Homebrew
    if test_command "brew"; then
        echo -e "\033[0;33m  Attempting install via Homebrew...\033[0m"
        if brew install gitleaks 2>/dev/null; then
            echo -e "\033[0;32m  [INSTALLED] gitleaks installed via brew\033[0m"
            TOOL_STATUS["gitleaks"]=1
        else
            echo -e "\033[0;31m  [FAILED] gitleaks install via brew failed\033[0m"
            TOOL_STATUS["gitleaks"]=0
        fi
    # Linux: 尝试下载二进制
    elif test_command "curl"; then
        echo -e "\033[0;33m  Attempting binary download...\033[0m"
        arch=$(uname -m)
        case "$arch" in
            x86_64)  gl_arch="x64" ;;
            aarch64|arm64) gl_arch="arm64" ;;
            *)       gl_arch="x64" ;;
        esac
        os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
        latest_url=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest \
            | grep "browser_download_url.*${os_name}_${gl_arch}.tar.gz" \
            | head -1 | cut -d '"' -f 4)
        if [ -n "$latest_url" ]; then
            tmp_dir=$(mktemp -d)
            if curl -sL "$latest_url" | tar -xz -C "$tmp_dir" && \
               mv "$tmp_dir/gitleaks" /usr/local/bin/gitleaks 2>/dev/null && \
               chmod +x /usr/local/bin/gitleaks; then
                echo -e "\033[0;32m  [INSTALLED] gitleaks installed to /usr/local/bin\033[0m"
                TOOL_STATUS["gitleaks"]=1
            else
                echo -e "\033[0;31m  [FAILED] gitleaks binary install failed (try sudo)\033[0m"
                TOOL_STATUS["gitleaks"]=0
            fi
            rm -rf "$tmp_dir"
        else
            echo -e "\033[0;31m  [FAILED] Could not find matching release\033[0m"
            echo "          Manual install: https://github.com/gitleaks/gitleaks/releases"
            TOOL_STATUS["gitleaks"]=0
        fi
    else
        echo -e "\033[0;31m  [SKIPPED] Neither brew nor curl available\033[0m"
        echo "          Manual install: https://github.com/gitleaks/gitleaks/releases"
        TOOL_STATUS["gitleaks"]=0
    fi
fi

# ---------- 5. pip-audit (Python 依赖漏洞扫描) ----------
echo -e "\033[0;33m[5/5] Checking pip-audit...\033[0m"
if test_command "pip-audit"; then
    echo -e "\033[0;32m  [OK] pip-audit available\033[0m"
    TOOL_STATUS["pip-audit"]=1
else
    pip_cmd=$(get_pip_cmd)
    if [ -n "$pip_cmd" ]; then
        echo -e "\033[0;33m  [MISSING] pip-audit not found, installing...\033[0m"
        if $pip_cmd install pip-audit --quiet 2>/dev/null; then
            echo -e "\033[0;32m  [INSTALLED] pip-audit installed via $pip_cmd\033[0m"
            TOOL_STATUS["pip-audit"]=1
        else
            echo -e "\033[0;31m  [FAILED] pip-audit installation failed\033[0m"
            TOOL_STATUS["pip-audit"]=0
        fi
    else
        echo -e "\033[0;31m  [SKIPPED] pip not available\033[0m"
        TOOL_STATUS["pip-audit"]=0
    fi
fi

# ---------- 汇总报告 ----------
echo ""
echo "=========================================="
echo -e "\033[0;36m  Security Tools Setup Summary\033[0m"
echo "=========================================="
echo ""

available=0
total=0
for tool in "npm" "pip" "semgrep" "gitleaks" "pip-audit"; do
    total=$((total + 1))
    if [ "${TOOL_STATUS[$tool]}" = "1" ]; then
        available=$((available + 1))
        echo -e "\033[0;32m  [OK]      $tool\033[0m"
    else
        echo -e "\033[0;31m  [MISSING] $tool\033[0m"
    fi
done

echo ""
if [ "$available" -eq "$total" ]; then
    color="\033[0;32m"
    echo -e "${color}Available: $available / $total\033[0m"
    echo -e "${color}All security tools are ready.\033[0m"
    echo -e "${color}vibe-security can now run full scans (CVE + SAST + Secrets + LLM audit).\033[0m"
else
    color="\033[0;33m"
    echo -e "${color}Available: $available / $total\033[0m"
    echo -e "${color}Some tools are missing. vibe-security AI will attempt auto-install on next run.\033[0m"
    echo -e "${color}Missing tools will be installed automatically when /vibe triggers security audit.\033[0m"
fi

echo ""
echo -e "\033[0;36mDone. You can now use /vibe and vibe-security will detect tools automatically.\033[0m"
echo ""
