#!/usr/bin/env pwsh
# Claude Skills Installation Script (Copy Method)
# Copies skills to the Claude skills directory.
# Use this method if you cannot create symbolic links on Windows.

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

$Copied = 0
$Updated = 0

foreach ($SkillDir in $SkillDirs) {
    $SkillName = $SkillDir.Name
    $SourcePath = $SkillDir.FullName
    $TargetPath = Join-Path $SkillsDir $SkillName

    if (Test-Path $TargetPath) {
        Write-Host "  [SKIP] $SkillName - already exists (delete to update)" -ForegroundColor DarkGray
    }
    else {
        Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse
        Write-Host "  [OK] $SkillName -> $TargetPath" -ForegroundColor Green
        $Copied++
    }
}

Write-Host "`nInstallation summary:" -ForegroundColor Cyan
Write-Host "  Copied: $Copied" -ForegroundColor Green
Write-Host "`nSkills are now available in Claude Code!" -ForegroundColor Green
Write-Host "Note: Copied skills won't update automatically. Re-run to update after deleting old folders.`n"
