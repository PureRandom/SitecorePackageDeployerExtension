[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {

    # Get the inputs.
    [string]$SitecoreUrl = Get-VstsInput -Name SitecoreUrl
    [string]$Force = Get-VstsInput -Name Force
    [string]$CheckPackageComplete = Get-VstsInput -Name CheckPackageComplete
    [string]$SitecorePackageDeployerPath = Get-VstsInput -Name SitecorePackageDeployerPath

    #### Run Package Deployer
    write-host "**** - Running Package Deployer - **** "

    $forcePackageDeployer = ""
    if ((-not [string]::IsNullOrEmpty($Force)) -and ($Force -eq 'true')) {
        $forcePackageDeployer = "?force=1"
    }

    $SitecorePackageDeployerUrl = "$SitecoreUrl/sitecore/admin/startsitecorepackagedeployer.aspx$forcePackageDeployer"
    write-host "Invoking $SitecorePackageDeployerUrl"
    Invoke-WebRequest -Uri $SitecorePackageDeployerUrl
    write-host "**** - Deployer Run - **** "

    if ((-not [string]::IsNullOrEmpty($CheckPackageComplete)) -and ($CheckPackageComplete -eq 'true')) {
        
        ## Check for Error Files
        function CheckErroredFiles {
            $errorfile = Get-ChildItem "$SitecorePackageDeployerPath\*.error_*"
                          
            if ($errorfile) {
                $errorfile | ForEach-Object {
                    if ($errorFiles -notcontains $_.BaseName) {
                        Write-Host "Errored: " $_.Name
                        $errorFiles.Add($_.BaseName) > $null
                    }
                }
           
            }
        }
           
        ## Check for Completed Files
        function CheckCompletedFiles {
            $completedfile = Get-ChildItem "$SitecorePackageDeployerPath\*.json"
           
            if ($completedfile) {
                $completedfile | ForEach-Object {
                    if ($completedFiles -notcontains $_.BaseName) {
                        $file = Get-Content $_.FullName
                        $containsWord = $file | ForEach-Object {$_ -match "Fail"}
                        if ($containsWord -notcontains $true) {
                            Write-Host "Completed: "$_.Name
                            $completedFiles.Add($_.BaseName) > $null
                        }
                    }
                }
           
            }
        }

        write-host "**** - Checking Process - **** "
        Write-Host("Package Deployer Loction: $SitecorePackageDeployerPath")

        $ErrorActionPreference = 'silentlycontinue'

        write-host "Clear deployer folder of previous packages"
        Remove-Item -path "$SitecorePackageDeployerPath\*.json" -Recurse
        Remove-Item -path "$SitecorePackageDeployerPath\*.error_*" -Recurse

        Write-Host " "
        Write-Host "Files to process:"
        Get-ChildItem "$SitecorePackageDeployerPath\*.update" | ForEach-Object {Write-Host $_.BaseName}

        $errorFiles = New-Object System.Collections.ArrayList
        $completedFiles = New-Object System.Collections.ArrayList

        
        Write-Host "Start Process:"
        Write-Host " "
        Do { 
            ## Check files
            CheckErroredFiles
            CheckCompletedFiles
        }
        Until ((Get-Childitem -path $SitecorePackageDeployerPath  -filter "*.update" -recurse).Length -eq 0 )

        # Final Check
        CheckErroredFiles
        CheckCompletedFiles
    }
}
Catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Error "$FailedItem - $ErrorMessage"
}
finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

