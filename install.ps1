#!/usr/bin/env pwsh
# Claude Skills Installation Script
# Symlinks skills from the checked-out repository to ~/.claude/skills/

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = Join-Path (Join-Path $env:USERPROFILE ".claude") "skills"

# Ensure target directory exists
if (-not (Test-Path $SkillsDir)) {
    Write-Host "Creating skills directory: $SkillsDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

# Get all skill directories (any directory with a SKILL.md file)
$SkillDirs = Get-ChildItem -Path $ScriptDir -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }

Write-Host "`nFound $($SkillDirs.Count) skills to install:`n" -ForegroundColor Green

$Installed = 0
$Updated = 0
$Skipped = 0

foreach ($SkillDir in $SkillDirs) {
    $SkillName = $SkillDir.Name
    $SourcePath = $SkillDir.FullName
    $TargetPath = Join-Path $SkillsDir $SkillName

    # Check if already symlinked
    if (Test-Path $TargetPath) {
        $LinkTarget = Get-Item $TargetPath | Select-Object -ExpandProperty Target
        if ($LinkTarget -eq $SourcePath) {
            Write-Host "  [SKIP] $SkillName - already linked" -ForegroundColor DarkGray
            $Skipped++
            continue
        } else {
            Write-Host "  [UPDATE] $SkillName - removing old link" -ForegroundColor Yellow
            Remove-Item -Path $TargetPath -Force -Recurse
        }
    }

    # Create symlink
    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -ErrorAction Stop | Out-Null
        Write-Host "  [OK] $SkillName -> $TargetPath" -ForegroundColor Green
        $Installed++
    }
    catch {
        if ($_.Exception.Message -match "administrator") {
            Write-Host "  [ERROR] $SkillName`: Administrator privileges required for symlinks on Windows." -ForegroundColor Red
            Write-Host "         Enable Developer Mode or run PowerShell as Administrator." -ForegroundColor Yellow
        } else {
            Write-Host "  [ERROR] Failed to link $SkillName`: $_" -ForegroundColor Red
        }
    }
}

Write-Host "`nInstallation summary:" -ForegroundColor Cyan
Write-Host "  Installed: $Installed" -ForegroundColor Green
Write-Host "  Updated: $Updated" -ForegroundColor Yellow
Write-Host "  Skipped: $Skipped" -ForegroundColor DarkGray
Write-Host "`nSkills are now available in Claude Code!" -ForegroundColor Green
Write-Host "Use '/oh-my-claudecode:help' to see available skills.`n"
