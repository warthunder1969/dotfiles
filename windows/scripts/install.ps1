
$packages = @(
    "7zip",
    "googlechrome",
    "git",
    "vscode",
    "notepadplusplus"
)

# Step 3: Mass install/upgrade packages silently
Write-Host "Installing application bundle..." -ForegroundColor Green
foreach ($package in $packages) {
    # -y confirms all prompts automatically
    choco upgrade $package -y
}

Write-Host "Environment setup complete!" -ForegroundColor Green
