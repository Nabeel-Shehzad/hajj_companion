# Import Path Fixer for Hajj Companion Multi-Platform Project
# This script updates import paths after restructuring

Write-Host "Fixing import paths for multi-platform architecture..." -ForegroundColor Cyan
Write-Host ""

$projectRoot = Get-Location
$mobileScreensPath = Join-Path $projectRoot "lib\mobile\screens"

# Define replacement pairs
$replacements = @{
    "import '../services/" = "import '../../core/services/"
    "import '../models/" = "import '../../core/models/"
    "import '../database/" = "import '../../core/database/"
    "import '../utils/" = "import '../../core/utils/"
}

# Get all Dart files in mobile/screens recursively
$dartFiles = Get-ChildItem -Path $mobileScreensPath -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue

if ($dartFiles) {
    $totalFiles = $dartFiles.Count
    $modifiedFiles = 0

    Write-Host "Found $totalFiles Dart files in mobile/screens" -ForegroundColor Yellow
    Write-Host ""

    foreach ($file in $dartFiles) {
        $modified = $false
        
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $originalContent = $content
        
        foreach ($pattern in $replacements.Keys) {
            if ($content -match [regex]::Escape($pattern)) {
                $content = $content -replace [regex]::Escape($pattern), $replacements[$pattern]
                $modified = $true
            }
        }
        
        if ($modified) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $modifiedFiles++
            $relativePath = $file.FullName.Replace($projectRoot, "")
            Write-Host "Fixed: $relativePath" -ForegroundColor Green
        }
    }

    Write-Host ""
    Write-Host "Import path fix complete!" -ForegroundColor Green
    Write-Host "Total files processed: $totalFiles" -ForegroundColor White
    Write-Host "Files modified: $modifiedFiles" -ForegroundColor Green
    Write-Host ""

    if ($modifiedFiles -gt 0) {
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Run: flutter pub get" -ForegroundColor White
        Write-Host "2. Run: flutter analyze" -ForegroundColor White
        Write-Host "3. Test: flutter run -t lib/main_mobile.dart" -ForegroundColor White
    }
} else {
    Write-Host "No Dart files found in mobile/screens" -ForegroundColor Red
