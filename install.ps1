# install.ps1
# VIBE-Claude-Plugin standard plugin installer for Windows

$PluginDir = $PSScriptRoot
$PluginsRoot = Join-Path $env:USERPROFILE ".claude\plugins"
$TargetDir = Join-Path $PluginsRoot "vibe-claude-plugin"

Write-Host "Installing VIBE-Claude-Plugin as a Claude Code plugin..." -ForegroundColor Cyan

if (-Not (Test-Path $PluginsRoot)) {
    New-Item -ItemType Directory -Force -Path $PluginsRoot | Out-Null
    Write-Host "Created plugins directory: $PluginsRoot" -ForegroundColor Green
}

if (Test-Path $TargetDir) {
    Remove-Item -Path $TargetDir -Recurse -Force
    Write-Host "Removed existing plugin directory: $TargetDir" -ForegroundColor Yellow
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

$itemsToCopy = @(
    ".claude-plugin",
    "commands",
    "skills",
    "scripts",
    "VERSION",
    "README.md",
    "README.zh-CN.md",
    "LICENSE",
    "CHANGELOG.md",
    "AI_DEVELOPMENT_DOC.md",
    "使用手册.md"
)

foreach ($item in $itemsToCopy) {
    $source = Join-Path $PluginDir $item
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $TargetDir -Recurse -Force
    }
}

Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "Plugin path: $TargetDir" -ForegroundColor Green
Write-Host "Please restart Claude Code, then run /plugins to verify or use /vibe directly." -ForegroundColor Yellow
