# install.ps1
# VIBE-Claude-Plugin Installation Script for Windows

$PluginDir = $PSScriptRoot
$SkillsDir = Join-Path $PluginDir "skills"
$TargetDir = Join-Path $env:USERPROFILE ".claude\skills"

Write-Host "Installing VIBE-Claude-Plugin..." -ForegroundColor Cyan

# Create target directory if it doesn't exist
if (-Not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Write-Host "Created directory: $TargetDir" -ForegroundColor Green
}

# Copy skills
Write-Host "Copying skills from $SkillsDir to $TargetDir" -ForegroundColor Cyan
Copy-Item -Path "$SkillsDir\*" -Destination $TargetDir -Recurse -Force

Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "You can now use the VIBE skills in Claude Code." -ForegroundColor Yellow
Write-Host "Restart Claude Code to apply the changes." -ForegroundColor Yellow
