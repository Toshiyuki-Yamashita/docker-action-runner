& {
    # configurations
    $VersionNo = 16
    $PSInstaller = [PSCustomObject]@{
        Uri = "https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.$VersionNo/PowerShell_6.0.0-alpha.$VersionNo-win10-win2016-x64.zip";
        OutFile = Join-Path $env:TEMP "powershell-6.0.0-alpha.$VersionNo.zip";
        Sha256 = "1AA8F34E640996961BB1D63BE5563502B9944F47D5B20995AAF3C95785965590";
        Destination = "C:\Program Files\PowerShell\6.0.0.$VersionNo";
        VersionTag = "6.0.0-alpha.$VersionNo"
    }
    $RemotingInstaller = [PSCustomObject]@{
        Uri = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/powershell-native/Install-PowerShellRemoting.ps1"
        OutFile = Join-Path $env:TEMP "Install-PowerShellRemoting.ps1";
    }
    # download
    function Invoke-Download([string]$Uri, [string]$OutFile) {
        Write-Host "Downloading $Uri ..." -ForegroundColor Green
        Write-Host "  Destination : $OutFile" -ForegroundColor Green
        Add-Type -AssemblyName System.Net.Http
        try {
            $client = New-Object System.Net.Http.HttpClient
            $response = $client.GetAsync($Uri).Result 
            $hstream = $response.Content.ReadAsStreamAsync().Result
            $fstream = [System.IO.File]::Create($OutFile)
            $hstream.CopyTo($fstream)
            $fstream.Flush()
        } finally {
            $fstream.Close()
            $hstream.Dispose()
            $response.Dispose()
        }
    }
    Invoke-Download -Uri $PSInstaller.Uri -OutFile $PSInstaller.OutFile
    Invoke-Download -Uri $RemotingInstaller.Uri -OutFile $RemotingInstaller.OutFile

    # verify and extract zip
    if ((Get-FileHash -LiteralPath $PSInstaller.OutFile -Algorithm SHA256).Hash -eq $PSInstaller.Sha256) {
        Write-Host "Verified SHA256 hash..." -ForegroundColor Green
    } else {
        Write-Warning "Invalid SHA256 hash!"
        return 
    }
    if (Test-Path -LiteralPath $PSInstaller.Destination) {
        Write-Warning "$($PSInstaller.Destination) already exists!"
        return 
    }
    # Install PowerShell
    Write-Host "Install PowerShell..." -ForegroundColor Green
    Write-Host "Extracting $($PSInstaller.OutFile) to $($PSInstaller.Destination) ..." -ForegroundColor Green
    Expand-Archive -LiteralPath $PSInstaller.OutFile -DestinationPath $PSInstaller.Destination
    Write-Host "PowerShell installation complete!" -ForegroundColor Green

    # Install PSRemoting
    Write-Host "Install PSRemoting endpoint..." -ForegroundColor Green
    # Install-PowerShellRemoting.ps1 invokes restarting WinRM Service.
    # So, if you run this script in a PSSession, the session disconnected.
    [ScriptBlock]::Create("$($RemotingInstaller.OutFile) -PowerShellHome `"$($PSInstaller.Destination)`" -PowerShellVersion `"$($PSInstaller.VersionTag)`"").Invoke()
    Write-Host "PSRemoting endpoing configuration complete!" -ForegroundColor Green
}