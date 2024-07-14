#The script will compare the two given branches in terms of files that have changed in your soloution.
#It will then create a list of projects in the form of "Project.csproj, Project2.csproj" based on the changed files.
#Based on this list, only the selected projects will be built by MSBuild.

#Author: Damian Czerwiński

param(
    [string]$CompareSourceBranch,
    [string]$BranchName,
    [string]$Repository,
    [string]$TargetBranch
)

Write-Host `n'SCRIPT STARTED'`n -ForegroundColor Green

if(-not ($BranchName -and $CompareSourceBranch -and $Repository))
{
	Write-Host 'You must set the following arguments!'`n -ForegroundColor Red
	Write-Host '-CompareSourceBranch - For example, enter something like: master or develop' -ForegroundColor Yellow
	Write-Host '-SourceBranchName - For example, enter something like: featureBranch-1' -ForegroundColor Yellow
	Write-Host '-Repository - For example, enter something like: C:\GIT\YourRepository' -ForegroundColor Yellow
	Write-Host '-TargetBranch - For example, enter something like: featureBranch-2' -ForegroundColor Yellow
	Write-Host `n'SCRIPT ENDED'`n  -ForegroundColor Green
	exit 1
}

Set-Location -Path $Repository

#Support for default headers for Azure DevOps Pull Requests

if($BranchName.Contains("pull"))
{
	$RemoteBranch = $BranchName -replace 'refs/', 'remotes/'
	$TargetBranch = $TargetBranch -replace 'refs/heads/', 'remotes/origin/'	
	$CompareSourceBranch = $TargetBranch
}
else
{
	$RemoteBranch = $BranchName -replace 'refs/heads/', 'remotes/origin/'
	$CompareSourceBranch = "remotes/origin/$CompareSourceBranch"
}

Write-Host 'Your source branch:'`n
$RemoteBranch

Write-Host `n'Your compare branch:'`n
$CompareSourceBranch

$changedFilesList = Invoke-Expression -Command "git diff --name-only $RemoteBranch..$CompareSourceBranch"

if(-not ($changedFilesList))
{
	Write-Host `n'ATTENTION! There are no changes between these branches or one of the branches does not exist!'`n -ForegroundColor Red
	Write-Host 'SCRIPT ENDED'`n  -ForegroundColor Green
	exit 1
}

$projectsList = @()
$hasFrontendChanged = 0
$isBuildable = 0

Write-Host `n'LIST OF CHANGED FILES:'`n  -ForegroundColor Green

foreach($element in $changedFilesList) {

	$element

    #Adapt to your project structure:

    if($element.Contains("/code"))
	{
		$index = $element.LastIndexOf("/code")
		
		if ($index -ge 0) 
		{	
			#Example: src/Feature/FeatureName/code/Models/Model.cs
			#Result: src/Feature/FeatureName
        	$cutElement = $element.Substring(0, $index)
			
			#Look for the .csproj file for every element: EXAMPLE (src/Feature/FeatureName) = C:\GIT\YourRepository\YourProject\src\Feature\FeatureName\FeatureName.csproj
			$projectsList += Get-ChildItem -Path "$cutElement" -Filter "*.csproj" -Recurse | ForEach-Object { $_.FullName }	
    	}
    }
		
	if($element.Contains("/Frontend"))
	{
		$hasFrontendChanged = 1
	}  
}

if([string]::IsNullOrEmpty($projectsList))
{
	Write-Host `n'ATTENTION! There are no changes detected to build!' -ForegroundColor Yellow
	
	$isBuildable = 0
}
else
{
	$projects = $projectsList | Get-Unique
	
	Write-Host `n'LIST OF PROJECTS TO BUILD:'`n  -ForegroundColor Green

	$projects
	$projects = $projects -join ' '
	$isBuildable = 1
}

Write-Host `n'FRONTEND STATUS:'`n  -ForegroundColor Green

if($hasFrontendChanged)
{
	Write-Host 'Frontend must be built.' -ForegroundColor Yellow
}
else
{
	Write-Host 'No changes on the Frontend.' -ForegroundColor Yellow
}

Write-Host `n'Setting global variables for the next task..'`n  -ForegroundColor Cyan

#Set global variables in Azure DevOps Task so MSBuild can use them 
Write-Host "##vso[task.setvariable variable=projects]$projects"
Write-Host "##vso[task.setvariable variable=hasFrontendChanged]$hasFrontendChanged"
Write-Host "##vso[task.setvariable variable=isBuildable]$isBuildable"

Write-Host 'SCRIPT ENDED'`n  -ForegroundColor Green
