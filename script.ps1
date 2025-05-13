# This script compares two branches to identify changed files in the solution.
# It generates a list of projects (e.g., "Project.csproj, Project2.csproj") based on the changes.
# Only the selected projects will be built using MSBuild.

# Author: Damian Czerwiński

param(
    [string]$CompareSourceBranch, # The branch to compare against (e.g., master or develop)
    [string]$BranchName,          # The current branch name (e.g., featureBranch-1)
    [string]$Repository,          # Path to the repository (e.g., C:\GIT\YourRepository)
    [string]$TargetBranch         # The target branch for pull requests (optional)
)

Write-Host "`nSCRIPT STARTED`n" -ForegroundColor Green

# Validate required parameters
if (-not ($BranchName -and $CompareSourceBranch -and $Repository)) {
    Write-Host "Missing required arguments!" -ForegroundColor Red
    Write-Host "-CompareSourceBranch: e.g., master or develop" -ForegroundColor Yellow
    Write-Host "-BranchName: e.g., featureBranch-1" -ForegroundColor Yellow
    Write-Host "-Repository: e.g., C:\GIT\YourRepository" -ForegroundColor Yellow
    Write-Host "-TargetBranch: e.g., featureBranch-2 (optional)" -ForegroundColor Yellow
    Write-Host "`nSCRIPT ENDED`n" -ForegroundColor Green
    exit 1
}

# Navigate to the repository directory
Set-Location -Path $Repository

# Determine remote branch and compare branch for Azure DevOps pull requests
if ($BranchName.Contains("pull")) {
    $RemoteBranch = $BranchName -replace 'refs/', 'remotes/'
    $TargetBranch = $TargetBranch -replace 'refs/heads/', 'remotes/origin/'
    $CompareSourceBranch = $TargetBranch
} else {
    $RemoteBranch = $BranchName -replace 'refs/heads/', 'remotes/origin/'
    $CompareSourceBranch = "remotes/origin/$CompareSourceBranch"
}

Write-Host "Source branch: $RemoteBranch"
Write-Host "Compare branch: $CompareSourceBranch"

# Get the list of changed files between the branches
$changedFilesList = Invoke-Expression -Command "git diff --name-only $RemoteBranch..$CompareSourceBranch"

if (-not $changedFilesList) {
    Write-Host "`nNo changes detected between the branches or one of the branches does not exist!" -ForegroundColor Red
    Write-Host "SCRIPT ENDED`n" -ForegroundColor Green
    exit 1
}

# Initialize variables
$projectsList = @()
$hasFrontendChanged = $false
$isBuildable = $false

Write-Host "`nLIST OF CHANGED FILES:" -ForegroundColor Green

# Process each changed file
foreach ($element in $changedFilesList) {
    # Check for backend code changes
    if ($element.Contains("/code")) {
        $index = $element.LastIndexOf("/code")
        if ($index -ge 0) {
            # Extract the project path (e.g., src/Feature/FeatureName)
            $cutElement = $element.Substring(0, $index)
            # Find .csproj files in the project directory
            $projectsList += Get-ChildItem -Path "$cutElement" -Filter "*.csproj" -Recurse | ForEach-Object { $_.FullName }
        }
    }

    # Check for frontend changes
    if ($element.Contains("/Frontend")) {
        $hasFrontendChanged = $true
    }
}

# Handle the list of projects to build
if ([string]::IsNullOrEmpty($projectsList)) {
    Write-Host "`nNo changes detected to build!" -ForegroundColor Yellow
    $isBuildable = $false
} else {
    $projects = $projectsList | Get-Unique
    Write-Host "`nLIST OF PROJECTS TO BUILD:" -ForegroundColor Green
    $projects
    $projects = $projects -join ' '
    $isBuildable = $true
}

# Display frontend status
Write-Host "`nFRONTEND STATUS:" -ForegroundColor Green
if ($hasFrontendChanged) {
    Write-Host "Frontend must be built." -ForegroundColor Yellow
} else {
    Write-Host "No changes detected in the Frontend." -ForegroundColor Yellow
}

# Set global variables for Azure DevOps tasks
Write-Host "`nSetting global variables for the next task..." -ForegroundColor Cyan
Write-Host "##vso[task.setvariable variable=projects]$projects"
Write-Host "##vso[task.setvariable variable=hasFrontendChanged]$hasFrontendChanged"
Write-Host "##vso[task.setvariable variable=isBuildable]$isBuildable"

Write-Host "SCRIPT ENDED`n" -ForegroundColor Green
