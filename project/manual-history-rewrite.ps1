#!/usr/bin/env powershell
# Automated script to fix the initial commit message

Write-Host "Attempting to rebase and fix initial commit..." -ForegroundColor Cyan

# Checkout to the initial commit
git checkout e18be86

if ($LASTEXITCODE -eq 0) {
    Write-Host "Checked out to initial commit" -ForegroundColor Green
    
    # Amend the initial commit
    git commit --amend -m "Initial commit: Forg3t Protocol with ZK proofs"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Amended initial commit successfully" -ForegroundColor Green
        
        # Cherry-pick the rest
        git cherry-pick 15be41d
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Cherry-picked latest commit" -ForegroundColor Green
            
            # Now we have a clean history, let's update master
            git checkout master
            git reset --hard HEAD
            
            Write-Host "Successfully rewrote git history!" -ForegroundColor Green
        }
    }
}
