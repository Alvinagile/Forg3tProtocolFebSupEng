#!/usr/bin/env powershell
# Script to rewrite git history using rebase

# Set environment for non-interactive rebase
$env:GIT_EDITOR = "true"

Write-Host "Starting git rebase to fix initial commit..." -ForegroundColor Green

# We need to create a script that git will use as the sequence editor
$rebaseScript = @'
# Find and replace the first 'pick' with 'reword' for e18be86
(Get-Content $args[0]) -replace '^pick e18be86', 'reword e18be86' | Set-Content $args[0]
'@

$rebaseScriptPath = ".\git-rebase-sequence.ps1"
$rebaseScript | Out-File -FilePath $rebaseScriptPath -Encoding UTF8

# Set GIT_SEQUENCE_EDITOR to use our script
$env:GIT_SEQUENCE_EDITOR = "powershell -ExecutionPolicy Bypass -File $rebaseScriptPath"

try {
    # Start interactive rebase from root
    git rebase -i --root
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Rebase initiated successfully" -ForegroundColor Green
    }
    else {
        Write-Host "Rebase failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    }
}
finally {
    # Cleanup
    Remove-Item $rebaseScriptPath -ErrorAction SilentlyContinue
}
